using Enderlook.Unity.Attributes;

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
#pragma warning restore CS0649

        // Hide an obsolete API
        public static Camera Camera { get; private set; }

        private bool canSpawn;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => Camera = Camera.main;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (canSpawn && enemyLevelData.TrySpawnEnemy(out GameObject enemy, Time.deltaTime))
                enemy.transform.position = spawnPoints.GetSpawnPoint(Camera);
        }

        internal void StartSpawing()
        {
            enemyLevelData.ResetCounter();
            canSpawn = true;
        }
    }
}