using Enderlook.Unity.Extensions;

using System;
using System.Collections;

using UnityEngine;

namespace Game.Attacks
{
    public abstract class AreaOfEffect : MonoBehaviour
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Layer to affect.")]
        protected LayerMask hitLayer;

        [Header("Setup")]
        [SerializeField, Tooltip("Time since spawn to produce effect.")]
        protected float warmupTime = 1;

        [SerializeField, Tooltip("Duration of effect in seconds. If 0, it's one frame")]
        protected float duration;
#pragma warning restore CS0649

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => StartCoroutine(Activate());

        private IEnumerator Activate()
        {
            Collider[] colliders = GetComponentsInChildren<Collider>();
            Array.ForEach(colliders, e => e.enabled = false);
            yield return new WaitForSeconds(warmupTime);
            Array.ForEach(colliders, e => e.enabled = true);
            yield return duration == 0 ? null : new WaitForSeconds(duration);
            Array.ForEach(colliders, e => e.enabled = false);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnTriggerEnter(Collider other)
        {
            GameObject otherGameObject = other.gameObject;
            if (otherGameObject.LayerMatchTest(hitLayer))
                ProduceEffect(otherGameObject);
        }

        protected abstract void ProduceEffect(GameObject otherGameObject);
    }
}