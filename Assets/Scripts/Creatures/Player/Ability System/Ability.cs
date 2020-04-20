﻿using Enderlook.Unity.Attributes;
using Enderlook.Unity.Utils.Clockworks;
using Enderlook.Unity.Utils.Interfaces;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class Ability : ScriptableObject, IInitialize<AbilitiesManager>, IUpdate
    {
#pragma warning disable IDE0051
        [Header("Setup")]
        [SerializeField, Multiline]
        private string description;

        [SerializeField/*, DrawTexture(50, false)*/]
        private Sprite icon;

        [SerializeField, Tooltip("Animation executed on shoot.")]
        private string animationName;

        [field: SerializeField, IsProperty, Tooltip("This value must match with the value used by the animation event in order to raise this ability properly.")]
        public string Key { get; private set; }

        [Header("Configuration")]
        [SerializeField]
        private Control control;

        [SerializeField, Tooltip("Time to use this ability again in seconds.")]
        private float cooldown = 1;
#pragma warning restore

        private BasicClockwork clockwork;
        private Animator animator;
        private bool isActive;

        public bool IsReady => clockwork.IsReady;

        public void Initialize(AbilitiesManager abilityManager)
        {
            clockwork = new BasicClockwork(cooldown);
            animator = abilityManager.Animator;

            // Fix bug
            isActive = false;

            PostInitialize(abilityManager);
        }

        public virtual void PostInitialize(AbilitiesManager abilitiesManager) { }

        public void UpdateBehaviour(float deltaTime)
        {
            if (!isActive)
                clockwork.UpdateBehaviour(deltaTime);
        }

        public void TryExectue()
        {
            if (IsReady && control.HasUserRequestTrigger())
            {
                isActive = true;
                animator.SetTrigger(animationName);
            }
        }

        public void TriggerFromAnimator()
        {
            isActive = false;
            Execute();
        }

        public abstract void Execute();
    }
}
