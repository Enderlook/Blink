using AvalonStudios.Extensions;

using Enderlook.Unity.Extensions;
using Enderlook.Unity.Utils.Clockworks;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemies/Enemy Attack"), RequireComponent(typeof(EnemyPathFinding)), RequireComponent(typeof(NavMeshAgent)), RequireComponent(typeof(Animator))]
    public class EnemyAttack : MonoBehaviour, IDie, IStunnable
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Basic attack animation name.")]
        protected string basicAttack;

        [SerializeField, Tooltip("Damage")]
        private int damage;

        [SerializeField, Tooltip("Cooldown")]
        private float cooldown;

        [SerializeField, Tooltip("Layers allowed to attack.")]
        private LayerMask attackLayer;
#pragma warning restore CS0649

        private EnemyPathFinding enemyPathFinding;
        private NavMeshAgent navMeshAgent;
        private Animator animator;

        private float nextAttack;
        private bool isDead;
        private bool isStunned;
        private Clockwork stunningClockwork;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            enemyPathFinding = GetComponent<EnemyPathFinding>();
            navMeshAgent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();
            stunningClockwork = new Clockwork(0, UnStun, true, 0);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (isDead)
                return;

            if (isStunned)
                stunningClockwork.UpdateBehaviour(Time.deltaTime);
            else if (enemyPathFinding.TargetDistance <= navMeshAgent.stoppingDistance)
            {
                enemyPathFinding.PlayWalkAnimation(false);
                if (Time.time >= nextAttack)
                {
                    animator.SetTrigger(GetAnimationKey());
                    nextAttack = Time.time + cooldown;
                }
            }
            else
                enemyPathFinding.PlayWalkAnimation(true);
        }

        protected virtual string GetAnimationKey() => basicAttack;

        private void OnTriggerEnter(Collider other)
        {
            GameObject target = other.gameObject;
            if (target.LayerMatchTest(attackLayer))
            {
                if (target.TryGetComponent(out IDamagable damagable))
                    damagable.TakeDamage(damage);
            }
        }

        void IDie.Die() => isDead = true;

        public void Stun(float duration)
        {
            isStunned = true;
            stunningClockwork.ResetCycles(1);
            stunningClockwork.ResetTime(duration);
        }

        private void UnStun() => isStunned = false;
    }
}
