using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures
{
    public class Hurtable : MonoBehaviour, IDamagable
    {
        [SerializeField, Tooltip("Current health.")]
        private IntGetSetReference health;

        public void TakeDamage(int amount) => health.SetValue(health.GetValue() - amount);

        public void TakeHealing(int amount) => health.SetValue(health.GetValue() + amount);
    }
}