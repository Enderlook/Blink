using Enderlook.Unity.Attributes;

using UnityEngine;

using RangeInt = Enderlook.Unity.Serializables.Ranges.RangeInt;

namespace Game.Pickups
{
    public abstract class SpawnOrbs : MonoBehaviour
    {
        [SerializeField, Tooltip("Prefab of orbs to spawn.")]
        private Orb prefab;

        [SerializeField, Tooltip("Range of energy to spawn.")]
        private RangeInt valueToSpawn;

        [SerializeField, Tooltip("Random range of spawning.")]
        private float spawnRadius;

        [SerializeField, Tooltip("Center of spawn range."), DrawVectorRelativeToTransform]
        private Vector3 spawnPoint;

        [SerializeField, Tooltip("Speed at which orbs are spawned.")]
        private float spawnSpeed;

        protected void Spawn()
        {
            int value = valueToSpawn.Value;
            int maximumSize = (int)(Mathf.Log(value + 7, 1.25f) - 8);

            while (value > 0)
            {
                int current = Random.Range(Mathf.Max(maximumSize / 2, 1), maximumSize);
                if (current > value)
                {
                    Spawn(value);
                    return;
                }
                value -= current;
                Spawn(current);
            }
        }

        private void Spawn(int value)
        {
            Vector3 center = spawnPoint + transform.position;
            Vector3 position = center + (spawnRadius * Random.onUnitSphere);
            Orb instance = Instantiate(prefab, position, transform.rotation);
            instance.SetValue(value);

            if (instance.TryGetComponent(out Rigidbody rigidbody))
                rigidbody.AddForce((position - center).normalized * spawnSpeed, ForceMode.VelocityChange);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnDrawGizmos()
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(spawnPoint + transform.position, spawnRadius);
        }
    }
}