using Enderlook.Extensions;

using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Scenes", menuName = "Game/Scenes")]
    public class Scenes : ScriptableObject
    {
        [SerializeField]
        private int[] scenes;

        public int GetScene() => scenes.RandomPick();
    }
}