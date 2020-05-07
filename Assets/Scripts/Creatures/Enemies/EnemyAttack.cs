using AvalonStudios.Extensions;

using Enderlook.Unity.Attributes;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemies/Attack"), RequireComponent(typeof(EnemyPathFinding)), RequireComponent(typeof(NavMeshAgent))]
    public class EnemyAttack : MonoBehaviour, IDie
    {
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

        private EnemyPathFinding enemyPathFinding;

        private NavMeshAgent navMeshAgent;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            enemyPathFinding = GetComponent<EnemyPathFinding>();
            navMeshAgent = GetComponent<NavMeshAgent>();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (isDead)
                return;

            if (enemyPathFinding.TargetDistance <= navMeshAgent.stoppingDistance)
            {
                enemyPathFinding.PlayWalkAnimation(false);
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
                enemyPathFinding.PlayWalkAnimation(true);
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
