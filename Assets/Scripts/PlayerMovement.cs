using Enderlook.Unity.Atoms;

using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField, Tooltip("Animator component.")]
        private Animator animator;

        [SerializeField, Tooltip("Run animation name.")]
        private string runAnimation;

        [SerializeField, Tooltip("Movement speed.")]
        private FloatGetReference speed;

        [SerializeField, Tooltip("Layer to get mouse position.")]
        private LayerMask layerGround;

        // We hide a Unity obsolete API
        private new Rigidbody rigidbody;

        private Vector3 velocity;
        

        private int LayerGround => 1 << layerGround.ToLayer();

        private void Awake() => rigidbody = GetComponent<Rigidbody>();

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

            RaycastHit ground;

            Vector3 pointOnScreen = Physics.Raycast(camRayPoint, out ground, LayerGround) ? ground.point : Vector3.zero;

            Vector3 playerDirection = rigidbody.position.VectorSubtraction(pointOnScreen);

            playerDirection.y = 0;

            Quaternion newPlayerDirection = Quaternion.LookRotation(playerDirection);

            rigidbody.MoveRotation(newPlayerDirection);
        }
    }
}
