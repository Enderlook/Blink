using Game.Attacks;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class AreaOfDamageAbilityComponent : HittingAbilityComponent
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Time in seconds since the prefab is spawn to produce damage.")]
        private float timeToProduceDamage = 1;
#pragma warning restore CS0649

        protected void InstantiatePrefab(Vector3 position, Quaternion rotation)
        {
            GameObject instance = Instantiate(prefab, position, rotation);
            AreaOfDamage.AddComponentTo(instance, timeToProduceDamage, damage, pushForce);
        }

        protected void InstantiatePrefab(Vector3 position) => InstantiatePrefab(position, Quaternion.identity);
    }
}