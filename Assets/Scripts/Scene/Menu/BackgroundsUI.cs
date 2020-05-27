using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Scene
{
    [System.Serializable]
    public class BackgroundsUI
    {
#pragma warning disable CS0649
        [field: SerializeField, IsProperty, Tooltip("Name shown in the menu style dropdown button.")]
        public string Name { get; private set; }

        [field: SerializeField, IsProperty, Tooltip("Background Sprite.")]
        public Sprite Sprite { get; private set; }

        [field: SerializeField, IsProperty, Tooltip("Particles System.")]
        public GameObject Particles { get; private set; }
#pragma warning restore CS0649
    }
}