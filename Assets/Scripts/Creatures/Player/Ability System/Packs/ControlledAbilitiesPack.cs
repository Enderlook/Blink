using System;
using System.Collections;
using System.Collections.Generic;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Controlled Abilities Pack", menuName = "Game/Ability System/Packs/Controlled Abilities Pack")]
    public class ControlledAbilitiesPack : AbilitiesPack, IReadOnlyList<(Ability, Control)>, IEnumerable<(Ability, Control)>
    {
        [SerializeField]
        private Control[] controls;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void OnValidate() => Array.Resize(ref controls, Count);

        public new(Ability, Control) this[int index] => (base[index], controls[index]);

        public new IEnumerator<(Ability, Control)> GetEnumerator()
        {
            for (int i = 0; i < Count; i++)
                yield return this[i];
        }

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}
