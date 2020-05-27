using Enderlook.Unity.Prefabs.HealthBarGUI;

using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

using Console = Game.Scene.CLI.Console;
using Random = UnityEngine.Random;

namespace Game.Scene
{
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
        [SerializeField, Tooltip("SpriteRenderer component of Background.")]
        private SpriteRenderer backgroundSpriteRenderer;

        [SerializeField, Tooltip("Component dropdown of backgrounds menu style.")]
        private Dropdown backgroundMenuStyleDropdown;

        [SerializeField, Tooltip("Values of background menu style dropdown.")]
        private BackgroundsUI[] backgroundsUIs;
#pragma warning restore CS0649

        private static int currentIndexBGUI;
        private static bool bgStyleMenuChanged;

        private GameObject lastParticleSystem;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
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

            StartCoroutine(Loading(level));
        }

        private IEnumerator Loading(AsyncOperation asyncOperation)
        {
            while (!asyncOperation.isDone)
            {
                loadingProgress.UpdateValues(asyncOperation.progress * 100);
                yield return null;
            }
        }

        public void StartCredits() => credits.SetTrigger(creditsKeyAnimation);

        private void SetBGMenuStyleInDropdown()
        {
            RectTransform rectTransform = backgroundMenuStyleDropdown.transform.Find("Template").GetComponent<RectTransform>();
            rectTransform.sizeDelta = new Vector2(rectTransform.sizeDelta.x, backgroundsUIs.Length * 75);

            backgroundMenuStyleDropdown.ClearOptions();

            List<string> optionsInDropdown = new List<string>();

            if (!bgStyleMenuChanged)
            {
                currentIndexBGUI = Random.Range(0, backgroundsUIs.Length);
            }

            for (int i = 0; i < backgroundsUIs.Length; i++)
            {
                BackgroundsUI backgroundsUI = backgroundsUIs[i];
                optionsInDropdown.Add(backgroundsUI.Name);

                if (i == currentIndexBGUI)
                {
                    backgroundSpriteRenderer.sprite = backgroundsUI.Sprite;
                    lastParticleSystem = Instantiate(backgroundsUI.Particles);
                }
            }

            backgroundMenuStyleDropdown.AddOptions(optionsInDropdown);
            backgroundMenuStyleDropdown.value = currentIndexBGUI;
            backgroundMenuStyleDropdown.RefreshShownValue();
        }

        public void SetMenuStyle(int index)
        {
            currentIndexBGUI = index;
            bgStyleMenuChanged = true;
            backgroundSpriteRenderer.sprite = backgroundsUIs[index].Sprite;
            Destroy(lastParticleSystem);
            lastParticleSystem = Instantiate(backgroundsUIs[index].Particles);
        }
    }
}