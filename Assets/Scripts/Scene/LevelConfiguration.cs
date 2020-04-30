using Game.Creatures.Player.AbilitySystem;
using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Level Configuration")]
    public class LevelConfiguration : MonoBehaviour
    {
        [SerializeField, Tooltip("Musics play during game.")]
        private AudioClip[] clips;

        [SerializeField, Tooltip("Abilities of player.")]
        private Ability[] abilities;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            Menu.Instance.SetGameMusic(clips);
            FindObjectOfType<AbilitiesManager>().SetAbilities(abilities);
        }
    }
}