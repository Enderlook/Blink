using Game.Attacks;
using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Area Of Healing Ability", menuName = "Game/Ability System/Components/Area Of Healing")]
    public class AreaOfHealingAbilityComponent : AbilityComponent
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Health restored by the healing aura")]
        protected int healing = 25;

        [SerializeField, Tooltip("Time in seconds since the prefab is spawn to produce the healing.")]
        private float timeToProduceHealing = 1;

        [SerializeField, Tooltip("Layer to affect.")]
        private LayerMask hitLayer;

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
            AreaOfHealing.AddComponentTo(instance, timeToProduceHealing, healing, hitLayer);
        }
    }
}