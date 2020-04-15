using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Game.Creatures.AbilitiesSystem
{
    [CreateAssetMenu(menuName = "Abilities/AoE")]
    public class AreaOfEffect : Ability
    {
        [SerializeField]
        private GameObject aoePrefab;

        [SerializeField]
        private string animationName;

        private LayerMask layerGround;

        public override void AwakeBehaviour()
        {
            base.AwakeBehaviour();
            layerGround = LayerMask.GetMask("Ground");
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
            if (active)
            {
                //Ray camRayPoint = Camera.main.ScreenPointToRay(Input.mousePosition);

                //Vector3 pointOnScreen = Physics.Raycast(camRayPoint, out RaycastHit ground, 100f, layerGround) ? ground.point : Vector3.zero;

                //Instantiate(aoePrefab, pointOnScreen, aoePrefab.transform.rotation);

                Debug.Log("Invoke prefab");

                active = false;
            }
        }
    }
}
