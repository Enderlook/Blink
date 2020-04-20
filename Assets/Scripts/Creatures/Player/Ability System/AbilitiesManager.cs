﻿using Enderlook.Unity.Attributes;
using System.Linq;
using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Abilites Manager")]
    [RequireComponent(typeof(Animator))]
    public class AbilitiesManager : MonoBehaviour
    {
        [SerializeField, Tooltip("Abilities of the player.")]
        private Ability[] abilities;

        [SerializeField, IsProperty, Tooltip("Where ablities which requires a shooting point does shoot.")]
        public Transform ShootingPosition;

        public Animator Animator { get; private set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            Animator = GetComponent<Animator>();
            foreach (Ability ability in abilities)
                ability.Initialize(this);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            foreach (Ability ability in abilities)
            {
                ability.UpdateBehaviour(Time.deltaTime);
                ability.TryExectue();
            }
        }

        public void ActiveSkill(string key) => abilities.First(e => e.Key == key).TriggerFromAnimator();
    }
}
