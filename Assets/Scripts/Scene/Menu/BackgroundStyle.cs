using System.Collections.Generic;

using UnityEngine;
using UnityEngine.UI;

namespace Game.Scene
{
    public class BackgroundStyle : MonoBehaviour
    {
        [SerializeField, Tooltip("Values of background menu style dropdown.")]
        private BackgroundsUI[] backgroundsUIs;

        [SerializeField, Tooltip("SpriteRenderer component of Background.")]
        private SpriteRenderer backgroundSpriteRenderer;

        [SerializeField, Tooltip("Image component of Background.")]
        private Image backgroundImage;

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

            SetSprite(CurrentIndexBGUI);
        }

        private void SetSprite(int index)
        {
            Sprite sprite = backgroundsUIs[index].Sprite;
            if (backgroundSpriteRenderer != null)
                backgroundSpriteRenderer.sprite = sprite;
            else
                backgroundImage.sprite = sprite;
        }

        public void SetBackgroundStyle(int index)
        {
            CurrentIndexBGUI = index;
            bgStyleMenuChanged = true;
            SetSprite(index);
            Destroy(lastParticleSystem);
            lastParticleSystem = Instantiate(backgroundsUIs[index].Particles);
        }
    }
}