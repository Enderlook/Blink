using UnityEngine;

namespace Game.Creatures.Abilities
{
    public abstract class Ability : ScriptableObject
    {
        [SerializeField, Tooltip("Ability name.")]
        private string abilityName;

        [SerializeField, Tooltip("Ability sprite.")]
        private Sprite abilitySprite;

        [SerializeField, Tooltip("Cooldown.")]
        private float cooldown = 1f;

        [SerializeField, Tooltip("Damage.")]
        protected float damage;

        public string AbilityName => abilityName;

        public float Cooldown => cooldown;

        public abstract void Initialize(GameObject gameObj);



        public abstract void TriggerAbility();

        public void KeyDown() => OnKeyDown();

        protected virtual void OnKeyDown() { }

        public void KeyHold() => OnKeyHold();

        protected virtual void OnKeyHold() { }
    }
}

