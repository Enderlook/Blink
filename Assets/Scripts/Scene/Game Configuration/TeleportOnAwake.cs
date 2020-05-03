using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Scene
{
    public class TeleportOnAwake : MonoBehaviour
    {
        [SerializeField, Tooltip("Determines in which location the crystal will be placed."), DrawVectorRelativeToTransform(true)]
        private Vector3 crystal;

        [SerializeField, Tooltip("Determines in which location the player will be placed."), DrawVectorRelativeToTransform(true)]
        private Vector3 player;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            CrystalAndPlayerTracker.Crystal.position = crystal;
            CrystalAndPlayerTracker.Player.position = player;
        }
    }
}