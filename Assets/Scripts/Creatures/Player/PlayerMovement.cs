using AvalonStudios.Extensions;

using Enderlook.Unity.Atoms;

using Game.Scene;
using Game.Scene.CLI;

using System.Collections;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Animator)), RequireComponent(typeof(NavMeshAgent)), AddComponentMenu("Game/Creatures/Player/Movement")]
    public class PlayerMovement : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Run animation name.")]
        private string runAnimation;

        [SerializeField, Tooltip("Movement speed.")]
        private FloatGetReference speed;

        [SerializeField, Tooltip("Layer to get mouse position.")]
        private LayerMask layerGround;

        [SerializeField, Tooltip("Range of the ray.")]
        private float range;
#pragma warning restore CS0649

        private Animator animator;

        private Vector3 velocity;

        private int LayerGround => 1 << layerGround.ToLayer();

        private float horizontal;
        private float vertical;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            animator = GetComponent<Animator>();

            NavMeshAgent navMeshAgent = GetComponent<NavMeshAgent>();
            navMeshAgent.enabled = false;
            StartCoroutine(FixNavMeshAgent());
            IEnumerator FixNavMeshAgent()
            {
                yield return new WaitForSeconds(1f);
                navMeshAgent.enabled = true;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void FixedUpdate()
        {
            if (Console.IsConsoleEnabled)
                return;

            if (GameManager.HasWon)
            {
                animator.SetBool(runAnimation, false);
                return;
            }

#if !UNITY_ANDROID || UNITY_EDITOR
#if UNITY_EDITOR && UNITY_ANDROID
            if (!UnityEditor.EditorApplication.isRemoteConnected)
#endif
            SetMovementInput(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
#endif

            Move(horizontal, vertical);
            SetMovementInput(0, 0);
            Turn();
        }

        public void SetMovementInput(float horizontal, float vertical)
        {
            this.horizontal = horizontal;
            this.vertical = vertical;
        }

        private void Move(float horizontal, float vertical)
        {
            velocity = new Vector3(horizontal, 0, vertical);
            velocity = velocity.normalized * speed * Time.deltaTime;

            transform.position += velocity;

            bool running = horizontal != 0 || vertical != 0;
            animator.SetBool(runAnimation, running);
        }

        private void Turn()
        {
            Ray camRayPoint = Camera.main.ScreenPointToRay(Input.mousePosition);

            Vector3 pointOnScreen = Physics.Raycast(camRayPoint, out RaycastHit ground, range, LayerGround) ? ground.point : Vector3.zero;

            Vector3 playerDirection = pointOnScreen - transform.position;
            playerDirection.y = 0;

            transform.rotation = Quaternion.LookRotation(playerDirection);
        }
    }
}
