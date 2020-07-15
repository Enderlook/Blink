using Game.Attacks;
using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Heal Player And Crystal Ability", menuName = "Game/Ability System/Components/Heal Player And Crystal")]
    public class HealPlayerAndCrystalAbilityComponent : AbilityComponent
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Health restored to player.")]
        protected int playerHealing = 25;

        [SerializeField, Tooltip("Health restored to crystal.")]
        protected int crystalHealing = 25;

        [SerializeField, Tooltip("Time in seconds since the prefab is spawn to produce the healing.")]
        private float timeToProduceHealing = 1;

        [Header("Setup")]
        [SerializeField, Tooltip("Spawned prefab.")]
        protected GameObject prefab;
#pragma warning restore CS0649

        private Transform spawnPoint;

        public override void Initialize(AbilitiesManager manager)
            => spawnPoint = CrystalAndPlayerTracker.Crystal;

        public override void Execute()
        {
            GameObject instance = Instantiate(prefab, spawnPoint.position, Quaternion.identity);
            HealPlayerAndCrystal.AddComponentTo(instance, timeToProduceHealing, playerHealing, crystalHealing);
        }
    }
}