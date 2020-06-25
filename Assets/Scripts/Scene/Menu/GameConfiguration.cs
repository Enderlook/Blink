using System;
using System.Linq;

using UnityEngine;
using UnityEngine.UI;

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
        private string[] qualityValues;
#pragma warning restore CS0649

        private static int currentResolutionIndex;
        private static bool resolutionChanged;

        private static int currentQuality;
        private static bool qualityChanged;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            SetResolutionsInDropdown();
            SetQualityValuesInDropdown();
        }

        private void SetQualityValuesInDropdown()
        {
            MainMenu.ConfigureDropdown(qualityDropdown, qualityValues, 4);

            if (qualityChanged)
                qualityDropdown.value = currentQuality;
            else
            {
                for (int i = 0; i < qualityValues.Length; i++)
                {
                    if (i == QualitySettings.GetQualityLevel())
                    {
                        currentQuality = qualityDropdown.value = i;
                        break;
                    }
                }
            }
        }

        private void SetResolutionsInDropdown()
        {
            MainMenu.ConfigureDropdown(resolutionDropdown, Screen.resolutions.Select(e => $"{e.width}x{e.height}"), 4);

            if (resolutionChanged)
                resolutionDropdown.value = currentResolutionIndex;
            else
                currentResolutionIndex = resolutionDropdown.value = Array.IndexOf(Screen.resolutions, Screen.currentResolution);
        }

        public void SetResolution(int index)
        {
            currentResolutionIndex = index;
            resolutionChanged = true;
            Screen.SetResolution(Screen.resolutions[index].width, Screen.resolutions[index].height, Screen.fullScreen);
        }

        public void SetQuality(int index)
        {
            currentQuality = index;
            qualityChanged = true;
            QualitySettings.SetQualityLevel(index);
        }
    }
}