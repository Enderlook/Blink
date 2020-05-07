using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Energy Orb")]
    public class EnergyOrb : Orb, IPickupable<CrystalPickupMagnet>
    {
        public void Accept(CrystalPickupMagnet picker)
        {
            picker.AddEnergy(value);
            Destroy(gameObject);
        }
    }
}