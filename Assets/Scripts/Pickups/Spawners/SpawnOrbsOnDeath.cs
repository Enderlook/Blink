using Game.Creatures;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Spawn Orbs On Death")]
    public class SpawnOrbsOnDeath : SpawnOrbs, IDie
    {
        void IDie.Die() => Spawn();
    }
}