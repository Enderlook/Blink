using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

public class GameConfiguration : MonoBehaviour
{
    [Header("UI Components")]

    [SerializeField, Tooltip("Component dropdown of resolution.")]
    private Dropdown resolutionDropdown = null;

    private List<Resolution> resolutions = new List<Resolution>();

    private static int currentResolutionIndex;

    public void Start()
    {
        SetResolutionsInDropdown();
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
        Screen.SetResolution(resolutions[index].width, resolutions[index].height, Screen.fullScreen);
    }
}
