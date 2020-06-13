using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemies/Reaper Attack"), RequireComponent(typeof(EnemyPathFinding)), RequireComponent(typeof(NavMeshAgent)), RequireComponent(typeof(Animator))]
    public class ReaperAttack : EnemyAttack
    {
        [SerializeField, Tooltip("Medium attack animation name.")]
        private string mediumAttack;

        [SerializeField, Tooltip("Strong attack animation name.")]
        private string strongAttack;

        protected override string GetAnimationKey()
        {
            float probability = Random.Range(0, 100);
            if (probability >= 0 && probability <= 60)
                return basicAttack;
            else if (probability >= 61 && probability <= 90)
                return mediumAttack;
            else
                return strongAttack;
        }
    }
}
