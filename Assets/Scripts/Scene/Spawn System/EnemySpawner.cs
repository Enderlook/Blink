using Enderlook.Unity.Attributes;
using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Scene
{
    public class EnemySpawner : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Expandable]
        private EnemyLevelData enemyLevelData;

        [SerializeField]
        private SpawnPointsManager spawnPoints;

        [SerializeField, Tooltip("Time in seconds before spawn the boss.")]
        private float bossCountdown;

        [SerializeField, Tooltip("Prefab of the boss.")]
        private GameObject bossPrefab;
#pragma warning restore CS0649

        // Hide an obsolete API
        public static Camera Camera { get; private set; }

        private bool canSpawn;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => Camera = Camera.main;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (GameManager.HasWon)
                return;

            if (canSpawn && enemyLevelData.TrySpawnEnemy(out GameObject enemy, Time.deltaTime))
                enemy.transform.position = spawnPoints.GetSpawnPoint(Camera);

            if (bossCountdown > 0)
            {
                bossCountdown -= Time.deltaTime;
                if (bossCountdown < 0)
                {
                    GameObject instance = Instantiate(bossPrefab);
                    instance.transform.position = spawnPoints.GetSpawnPoint(Camera);
                }
            }
        }

        internal void StartSpawing()
        {
            enemyLevelData.ResetCounter();
            canSpawn = true;
        }
    }
}