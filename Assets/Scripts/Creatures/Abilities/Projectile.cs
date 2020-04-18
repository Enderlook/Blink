using AvalonStudios.Extensions;

using UnityEngine;
using Game.Creatures.Player;

namespace Game.Creatures.AbilitiesSystem
{
    [CreateAssetMenu(menuName = "Abilities/Projectile")]
    public class Projectile : Ability
    {
        public GameObject Prefab { get { return projectile; } set { projectile = value; } }

        public string AnimationName { get { return animationName; } set { animationName = value; } }

        public Transform ShotPosition { get { return shotPosition; } set { shotPosition = value; } }

        public int Damage { get { return damage; } set { damage = value; } }

        [SerializeField]
        private GameObject projectile;

        [SerializeField]
        private float hitForce;

        [SerializeField]
        private string animationName;

        [SerializeField]
        private Transform shotPosition;

        [SerializeField]
        private int damage;

        private Abilities abilitiesRef;
        private Rigidbody rbProjectile;
        private Transform projectileTransform;
        private CapsuleCollider projectileCapsule;
        private Color gizmoColor = Color.red;

        public override void Initialize(Abilities abilities)
        {
            base.Initialize(abilities);
            abilitiesRef = abilities;
            shotPosition = abilities.ThisShotPosition;
        }

        public override void AwakeBehaviour()
        {
            base.AwakeBehaviour();
            rbProjectile = projectile.GetComponent<Rigidbody>();
            projectileTransform = projectile.GetComponent<Transform>();
        }

        public override void UpdateBehaviour()
        {
            if (projectileCapsule != null)
            {
                Vector3 ls = rbProjectile.transform.lossyScale;
                float rScale = Mathf.Max(Mathf.Abs(ls.x), Mathf.Abs(ls.z));
                float radius = projectileCapsule.radius * rScale;

                float halfHeight = projectileCapsule.height * Mathf.Abs(ls.y) * .5f;
                Vector3 capsuleBoundsStart = projectileCapsule.bounds.center + projectileTransform.up * halfHeight;
                Vector3 capsuleBoundsEnd = projectileCapsule.bounds.center - projectileTransform.up * halfHeight;

                bool col = Physics.CheckCapsule(capsuleBoundsStart, capsuleBoundsEnd, radius, targetLayer);
                if (col)
                {
                    projectileCapsule = null;
                }
            }
        }

        protected override void OnButtonDown()
        {
            base.OnButtonDown();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                active = true;
                StartFire();
            }
        }

        protected override void OnButtonHold()
        {
            base.OnButtonHold();

            if (Time.time > lastCooldown + Cooldown)
            {
                lastCooldown = Time.time;
                active = true;
                StartFire();
            }
        }

        public void StartFire() => ThisAnimator.SetTrigger(animationName);

        public override void TriggerAbility()
        {
            if (active)
            {
                GameObject instance = Instantiate(projectile, shotPosition.position, shotPosition.rotation);
                HitDamage.AddComponentTo(instance, damage);
                active = false;
            }
        }
    }
}
