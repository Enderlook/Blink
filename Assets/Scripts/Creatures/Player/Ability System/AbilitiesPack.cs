using System.Collections;
using System.Collections.Generic;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Abilities Pack", menuName = "Game/Abilities/Abilities Pack")]
    public class AbilitiesPack : ScriptableObject, IReadOnlyList<Ability>
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Abilities")]
        private Ability[] abilities;
#pragma warning restore CS0649

        public Ability this[int index] => ((IReadOnlyList<Ability>)abilities)[index];

        public int Count => ((IReadOnlyList<Ability>)abilities).Count;

        public IEnumerator<Ability> GetEnumerator() => ((IEnumerable<Ability>)abilities).GetEnumerator();

        IEnumerator IEnumerable.GetEnumerator() => ((IEnumerable<Ability>)abilities).GetEnumerator();
    }
}
