using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

public class GameConfiguration : MonoBehaviour
{
    [Header("UI Components")]

    [SerializeField, Tooltip("Component dropdown of resolution.")]
    private Dropdown resolutionDropdown = null;

    [SerializeField, Tooltip("Component dropdown of quality.")]
    private Dropdown qualityDropdown = null;

    [SerializeField, Tooltip("Values of quality dropdown")]
    private List<string> qualityValues = null;

    private List<Resolution> resolutions = new List<Resolution>();

    private static int currentResolutionIndex;
    private static bool resolutionChanged = false;
    private static int currentQuality;
    private static bool qualityChanged = false;

    public void Start()
    {
        SetResolutionsInDropdown();
        SetQualityValuesInDropdown();
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
}
