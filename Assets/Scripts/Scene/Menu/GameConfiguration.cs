using Enderlook.Unity.Attributes;

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

    [SerializeField, Tooltip("Has backgrounds?")]
    private bool hasBackgrounds = false;

    [SerializeField, Tooltip("SpriteRenderer component of Background."), ShowIf(nameof(hasBackgrounds), true)]
    private SpriteRenderer backgroundSpriteRenderer;

    [SerializeField, Tooltip("Component dropdown of backgrounds menu style."), ShowIf(nameof(hasBackgrounds), true)]
    private Dropdown backgroundMenuStyileDropdown = null;

    [SerializeField, Tooltip("Values of background menu style dropdown."), ShowIf(nameof(hasBackgrounds), true)]
    private List<BackgroundsUI> backgroundsUIs = null;

    [SerializeField, Tooltip("Default background."), ShowIf(nameof(hasBackgrounds), true)]
    private Sprite defaultBG = null;

    [SerializeField, Tooltip("Has Credits?")]
    private bool hasCredits = false;

    [SerializeField, Tooltip("Credits panel."), ShowIf(nameof(hasCredits), true)]
    private Animator credits;

    [SerializeField, Tooltip("Credits animation parameter."), ShowIf(nameof(hasCredits), true)]
    private string creditsKeyAnimation;

    private List<Resolution> resolutions = new List<Resolution>();

    private static int currentResolutionIndex;
    private static bool resolutionChanged;

    private static int currentQuality;
    private static bool qualityChanged;

    private static int currentIndexBGUI;
    private static bool bgStyleMenuChanged;

    public void Start()
    {
        SetResolutionsInDropdown();
        if (hasCredits) SetQualityValuesInDropdown();
        if (hasBackgrounds) SetBGMenuStyleInDropdown();
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
                    GameObject p = backgroundsUIs.ElementAt(currentIndexBGUI).Particle;
                    backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p) ? true : false));
                }
                else
                {
                    int current = currentIndexBGUI;
                    currentIndexBGUI = current;
                    backgroundSpriteRenderer.sprite = backgroundsUIs.ElementAt(currentIndexBGUI).BGSprite;
                    GameObject p = backgroundsUIs.ElementAt(currentIndexBGUI).Particle;
                    backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p) ? true : false));
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
        backgroundSpriteRenderer.sprite = backgroundsUIs.ElementAt(index).BGSprite;
        GameObject p = backgroundsUIs.ElementAt(index).Particle;
        backgroundsUIs.ForEach(x => x.Particle.SetActive(x.Particle.Equals(p) ? true : false));
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
