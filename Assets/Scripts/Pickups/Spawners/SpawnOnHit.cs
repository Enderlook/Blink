using Game.Creatures;

using System.Linq;

using UnityEngine;

using RangeInt = Enderlook.Unity.Serializables.Ranges.RangeInt;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Spawn On Hit"), RequireComponent(typeof(IPickupSpawner))]
    public class SpawnOnHit : MonoBehaviour, IDamagable
    {
#pragma warning disable CS0649
        [SerializeField, Range(0, 1), Tooltip("Amount of childs remain after awake.")]
        private float survivalPercent = 1;

        [SerializeField, Tooltip("Amount of childs destroyed and spawn drops per hit.")]
        private RangeInt destroysPerHit;
#pragma warning restore CS0649

        private IPickupSpawner spawner;

        private void Awake()
        {
            spawner = GetComponent<IPickupSpawner>();
            foreach (Transform child in transform.Cast<Transform>())
            {
                if (Random.value > survivalPercent)
                    child.gameObject.SetActive(false);
            }
        }

        void IDamagable.TakeDamage(int amount)
        {
            int value = destroysPerHit.Value;
            int i = 0;
            foreach (Transform child in transform.Cast<Transform>())
            {
                GameObject childGO = child.gameObject;
                if (childGO.activeSelf)
                {
                    spawner.Spawn();
                    child.gameObject.SetActive(false);

                    if (i++ >= value)
                        break;
                }
            }
        }

        void IDamagable.TakeHealing(int amount) => Debug.LogWarning($"TakeHealing from {nameof(SpawnOnHit)} in {gameObject.name} should not be called.");
    }
}