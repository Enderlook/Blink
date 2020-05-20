using UnityEngine;

using RangeInt = Enderlook.Unity.Serializables.Ranges.RangeInt;

namespace Game.Pickups.Orbs
{
    [AddComponentMenu("Game/Pickups/Orbs/Spawn Orbs")]
    public class SpawnOrbs : SpawnPickup, IPickupSpawner
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Prefab of orbs to spawn.")]
        private Orb prefab;

        [SerializeField, Tooltip("Range of values to spawn.")]
        private RangeInt valueToSpawn;

#pragma warning restore CS0649

        public void Spawn()
        {
            int value = valueToSpawn.Value;
            int maximumSize = (int)(Mathf.Log(value + 7, 1.25f) - 8);

            while (value > 0)
            {
                int current = Random.Range(Mathf.Max(maximumSize / 2, 1), maximumSize);
                if (current > value)
                {
                    Spawn(value);
                    return;
                }
                value -= current;
                Spawn(current);
            }
        }

        private void Spawn(int value)
        {
            Orb instance = Spawn(prefab);
            instance.SetValue(value);
        }
    }
}