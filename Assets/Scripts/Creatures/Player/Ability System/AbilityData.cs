using System.Collections.Generic;
using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Abilities Data", menuName = "Game/Abilities/Abilities Data")]
    public class AbilityData : ScriptableObject
    {
        public List<Ability> AbilitiesData => abilities;

        [SerializeField, Tooltip("Abilities")]
        List<Ability> abilities;
    }
}
