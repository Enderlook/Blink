using Game.Attacks;
using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Area Of Freezing Ability", menuName = "Game/Ability System/Components/Area Of Freezing")]
    public class AreaOfFreezingAbilityComponent : AbilityComponent
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Amount of time enemies are freezed.")]
        protected int duration = 4;

        [SerializeField, Tooltip("Time in seconds since the prefab is spawn to freeze the area.")]
        private float timeToProduceHealing = 1;

        [SerializeField, Tooltip("Material applied to renderers.")]
        private Material material;

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
            AreaOfFreezing.AddComponentTo(instance, timeToProduceHealing, duration, material, hitLayer);
        }
    }
}