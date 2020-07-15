using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI Mobile")]
    public class AbilityUIManagerMobile : AbilityUIManager
    {
#pragma warning disable CS0649
        private AbilityUI[] abilitiesUIs;

        protected override AbilityUI[] AbilitiesUIs => abilitiesUIs;
#pragma warning restore CS0649

        [SerializeField]
        private float cancelRequestTimeout = .1f;
        private float currentCancelRequestTimeout = 0;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
#if !(UNITY_ANDROID && IGNORE_UNITY_REMOTE)
            Destroy(this);
#endif
            abilitiesUIs = new AbilityUI[abilitiesRoot.childCount];
            for (int i = 0; i < abilitiesRoot.childCount; i++)
                abilitiesUIs[i] = abilitiesRoot.GetChild(i).GetComponent<AbilityUI>();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update() => currentCancelRequestTimeout -= Time.deltaTime;

        public override void SetAbilities(AbilitiesPack abilities)
        {
            base.SetAbilities(abilities);
            for (int i = 0; i < AbilitiesUIs.Length; i++)
            {
                AbilityUI instance = AbilitiesUIs[i];
                Ability ability = abilities[i];
                instance.Initialize(this);
#if UNITY_ANDROID
                instance.SetSprite(ability.IconMobile);
#else
                instance.SetSprite(ability.Icon);
#endif
                instance.SetLoadPercentage(ability);
            }

            ToggleAbility(0);
        }

        public override bool CanUseAbility(int index) => currentCancelRequestTimeout <= 0 && AbilitiesUIs[index].IsOn;

        public override void ToggleAbility(int index)
        {
#if UNITY_ANDROID
            for (int i = 0; i < AbilitiesUIs.Length; i++)
                AbilitiesUIs[i].ManualToggle(i == index);
#endif
        }

        public override void ToggleAbility(AbilityUI abilityUI)
        {
#if UNITY_ANDROID
            foreach (AbilityUI ability in AbilitiesUIs)
                ability.ManualToggle(ability == abilityUI);
            currentCancelRequestTimeout = cancelRequestTimeout;
#endif
        }
    }
}