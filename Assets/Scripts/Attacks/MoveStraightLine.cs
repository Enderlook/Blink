using UnityEngine;

namespace Game.Attacks.Projectiles
{
    [RequireComponent(typeof(Rigidbody)), AddComponentMenu("Game/Attacks/Move Straight Line")]
    public class MoveStraightLine : MonoBehaviour
    {
        [SerializeField, Tooltip("Speed of movement per second.")]
        private float speed;

        private Rigidbody thisRigidbody;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => thisRigidbody = GetComponent<Rigidbody>();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void FixedUpdate() => thisRigidbody.MovePosition(thisRigidbody.position + (transform.forward * speed * Time.fixedDeltaTime));

        public static void AddComponentTo(GameObject source, float speed)
        {
            MoveStraightLine component = source.AddComponent<MoveStraightLine>();
            component.speed = speed;
        }
    }
}