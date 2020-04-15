using UnityEngine;

using Game.Creatures.Player;

namespace Game.Creatures.AbilitiesSystem
{
    public abstract class Ability : ScriptableObject
    {
        public enum IconTypes { None, Icon }

        public enum MouseButton { None = -1, Left = 0, Right = 1, Middle = 2 }

        [SerializeField]
        private string abilityName;

        [SerializeField]
        private string description;

        [SerializeField]
        private IconTypes iconType;

        [SerializeField]
        private Sprite abilityIcon;

        [SerializeField]
        private float cooldown = 1f;

        //protected float damage;

        [SerializeField]
        private KeyCode keyButton;

        [SerializeField]
        private MouseButton mouseButton;

        [SerializeField]
        private bool canBeHoldDown;

        // Properties
        public Animator ThisAnimator { get { return animator; } set { animator = value; } }

        public string AbilityName { get { return abilityName; } set { abilityName = value; } }

        public string Description { get { return description; } set { description = value; } }

        public float Cooldown { get { return cooldown; } set { cooldown = value; } }

        public KeyCode KeyButton { get { return keyButton; } set { keyButton = value; } }

        public MouseButton ThisMouseButton { get { return mouseButton; } set { mouseButton = value; } }

        public bool CanBeHoldDown { get { return canBeHoldDown; } set { canBeHoldDown = value; } }

        public IconTypes IconType { get { return iconType; } set { iconType = value; } }

        public Sprite AbilityIcon { get { return abilityIcon; } set { abilityIcon = value; } }

        // Privates variables

        private Animator animator;
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

