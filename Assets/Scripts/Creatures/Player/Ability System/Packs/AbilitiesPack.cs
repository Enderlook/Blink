using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Abilities Pack", menuName = "Game/Ability System/Packs/Abilities Pack")]
    public class AbilitiesPack : ScriptableObject, IReadOnlyList<Ability>
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Abilities")]
        private Ability[] abilities;
#pragma warning restore CS0649

        public Ability this[int index] => abilities[index];

        public int Count => abilities.Length;

        public void TriggerAbilityWithKey(string key) => abilities.OfType<AnimatedAbility>().First(e => e.Key == key).OnTrigger();

        public void Initialize(AbilitiesManager manager) => Array.ForEach(abilities, e => e.Initialize(manager));

        public void ChargeToMaximum() => Array.ForEach(abilities, e => e.ChargeToMaximum());

        public AbilitiesPack CreateInstance(params Ability[] abilities)
        {
            AbilitiesPack instance = CreateInstance<AbilitiesPack>();
            instance.abilities = abilities;
            return instance;
        }

        public IEnumerator<Ability> GetEnumerator() => ((IEnumerable<Ability>)abilities).GetEnumerator();

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}
