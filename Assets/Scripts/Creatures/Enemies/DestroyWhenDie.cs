using Enderlook.Unity.Atoms;
using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Destroy When Die")]
    public class DestroyWhenDie : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("When value reach 0 the Game Object is destroyed.")]
        private IntEventReference healthEvent;

        [SerializeField, Tooltip("Active to use animator")]
        private bool useAnimator;

        [SerializeField, Tooltip("Animator component"), ShowIf(nameof(useAnimator), true)]
        private Animator animator;

        [SerializeField, Tooltip("Dead animation key"), ShowIf(nameof(useAnimator), true)]
        private string deadAnimation;
#pragma warning restore CS0649

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => healthEvent.Register(CheckIfDeath);

        private void CheckIfDeath(int health)
        {
            if (health == 0)
            {
                if (useAnimator)
                    animator.SetBool(deadAnimation, true);
                else
                    Destroy(gameObject);
            }
        }

        public void DestroyByAnimationEvent() => Destroy(gameObject);
    }
}