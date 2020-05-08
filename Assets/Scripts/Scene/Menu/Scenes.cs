using Enderlook.Extensions;

using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Scenes", menuName = "Game/Scenes")]
    public class Scenes : ScriptableObject
    {
#pragma warning disable CS0649
        [SerializeField]
        private int[] scenes;
#pragma warning restore CS0649

        private int lastVisitedScene = -1;

        public int GetScene()
        {
            if (scenes.Length == 1)
                return scenes.RandomPick();

            while (true)
            {
                int value = scenes.RandomPick();
                if (value != lastVisitedScene)
                    return value;
            }
        }
    }
}