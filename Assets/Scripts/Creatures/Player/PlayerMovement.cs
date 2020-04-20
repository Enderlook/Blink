using AvalonStudios.Extensions;

using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Rigidbody)), RequireComponent(typeof(Animator))]
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField, Tooltip("Run animation name.")]
        private string runAnimation;

        [SerializeField, Tooltip("Movement speed.")]
        private FloatGetReference speed;
#pragma warning restore CS0649

        [SerializeField, Tooltip("Layer to get mouse position.")]
        private LayerMask layerGround;

        [SerializeField, Tooltip("Range of the ray.")]
        private float range;

        // We hide a Unity obsolete API
        private new Rigidbody rigidbody;

        private Animator animator;

        private Vector3 velocity;

        private int LayerGround => 1 << layerGround.ToLayer();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            rigidbody = GetComponent<Rigidbody>();
            animator = GetComponent<Animator>();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void FixedUpdate()
        {
            float horizontal = Input.GetAxis("Horizontal");
            float vertical = Input.GetAxis("Vertical");

            Move(horizontal, vertical);
            Turn();
        }

        private void Move(float horizontal, float vertical)
        {
            velocity = new Vector3(horizontal, 0, vertical);
            velocity = velocity.normalized * speed * Time.deltaTime;

            rigidbody.MovePosition(rigidbody.position + velocity);

            bool running = horizontal != 0 || vertical != 0;
            animator.SetBool(runAnimation, running);
        }

        private void Turn()
        {
            Ray camRayPoint = Camera.main.ScreenPointToRay(Input.mousePosition);

            Vector3 pointOnScreen = Physics.Raycast(camRayPoint, out RaycastHit ground, range, LayerGround) ? ground.point : Vector3.zero;

            Vector3 playerDirection = rigidbody.position.VectorSubtraction(pointOnScreen);

            playerDirection.y = 0;

            Quaternion newPlayerDirection = Quaternion.LookRotation(playerDirection);

            rigidbody.MoveRotation(newPlayerDirection);
        }
    }
}
