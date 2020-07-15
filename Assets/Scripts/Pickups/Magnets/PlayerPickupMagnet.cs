using Game.Creatures;
using Game.Creatures.Player.AbilitySystem;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Player Pickup Magnet"), RequireComponent(typeof(Hurtable)), RequireComponent(typeof(PlayerAbilitiesManager))]
    public class PlayerPickupMagnet : PickupMagnet<PlayerPickupMagnet>
    {
        public Hurtable Hurtable { get; private set; }

        public PlayerAbilitiesManager AbilitiesManager { get; private set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            Hurtable = GetComponent<Hurtable>();
            AbilitiesManager = GetComponent<PlayerAbilitiesManager>();
        }

        protected override void Visit(IPickupable<PlayerPickupMagnet> pickup) => pickup.Accept(this);
    }
}