﻿using Enderlook.Extensions;
using Enderlook.Unity.Atoms;

using Game.Others;

using UnityEngine;

namespace Game.Creatures
{
    [RequireComponent(typeof(AudioSource)), RequireComponent(typeof(RandomPitch)), AddComponentMenu("Game/Creatures/Hurtable")]
    public class Hurtable : MonoBehaviour, IDamagable
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Current health.")]
        private IntGetSetReference health;

        [SerializeField, Tooltip("Maximum health.")]
        private IntGetSetReference maxHealth;

        [SerializeField, Tooltip("Sounds play when hurt.")]
        private AudioClip[] hurtSounds;

        [SerializeField, Tooltip("Sounds play when die.")]
        private AudioClip[] dieSounds;
#pragma warning restore CS0649

        public int Health => health;

        public int MaxHealth => maxHealth;

        private AudioSource audioSource;

        private RandomPitch randomPitch;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            audioSource = GetComponent<AudioSource>();
            randomPitch = GetComponent<RandomPitch>();
        }

        public void TakeDamage(int amount)
        {
            randomPitch.Randomize();
            health.SetValue(health.GetValue() - amount);
            audioSource.clip = hurtSounds.RandomPick();
            audioSource.Play();

            if (health.GetValue() == 0)
                Die();
        }

        private void Die()
        {
            AudioSourceSpawner.Play(dieSounds.RandomPick(), transform.position, audioSource.outputAudioMixerGroup);

            IDie[] actions = GetComponentsInChildren<IDie>();
            for (int i = 0; i < actions.Length; i++)
                actions[i].Die();
        }

        public void TakeHealing(int amount)
            => health.SetValue(Mathf.Min(health.GetValue() + amount, maxHealth.GetValue()));

        public void SetMaxHealth(int maxHealth) => this.maxHealth.SetValue(maxHealth);
    }
}