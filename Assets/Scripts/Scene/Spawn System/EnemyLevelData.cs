using Enderlook.Extensions;
using Enderlook.Unity.Attributes;
using Enderlook.Unity.Components;
#if UNITY_EDITOR
using Enderlook.Unity.Utils.UnityEditor;
using Enderlook.Utils;
using System.Linq;
using UnityEditor;
#endif
using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Enemy Level Data", menuName = "Game/Enemy Level Data")]
    public class EnemyLevelData : ScriptableObject
    {
        // Keep name in sync with EnemyLevelDataEditor
        [SerializeField, Tooltip("Calculates maximum enemies at the same time.\nMaximum Enemies = Mathf.Min(Difficulty * X, Y) * Z + W.")]
        private Vector4 maximumEnemies = new Vector4(1, 1, 10, 5);

        // Keep name in sync with EnemyLevelDataEditor
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

        private static float GetValue(Vector4 parameters)
            => (Mathf.Min(GameManager.Difficulty * parameters.x, parameters.y) * parameters.z) + parameters.w;

#if UNITY_EDITOR
        private static float GetValueEditorOnly(Vector4 parameters, float difficulty)
           => (Mathf.Min(difficulty * parameters.x, parameters.y) * parameters.z) + parameters.w;

        [MenuItem("Assets/Game/Create Enemy Level Data")]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private static void CreateEnemyLevelData()
        {
            EnemyLevelData enemyLevelData = CreateInstance<EnemyLevelData>();
            enemyLevelData.enemiesData = Selection.GetFiltered<EnemyData>(SelectionMode.DeepAssets);
            AssetDatabase.CreateAsset(
                enemyLevelData,
                StringUtils.GetCommonPreffix(
                    enemyLevelData.enemiesData.Select(
                        e => string.Join("/", AssetDatabase.GetAssetPath(e).Split('/'))
                    )
                ) + "Enemy Level Data.asset"
            );
        }

        [MenuItem("Assets/Game/Create Enemy Data", true)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private static bool CreateEnemyLevelDataValidator()
            => Selection.GetFiltered<GameObject>(SelectionMode.TopLevel).Length > 0;
#endif
    }
}