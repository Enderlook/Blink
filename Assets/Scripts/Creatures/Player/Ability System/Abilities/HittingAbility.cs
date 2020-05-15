using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class HittingAbility : Ability
    {
#pragma warning disable CS0649
        [Header("Configuration")]
        [SerializeField, Tooltip("Damage done on hit.")]
        protected int damage = 25;

        [SerializeField, Tooltip("Amount of force applied to targets.")]
        protected float pushForce = 10;

        [Header("Setup")]
        [SerializeField, Tooltip("Spawned prefab.")]
        protected GameObject prefab;
#pragma warning restore CS0649
    }
}