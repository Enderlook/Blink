using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Menu Music Setter")]
    public class MenuMusicSetter : MonoBehaviour
    {
        [SerializeField, Tooltip("Musics play during game.")]
        private AudioClip[] clips;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]

        private void Awake() => FindObjectOfType<Menu>().SetGameMusic(clips);
    }
}