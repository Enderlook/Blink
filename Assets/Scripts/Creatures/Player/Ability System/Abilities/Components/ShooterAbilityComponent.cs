using Game.Attacks.Projectiles;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Shooter Ability", menuName = "Game/Ability System/Components/Shooter")]
    public class ShooterAbilityComponent : HittingAbilityComponent
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Speed projectile movement.")]
        private float speed = 1;

        [Header("Setup")]
        [SerializeField, Tooltip("Layer hit")]
        private LayerMask hitLayer;
#pragma warning restore CS0649

        private Transform shootingPosition;

        public override void Initialize(AbilitiesManager abilityManager)
            => shootingPosition = abilityManager.ShootingPosition;

        public override void Execute()
        {
            GameObject instance = Instantiate(prefab, shootingPosition.position, shootingPosition.rotation);
            MoveStraightLine.AddComponentTo(instance, speed);
            ProjectileHit.AddComponentTo(instance, damage, pushForce, hitLayer);
        }
    }
}
