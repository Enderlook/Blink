using Game.Creatures;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Spawn Orbs On Death"), RequireComponent(typeof(IPickupSpawner))]
    public class SpawnOnDeath : MonoBehaviour, IDie
    {
        void IDie.Die() => GetComponent<IPickupSpawner>().Spawn();
    }
}