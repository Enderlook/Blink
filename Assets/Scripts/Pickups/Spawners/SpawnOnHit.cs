using Game.Creatures;

using UnityEngine;

using System.Linq;
using System.Collections.Generic;
using Enderlook.Extensions;

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
        private RangeInt desotrysPerHit;
#pragma warning restore CS0649

        private List<GameObject> childs;

        private IPickupSpawner spawner;

        private void Awake()
        {
            spawner = GetComponent<IPickupSpawner>();
            childs = new List<GameObject>();
            foreach (Transform child in transform.Cast<Transform>())
            {
                if (Random.value > survivalPercent)
                    Destroy(child.gameObject);
                else
                    childs.Add(child.gameObject);
            }
        }

        void IDamagable.TakeDamage(int amount)
        {
            int value = desotrysPerHit.Value;
            for (int i = 0; i < value; i++)
            {
                if (childs.TryPopLast(out GameObject child))
                {
                    Destroy(child);
                    spawner.Spawn();
                }
                else
                {
                    Destroy(this);
                    Destroy((Component)spawner);
                    return;
                }
            }
        }

        void IDamagable.TakeHealing(int amount) => Debug.LogWarning($"TakeHealing from {nameof(SpawnOnHit)} in {gameObject.name} should not be called.");
    }
}