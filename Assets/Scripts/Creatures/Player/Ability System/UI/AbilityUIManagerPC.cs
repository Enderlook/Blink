using System;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI Manager PC")]
    public class AbilityUIManagerPC : AbilityUIManager
    {
        private const string NOT_SUPPORTED = "This method should only be called on mobile.";

        [SerializeField]
        private AbilityUI prefab;

        private AbilityUI[] abilitiesUIs = Array.Empty<AbilityUI>();
        protected override AbilityUI[] AbilitiesUIs => abilitiesUIs;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
#if UNITY_ANDROID && IGNORE_UNITY_REMOTE
            Destroy(this);
#endif
        }

        public override void SetAbilities(AbilitiesPack abilities)
        {
            base.SetAbilities(abilities);
            for (int i = 0; i < abilitiesUIs.Length; i++)
                Destroy(abilitiesUIs[i].gameObject);

            abilitiesUIs = new AbilityUI[abilities.Count];
            for (int i = 0; i < abilitiesUIs.Length; i++)
            {
                AbilityUI instance = Instantiate(prefab, abilitiesRoot);
                abilitiesUIs[i] = instance;
                Ability ability = abilities[i];
                instance.name += " " + ability.name;
                instance.Initialize(this);
                instance.SetSprite(ability.Icon);
                instance.SetLoadPercentage(ability);
            }
        }

        public override bool CanUseAbility(int index)
            => throw new PlatformNotSupportedException(NOT_SUPPORTED);

        public override void ToggleAbility(int index)
            => throw new PlatformNotSupportedException(NOT_SUPPORTED);

        public override void ToggleAbility(AbilityUI abilityUI)
            => throw new PlatformNotSupportedException(NOT_SUPPORTED);
    }
}