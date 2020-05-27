using Enderlook.Unity.Attributes;

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

namespace Game.Scene
{
    public class GameConfiguration : MonoBehaviour
    {
#pragma warning disable CS0649
        [Header("UI Components")]
        [SerializeField, Tooltip("Component dropdown of resolution.")]
        private Dropdown resolutionDropdown;

        [SerializeField, Tooltip("Component dropdown of quality.")]
        private Dropdown qualityDropdown;

        [SerializeField, Tooltip("Values of quality dropdown")]
        private List<string> qualityValues;

        [SerializeField, Tooltip("Has backgrounds?")]
        private bool hasBackgrounds;

        [SerializeField, Tooltip("SpriteRenderer component of Background."), ShowIf(nameof(hasBackgrounds), true)]
        private SpriteRenderer backgroundSpriteRenderer;

        [SerializeField, Tooltip("Component dropdown of backgrounds menu style."), ShowIf(nameof(hasBackgrounds), true)]
        private Dropdown backgroundMenuStyileDropdown;

        [SerializeField, Tooltip("Values of background menu style dropdown."), ShowIf(nameof(hasBackgrounds), true)]
        private List<BackgroundsUI> backgroundsUIs;

        [SerializeField, Tooltip("Default background."), ShowIf(nameof(hasBackgrounds), true)]
        private Sprite defaultBG;

        [SerializeField, Tooltip("Has Credits?")]
        private bool hasCredits;

        [SerializeField, Tooltip("Credits panel."), ShowIf(nameof(hasCredits), true)]
        private Animator credits;

        [SerializeField, Tooltip("Credits animation parameter."), ShowIf(nameof(hasCredits), true)]
        private string creditsKeyAnimation;
#pragma warning restore CS0649

        private List<Resolution> resolutions = new List<Resolution>();

        private static int currentResolutionIndex;
        private static bool resolutionChanged;

        private static int currentQuality;
        private static bool qualityChanged;

        private static int currentIndexBGUI = -1;
        private static bool bgStyleMenuChanged;

        public void Start()
        {
            SetResolutionsInDropdown();
            if (hasCredits) SetQualityValuesInDropdown();
            if (hasBackgrounds)
            {
                if (currentIndexBGUI == -1)
                    SetMenuStyle(Random.Range(0, backgroundsUIs.Count));
                SetBGMenuStyleInDropdown();
            }
        }

        private void SetBGMenuStyleInDropdown()
        {
            backgroundMenuStyileDropdown.ClearOptions();

            List<string> optionsInDropdown = new List<string>();

            foreach (BackgroundsUI backgroundUI in backgroundsUIs)
            {
                string option = backgroundUI.NameBG;
                optionsInDropdown.Add(option);

                if (!bgStyleMenuChanged)
                {
                    if (backgroundUI.BGSprite.Equals(defaultBG))
                    {
                        currentIndexBGUI = backgroundsUIs.IndexOf(backgroundUI);
                        backgroundSpriteRenderer.sprite = defaultBG;
                        GameObject p = backgroundsUIs[currentIndexBGUI].Particle;
                        backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p)));
                    }
                    else
                    {
                        backgroundSpriteRenderer.sprite = backgroundsUIs[currentIndexBGUI].BGSprite;
                        GameObject p = backgroundsUIs[currentIndexBGUI].Particle;
                        backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p)));
                    }
                }
                currentIndexBGUI = backgroundUI.BGSprite.Equals(defaultBG) ? backgroundsUIs.IndexOf(backgroundUI) : currentIndexBGUI;
            }

            backgroundMenuStyileDropdown.AddOptions(optionsInDropdown);
            backgroundMenuStyileDropdown.value = currentIndexBGUI;
            backgroundMenuStyileDropdown.RefreshShownValue();
        }

        private void SetQualityValuesInDropdown()
        {
            qualityDropdown.ClearOptions();

            List<string> optionsInDropdown = new List<string>();

            foreach (string quality in qualityValues)
            {
                string option = quality;
                optionsInDropdown.Add(option);

                if (!qualityChanged)
                    currentQuality = qualityValues.IndexOf(quality) == QualitySettings.GetQualityLevel() ? qualityValues.IndexOf(quality) : currentQuality;
            }

            qualityDropdown.AddOptions(optionsInDropdown);
            qualityDropdown.value = currentQuality;
            qualityDropdown.RefreshShownValue();
        }

        private void SetResolutionsInDropdown()
        {
            resolutions = Screen.resolutions.ToList();

            resolutionDropdown.ClearOptions();

            List<string> optionsInDropdown = new List<string>();

            foreach (Resolution resolution in resolutions)
            {
                string option = $"{resolution.width}x{resolution.height}";
                optionsInDropdown.Add(option);

                if (!resolutionChanged)
                    currentResolutionIndex = resolution.width == Screen.currentResolution.width
                        && resolution.height == Screen.currentResolution.height ? resolutions.IndexOf(resolution) : currentResolutionIndex;
            }

            resolutionDropdown.AddOptions(optionsInDropdown);
            resolutionDropdown.value = currentResolutionIndex;
            resolutionDropdown.RefreshShownValue();
        }

        public void SetResolution(int index)
        {
            currentResolutionIndex = index;
            resolutionChanged = true;
            Screen.SetResolution(resolutions[index].width, resolutions[index].height, Screen.fullScreen);
        }

        public void SetQuality(int index)
        {
            currentQuality = index;
            qualityChanged = true;
            QualitySettings.SetQualityLevel(index);
        }

        public void SetMenuStyle(int index)
        {
            currentIndexBGUI = index;
            bgStyleMenuChanged = true;
            backgroundSpriteRenderer.sprite = backgroundsUIs[index].BGSprite;
            GameObject p = backgroundsUIs[index].Particle;
            backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p)));
        }

        public void StartCredits() => credits.SetTrigger(creditsKeyAnimation);
    }

    [System.Serializable]
    public class BackgroundsUI
    {
        [Header("Background Menu Style")]

        [SerializeField, Tooltip("Name of the bg.")]
        private string nameBG = "";

        [SerializeField, Tooltip("Sprite of the bg.")]
        private Sprite bgSprite = null;

        [SerializeField, Tooltip("Particles.")]
        private GameObject particle;

        public string NameBG => nameBG;

        public Sprite BGSprite => bgSprite;

        public GameObject Particle => particle;
    }
}