using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures
{
    public class Hurtable : MonoBehaviour, IDamagable
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Current health.")]
        private IntGetSetReference health;
#pragma warning restore CS0649

        [SerializeField, Tooltip("Maximum health.")]
        private IntGetSetReference maxHealth;

        public int Health => health;

        public int MaxHealth => maxHealth;

        public void TakeDamage(int amount)
        {
            health.SetValue(health.GetValue() - amount);
            if (health <= 0)
                Destroy(gameObject);
        }

        public void TakeHealing(int amount) => health.SetValue(health.GetValue() + amount);

        public void SetMaxHealth(int maxHealth) => this.maxHealth.SetValue(maxHealth);
    }
}