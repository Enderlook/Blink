using AvalonStudios.Extensions;

using System.Collections.Generic;
using UnityEngine;
using System.Threading.Tasks;

namespace Game.Creatures.AbilitiesSystem
{
    [CreateAssetMenu(menuName = "Abilities/AoE")]
    public class AreaOfEffect : Ability
    {
        public enum Target { Self, Enemies }

        [SerializeField]
        private GameObject aoePrefab;

        [SerializeField]
        private string animationName;

        [SerializeField]
        private Target target;

        private LayerMask layerGround;

        private Collider colliderParticle;
        private Transform aoeVFXTransform;
        private CapsuleCollider aoeCapsule;

        public override void AwakeBehaviour()
        {
            base.AwakeBehaviour();
            layerGround = LayerMask.GetMask("Ground");
            aoeVFXTransform = aoePrefab.GetComponent<Transform>();
        }

        public override void UpdateBehaviour()
        {
            base.UpdateBehaviour();
            if (aoeCapsule != null)
            {

                bool col = GenerateRayCastByCapsuleCollider(aoeCapsule, aoeVFXTransform);
                if (col)
                {
                    aoeCapsule = null;
                    Debug.Log("AoE");
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
                InvokeElementAnimation();
            }
        }

        public void InvokeElementAnimation() => ThisAnimator.SetTrigger(animationName);

        public override void TriggerAbility()
        {
            List<ParticleSystem> particleSystems = new List<ParticleSystem>();

            if (active)
            {
                float timeToDestroy = 0;
                float timeToStart = 0;
                float timeToEnd = 0;

                Vector3 pointToInvoke = Vector3.zero;

                if (target == Target.Enemies)
                {
                    Ray camRayPoint = Camera.main.ScreenPointToRay(Input.mousePosition);

                    pointToInvoke = Physics.Raycast(camRayPoint, out RaycastHit ground, 100f, layerGround) ? ground.point : Vector3.zero;

                }
                else
                    pointToInvoke = selfTransform.position;


                GameObject aoe = Instantiate(aoePrefab, pointToInvoke, aoePrefab.transform.rotation);

                if (aoe != null)
                {
                    if (aoe.TryGetComponent(out Collider col))
                        colliderParticle = col;

                    foreach (Transform t in aoe.transform)
                    {
                        if (t.TryGetComponent(out ParticleSystem particleSystem))
                        {
                            if (particleSystem.gameObject.layer == LayerMask.NameToLayer("Impact"))
                            {
                                timeToStart = particleSystem.main.startDelayMultiplier;
                                timeToEnd = particleSystem.main.startLifetimeMultiplier;
                            }
                            timeToDestroy += particleSystem.main.duration;
                            particleSystems.Add(particleSystem);
                        }
                    }

                    Disable(timeToStart, timeToEnd, aoe);
                    Destroy(aoe, (timeToDestroy / particleSystems.Count));
                }
                active = false;
            }
        }

        private async void Disable(float startTime, float endTime, GameObject p)
        {
            await Task.Delay(System.TimeSpan.FromSeconds(startTime));
            colliderParticle.enabled = true;

            if (p.TryGetComponent(out CapsuleCollider capsule))
                aoeCapsule = capsule;

            await Task.Delay(System.TimeSpan.FromSeconds(endTime));
            colliderParticle.enabled = false;
        }
    }
}
