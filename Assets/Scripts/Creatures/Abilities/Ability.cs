using UnityEngine;
using Game.Creatures.Player;

namespace Game.Creatures.AbilitiesSystem
{
    public abstract class Ability : ScriptableObject
    {
        public enum MouseButton { None = -1, Left = 0, Right = 1, Middle = 2 }

        [SerializeField, Tooltip("Ability name.")]
        private string abilityName;

        [SerializeField, Tooltip("Ability sprite.")]
        private Sprite abilitySprite;

        [SerializeField, Tooltip("Cooldown.")]
        private float cooldown = 1f;
        

        [SerializeField, Tooltip("Damage.")]
        protected float damage;

        [SerializeField, Tooltip("Key.")]
        private KeyCode keyButton;

        [SerializeField, Tooltip("Mouse button.")]
        private MouseButton mouseButton;

        [SerializeField, Tooltip("Can be hold down.")]
        private bool canBeHoldDown;

        private Animator animator;

        public Animator ThisAnimator { get { return animator; } set { animator = value; } }

        public string AbilityName => abilityName;

        public float Cooldown => cooldown;

        public KeyCode KeyButton => keyButton;

        public int ThisMouseButton => (int)mouseButton;

        public bool CanBeHoldDown => canBeHoldDown;

        protected float lastCooldown = 0;

        public virtual void Initialize(Abilities abilities)
        {
            ThisAnimator = abilities.ThisAnimator;
        }

        public virtual void AwakeBehaviour()
        {
            lastCooldown = -Cooldown;
        }

        public virtual void UpdateBehaviour() { }

        public abstract void TriggerAbility();

        public void ButtonDown() => OnButtonDown();

        protected virtual void OnButtonDown() { }

        public void ButtonHold() => OnButtonHold();

        protected virtual void OnButtonHold() { }
    }
}

