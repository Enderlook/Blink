using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures
{
    public class Hurtable : MonoBehaviour, IDamagable
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Current health.")]
        private IntGetSetReference health;

        [SerializeField, Tooltip("Maximum health.")]
        private IntGetSetReference maxHealth;
#pragma warning restore CS0649

        public int Health => health;

        public int MaxHealth => maxHealth;

        public void TakeDamage(int amount) => health.SetValue(health.GetValue() - amount);

        public void TakeHealing(int amount) => health.SetValue(health.GetValue() + amount);

        public void SetMaxHealth(int maxHealth) => this.maxHealth.SetValue(maxHealth);
    }
}