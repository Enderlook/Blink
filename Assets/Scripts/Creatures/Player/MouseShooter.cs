using UnityEngine;
using Game.Creatures.Abilities.ShootAbility;

namespace Game.Creatures.Player
{
    public class MouseShooter : MonoBehaviour
    {
        [SerializeField, Tooltip("Animator component")]
        private Animator animator;

        private string animationName;
        private float damage;

        public void Initialize(ShootAbility shootAbility)
        {
            animationName = shootAbility.AnimationName;
            damage = shootAbility.Damage;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        public void Fire()
        {
            animator.SetTrigger(animationName);
        }
    }
}