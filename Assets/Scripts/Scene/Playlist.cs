using Enderlook.Extensions;

using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Playlist", menuName = "Game/Playlist")]
    public class Playlist : ScriptableObject
    {
        [SerializeField, Tooltip("Clips of this playlist.")]
        private AudioClip[] clips;

        public AudioClip GetRandomMusic() => clips.RandomPick();
    }
}