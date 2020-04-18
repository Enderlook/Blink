using UnityEngine;

namespace Game.Creatures.AbilitiesSystem
{
    [RequireComponent(typeof(Collider))]
    public class HitDamage : MonoBehaviour
    {
        [SerializeField, Tooltip("Damage done when collision triggers.")]
        private int damage;

        [SerializeField, Tooltip("Whenever it can only produce damage once.")]
        private bool onlyHitOnce;

        private bool canHit = true;

        private void OnCollisionEnter(Collision collider)
        {
            if (canHit)
            {
                IDamagable damagable = collider.gameObject.GetComponent<IDamagable>();
                if (damagable != null)
                {
                    damagable.TakeDamage(damage);
                    if (onlyHitOnce)
                        canHit = false;
                }
            }
        }

        /// <summary>
        /// Creates and attach a <see cref="HitDamage"/> to <paramref name="gameObject"/>.
        /// </summary>
        /// <param name="gameObject"><see cref="GameObject"/> to add component <see cref="HitDamage"/>.</param>
        /// <param name="damage">Damage amount done on hit.</param>
        /// <param name="onlyHitOnce">Whenever the projectile can only damage once (only process a single collision) or unlimited times.</param>
        public static void AddComponentTo(GameObject gameObject, int damage, bool onlyHitOnce = true)
        {
            HitDamage hitDamage = gameObject.AddComponent<HitDamage>();
            hitDamage.damage = damage;
            hitDamage.onlyHitOnce = onlyHitOnce;
        }
    }
}