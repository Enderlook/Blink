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

        [SerializeField, Range(0, 1)]
        private float difficultyInSceneFactor = .5f;

        [Header("Setup")]
        [SerializeField]
        private Text timer;

        private int currentLevel = 1;

        private enum GameState { Starting, Running };

        private GameState gameState;

        private Clockwork timeUntilStart;

        private Clockwork timeUntilNextScene;

        private IBasicClockwork currentClockwork;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
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

            timer.text = minutes > 0 ? $"{minutes}:{seconds}" : $"{seconds}";
        }

        private float GetDifficulty()
        {
            float DifficultyByScene(int scene) => baseDifficulty * Mathf.Pow(scene, levelDifficultyFactor);
            return Mathf.Lerp(DifficultyByScene(currentLevel), DifficultyByScene(currentLevel + 1), timeUntilNextScene.WarmupPercent * difficultyInSceneFactor);
        }
    }
}