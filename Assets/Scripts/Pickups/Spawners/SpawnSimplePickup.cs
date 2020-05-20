using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Spawn Simple Pickup")]
    public class SpawnSimplePickup : SpawnPickup, IPickupSpawner
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Prefab to spawn.")]
        private GameObject prefab;
#pragma warning restore CS0649

        public void Spawn() => Spawn(prefab);
    }
}