﻿using Enderlook.Extensions;
using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Enemy Level Data", menuName = "Game/Enemy Level Data")]
    public class EnemyLevelData : ScriptableObject
    {
        [SerializeField, Tooltip("Calculates maximum enemies at the same time.\nMaximum Enemies = Mathf.Min(Difficulty * X, Y) * Z + W.")]
        private Vector4 maximumEnemies = new Vector4(1, 1, 10, 5);

        [SerializeField, Tooltip("Calculates amount of enemies spawn per second.\nEnemies Per Second = Mathf.Min(Difficulty * X, Y) * Z + W.")]
        private Vector4 enemiesPerSecond = new Vector4(.5f, 2, 1, .25f);
        private float timeSinceLastSpawn;

#pragma warning disable CS0649
        [SerializeField]
        private EnemyData[] enemiesData;
#pragma warning restore CS0649

        private GameObjectCounter counter;

        private bool isCurrentlySpawning = true;

        public void ResetCounter()
        {
            counter = new GameObjectCounter();
            counter.RegisterDestroy(CheckForSpace);
            isCurrentlySpawning = true;
            timeSinceLastSpawn = float.MaxValue;
        }

        public bool TrySpawnEnemy(out GameObject enemy, float timeSinceLastUpdate)
        {
            if (isCurrentlySpawning)
            {
                timeSinceLastSpawn += timeSinceLastUpdate;
                if (timeSinceLastSpawn >= 1 / GetValue(enemiesPerSecond))
                {
                    timeSinceLastSpawn = 0;
                    enemy = SpawnEnemy();
                    return true;
                }
            }

            enemy = default;
            return false;
        }

        private GameObject SpawnEnemy()
        {
            GameObject gameObject = GetRandomEnemyData().SpawnEnemy();
            counter.RegisterGameObject(gameObject);
            if (counter.Alives >= GetValue(maximumEnemies))
                isCurrentlySpawning = false;
            return gameObject;
        }

        private void CheckForSpace(GameObjectCounter gameObjectCounter, GameObject destroyed)
        {
            if (gameObjectCounter.Alives < GetValue(maximumEnemies))
                isCurrentlySpawning = true;
        }

        private EnemyData GetRandomEnemyData() => enemiesData.RandomPickWeighted(e => e.GetWeight());

        private float GetValue(Vector4 parameters)
            => (Mathf.Min(GameManager.Difficulty * parameters.x, parameters.y) * parameters.z) + parameters.w;
    }
}