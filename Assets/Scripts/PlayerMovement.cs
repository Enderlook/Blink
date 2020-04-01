using Enderlook.Unity.Atoms;

using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField, Tooltip("Movement speed.")]
        private FloatGetReference speed;

        // We hide a Unity obsolete API
        private new Rigidbody rigidbody;

        private Vector3 velocity;
        private LayerMask layerGround = LayerMask.GetMask("Ground");

        private int LayerGround => 1 << layerGround.ToLayer();

        private void Awake() => rigidbody = GetComponent<Rigidbody>();

        private void FixedUpdate()
        {
            float h = Input.GetAxis("Horizontal");
            float v = Input.GetAxis("Vertical");

            Move(h, v, speed);

            Turn();
        }

        private void Move(float h, float v, float s)
        {
            velocity.Set(h, 0, v);

            velocity = velocity.normalized * s * Time.deltaTime;

            rigidbody.MovePosition(rigidbody.position + velocity);
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
