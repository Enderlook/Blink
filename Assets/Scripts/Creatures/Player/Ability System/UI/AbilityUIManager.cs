using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI Manager")]
    public abstract class AbilityUIManager : MonoBehaviour
    {
        [SerializeField]
        protected RectTransform abilitiesRoot;

        private AbilitiesPack abilities;
        protected virtual AbilityUI[] AbilitiesUIs { get; }

        public void UpdateAbility(int index)
            => AbilitiesUIs[index].SetLoadPercentage(abilities[index]);

        public virtual void SetAbilities(AbilitiesPack abilities)
            => this.abilities = abilities;

        public abstract bool CanUseAbility(int index);

        public abstract void ToggleAbility(int index);

        public abstract void ToggleAbility(AbilityUI abilityUI);
    }
}