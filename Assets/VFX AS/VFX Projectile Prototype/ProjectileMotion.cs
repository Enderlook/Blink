using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ProjectileMotion : MonoBehaviour
{
    [SerializeField, Tooltip("Rigidbody")]
    private Rigidbody rb = null;

    [SerializeField, Tooltip("Speed")]
    private float speed;

    [SerializeField, Tooltip("Shoteable layer.")]
    private LayerMask shoteableLayer;

    private void Start()
    {
    }

    private void FixedUpdate()
    {
        if (speed != 0 && rb != null)
            rb.velocity = (rb.transform.forward * speed);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer != 5)
            Destroy(gameObject);
    }
}
