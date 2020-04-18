using Enderlook.Unity.Atoms;

using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField, Tooltip("Animator component.")]
        private Animator animator = null;

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

        private Vector3 velocity;        

        private int LayerGround => 1 << layerGround.ToLayer();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => rigidbody = GetComponent<Rigidbody>();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void FixedUpdate()
        {
            float hor = Input.GetAxis("Horizontal");
            float ver = Input.GetAxis("Vertical");

            Move(hor, ver, speed);

            Turn();
        }

        private void Move(float h, float v, float s)
        {
            velocity.Set(h, 0, v);

            velocity = velocity.normalized * s * Time.deltaTime;

            rigidbody.MovePosition(rigidbody.position + velocity);

            bool running = h != 0 || v != 0;

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
