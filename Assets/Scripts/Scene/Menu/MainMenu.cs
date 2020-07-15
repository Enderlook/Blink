using Enderlook.Unity.Prefabs.HealthBarGUI;

using System.Collections;
using System.Collections.Generic;
using System.Linq;

using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

using Console = Game.Scene.CLI.Console;

namespace Game.Scene
{
    [RequireComponent(typeof(BackgroundStyle))]
    public class MainMenu : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Scenes scenes;

        [SerializeField]
        private int hudScene;

        [SerializeField]
        private HealthBar loadingProgress;

        [SerializeField]
        private GameObject panel;

        [SerializeField, Tooltip("Key pressed to disable console.")]
        private KeyCode disableConsole;

        [Header("Credits")]
        [SerializeField, Tooltip("Credits panel.")]
        private Animator credits;

        [SerializeField, Tooltip("Credits animation parameter.")]
        private string creditsKeyAnimation;

        [Header("Backgrounds")]
        [SerializeField, Tooltip("Component dropdown of backgrounds menu style.")]
        private Dropdown backgroundMenuStyleDropdown;
#pragma warning restore CS0649

        private BackgroundStyle backgroundStyle;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            backgroundStyle = GetComponent<BackgroundStyle>();
            GameObject core = GameObject.Find("Core");
            if (core != null)
                Destroy(core);
            SetBGMenuStyleInDropdown();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (Input.GetKeyDown(disableConsole) && Console.IsConsoleEnabled)
                Console.IsConsoleEnabled = false;
        }

        public void InitializeGame()
        {
            UnityEngine.SceneManagement.Scene current = SceneManager.GetActiveScene();

            AsyncOperation hud = SceneManager.LoadSceneAsync(hudScene, LoadSceneMode.Additive);
            AsyncOperation level = SceneManager.LoadSceneAsync(scenes.GetScene(), LoadSceneMode.Additive);

            level.completed += (_) =>
            {
                SceneManager.UnloadSceneAsync(current);
                SceneManager.UnloadSceneAsync(hudScene);
            };

            panel.SetActive(false);

            loadingProgress.gameObject.SetActive(true);
            loadingProgress.ManualUpdate(0, 1);

            StartCoroutine(Work());

            IEnumerator Work()
            {
                level.allowSceneActivation = false;
                hud.allowSceneActivation = false;
                while (!level.isDone || !hud.isDone)
                {
                    // Fix bug
                    if (level.progress >= .9f && hud.progress >= .9f)
                        break;
                    loadingProgress.UpdateValues((level.progress + hud.progress) * 50);
                    yield return null;
                }
                level.allowSceneActivation = true;
                hud.allowSceneActivation = true;
            }
        }

        public void StartCredits() => credits.SetTrigger(creditsKeyAnimation);

        public static void ConfigureDropdown(Dropdown dropdown, IEnumerable<string> elements, int maxAmount = -1)
        {
            List<string> options = elements.ToList();

            maxAmount = maxAmount == -1 ? options.Count : Mathf.Min(options.Count, maxAmount);

            RectTransform rectTransform = dropdown.transform.Find("Template").GetComponent<RectTransform>();
            rectTransform.sizeDelta = new Vector2(rectTransform.sizeDelta.x, maxAmount * 75);

            dropdown.ClearOptions();
            dropdown.AddOptions(options);
            dropdown.RefreshShownValue();
            dropdown.SetValueWithoutNotify(BackgroundStyle.CurrentIndexBGUI);
        }

        private void SetBGMenuStyleInDropdown() => backgroundStyle.SetDropdown(backgroundMenuStyleDropdown);
    }
}