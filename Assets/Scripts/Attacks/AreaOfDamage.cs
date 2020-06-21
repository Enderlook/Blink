using Game.Creatures;

using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Area of Damage")]
    public class AreaOfDamage : AreaOfEffect
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Damage done on explosion.")]
        private int damage = 10;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        protected override void ProduceEffect(GameObject otherGameObject)
        {
            if (damage > 0 && otherGameObject.TryGetComponent(out IDamagable damagable))
                damagable.TakeDamage(damage);

            if (pushForce > 0 && otherGameObject.TryGetComponent(out IPushable pushable))
                pushable.AddForce((otherGameObject.transform.position - transform.position) * pushForce, ForceMode.Impulse);
        }

        public static void AddComponentTo(GameObject source, float timeToExplode, int damage, float pushForce = 0, LayerMask hitLayer = default, float duration = 0)
        {
            AreaOfDamage component = source.AddComponent<AreaOfDamage>();
            component.damage = damage;
            component.pushForce = pushForce;
            component.warmupTime = timeToExplode;
            component.hitLayer = hitLayer;
            component.duration = duration;
        }
    }
}
    