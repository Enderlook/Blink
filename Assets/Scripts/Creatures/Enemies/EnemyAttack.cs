using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Game.Creatures
{
    public class EnemyAttack : MonoBehaviour
    {
        [SerializeField, Tooltip("Enemy path finding.")]
        private EnemyPathFinding enemyPathFinding;

        [SerializeField, Tooltip("Animator component.")]
        private Animator animator;

        [SerializeField, Tooltip("Animation key")]
        private string animationKey;

        [SerializeField, Tooltip("Cooldown")]
        private float cooldown;

        private float nextAttack;

        private void Update()
        {
            if (enemyPathFinding.TargetDistance <= enemyPathFinding.ThisNavMeshAgent.stoppingDistance)
            {
                if (Time.time >= nextAttack)
                {
                    animator.SetTrigger(animationKey);
                    nextAttack = Time.time + cooldown;
                }
            }
        }

    }
}
