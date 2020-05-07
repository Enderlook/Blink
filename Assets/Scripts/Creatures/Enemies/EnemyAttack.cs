using AvalonStudios.Extensions;
using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures
{
    public class EnemyAttack : MonoBehaviour, IDie
    {
        [SerializeField, Tooltip("Enemy path finding.")]
        private EnemyPathFinding enemyPathFinding;

        [SerializeField, Tooltip("Is Boss")]
        private bool isBoss;

        [SerializeField, Tooltip("Basic attack key")]
        private string basicAttack;

        [SerializeField, Tooltip("Medium attack."), ShowIf(nameof(isBoss), true)]
        private string mediumAttack;

        [SerializeField, Tooltip("Strong attack"), ShowIf(nameof(isBoss), true)]
        private string strongAttack;

        [SerializeField, Tooltip("Damage")]
        private int damage;

        [SerializeField, Tooltip("Cooldown")]
        private float cooldown;

        [SerializeField, Tooltip("Player layer")]
        private LayerMask playerLayer;

        [SerializeField, Tooltip("Crystal layer")]
        private LayerMask crystalLayer;

        private float nextAttack;

        private bool isDead;

        private void Update()
        {
            if (isDead)
                return;

            if (enemyPathFinding.TargetDistance <= enemyPathFinding.ThisNavMeshAgent.stoppingDistance)
            {
                enemyPathFinding.ThisAnimator.SetBool(enemyPathFinding.WalkAnimation, false);
                if (Time.time >= nextAttack)
                {
                    string animationKey;
                    if (isBoss)
                    {
                        float prob = Random.Range(0, 100);
                        if (prob >= 0 && prob <= 60)
                            animationKey = basicAttack;
                        else if (prob >= 61 && prob <= 90)
                            animationKey = mediumAttack;
                        else
                            animationKey = strongAttack;
                    }
                    else
                        animationKey = basicAttack;

                    enemyPathFinding.ThisAnimator.SetTrigger(animationKey);
                    nextAttack = Time.time + cooldown;
                }
            }
            else
                enemyPathFinding.ThisAnimator.SetBool(enemyPathFinding.WalkAnimation, true);
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.gameObject.layer == playerLayer.ToLayer() || other.gameObject.layer == crystalLayer.ToLayer())
            {
                if (other.gameObject.TryGetComponent(out IDamagable damagable))
                    damagable.TakeDamage(damage);
            }
        }

        void IDie.Die() => isDead = true;
    }
}
