using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Scene
{
    public class TeleportOnAwake : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Determines in which location the crystal will be placed."), DrawVectorRelativeToTransform(true)]
        private Vector3 crystal;

        [SerializeField, Tooltip("Determines in which location the player will be placed."), DrawVectorRelativeToTransform(true)]
        private Vector3 player;
#pragma warning restore CS0649

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            CrystalAndPlayerTracker.Crystal.position = crystal;
            CrystalAndPlayerTracker.Player.position = player;
        }
    }
}