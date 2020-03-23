using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures.Player
{
    [RequireComponent(typeof(Rigidbody))]
    public class PlayerMovement : MonoBehaviour
    {
        [SerializeField]
        private FloatGetReference speed;

        // We hide a Unity obsolete API
        private new Rigidbody rigidbody;

        private void Awake() => rigidbody = GetComponent<Rigidbody>();

        private void Update()
        {
            float s = speed;
            rigidbody.velocity = new Vector3(Input.GetAxis("Horizontal") * s, 0, Input.GetAxis("Vertical") * s);
        }
    }
}
