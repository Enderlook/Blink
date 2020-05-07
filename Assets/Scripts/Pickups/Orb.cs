using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Orb")]
    public class Orb : MonoBehaviour, IPickupable<CrystalPickupMagnet>
    {
        [SerializeField, Tooltip("Amount of energy given when picked up."), Min(1)]
        private int energy = 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => AutoSize();

        private void AutoSize() => transform.localScale *= Mathf.Pow(energy + 4, .25f) - .5f;

        public void Accept(CrystalPickupMagnet picker)
        {
            picker.AddEnergy(energy);
            Destroy(gameObject);
        }

        public void SetEnergy(int energy)
        {
            this.energy = energy;
            AutoSize();
        }
    }
}