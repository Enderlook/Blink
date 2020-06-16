using Enderlook.Unity.Extensions;
using Enderlook.Unity.Utils.Clockworks;

using Game.Scene;

using System;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemies/Enemy Attack"), RequireComponent(typeof(Rigidbody)), RequireComponent(typeof(EnemyPathFinding)), RequireComponent(typeof(NavMeshAgent)), RequireComponent(typeof(Animator))]
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

        [SerializeField, Tooltip("Distance from enemy to stop. This value is added to the " + nameof(NavMeshAgent) + nameof(NavMeshAgent.stoppingDistance) + ".")]
        private float thresholdDistance;

        [SerializeField, Tooltip("Attack angle of view."), Range(0, Mathf.PI)]
        private float angleOfView = Mathf.PI / 2;

        [SerializeField, Tooltip("Maximum radiants rotated per second.")]
        private float rotationSpeed = .5f;
#pragma warning restore CS0649

        private EnemyPathFinding enemyPathFinding;
        private NavMeshAgent navMeshAgent;
        private Animator animator;
        private Rigidbody rigidBody;

        private float nextAttack;
        private bool isDead;
        private bool isStunned;
        private Clockwork stunningClockwork;
        private GameManager gameManager;

#if UNITY_EDITOR
        private Color gizmos = Color.yellow;
#endif

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            gameManager = FindObjectOfType<GameManager>();
            enemyPathFinding = GetComponent<EnemyPathFinding>();
            navMeshAgent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();
            rigidBody = GetComponent<Rigidbody>();
            stunningClockwork = new Clockwork(0, UnStun, true, 0);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (gameManager.HasWon)
                return;

            if (isDead)
                return;

            if (isStunned)
            {
                RestoreMobility();
                stunningClockwork.UpdateBehaviour(Time.deltaTime);
                return;
            }

            float checkRange = navMeshAgent.stoppingDistance + thresholdDistance;
            if (enemyPathFinding.TargetDistance <= checkRange)
            {
#if UNITY_EDITOR
                gizmos = (Color.yellow + Color.red) / 2;
#endif
                enemyPathFinding.CanWalk = false;

                Vector3 direction = enemyPathFinding.TargetPosition - transform.position;
                Vector2 direction2 = new Vector2(direction.x, direction.z);
                float angle = Vector2.Angle(direction2, new Vector2(transform.forward.x, transform.forward.z));
                if (angle >= angleOfView || angle <= angleOfView)
                {
#if UNITY_EDITOR
                    gizmos = Color.red / 2;
#endif
                    if (Time.time >= nextAttack)
                    {
                        animator.SetTrigger(GetAnimationKey());
                        nextAttack = Time.time + cooldown;
                    }
                }
                else
                {
                    navMeshAgent.updateRotation = false;
                    rigidBody.rotation = Quaternion.Euler(Vector3.RotateTowards(rigidBody.rotation.eulerAngles, direction * Time.deltaTime, rotationSpeed, 0));
                }
            }
            else
            {
#if UNITY_EDITOR
                gizmos = Color.yellow;
#endif
                RestoreMobility();
            }
        }

        private void RestoreMobility()
        {
            enemyPathFinding.CanWalk = true;
            navMeshAgent.updateRotation = true;
        }

        protected virtual string GetAnimationKey() => basicAttack;

        private void OnTriggerEnter(Collider other)
        {
            GameObject target = other.gameObject;
            if (target.LayerMatchTest(attackLayer) && target.TryGetComponent(out IDamagable damagable))
                damagable.TakeDamage(damage);
        }

        void IDie.Die() => isDead = true;

        public void Stun(float duration)
        {
            isStunned = true;
            stunningClockwork.ResetCycles(1);
            stunningClockwork.ResetTime(duration);
        }

        private void UnStun() => isStunned = false;

#if UNITY_EDITOR
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnDrawGizmosSelected()
        {
            NavMeshAgent navMeshAgent = GetComponent<NavMeshAgent>();
            float checkRange = navMeshAgent.stoppingDistance + thresholdDistance;

            Gizmos.DrawWireSphere(transform.position, thresholdDistance + navMeshAgent.stoppingDistance);

            Gizmos.color = (gizmos + Color.black) / 2;
            
            const float delta = .1f;

            DrawArc(GetPointHorizontal, angleOfView);
            DrawArc((float a)
                => new Vector3(
                    0,
                    Mathf.Sin(a) * checkRange,
                    Mathf.Cos(a) * checkRange
                ), angleOfView);

            Vector3 point = GetPointHorizontal(-angleOfView);
            DrawArc((float a)
                 => new Vector3(
                     Mathf.Cos(a) * point.x,
                     Mathf.Sin(a) * point.x,
                     point.z
                 ), Mathf.PI);

            Vector3 GetPointHorizontal(float a)
                 => new Vector3(
                     Mathf.Sin(a) * checkRange,
                     0,
                     Mathf.Cos(a) * checkRange
                 );

            void DrawArc(Func<float, Vector3> getPoint, float to)
            {
                float angle = -to;
                Vector3 pointA = getPoint(-to);
                angle += delta;
                Gizmos.DrawLine(transform.position, AsRelative(pointA));
                for (; angle <= to; angle += delta)
                {
                    Vector3 pointB = getPoint(angle);
                    Gizmos.DrawLine(AsRelative(pointA), AsRelative(pointB));
                    pointA = pointB;
                }
                Vector3 pointC = getPoint(to);
                Gizmos.DrawLine(AsRelative(pointC), AsRelative(pointA));
                Gizmos.DrawLine(transform.position, AsRelative(pointC));
            }

            Vector3 AsRelative(Vector3 vector3)
                => transform.position + (transform.right * vector3.x) + (transform.forward * vector3.z) + (transform.up * vector3.y);
        }
#endif
    }
}
