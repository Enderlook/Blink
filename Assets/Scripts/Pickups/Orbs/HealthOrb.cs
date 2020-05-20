using UnityEngine;

namespace Game.Pickups.Orbs
{
    [AddComponentMenu("Game/Pickups/Orbs/Health Orb")]
    public class HealthOrb : Orb, IPickupable<PlayerPickupMagnet>
    {
        public void Accept(PlayerPickupMagnet picker)
        {
            picker.hurtable.TakeHealing(value);
            Pick();
        }
    }
}