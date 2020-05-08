using Enderlook.Unity.Extensions;

using Game.Creatures;

using UnityEngine;

namespace Game.Attacks.Projectiles
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Projectile Hit")]
    public class ProjectileHit : MonoBehaviour
    {
        [SerializeField, Tooltip("Damage done on hit.")]
        private int damage = 10;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        private LayerMask hitLayer;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnCollisionEnter(Collision collider)
        {
            GameObject otherGameObject = collider.gameObject;
            if (otherGameObject.LayerMatchTest(hitLayer))
            {
                if (damage > 0 && otherGameObject.TryGetComponent(out IDamagable damagable))
                    damagable.TakeDamage(damage);

                if (pushForce > 0 && otherGameObject.TryGetComponent(out IPushable pushable))
                    pushable.AddForce(transform.forward * pushForce, ForceMode.Impulse);
            }
        }

        public static void AddComponentTo(GameObject source, int damage, float pushForce = 0, LayerMask hitLayer = default)
        {
            ProjectileHit component = source.AddComponent<ProjectileHit>();
            component.damage = damage;
            component.pushForce = pushForce;
            component.hitLayer = hitLayer;
        }
    }
}