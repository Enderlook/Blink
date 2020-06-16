﻿using Enderlook.Unity.Attributes;

using Game.Scene;

using System;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [RequireComponent(typeof(Animator)), AddComponentMenu("Game/Ability System/Managers/Abilites Manager")]
    public class AbilitiesManager : MonoBehaviour
    {
#pragma warning disable CS0649
        [field: SerializeField, IsProperty, Tooltip("Where ablities which requires a shooting point does shoot.")]
        public Transform ShootingPosition { get; private set; }

        [field: SerializeField, IsProperty]
        protected AbilityUIManager UIManager { get; private set; }
#pragma warning restore CS0649

        [NonSerialized]
        private AbilitiesPack abilities;

        public Animator Animator { get; private set; }

        protected GameManager gameManager;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            gameManager = FindObjectOfType<GameManager>();
            Animator = GetComponent<Animator>();
        }

        public void ChargeAbilitiesToMaximum()
        {
            for (int i = 0; i < abilities.Count; i++)
            {
                abilities[i].ChargeToMaximum();
                UIManager.UpdateAbility(i);
            }
        }

        protected void SetAbilities(AbilitiesPack abilities)
        {
            abilities.Initialize(this);
            this.abilities = abilities;
            UIManager.SetAbilities(abilities);
        }

        public void ActiveSkill(string key) => abilities.TriggerAbilityWithKey(key);
    }
}
