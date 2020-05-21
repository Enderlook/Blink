using Enderlook.Utils.Exceptions;

using Game.Creatures;
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
        [Header("All")]
        [SerializeField, Tooltip("Amount of hit points restored to crystal.")]
        private int healCrystalAmount = 5;

        [Header("Earth")]
        [SerializeField, Tooltip("Maximum health increase.")]
        private int maxHealthAmount = 5;
#pragma warning restore CS0649

        public void Accept(PlayerPickupMagnet picker)
        {
            CrystalAndPlayerTracker.CrystalHurtable.TakeHealing(healCrystalAmount);
            ProduceEffect();
            Pick();
        }

        private void ProduceEffect()
        {
            switch (CrystalDropConfiguration.Element)
            {
                case CrystalElement.Air:
                    Air();
                    break;
                case CrystalElement.Earth:
                    Earth();
                    break;
                case CrystalElement.Fire:
                    Fire();
                    break;
                case CrystalElement.Water:
                    Water();
                    break;
                default:
                    throw new ImpossibleStateException();
            }
        }

        private void Water()
        {
            throw new NotImplementedException();
        }

        private void Fire()
        {
            throw new NotImplementedException();
        }

        private void Earth()
        {
            Hurtable crystalHurtable = CrystalAndPlayerTracker.CrystalHurtable;
            crystalHurtable.SetMaxHealth(maxHealthAmount + crystalHurtable.MaxHealth);
            crystalHurtable.TakeHealing(maxHealthAmount);
        }

        private void Air()
        {
            throw new NotImplementedException();
        }
    }
}