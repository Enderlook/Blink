using AvalonStudios.Extensions;

using UnityEngine;
using Game.Creatures.Player;

namespace Game.Creatures.AbilitiesSystem
{
    [CreateAssetMenu(menuName = "Abilities/Projectile")]
    public class Projectile : Ability
    {
        public GameObject Prefab { get { return projectile; } set { projectile = value; } }

        public AudioClip ShotSFX { get { return shotSFX; } set { shotSFX = value; } }

        public AudioClip HitSFX { get { return hitSFX; } set { hitSFX = value; } }

        public float Speed { get { return speed; } set { speed = value; } }

        public string AnimationName { get { return animationName; } set { animationName = value; } }

        public Transform ShotPosition { get { return shotPosition; } set { shotPosition = value; } }

        public float Damage { get { return damage; } set { damage = value; } }

        public LayerMask ShoteableMask { get { return shoteableMask; } set { shoteableMask = value; } }

        private GameObject projectile;

        private AudioClip shotSFX;

        private AudioClip hitSFX;

        private float speed;

        private float hitForce;

        private string animationName;

        private Transform shotPosition;

        private LayerMask shoteableMask;

        private Abilities abilitiesRef;
        private Rigidbody rbProjectile;

        public override void Initialize(Abilities abilities)
        {
            base.Initialize(abilities);
            abilitiesRef = abilities;
            shotPosition = abilities.ThisShotPosition;
        }

        public override void AwakeBehaviour()
        {
            base.AwakeBehaviour();
            rbProjectile = Prefab.GetComponent<Rigidbody>();
        }

        public override void UpdateBehaviour()
        {
            //Debug.Log($"Collision: ");
        }

        protected override void OnButtonDown()
        {
            base.OnButtonDown();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                StartFire();
            }
        }

        protected override void OnButtonHold()
        {
            base.OnButtonHold();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                StartFire();
            }
        }

        public void StartFire() => ThisAnimator.SetTrigger(animationName);

        public override void TriggerAbility()
        {
            rbProjectile = Instantiate(projectile, shotPosition.position, shotPosition.rotation).GetComponent<Rigidbody>();

            rbProjectile.velocity = rbProjectile.transform.forward * speed;
        }
    }
}