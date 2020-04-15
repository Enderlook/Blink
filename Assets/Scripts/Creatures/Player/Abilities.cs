using System.Collections.Generic;
using UnityEngine;

using Game.Creatures.AbilitiesSystem;

namespace Game.Creatures.Player
{
    public class Abilities : MonoBehaviour
    {
        [SerializeField, Tooltip("Animator component.")]
        private Animator animator = null;

        [SerializeField, Tooltip("Ability")]
        private List<Ability> abilities;

        [SerializeField, Tooltip("Shot Position.")]
        private Transform shotPosition;

        public Animator ThisAnimator => animator;

        public Transform ThisShotPosition => shotPosition;

        private void Awake() => Initialize(abilities);

        public void Initialize(List<Ability> selectedAbility)
        {
            foreach (Ability ability in selectedAbility)
            {
                ability.Initialize(this);
                ability.AwakeBehaviour();
            }
        }

        private void Update()
        {
            foreach (Ability ability in abilities)
            {
                bool shouldShoot = ability.CanBeHoldDown
                    ? Input.GetKey(ability.KeyButton) || (Input.GetMouseButton((int)ability.ThisMouseButton) && ability.ThisMouseButton != Ability.MouseButton.None)
                    : Input.GetKeyDown(ability.KeyButton) || (Input.GetMouseButtonDown((int)ability.ThisMouseButton) && ability.ThisMouseButton != Ability.MouseButton.None);

                if (shouldShoot && ability.CanBeHoldDown)
                    ability.ButtonHold();
                else if (shouldShoot)
                    ability.ButtonDown();
                ability.UpdateBehaviour();
            }
        }

        public void ActiveSkill() => abilities.ForEach(ability => { ability.TriggerAbility(); });
    }
}
