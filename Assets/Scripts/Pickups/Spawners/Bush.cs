using Game.Creatures;
using Game.Pickups;

using UnityEngine;

namespace Game
{
    [AddComponentMenu("Game/Pickups/Bush")]
    public class Bush : SpawnOrbs, IDamagable
    {
        [SerializeField]
        private GameObject berries;

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