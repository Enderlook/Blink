using Enderlook.Extensions;

using Game.Creatures.Player.AbilitySystem;
using System.Linq;
using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Level Configuration"), DefaultExecutionOrder(1)]
    public class LevelConfiguration : MonoBehaviour
    {
        [SerializeField, Tooltip("Musics play during game.")]
        private AudioClip[] clips;

        [SerializeField, Tooltip("Abilities of player. A random element is choosen.")]
        private AbilitiesPack[] abilityData;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            Menu.Instance.SetGameMusic(clips);
            SetAbilityPack(Random.Range(0, abilityData.Length));
        }

        public string SetAbilityPack(int index)
        {
            if (index > abilityData.Length)
                return null;

            AbilitiesPack abilities = abilityData[index];
            FindObjectOfType<AbilitiesManager>().SetAbilities(abilities);
            return abilities.name;
        }
    }
}