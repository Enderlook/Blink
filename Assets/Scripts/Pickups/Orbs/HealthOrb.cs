using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Health Orb")]
    public class HealthOrb : Orb, IPickupable<PlayerPickupMagnet>
    {
        public void Accept(PlayerPickupMagnet picker)
        {
            picker.hurtable.TakeHealing(value);
            Destroy(gameObject);
        }
    }
}