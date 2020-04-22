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
#pragma warning disable CS0649
        [SerializeField]
        private GameObject enemyPrefab;
#pragma warning restore CS0649

        [SerializeField, Tooltip("Calculates enemy spawn weight.\nWeight = Mathf.Min((Difficulty - X) * Y, Z) + W.")]
        private Vector4 weight = new Vector4(0, 1, 2, 0);

        [SerializeField, Tooltip("Calculates enemy health multiplier.\nMultiplier = Mathf.Min((Difficulty - X) * Y, Z) + W.")]
        private Vector4 health = new Vector4(0, 1, 2, 0);

        [SerializeField, Tooltip("Calculates enemy damage multiplier.\nMultiplier = Mathf.Min((Difficulty - X) * Y, Z) + W.")]
        private Vector4 damage = new Vector4(0, 1, 2, 0);

        public float GetWeight() => GetValue(weight);

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

        private int GetMultipliedFactor(int value, Vector4 parameters) => Mathf.RoundToInt(GetValue(parameters) * value);

        private float GetValue(Vector4 parameters)
            => Mathf.Min((GameManager.Difficulty - parameters.x) * parameters.y, parameters.z) + parameters.w;

#if UNITY_EDITOR
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