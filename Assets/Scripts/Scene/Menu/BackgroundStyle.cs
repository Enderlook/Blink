using System.Collections.Generic;
using UnityEngine;

namespace Game.Scene
{
    public class BackgroundStyle : MonoBehaviour
    {
        [SerializeField, Tooltip("Values of background menu style dropdown.")]
        private BackgroundsUI[] backgroundsUIs;

        [SerializeField, Tooltip("SpriteRenderer component of Background.")]
        private SpriteRenderer backgroundSpriteRenderer;

        public IReadOnlyList<BackgroundsUI> BackgroundsUIs => backgroundsUIs;

        public static int CurrentIndexBGUI { get; private set; }
        private static bool bgStyleMenuChanged;
        private GameObject lastParticleSystem;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            if (!bgStyleMenuChanged)
                CurrentIndexBGUI = Random.Range(0, BackgroundsUIs.Count);

            lastParticleSystem = Instantiate(backgroundsUIs[CurrentIndexBGUI].Particles);
            backgroundSpriteRenderer.sprite = backgroundsUIs[CurrentIndexBGUI].Sprite;
        }

        public void SetBackgroundStyle(int index)
        {
            CurrentIndexBGUI = index;
            bgStyleMenuChanged = true;
            backgroundSpriteRenderer.sprite = backgroundsUIs[index].Sprite;
            Destroy(lastParticleSystem);
            lastParticleSystem = Instantiate(backgroundsUIs[index].Particles);
        }
    }
}