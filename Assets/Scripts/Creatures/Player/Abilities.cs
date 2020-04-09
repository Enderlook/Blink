using UnityEngine;
using Game.Creatures.Abilities;

namespace Game.Creatures.Player
{
    public class Abilities : MonoBehaviour
    {
        public enum MouseButton { None = -1, Left = 0, Right = 1, Middle = 2 }

        [SerializeField, Tooltip("Ability")]
        private Ability ability;

        [SerializeField, Tooltip("Mouse button.")]
        private MouseButton mouseButton;

        private float cooldownDuration;
        private float nextReadyTime;
        private float cooldownTimeLeft;

        private void Awake() => Initialize(ability);

        public void Initialize(Ability selectedAbility)
        {
            ability = selectedAbility;
            cooldownDuration = ability.Cooldown;
            ability.Initialize(gameObject);
        }

        private void Update()
        {
            if (Time.time > nextReadyTime)
            {
                if (Input.GetMouseButtonDown((int)mouseButton) && mouseButton != MouseButton.None)
                {
                    Triggered();
                }
            }
            else
            {
                Cooldown();
            }
        }

        private void Cooldown()
        {
            cooldownTimeLeft -= Time.deltaTime;
        }

        private void Triggered()
        {
            nextReadyTime = cooldownDuration + Time.time;
            cooldownTimeLeft = cooldownDuration;
            ability.TriggerAbility();
        }
    }
}
