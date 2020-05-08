using Enderlook.Unity.Prefabs.FloatingText;
#if UNITY_EDITOR
using Enderlook.Unity.Utils.UnityEditor;
#endif

using Game.Creatures;

#if UNITY_EDITOR
using UnityEditor;
#endif

using UnityEngine;

namespace Game.Scene
{
    [CreateAssetMenu(fileName = "Enemy Spawn Data", menuName = "Game/Enemy Spawn Data")]
    public class EnemyData : ScriptableObject
    {
        // Keep names in sync with EnemyDataEditor

#pragma warning disable CS0649
        [SerializeField]
        private GameObject enemyPrefab;
#pragma warning restore CS0649

        [SerializeField, Tooltip("Minimal difficulty to start spawning.")]
        private float difficultyThreshold = 0;

        [SerializeField, Tooltip("Up to which difficulty above Difficulty Threshold should scale.")]
        private float difficultyCap = 1;

        [SerializeField, Tooltip("Calculates enemy spawn weigth.\nWeight = Mathf.Min(Difficulty - Threshold, Cap) * X + Y.")]
        private Vector2 weight = new Vector2(1, 0);

        [SerializeField, Tooltip("Calculates enemy health multiplier.\nHealth Multiplier = Mathf.Min(Difficulty - Threshold, Cap) * X + Y.")]
        private Vector2 health = new Vector2(1, 0);

        [SerializeField, Tooltip("Calculates enemy damage multiplier.\nDamage Multiplier = Mathf.Min(Difficulty - Threshold, Cap) * X + Y.")]
        private Vector2 damage = new Vector2(1, 0);

        public float GetWeight() => Mathf.Max(GetValue(weight), 0);

        public GameObject SpawnEnemy()
        {
            // Set position
            GameObject instance = Instantiate(enemyPrefab);

            // Set health and max health
            Hurtable hurtable = instance.GetComponent<Hurtable>();
            FloatingTextController floatingTextController = instance.GetComponent<FloatingTextController>();
            floatingTextController.isEnable = false;
            int currentHealth = hurtable.Health;
            int maxHealth = GetMultipliedFactor(hurtable.MaxHealth, health);
            hurtable.SetMaxHealth(maxHealth);
            hurtable.TakeHealing(maxHealth - currentHealth);
            floatingTextController.isEnable = true;

            return instance;
        }

        private int GetMultipliedFactor(int value, Vector2 parameters) => Mathf.RoundToInt(GetValue(parameters) * value);

        private float GetValue(Vector2 parameters)
            => Mathf.Min(GameManager.Difficulty - difficultyThreshold, difficultyCap) * parameters.x + parameters.y;

#if UNITY_EDITOR
        private float GetValueEditorOnly(Vector2 parameters, float amount)
           => Mathf.Min(amount - difficultyThreshold, difficultyCap) * parameters.x + parameters.y;

        [MenuItem("Assets/Game/Create Enemy Data")]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private static void CreateEnemyData()
        {
            foreach (GameObject enemy in Selection.GetFiltered<GameObject>(SelectionMode.TopLevel))
            {
                EnemyData enemyData = CreateInstance<EnemyData>();
                enemyData.enemyPrefab = enemy;
                enemyData.name = enemy.name;
                AssetDatabase.CreateAsset(enemyData, AssetDatabase.GetAssetPath(enemy).WithDifferentExtension("asset"));
            }
        }

        [MenuItem("Assets/Game/Create Enemy Data", true)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private static bool CreateEnemyDataValidator()
            => Selection.GetFiltered<GameObject>(SelectionMode.TopLevel).Length > 0;
#endif
    }
}