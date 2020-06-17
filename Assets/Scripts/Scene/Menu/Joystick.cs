﻿using Game.Creatures.Player;

using UnityEngine;
using UnityEngine.EventSystems;

namespace Game.Scene
{
    public class Joystick : MonoBehaviour, IDragHandler, IEndDragHandler
    {
#pragma warning disable CS0649
        [SerializeField, Min(.01f), Tooltip("Maximum distance that button can move out.")]
        private float maxDistance;

        [SerializeField, Min(.01f), Tooltip("Minimum distance from center to start moving.")]
        private float minDistance;
#pragma warning restore CS0649

        private PlayerMovement playerMovement;

        public bool IsDragging { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => playerMovement = FindObjectOfType<PlayerMovement>();

        public void OnEndDrag(PointerEventData eventData)
        {
            IsDragging = false;
            transform.localPosition = Vector3.zero;
        }

        public void OnDrag(PointerEventData eventData)
        {
            IsDragging = true;

            transform.position = eventData.position;
            Vector3 localPosition = Vector3.ClampMagnitude(transform.localPosition, maxDistance);
            transform.localPosition = localPosition;

            if (localPosition.magnitude >= minDistance)
            {
                localPosition = localPosition.normalized * (localPosition.magnitude - minDistance) / (maxDistance - minDistance);
                // In PC, players can have both axis at 1 but in mobile that would look odd in the joystick,
                // so we increases the values a bit
                playerMovement.SetMovementInput(Mathf.Sqrt(localPosition.x), Mathf.Sqrt(localPosition.y));
            }
        }

#if UNITY_EDITOR
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnValidate()
        {
            if (maxDistance <= minDistance)
                maxDistance = minDistance + .1f;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(transform.position, minDistance);
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(transform.position, maxDistance);
        }
#endif
    }
}