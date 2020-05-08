using Enderlook.Unity.Utils.Clockworks;
using System;

using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace Game.Scene
{
    public class GameManager : MonoBehaviour
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Time in seconds before starting to spawn enemies.")]
        private int startTime = 5;

        [SerializeField, Min(1), Tooltip("Required energy to advance level.")]
        private int baseEnergy = 50;

        [SerializeField, Min(0), Tooltip("Increase of required energy to advance level per level.")]
        private int linearIncreaseEnergy = 10;

        [SerializeField, Min(.1f), Tooltip("Base difficulty of the game.")]
        private float baseDifficulty = 1;

        [SerializeField, Min(.1f), Tooltip("Linear increase of difficulty per level.")]
        private float linearIncreaseDifficulty = .5f;

        [SerializeField, Min(.1f), Tooltip("Multiplicative increase of difficulty per level.")]
        private float geometryIncreaseDifficulty = .5f;

        [SerializeField, Range(0, 1), Tooltip("Increase of difficulty in-level.")]
        private float difficultyInSceneFactor = .5f;

#pragma warning disable CS0649
        [Header("Setup")]
        [SerializeField]
        private Text timer;

        [SerializeField, Tooltip("Playable scenes.")]
        private Scenes scenes;
#pragma warning restore CS0649

        private int currentLevel = 1;

        private enum GameState { Starting, Running, Loading };
        private GameState gameState;

        private Clockwork timeUntilStart;

        private int lastDifficultyUpdateFrame = 0;
        private float lastUpdatedDifficulty;

        private int currentRequiredEnergy;
        public int CurrentEnergy { get; private set; }

        private float EnergyPercent => CurrentEnergy / (float)currentRequiredEnergy;

        private float DifficultyValue {
            get {
                int frameCount = Time.frameCount;
                if (lastDifficultyUpdateFrame < frameCount)
                {
                    lastDifficultyUpdateFrame = frameCount;
                    lastUpdatedDifficulty = GetDifficulty();
                }
                return lastUpdatedDifficulty;
            }
        }

        private static GameManager instance;

        /// <summary>
        /// Current difficulty of the game.
        /// </summary>
        public static float Difficulty => instance.DifficultyValue;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            if (instance != null)
                throw new InvalidOperationException($"Only a single instance of {nameof(GameManager)} can exist at the same time.");
            instance = this;

            timeUntilStart = new Clockwork(startTime, SetStateToRunning, true, 0);
            SetStateToStarting();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (Menu.Instance.IsPlaying)
                switch (gameState)
                {
                    case GameState.Starting:
                        timeUntilStart.UpdateBehaviour(Time.deltaTime);
                        ShowTimer(timeUntilStart);
                        break;
                    case GameState.Running:
                        ShowPercent();
                        if (EnergyPercent >= 1)
                            Complete();
                        break;
                }
        }

        private void Complete()
        {
            Menu.Instance.Win();
        }

        private void ShowPercent() => timer.text = $"{Mathf.RoundToInt(EnergyPercent * 100)}%";

        public AsyncOperation AdvanceScene() => AdvanceScene(scenes.GetScene());

        public AsyncOperation AdvanceScene(int scene)
        {
            SetStateToLoading();

            AsyncOperation operation = ChangeScene(scene);
            operation.completed += (_) =>
            {
                currentLevel++;
                SetStateToStarting();
            };
            return operation;
        }

        private void SetStateToLoading() => gameState = GameState.Loading;

        private AsyncOperation ChangeScene(int scene)
            => SceneManager.LoadSceneAsync(scene, LoadSceneMode.Single);

        private void SetStateToRunning()
        {
            gameState = GameState.Running;
            currentRequiredEnergy = baseEnergy + (currentLevel * linearIncreaseEnergy);
            FindObjectOfType<EnemySpawner>().StartSpawing();
        }

        private void SetStateToStarting()
        {
            gameState = GameState.Starting;
            timeUntilStart.ResetCycles(1);
        }

        private void ShowTimer(IBasicClockwork clockwork)
        {
            float time = clockwork.CooldownTime;
            int minutes = (int)(time / 60);
            int seconds = (int)(time % 60);

            timer.text = minutes > 0 ? $"{minutes}:{seconds}" : seconds.ToString();
        }

        private float GetDifficulty()
        {
            float DifficultyByScene(int scene) => baseDifficulty * Mathf.Pow(scene, geometryIncreaseDifficulty) + baseDifficulty * (scene - 1) * linearIncreaseDifficulty;
            return Mathf.Lerp(DifficultyByScene(currentLevel), DifficultyByScene(currentLevel + 1), EnergyPercent * difficultyInSceneFactor);
        }

        public void AddEnergy(int energy)
        {
            CurrentEnergy += energy;
            if (CurrentEnergy > currentRequiredEnergy)
                CurrentEnergy = currentRequiredEnergy;
        }
    }
}