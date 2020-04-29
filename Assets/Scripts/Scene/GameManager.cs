using Enderlook.Unity.Utils.Clockworks;

using System;

using UnityEngine;
using UnityEngine.UI;

namespace Game.Scene
{
    public class GameManager : MonoBehaviour
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Time in seconds before starting to spawn enemies.")]
        private int startTime = 5;

        [SerializeField, Tooltip("Time in seconds before changing map.")]
        private int timePerScene = 120;

        [SerializeField, Min(.1f)]
        private float baseDifficulty = 1;

        [SerializeField, Min(.1f)]
        private float levelDifficultyFactor = .5f;

        [SerializeField, Min(.1f)]
        private float levelDifficultyPowerFactor = .5f;

        [SerializeField, Range(0, 1)]
        private float difficultyInSceneFactor = .5f;

#pragma warning disable CS0649
        [Header("Setup")]
        [SerializeField]
        private Text timer;
#pragma warning restore CS0649

        private int currentLevel = 1;

        private enum GameState { Starting, Running };

        private GameState gameState;

        private Clockwork timeUntilStart;

        private Clockwork timeUntilNextScene;

        private IBasicClockwork currentClockwork;

        private int lastDifficultyUpdateFrame = 0;

        private float lastUpdatedDifficulty;

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
            if (instance == null)
                instance = this;
            else
                throw new InvalidOperationException($"Only a single instance of {nameof(GameManager)} can exist at the same time.");

            timeUntilStart = new Clockwork(startTime, SetStateToRunning, true, 0);
            timeUntilNextScene = new Clockwork(timePerScene, AdvanceScene, true, 0);
            SetStateToStarting();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            currentClockwork.UpdateBehaviour(Time.deltaTime);
            ShowTimer(currentClockwork);
        }

        private void AdvanceScene()
        {
            currentLevel++;
            SetStateToStarting();

            throw new NotImplementedException();
        }

        private void SetStateToRunning()
        {
            gameState = GameState.Running;
            timeUntilNextScene.ResetCycles(1);
            currentClockwork = timeUntilNextScene;
            FindObjectOfType<EnemySpawner>().StartSpawing();
        }

        private void SetStateToStarting()
        {
            gameState = GameState.Starting;
            timeUntilStart.ResetCycles(1);
            currentClockwork = timeUntilStart;
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
            float DifficultyByScene(int scene) => baseDifficulty * Mathf.Pow(scene, levelDifficultyPowerFactor) + baseDifficulty * (scene - 1) * levelDifficultyFactor;
            return Mathf.Lerp(DifficultyByScene(currentLevel), DifficultyByScene(currentLevel + 1), timeUntilNextScene.WarmupPercent * difficultyInSceneFactor);
        }
    }
}