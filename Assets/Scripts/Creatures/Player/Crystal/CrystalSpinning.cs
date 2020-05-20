using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Crystal
{
    [AddComponentMenu("Game/Creatures/Crystal/Spining"), RequireComponent(typeof(Animator))]
    public class CrystalSpinning : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Maximum additional animation speed.")]
        private float maximumSpeed = 1;
#pragma warning restore CS0649

        private Animator animator;

        private GameManager gameManager;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            animator = GetComponent<Animator>();
            gameManager = FindObjectOfType<GameManager>();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update() => animator.speed = 1 + (gameManager.EnergyPercent * maximumSpeed);
    }
}