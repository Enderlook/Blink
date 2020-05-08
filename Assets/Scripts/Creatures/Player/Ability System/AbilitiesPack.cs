using System.Collections;
using System.Collections.Generic;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Abilities Pack", menuName = "Game/Abilities/Abilities Pack")]
    public class AbilitiesPack : ScriptableObject, IReadOnlyList<Ability>
    {
        [SerializeField, Tooltip("Abilities")]
        private Ability[] abilities;

        public Ability this[int index] => ((IReadOnlyList<Ability>)abilities)[index];

        public int Count => ((IReadOnlyList<Ability>)abilities).Count;

        public IEnumerator<Ability> GetEnumerator() => ((IEnumerable<Ability>)abilities).GetEnumerator();

        IEnumerator IEnumerable.GetEnumerator() => ((IEnumerable<Ability>)abilities).GetEnumerator();
    }
}
