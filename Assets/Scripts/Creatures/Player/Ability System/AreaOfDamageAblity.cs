using Enderlook.Unity.Attributes;

using Game.Attacks;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Area Of Damage Ability", menuName = "Game/Abilities/Area Of Damage")]
    public class AreaOfDamageAblity : Ability
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Damage done on hit.")]
        private int damage = 25;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        private float pushForce = 10;

        [SerializeField, Tooltip("Time in seconds since the prefab is spawn to produce damage.")]
        private float timeToProduceDamage = 1;

        [Header("Setup")]
        [SerializeField, Tooltip("Spawned prefab.")]
        private GameObject prefab;

        [SerializeField, Layer, Tooltip("Which layer is the floor.")]
        private int layer;
#pragma warning restore CS0649

        private Camera camera;

        public override void PostInitialize(AbilitiesManager abilitiesManager)
            => camera = Camera.main;

        public override void Execute()
        {
            Ray ray = camera.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out RaycastHit hit, 1 << layer))
            {
                GameObject instance = Instantiate(prefab, hit.point, Quaternion.identity);
                AreaOfDamage.AddComponentTo(instance, timeToProduceDamage, damage, pushForce);
            }
        }
    }
}