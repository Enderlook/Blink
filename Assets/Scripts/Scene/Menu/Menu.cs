using Enderlook.Extensions;
using Enderlook.Unity.Atoms;
using Enderlook.Unity.Prefabs.HealthBarGUI;

using System;
using System.Collections;

using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Menu")]
    [RequireComponent(typeof(AudioSource))]
    public class Menu : MonoBehaviour
    {
        [SerializeField, Tooltip("Music play while pause.")]
        private AudioClip[] menuMusic;

        [SerializeField, Tooltip("Music play while playing.")]
        private AudioClip[] playMusic;

        [SerializeField, Tooltip("Music play on win.")]
        private AudioClip winMusic;

        [SerializeField, Tooltip("Music play on lose.")]
        private AudioClip loseMusic;

        [SerializeField, Tooltip("Menu show on win.")]
        private GameObject winMenu;

        [SerializeField, Tooltip("Menu show on lose.")]
        private GameObject loseMenu;

        [SerializeField, Tooltip("Key pressed to enable, disable menu or rollback panels from menu.")]
        private KeyCode pauseKey;

        [SerializeField, Tooltip("Menu.")]
        private GameObject menu;

        [SerializeField, Tooltip("Menu panels.")]
        private GameObject[] panels;

        [SerializeField, Tooltip("When any of this values reaches 0, player loose.")]
        private IntEvent[] events;

        [SerializeField, Tooltip("Loading screen.")]
        private GameObject loadingScreen;

        private AudioSource audioSource;

        private bool isPlaying;
        public bool IsPlaying {
            get => isPlaying;
            set {
                if (isPlaying == value)
                    return;
                isPlaying = value;
                Time.timeScale = value ? 1 : 0;
                PlayMusic();
                if (!value)
                    menu.SetActive(true);
                else
                {
                    for (int i = 0; i < panels.Length; i++)
                        panels[i].SetActive(false);
                    menu.SetActive(false);
                }
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

            if (Input.GetKeyDown(pauseKey) && mode == Mode.Playing)
                ToggleMenu();
        }

        private void ToggleMenu()
        {
            if (IsPlaying)
                IsPlaying = false;
            else
            {
                for (int i = 0; i < panels.Length; i++)
                    if (panels[i].activeSelf)
                    {
                        panels[i].SetActive(false);
                        return;
                    }
                IsPlaying = true;
            }
        }

        private void PlayMusic()
        {
            AudioClip[] audioClip = (IsPlaying ? playMusic : menuMusic);
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
            {
                mode = Mode.Lose;
                ShowGameOver();
            }
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
                    menu.SetActive(false);
                    break;
                case Mode.Lose:
                    audioSource.clip = loseMusic;
                    winMenu.SetActive(false);
                    menu.SetActive(false);
                    loseMenu.SetActive(true);
                    break;
                case Mode.Playing:
                    throw new InvalidOperationException();
            }
            audioSource.Play();
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
    }
}