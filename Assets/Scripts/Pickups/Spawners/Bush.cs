using Game.Creatures;
using Game.Pickups;

using UnityEngine;

namespace Game
{
    [AddComponentMenu("Game/Pickups/Bush")]
    public class Bush : SpawnOrbs, IDamagable
    {
#pragma warning disable CS0649
        [SerializeField]
        private GameObject berries;
#pragma warning restore CS0649

        void IDamagable.TakeDamage(int amount)
        {
            if (berries.activeSelf)
            {
                berries.SetActive(false);
                Spawn();
            }
        }

        void IDamagable.TakeHealing(int amount) => Debug.LogWarning($"TakeHealing from {nameof(Bush)} in {gameObject.name} should not be called.");
    }
}