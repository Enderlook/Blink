using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class AnimatedAbility : TriggerableAbility
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Animation to execute.")]
        private string animationName;

        [field: SerializeField, IsProperty, Tooltip("This value must match with the value used by the animation event in order to raise this ability properly.")]
        public string Key { get; private set; }
#pragma warning restore CS0649

        private Animator animator;

        public override sealed void Initialize(AbilitiesManager manager)
        {
            animator = manager.Animator;
            PostInitialize(manager);
        }

        public virtual void PostInitialize(AbilitiesManager manager) { }

        protected override sealed void ExecuteStart() => animator.SetTrigger(animationName);
    }
}
