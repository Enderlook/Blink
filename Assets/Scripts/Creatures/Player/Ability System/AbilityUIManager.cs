using System;
using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public class AbilityUIManager : MonoBehaviour
    {
        [SerializeField]
        private RectTransform abilitiesRoot;

        [SerializeField]
        private AbilityUI prefab;

        private Ability[] abilities = Array.Empty<Ability>();
        private AbilityUI[] abilitiesUIs = Array.Empty<AbilityUI>();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            for (int i = 0; i < abilities.Length; i++)
            {
                Debug.Log($"{abilities[i].name} {abilities[i].Percentage}");
                abilitiesUIs[i].SetLoadPercentage(abilities[i].Percentage);
            }
        }

        public void SetAbilities(Ability[] abilities)
        {
            for (int i = 0; i < abilitiesUIs.Length; i++)
                Destroy(abilitiesUIs[i].gameObject);

            this.abilities = abilities;
            abilitiesUIs = new AbilityUI[abilities.Length];
            for (int i = 0; i < abilitiesUIs.Length; i++)
            {
                AbilityUI instance = Instantiate(prefab, abilitiesRoot);
                abilitiesUIs[i] = instance;
                Ability ability = abilities[i];
                instance.SetSprite(ability.Icon);
                instance.SetLoadPercentage(ability.Percentage);
            }
        }
    }
}