﻿using AvalonStudios.Extensions;

using Enderlook.Unity.Attributes;
using Enderlook.Unity.Utils.Clockworks;

using System.Collections;

using UnityEngine;
using UnityEngine.AI;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemies/Attack"), RequireComponent(typeof(EnemyPathFinding)), RequireComponent(typeof(NavMeshAgent)), RequireComponent(typeof(Animator))]
    public class EnemyAttack : MonoBehaviour, IDie, IStunnable
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Is Boss")]
        private bool isBoss;

        [SerializeField, Tooltip("Basic attack key")]
        private string basicAttack;

        [SerializeField, Tooltip("Medium attack."), ShowIf(nameof(isBoss), true)]
        private string mediumAttack;

        [SerializeField, Tooltip("Strong attack"), ShowIf(nameof(isBoss), true)]
        private string strongAttack;

        [SerializeField, Tooltip("Damage")]
        private int damage;

        [SerializeField, Tooltip("Cooldown")]
        private float cooldown;

        [SerializeField, Tooltip("Player layer")]
        private LayerMask playerLayer;

        [SerializeField, Tooltip("Crystal layer")]
        private LayerMask crystalLayer;
#pragma warning restore CS0649

        private EnemyPathFinding enemyPathFinding;
        private NavMeshAgent navMeshAgent;
        private Animator animator;

        private float nextAttack;
        private bool isDead;
        private bool isStunned;
        private Clockwork stunningClockwork;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            enemyPathFinding = GetComponent<EnemyPathFinding>();
            navMeshAgent = GetComponent<NavMeshAgent>();
            animator = GetComponent<Animator>();
            stunningClockwork = new Clockwork(0, UnStun, true, 0);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (isDead)
                return;

            if (isStunned)
                stunningClockwork.UpdateBehaviour(Time.deltaTime);
            else if (enemyPathFinding.TargetDistance <= navMeshAgent.stoppingDistance)
            {
                enemyPathFinding.PlayWalkAnimation(false);
                if (Time.time >= nextAttack)
                {
                    string animationKey;
                    if (isBoss)
                    {
                        float prob = Random.Range(0, 100);
                        if (prob >= 0 && prob <= 60)
                            animationKey = basicAttack;
                        else if (prob >= 61 && prob <= 90)
                            animationKey = mediumAttack;
                        else
                            animationKey = strongAttack;
                    }
                    else
                        animationKey = basicAttack;

                    animator.SetTrigger(animationKey);
                    nextAttack = Time.time + cooldown;
                }
            }
            else
                enemyPathFinding.PlayWalkAnimation(true);
        }

        private void OnTriggerEnter(Collider other)
        {
            GameObject target = other.gameObject;
            if (target.layer == playerLayer.ToLayer() || target.layer == crystalLayer.ToLayer())
            {
                if (target.TryGetComponent(out IDamagable damagable))
                    damagable.TakeDamage(damage);
            }
        }

        void IDie.Die() => isDead = true;

        public void Stun(float duration)
        {
            isStunned = true;
            stunningClockwork.ResetCycles(1);
            stunningClockwork.ResetTime(duration);
        }

        private void UnStun() => isStunned = false;
    }
}
