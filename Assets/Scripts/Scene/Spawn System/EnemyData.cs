using Enderlook.Unity.Prefabs.FloatingText;

using Game.Creatures;

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
    }
}