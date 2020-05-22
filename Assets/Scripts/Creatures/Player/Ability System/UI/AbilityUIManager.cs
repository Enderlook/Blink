using System;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI Manager")]
    public class AbilityUIManager : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private RectTransform abilitiesRoot;

        [SerializeField]
        private AbilityUI prefab;
#pragma warning restore CS0649

        private AbilitiesPack abilities;
        private AbilityUI[] abilitiesUIs = Array.Empty<AbilityUI>();

        public void UpdateAbility(int index) => abilitiesUIs[index].SetLoadPercentage(abilities[index]);

        public void SetAbilities(AbilitiesPack abilities)
        {
            for (int i = 0; i < abilitiesUIs.Length; i++)
                Destroy(abilitiesUIs[i].gameObject);

            this.abilities = abilities;
            abilitiesUIs = new AbilityUI[abilities.Count];
            for (int i = 0; i < abilitiesUIs.Length; i++)
            {
                AbilityUI instance = Instantiate(prefab, abilitiesRoot);
                abilitiesUIs[i] = instance;
                Ability ability = abilities[i];
                instance.SetSprite(ability.Icon);
                instance.SetLoadPercentage(ability);
            }
        }
    }
}