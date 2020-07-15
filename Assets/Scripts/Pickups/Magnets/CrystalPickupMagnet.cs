using Game.Scene;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Crystal Pickup Magnet")]
    public class CrystalPickupMagnet : PickupMagnet<CrystalPickupMagnet>
    {
        private GameManager gameManager;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => gameManager = FindObjectOfType<GameManager>();

        public void AddEnergy(int energy) => gameManager.AddEnergy(energy);

        protected override void Visit(IPickupable<CrystalPickupMagnet> pickup) => pickup.Accept(this);
    }
}