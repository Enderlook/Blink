using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Ability", menuName = "Game/Ability System/Abilities/Animated")]
    public class AnimatedAbility : TriggerableAbility
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Animation to execute.")]
        private string animationName;

        [field: SerializeField, IsProperty, Tooltip("This value must match with the value used by the animation event in order to raise this ability properly.")]
        public string Key { get; private set; }
#pragma warning restore CS0649

        private Animator animator;

        protected override sealed void PostInitialize(AbilitiesManager initializer) => animator = initializer.Animator;

        protected override sealed void ExecuteStart() => animator.SetTrigger(animationName);
    }
}
