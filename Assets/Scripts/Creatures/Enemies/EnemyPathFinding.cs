using Game.Scene;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [RequireComponent(typeof(NavMeshAgent)), AddComponentMenu("Game/Creatures/Enemy/Path Finding"), DefaultExecutionOrder(10)]
    public class EnemyPathFinding : MonoBehaviour, IPushable, IDie
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Animator component.")]
        private Animator animator;

        [SerializeField, Tooltip("Animation key")]
        private string walkAnimation;

        [SerializeField, Tooltip("Determines the weight of the crystal when deciding to move towards it or the player.")]
        private float crystalSeekWeight = 1;

        [SerializeField, Tooltip("Determines the weight of the player when deciding to move towards it or the crystal.")]
        private float playerSeekWeight = 1;

        [SerializeField, Tooltip("Used to determine push strength.")]
        private float mass = 1;
#pragma warning restore CS0649

        public float TargetDistance { get; private set; }

        private NavMeshAgent navMeshAgent;
        private NavMeshPath crystalPath;
        private NavMeshPath playerPath;

        private int navMeshFrameCheck;
        private static int frameCheck;
        private const int MAX_CHECK_FRAME = 10;

        private bool isDead;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            navMeshAgent = GetComponent<NavMeshAgent>();
            crystalPath = new NavMeshPath();
            playerPath = new NavMeshPath();
            navMeshFrameCheck = frameCheck++ % MAX_CHECK_FRAME;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            DetermineTarget();
            Vector3 pathEndPosition = navMeshAgent.pathEndPosition;
            transform.LookAt(new Vector3(pathEndPosition.x, transform.position.y, pathEndPosition.z));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (isDead)
                navMeshAgent.enabled = false;
            else
            {
                if (Time.frameCount % MAX_CHECK_FRAME == navMeshFrameCheck)
                    DetermineTarget();
            }
        }

        private void DetermineTarget()
        {
            float crystalDistance = GetPathDistance(CrystalAndPlayerTracker.CrystalPosition, crystalPath);
            float playerDistance = GetPathDistance(CrystalAndPlayerTracker.PlayerPosition, playerPath);

            if (crystalDistance * (1 / crystalSeekWeight) < playerDistance * (1 / playerSeekWeight))
            {
                TargetDistance = crystalDistance;
                navMeshAgent.SetPath(crystalPath);
            }
            else
            {
                TargetDistance = playerDistance;
                navMeshAgent.SetPath(playerPath);
            }
        }

        public void AddForce(Vector3 force, ForceMode mode = ForceMode.Force)
        {
            switch (mode)
            {
                case ForceMode.Force:
                    navMeshAgent.velocity += force * mass / (Time.deltaTime * Time.deltaTime);
                    break;
                case ForceMode.Acceleration:
                    navMeshAgent.velocity += force / (Time.deltaTime * Time.deltaTime);
                    break;
                case ForceMode.Impulse:
                    navMeshAgent.velocity += force * mass;
                    break;
                case ForceMode.VelocityChange:
                    navMeshAgent.velocity += force;
                    break;
            }
        }

        public float GetPathDistance(Vector3 target, NavMeshPath path)
        {
            // https://forum.unity.com/threads/getting-the-distance-in-nav-mesh.315846/#post-2052142

            path.ClearCorners();

            navMeshAgent.CalculatePath(target, path);

            float distance = 0;
            if (path.status != NavMeshPathStatus.PathInvalid && path.corners.Length > 1)
            {
                for (int i = 1; i < path.corners.Length; ++i)
                    distance += Vector3.Distance(path.corners[i - 1], path.corners[i]);
            }
            else
                distance = Mathf.Infinity;

            return distance;
        }

        void IDie.Die() => isDead = true;

        public void PlayWalkAnimation(bool play) => animator.SetBool(walkAnimation, play);
    }
}
