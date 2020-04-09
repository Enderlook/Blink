using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Game.Creatures.Player;

namespace Game.Creatures.Abilities.ShootAbility
{
    [CreateAssetMenu(menuName = "Abilities/ShootAbility")]
    public class ShootAbility : Ability
    {
        //[SerializeField, Tooltip("Prefab to be instantiate.")]
        //private GameObject projectile;

        [SerializeField, Tooltip("Hit force.")]
        private float hitForce;

        [SerializeField, Tooltip("Animation name.")]
        private string animationName;

        public string AnimationName => animationName;

        public float Damage => damage;

        private MouseShooter mouseShooter;

        public override void Initialize(GameObject gameObj)
        {
            mouseShooter = gameObj.GetComponent<MouseShooter>();
            mouseShooter.Initialize(this);

        }

        public override void TriggerAbility()
        {
            mouseShooter.Fire();
        }
    }
}