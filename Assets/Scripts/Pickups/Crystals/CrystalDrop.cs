using Enderlook.Utils.Exceptions;

using Game.Creatures;
using Game.Creatures.Player.AbilitySystem;
using Game.Pickups.Crystals;
using Game.Scene;

using System;

using UnityEngine;

namespace Game.Pickups.Orbs
{
    [AddComponentMenu("Game/Pickups/Crystal/Crystal Drop")]
    public class CrystalDrop : Pickup, IPickupable<PlayerPickupMagnet>
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Amount of hit points restored to crystal.")]
        private int healCrystalAmount = 5;

        [SerializeField, Tooltip("Charge restored when picked up.")]
        private float charge = 1;
#pragma warning restore CS0649

        public void Accept(PlayerPickupMagnet picker)
        {
            CrystalAndPlayerTracker.CrystalHurtable.TakeHealing(healCrystalAmount);
            picker.AbilitiesManager.ChargeManualAbilities(charge);
            Pick();
        }
    }
}