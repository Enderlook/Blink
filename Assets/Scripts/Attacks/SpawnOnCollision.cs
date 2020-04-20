using System.Linq;

using UnityEngine;

namespace Game.Attacks.Projectiles
{
    [AddComponentMenu("Game/Attacks/Spawn On Collision")]
    public class SpawnOnCollision : MonoBehaviour
    {
        [SerializeField, Tooltip("Prefab spawn on hit.")]
        private GameObject prefab;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnCollisionEnter(Collision collision)
        {
            ContactPoint contact = collision.contacts[0];
            Quaternion contactRotation = Quaternion.FromToRotation(Vector3.up, contact.normal);
            SpawnPrefab(contact.point, contactRotation);
            Destroy(gameObject);
        }

        private void SpawnPrefab(Vector3 position, Quaternion rotation)
        {
            GameObject instance = Instantiate(prefab, position, rotation);
            Destroy(instance, instance.GetComponentsInChildren<ParticleSystem>().Max(e => e.main.duration));
        }
    }
}
