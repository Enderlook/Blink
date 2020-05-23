using Enderlook.Extensions;
using Enderlook.Unity.Atoms;
using Enderlook.Unity.Prefabs.HealthBarGUI;

using System;
using System.Collections;

using UnityEditor;

using UnityEngine;
using UnityEngine.UI;

using Console = Game.Scene.CLI.Console;

namespace Game.Scene
{
    [AddComponentMenu("Game/Menu")]
    [RequireComponent(typeof(AudioSource))]
    public class Menu : MonoBehaviour
    {
#pragma warning disable CS0649
        [Header("Music")]
        [SerializeField, Tooltip("Music play while pause.")]
        private AudioClip[] menuMusic;

        [SerializeField, Tooltip("Music play while playing.")]
        private AudioClip[] playMusic;

        [SerializeField, Tooltip("Music play on win.")]
        private AudioClip winMusic;

        [SerializeField, Tooltip("Music play on lose.")]
        private AudioClip loseMusic;

        [Header("Special Menus")]
        [SerializeField, Tooltip("Menu show on win.")]
        private GameObject winMenu;

        [SerializeField, Tooltip("Menu show on lose.")]
        private GameObject loseMenu;

        [SerializeField, Tooltip("Menu panel.")]
        private GameObject menu;

        [SerializeField, Tooltip("Key pressed to enable, disable menu or rollback panels from menu.")]
        private KeyCode pauseKey;

        [Header("Others")]
        [SerializeField, Tooltip("Background image.")]
        private Image background;

        [SerializeField, Tooltip("Options panel.")]
        private GameObject options;

        [SerializeField, Tooltip("When any of this values reaches 0, player loose.")]
        private IntEvent[] events;

        [SerializeField, Tooltip("Loading screen.")]
        private GameObject loadingScreen;
#pragma warning restore CS0649

        private AudioSource audioSource;

        private bool isPlaying;
        public bool IsPlaying {
            get => isPlaying;
            private set {
                if (isPlaying == value)
                    return;
                isPlaying = value;
                Time.timeScale = value ? 1 : 0;
                PlayMusic();
            }
        }

        public static Menu Instance { get; private set; }

        private enum Mode { Playing, Win, Lose }
        private Mode mode;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => isPlaying = Time.timeScale == 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            Instance = this;

            audioSource = GetComponent<AudioSource>();
            for (int i = 0; i < events.Length; i++)
                events[i].Register(CheckLose);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        public void Update()
        {
            if (!audioSource.isPlaying)
                PlayMusic();

            if (Input.GetKeyDown(pauseKey))
            {
                if (Console.IsConsoleEnabled)
                    Console.IsConsoleEnabled = false;
                else if (mode == Mode.Playing)
                    ToggleMenu();
            }
        }

        private void ToggleMenu()
        {
            if (IsPlaying)
            {
                IsPlaying = false;
                background.enabled = true;
                menu.SetActive(true);
            }
            else
            {
                if (options.activeSelf)
                {
                    options.SetActive(false);
                    menu.SetActive(true);
                    return;
                }
                IsPlaying = true;
                menu.SetActive(false);
                background.enabled = false;
            }
        }

        private void PlayMusic()
        {
            // Fix bug
            if (audioSource == null)
                audioSource = GetComponent<AudioSource>();

            AudioClip[] audioClip = IsPlaying ? playMusic : menuMusic;
            if (audioClip.Length == 0)
            {
                Debug.LogWarning("Play music was empty. We will try on next frame.");
                return;
            }
            audioSource.clip = audioClip.RandomPick();
            audioSource.Play();
        }

        private void CheckLose(int value)
        {
            if (value == 0)
                Lose();
        }

        public void Lose()
        {
            mode = Mode.Lose;
            ShowGameOver();
        }

        public void Win()
        {
            mode = Mode.Win;
            ShowGameOver();
        }

        private void ShowGameOver()
        {
            IsPlaying = false;
            switch (mode)
            {
                case Mode.Win:
                    audioSource.clip = winMusic;
                    winMenu.SetActive(true);
                    break;
                case Mode.Lose:
                    audioSource.clip = loseMusic;
                    loseMenu.SetActive(true);
                    break;
                case Mode.Playing:
                    throw new InvalidOperationException();
            }
            audioSource.Play();
            background.enabled = true;
        }

        public void SetGameMusic(AudioClip[] clips)
        {
            playMusic = clips;
            if (isPlaying)
                PlayMusic();
        }

        public void NextLevel()
        {
            GameObject instance = Instantiate(loadingScreen);
            HealthBar healthBar = instance.GetComponentInChildren<HealthBar>();
            healthBar.ManualUpdate(0, 1);
            AsyncOperation operation = FindObjectOfType<GameManager>().AdvanceScene();

            HideMenu();

            operation.completed += (_) => IsPlaying = true;

            StartCoroutine(LoadingBarCharge());

            IEnumerator LoadingBarCharge()
            {
                while (operation.progress <= 0.9f)
                {
                    healthBar.ManualUpdate(operation.progress);
                    yield return null;
                }
            }
        }

        public void Continue()
        {
            HideMenu();
            IsPlaying = true;
        }

        private void HideMenu()
        {
            options.SetActive(false);
            winMenu.SetActive(false);
            loseMenu.SetActive(false);
            menu.SetActive(false);
            background.enabled = false;
        }

        public void Restart()
        {
            GameObject go = new GameObject();
            go.AddComponent<Slave>();
            DontDestroyOnLoad(go);
            FindObjectOfType<UIManagement>().GoToMenu();
        }

        private class Slave : MonoBehaviour
        {
            [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
            private void Update()
            {
                MainMenu mainMenu = FindObjectOfType<MainMenu>();
                if (mainMenu == null)
                    return;
                mainMenu.InitializeGame();
                Destroy(gameObject);
            }
        }
    }
}
