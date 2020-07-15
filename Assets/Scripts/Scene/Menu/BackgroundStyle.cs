using System.Collections.Generic;
using System.Linq;

using UnityEngine;
using UnityEngine.UI;

namespace Game.Scene
{
    public class BackgroundStyle : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Values of background menu style dropdown.")]
        private BackgroundsUI[] backgroundsUIs;

        [SerializeField, Tooltip("SpriteRenderer component of Background.")]
        private SpriteRenderer backgroundSpriteRenderer;

        [SerializeField, Tooltip("Image component of Background.")]
        private Image backgroundImage;
#pragma warning restore CS0649

        public IReadOnlyList<BackgroundsUI> BackgroundsUIs => backgroundsUIs;

        public static int CurrentIndexBGUI { get; private set; }
        private static bool bgStyleMenuChanged;
        private GameObject lastParticleSystem;

        private Dropdown backgroundStyleDropwdown;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            if (!bgStyleMenuChanged)
                CurrentIndexBGUI = Random.Range(0, BackgroundsUIs.Count);

            lastParticleSystem = Instantiate(backgroundsUIs[CurrentIndexBGUI].Particles);

            SetSprite(CurrentIndexBGUI);

            if (backgroundStyleDropwdown != null)
                backgroundStyleDropwdown.value = CurrentIndexBGUI;
        }

        public void SetDropdown(Dropdown dropdown)
        {
            MainMenu.ConfigureDropdown(dropdown, BackgroundsUIs.Select(e => e.Name));

            backgroundStyleDropwdown = dropdown;
        }

        private void SetSprite(int index)
        {
            Sprite sprite = backgroundsUIs[index].Sprite;
            if (backgroundSpriteRenderer != null)
                backgroundSpriteRenderer.sprite = sprite;
            else if (backgroundImage != null)
                backgroundImage.sprite = sprite;
            else
                Debug.LogError($"Both {nameof(backgroundSpriteRenderer)} and {nameof(backgroundImage)} are null. Only one can be null.");
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