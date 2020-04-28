using Game.Attacks.Projectiles;
using AvalonStudios.Extensions;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Shooter Ability", menuName = "Game/Abilities/Shooter")]
    public class ShooterAbility : Ability
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Damage done on hit.")]
        private int damage = 10;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        [SerializeField, Tooltip("Speed projectile movement.")]
        private float speed = 1;

        [Header("Setup")]
        [SerializeField, Tooltip("Projectile prefab.")]
        private GameObject prefab;

        [SerializeField, Tooltip("Layer hit")]
        private LayerMask hitLayer;

        private Transform shootingPosition;

        public override void PostInitialize(AbilitiesManager abilityManager)
            => shootingPosition = abilityManager.ShootingPosition;

        public override void Execute()
        {
            GameObject instance = Instantiate(prefab, shootingPosition.position, shootingPosition.rotation);
            MoveStraightLine.AddComponentTo(instance, speed);
            ProjectileHit.AddComponentTo(instance, damage, pushForce, hitLayer.ToLayer());
        }
    }
}
