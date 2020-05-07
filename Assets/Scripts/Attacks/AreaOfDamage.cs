using Game.Creatures;

using System;
using System.Collections;

using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Area of Damage")]
    public class AreaOfDamage : MonoBehaviour
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Damage done on explsoion.")]
        private int damage = 10;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        [Header("Setup")]
        [SerializeField, Tooltip("Time since spawn to produce damage.")]
        private float timeToExplode = 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => StartCoroutine(Explode());

        private IEnumerator Explode()
        {
            Collider[] colliders = GetComponentsInChildren<Collider>();
            Array.ForEach(colliders, e => e.enabled = false);
            yield return new WaitForSeconds(timeToExplode);
            Array.ForEach(colliders, e => e.enabled = true);
            yield return null;
            Array.ForEach(colliders, e => e.enabled = false);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnTriggerEnter(Collider other)
        {
            GameObject otherGameObject = other.gameObject;
            if (damage > 0 && otherGameObject.TryGetComponent(out IDamagable damagable))
                damagable.TakeDamage(damage);

            if (pushForce > 0 && otherGameObject.TryGetComponent(out IPushable pushable))
                pushable.AddForce((other.transform.position - transform.position) * pushForce, ForceMode.Impulse);
        }

        public static void AddComponentTo(GameObject source, float timeToExplode, int damage, float pushForce = 0)
        {
            AreaOfDamage component = source.AddComponent<AreaOfDamage>();
            component.damage = damage;
            component.pushForce = pushForce;
            component.timeToExplode = timeToExplode;
        }
    }
}