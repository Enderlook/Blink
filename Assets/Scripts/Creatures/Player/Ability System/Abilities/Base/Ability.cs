using Enderlook.Unity.Attributes;
using Enderlook.Unity.Utils.Interfaces;

using System;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class Ability : ScriptableObject, IInitialize<AbilitiesManager>
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Required charge to execute.")]
        private float maxCharge;

        [field: Header("Setup")]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        [field: SerializeField, IsProperty/*, DrawTexture(50, false)*/]
        public Sprite Icon { get; private set; }
#pragma warning restore CS0649

        private float charge;

        public float Percent => charge / maxCharge;

        public virtual bool IsReady => charge == maxCharge;

        public virtual void Initialize(AbilitiesManager initializer) { }

        public void ChargeToMaximum() => charge = maxCharge;

        public void Charge(float amount) => charge = Mathf.Min(charge + amount, maxCharge);

        public void Execute()
        {
            if (!IsReady)
                throw new InvalidOperationException($"{nameof(Ability)} {name} can't be executed because {nameof(IsReady)} is false.");

            charge = 0;

            ExecuteBehaviour();
        }

        protected abstract void ExecuteBehaviour();
    }
}
