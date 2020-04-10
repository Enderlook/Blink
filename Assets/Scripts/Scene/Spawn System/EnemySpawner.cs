using Enderlook.Extensions;
using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Scene
{
    public class EnemySpawner : MonoBehaviour
    {
        [SerializeField]
        private SpawnPointsManager spawnPoints;

        [SerializeField]
        private EnemyData[] enemiesData;

        [SerializeField, Tooltip("Calculates maximum enemies at the same time.\nMaximum Enemies = Mathf.Min(Difficulty * X, Y) * Z + W.")]
        private Vector4 maximumEnemies = new Vector4(1, 1, 10, 5);

        [SerializeField, Tooltip("Calculates amount of enemies spawn per second.\nEnemies Per Second = Mathf.Min(Difficulty * X, Y) * Z + W.")]
        private Vector4 enemiesPerSecond = new Vector4(.5f, 2, 1, .25f);
        private float timeSinceLastSpawn;

        // Hide an obsolete API
        private new Camera camera;

        private enum Mode { Freeze, WaitingForSpace, Spawning };

        private Mode mode;

        private GameObjectCounter counter = new GameObjectCounter();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            camera = Camera.main;
            counter.RegisterDestroy(CheckForSpace);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (mode == Mode.Spawning)
            {
                timeSinceLastSpawn += Time.deltaTime;
                if (timeSinceLastSpawn >= 1 / GetValue(enemiesPerSecond))
                {
                    timeSinceLastSpawn = 0;
                    counter.RegisterGameObject(SpawnEnemy());
                    if (counter.Alives > GetValue(maximumEnemies))
                        mode = Mode.WaitingForSpace;
                }
            }
        }

        private void CheckForSpace(GameObjectCounter gameObjectCounter, GameObject destroyed)
        {
            if (gameObjectCounter.Alives < GetValue(maximumEnemies))
                mode = Mode.Spawning;
        }

        public void StartSpawing() => mode = Mode.Spawning;

        private EnemyData GetRandomEnemyData() => enemiesData.RandomPickWeighted(e => e.GetWeight());

        private GameObject SpawnEnemy()
        {
            EnemyData enemyData = GetRandomEnemyData();
            return enemyData.SpawnEnemy(spawnPoints.GetSpawnPoint(camera));
        }

        private float GetValue(Vector4 parameters)
            => Mathf.Min(GameManager.Difficulty * parameters.x, parameters.y) * parameters.z + parameters.w;
    }
}