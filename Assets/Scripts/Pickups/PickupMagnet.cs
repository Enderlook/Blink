using Enderlook.Unity.Extensions;
using UnityEngine;

namespace Game.Pickups
{
    public abstract class PickupMagnet<T> : MonoBehaviour where T : PickupMagnet<T>
    {
        [SerializeField, Min(0), Tooltip("Maximum distance to pickup items.")]
        private float pickingRadius;

        [SerializeField, Min(0), Tooltip("Maximum distance where items are pulled.")]
        private float magnetRadius;

        [SerializeField, Min(0), Tooltip("Pulling speed.")]
        private float magnetSpeed;

        [SerializeField, Tooltip("Items from which layers are picked up.")]
        private LayerMask layerToPickup;

        private int magnetFrameCheck;
        private static int frameCheck;
        private const int MAX_CHECK_FRAME = 3;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => magnetFrameCheck = frameCheck++ % MAX_CHECK_FRAME;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (Time.frameCount % MAX_CHECK_FRAME != magnetFrameCheck)
                return;

            float radius = pickingRadius * pickingRadius;
            Collider[] items = Physics.OverlapSphere(transform.position, magnetRadius, layerToPickup);
            for (int i = 0; i < items.Length; i++)
            {
                Transform item = items[i].transform;
                if (!item.TryGetComponent(out IPickupable<T> pickup))
                    continue;

                if (item.TryGetComponent(out Rigidbody2D rigidbody))
                    rigidbody.AddForce((transform.position - item.position).normalized * magnetSpeed);
                else
                    item.position = Vector3.MoveTowards(item.position, transform.position, magnetSpeed * Time.deltaTime * MAX_CHECK_FRAME);
                if ((item.position - transform.position).sqrMagnitude <= radius)
                    Visit(pickup);
            }
        }

        protected abstract void Visit(IPickupable<T> pickup);

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnDrawGizmos()
        {
            Gizmos.color = Color.blue;
            Gizmos.DrawWireSphere(transform.position, magnetRadius);

            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(transform.position, pickingRadius);
        }
    }
}