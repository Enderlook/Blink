using Game.Creatures;

using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Area of Healing")]
    public class AreaOfHealing : AreaOfEffect
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Heal restored.")]
        private int healing = 10;

        protected override void ProduceEffect(GameObject otherGameObject)
        {
            if (healing > 0 && otherGameObject.TryGetComponent(out IDamagable damagable))
                damagable.TakeHealing(healing);
        }

        public static void AddComponentTo(GameObject source, float timeToHeal, int healing, LayerMask hitLayer = default)
        {
            AreaOfHealing component = source.AddComponent<AreaOfHealing>();
            component.healing = healing;
            component.warmupTime = timeToHeal;
            component.hitLayer = hitLayer;
        }
    }
}
