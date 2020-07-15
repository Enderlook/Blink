using Enderlook.Unity.Attributes;

using System;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI Manager")]
    public class AbilityUIManager : MonoBehaviour
    {
#pragma warning disable CS0649
#if UNITY_EDITOR
        [SerializeField, Tooltip("Only for Android.")]
        private bool isAndroid = false;
#endif

        [SerializeField, ShowIf(nameof(isAndroid), false)]
        private RectTransform abilitiesRoot;

        [SerializeField, ShowIf(nameof(isAndroid), false)]
        private AbilityUI prefab;

        [SerializeField, ShowIf(nameof(isAndroid), true)]
        private AbilityUI[] prefabs = null; 

#pragma warning disable CS0414
#if UNITY_EDITOR || UNITY_ANDROID
        [SerializeField]
        private float cancelRequestTimeout = .1f;
#endif
#pragma warning restore CS0649, CS0414

        private AbilitiesPack abilities;
        private AbilityUI[] abilitiesUIs = Array.Empty<AbilityUI>();

#if UNITY_ANDROID
        private float currentCancelRequestTimeout = 0;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update() => currentCancelRequestTimeout -= Time.deltaTime;
#endif

#if UNITY_ANDROID
        public bool CanUseAbility(int index) => currentCancelRequestTimeout <= 0 && prefabs[index].IsOn;
#endif

        public void UpdateAbility(int index)
        {
#if UNITY_ANDROID
            Debug.Log(index);
            prefabs[index].SetLoadPercentage(abilities[index]);
#else
            abilitiesUIs[index].SetLoadPercentage(abilities[index]);
#endif
        }

        public void SetAbilities(AbilitiesPack abilities)
        {
#if UNITY_ANDROID
            for (int i = 0; i < prefabs.Length; i++)
            {
                AbilityUI instance = prefabs[i];
                Ability ability = abilities[i];
                instance.Initialize(this);
                instance.SetSprite(ability.IconMobile);
                instance.SetLoadPercentage(ability);
            }
#else

            for (int i = 0; i < abilitiesUIs.Length; i++)
                Destroy(abilitiesUIs[i].gameObject);

            this.abilities = abilities;
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
#endif
#if UNITY_ANDROID
            ToggleAbility(0);
#endif
        }

#if UNITY_ANDROID
        public void ToggleAbility(int index)
        {
            for (int i = 0; i < prefabs.Length; i++)
                prefabs[i].ManualToggle(i == index);
        }

        public void ToggleAbility(AbilityUI abilityUI)
        {
            foreach (AbilityUI ability in prefabs)
                ability.ManualToggle(ability == abilityUI);
            currentCancelRequestTimeout = cancelRequestTimeout;
        }
#endif
    }
}