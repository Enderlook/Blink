using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Game.Creatures.Player;

namespace Game.Creatures.AbilitiesSystem
{
    [CreateAssetMenu(menuName = "Abilities/Projectile")]
    public class Projectile : Ability
    {
        //[SerializeField, Tooltip("Prefab to be instantiate.")]
        //private GameObject projectile;

        [SerializeField, Tooltip("Hit force.")]
        private float hitForce;

        [SerializeField, Tooltip("Animation name.")]
        private string animationName;

        public string AnimationName { get { return animationName; } set { animationName = value; } }

        public float Damage { get { return damage; } set { damage = value; } }

        //public override void Initialize(Abilities abilities)
        //{
        //    base.Initialize(abilities);
        //}

        public override void AwakeBehaviour()
        {
            base.AwakeBehaviour();
        }

        protected override void OnButtonDown()
        {
            base.OnButtonDown();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                TriggerAbility();
            }
        }

        protected override void OnButtonHold()
        {
            base.OnButtonHold();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                TriggerAbility();
            }
        }

        public override void TriggerAbility() => ThisAnimator.SetTrigger(animationName);
    }
}