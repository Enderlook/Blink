using UnityEngine;

namespace Game.Pickups.Orbs
{
    [AddComponentMenu("Game/Pickups/Orbs/Energy Orb")]
    public class EnergyOrb : Orb, IPickupable<CrystalPickupMagnet>
    {
        public void Accept(CrystalPickupMagnet picker)
        {
            picker.AddEnergy(value);
            Pick();
        }
    }
}