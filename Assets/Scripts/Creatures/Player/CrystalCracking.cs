using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Crystal/Cracking")]
    public class CrystalCracking : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private IntGetReference health;

        [SerializeField]
        private IntGetReference maxHealth;

        [SerializeField]
        private IntEventReference healthEvent;

        [SerializeField]
        private Material materialCrystal;
#pragma warning restore CS0649

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            healthEvent.Register(OnChange);
            materialCrystal.SetFloat("_Health", (float)health / maxHealth);
        }

        public void OnChange(int _) => materialCrystal.SetFloat("_Health", (float)health / maxHealth);
    }
}