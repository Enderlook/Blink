using Game.Creatures.Player.AbilitySystem;

using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Level Configuration"), DefaultExecutionOrder(1)]
    public class LevelConfiguration : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Musics play during game.")]
        private AudioClip[] clips;

        [SerializeField, Tooltip("Abilities of player. A random element is choosen.")]
        private ControlledAbilitiesPack[] abilityData;
#pragma warning restore CS0649

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

            ControlledAbilitiesPack abilities = abilityData[index];
            CrystalAndPlayerTracker.Player.GetComponentInChildren<PlayerAbilitiesManager>().SetAbilities(abilities);
            return abilities.name;
        }
    }
}