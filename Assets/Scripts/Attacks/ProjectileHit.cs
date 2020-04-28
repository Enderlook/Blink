using Game.Creatures;
using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Attacks.Projectiles
{
    [AddComponentMenu("Game/Attacks/Projectile Hit")]
    [RequireComponent(typeof(Collider))]
    public class ProjectileHit : MonoBehaviour
    {
        [SerializeField, Tooltip("Damage done on hit.")]
        private int damage = 10;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        private int hitLayer = 0;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnCollisionEnter(Collision collider)
        {
            GameObject otherGameObject = collider.gameObject;
            if (otherGameObject.layer == hitLayer)
            {
                if (damage > 0)
                {
                    IDamagable damagable = otherGameObject.GetComponent<IDamagable>();
                    if (damagable != null)
                        damagable.TakeDamage(damage);
                }

                if (pushForce > 0)
                {
                    IPushable pushable = otherGameObject.GetComponent<IPushable>();
                    if (pushable != null)
                        pushable.AddForce(transform.forward * pushForce, ForceMode.Impulse);
                }
            }
            
        }

        public static void AddComponentTo(GameObject source, int damage, float pushForce = 0, int hitLayer = 0)
        {
            ProjectileHit component = source.AddComponent<ProjectileHit>();
            component.damage = damage;
            component.pushForce = pushForce;
            component.hitLayer = hitLayer;
        }
    }
}