using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using AvalonStudios.Extensions;

namespace AvalonStudios.VFX
{
    [RequireComponent(typeof(Rigidbody))]
    public class ProjectileMotion : MonoBehaviour
    {
        public GameObject HitVFX => hitVFX;

        [SerializeField, Tooltip("Rigidbody")]
        private Rigidbody rb = null;

        [SerializeField, Tooltip("Speed")]
        private float speed;

        [SerializeField, Tooltip("Ignore layer.")]
        private LayerMask ignoreLayer;

        [SerializeField, Tooltip("Enemy layer.")]
        private LayerMask enemyLayer;

        [Header("Prefabs")]

        [SerializeField, Tooltip("Hit prefab.")]
        private GameObject hitVFX;

        [Header("Destroy Trails")]

        [SerializeField, Tooltip("List of GameObjects attach to parent object.")]
        private List<GameObject> trails;

        private void FixedUpdate()
        {
            if (speed != 0 && rb != null)
                rb.velocity = (rb.transform.forward * speed);
        }

        private void OnCollisionEnter(Collision collider)
        {
            if (collider.gameObject.layer != ignoreLayer.ToLayer())
            {
                ContactPoint contact = collider.contacts[0];
                Quaternion contactRotation = Quaternion.FromToRotation(Vector3.up, contact.normal);
                Vector3 contactPosition = contact.point;

                if (hitVFX != null)
                {
                    GameObject hitObj = Instantiate(hitVFX, contactPosition, contactRotation);

                    ParticleSystem psHit = hitObj.GetComponent<ParticleSystem>();

                    ParticleSystem ps = psHit == null ? hitObj.transform.GetChild(0).GetComponent<ParticleSystem>() : psHit;

                    Destroy(hitObj, ps.main.duration);
                }

                StartCoroutine(DestroyParticles(0f));
            }
        }

        public IEnumerator DestroyParticles(float waitTime)
        {
            if (transform.childCount > 0 && waitTime != 0)
            {
                List<Transform> transforms = new List<Transform>();

                foreach (Transform t in transform.GetChild(0).transform)
                    transforms.Add(t);

                while (transform.GetChild(0).localScale.x > 0)
                {
                    yield return new WaitForSeconds(0.01f);
                    Vector3 newScale = new Vector3(.1f, .1f, .1f);
                    transform.GetChild(0).localScale -= newScale;
                    foreach (Transform t in transforms)
                        t.localScale -= newScale;
                }
            }

            yield return new WaitForSeconds(waitTime);
            Destroy(gameObject);
        }
    }
}
