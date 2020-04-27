using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Creatures
{
    public class EnemyAttack : MonoBehaviour
    {
        [SerializeField, Tooltip("Enemy path finding.")]
        private EnemyPathFinding enemyPathFinding;

        [SerializeField, Tooltip("Animator component.")]
        private Animator animator;

        [SerializeField, Tooltip("Animation key")]
        private string animationKey;

        [SerializeField, Tooltip("Damage")]
        private int damage;

        [SerializeField, Tooltip("Cooldown")]
        private float cooldown;

        [SerializeField, Tooltip("Player layer")]
        private LayerMask playerLayer;

        [SerializeField, Tooltip("Crystal layer")]
        private LayerMask crystalLayer;

        private float nextAttack;

        private void Update()
        {
            if (enemyPathFinding.TargetDistance <= enemyPathFinding.ThisNavMeshAgent.stoppingDistance)
            {
                if (Time.time >= nextAttack)
                {
                    animator.SetTrigger(animationKey);
                    nextAttack = Time.time + cooldown;
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.gameObject.layer == playerLayer.ToLayer() || other.gameObject.layer == crystalLayer.ToLayer())
            {
                if (other.gameObject.TryGetComponent(out IDamagable damagable))
                    damagable.TakeDamage(damage);
            }
        }

    }
}
