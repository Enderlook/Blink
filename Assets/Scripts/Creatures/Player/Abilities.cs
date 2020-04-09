using System.Linq;
using System.Collections.Generic;
using UnityEngine;

using Game.Creatures.Abilities;

namespace Game.Creatures.Player
{
    public class Abilities : MonoBehaviour
    {
        [SerializeField, Tooltip("Ability")]
        private List<Ability> abilities;

        private void Awake() => Initialize(abilities);

        public void Initialize(List<Ability> selectedAbility)
        {
            foreach (Ability ability in selectedAbility)
            {
                ability.Initialize(gameObject);
                ability.AwakeBehaviour();
            }
        }

        private void Update()
        {
            foreach (Ability ability in abilities)
            {
                bool shouldShoot = ability.CanBeHoldDown
                    ? Input.GetKey(ability.KeyButton) || (Input.GetMouseButton(ability.ThisMouseButton) && ability.ThisMouseButton != -1)
                    : Input.GetKeyDown(ability.KeyButton) || (Input.GetMouseButtonDown(ability.ThisMouseButton) && ability.ThisMouseButton != -1);

                if (shouldShoot && ability.CanBeHoldDown)
                    ability.ButtonHold();
                else if (shouldShoot)
                    ability.ButtonDown();
            }
        }
    }
}
