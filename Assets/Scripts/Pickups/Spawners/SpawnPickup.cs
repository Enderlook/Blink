using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Pickups
{
    public abstract class SpawnPickup : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Random range of spawning.")]
        private float spawnRadius;

        [SerializeField, Tooltip("Pickups can't spawn closer than this range.")]
        private float minSpawnRadius;

        [SerializeField, Tooltip("Center of spawn range."), DrawVectorRelativeToTransform]
        private Vector3 spawnPoint;

        [SerializeField, Tooltip("Velocity at which pickups are spawned.")]
        private float spawnSpeed;

        [SerializeField, Tooltip("Only spawn above the Y position of Spawn Radius.")]
        private bool spawnOnlyAbove;
#pragma warning restore CS0649

        protected T Spawn<T>(T prefab) where T : Object
        {
            Vector3 center = spawnPoint + transform.position;
            Vector3 offset = spawnRadius * Random.onUnitSphere;
            if (spawnOnlyAbove)
                offset.y = Mathf.Max(offset.y, spawnPoint.y);
            if (offset.magnitude < minSpawnRadius)
                offset = offset * minSpawnRadius / offset.magnitude;
            T instance = Instantiate(prefab, offset + center, transform.rotation);

            Rigidbody rigidbody = null;
            if (instance is GameObject gameObject)
                rigidbody = gameObject.GetComponent<Rigidbody>();
            else if (instance is Component component)
                rigidbody = component.GetComponent<Rigidbody>();

            if (rigidbody != null)
                rigidbody.AddForce(offset.normalized * spawnSpeed, ForceMode.VelocityChange);

            return instance;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnDrawGizmos()
        {
            Gizmos.color = (Color.red + Color.yellow) / 2;
            Gizmos.DrawWireSphere(spawnPoint + transform.position, minSpawnRadius);
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(spawnPoint + transform.position, spawnRadius);
        }
    }
}