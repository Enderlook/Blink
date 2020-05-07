using Game.Creatures;

using System;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Player Pickup Magnet"), RequireComponent(typeof(Hurtable))]
    public class PlayerPickupMagnet : PickupMagnet<PlayerPickupMagnet>
    {
        [NonSerialized]
        public Hurtable hurtable;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => hurtable = GetComponent<Hurtable>();

        protected override void Visit(IPickupable<PlayerPickupMagnet> pickup) => pickup.Accept(this);
    }
}