using Enderlook.Extensions;
using Enderlook.Unity.Atoms;
using Enderlook.Unity.Components;

using Game.Others;

using System;

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
            if (amount < 0)
                Debug.LogWarning($"{nameof(amount)} ({amount}) should not be negative in {nameof(Hurtable)}. {nameof(gameObject)} {gameObject.name} is restoring health.");

            randomPitch.Randomize();
            health.SetValue(health.GetValue() - amount);
            audioSource.clip = hurtSounds.RandomPick();
            audioSource.Play();

            if (health.GetValue() == 0)
                Die();
        }

        private void Die()
        {
            AudioSourceUtils.PlayAndDestroy(dieSounds.RandomPick(), transform.position, audioSource.outputAudioMixerGroup);

            IDie[] actions = GetComponentsInChildren<IDie>();
            for (int i = 0; i < actions.Length; i++)
                actions[i].Die();
        }

        public void TakeHealing(int amount)
        {
            if (amount < 0)
                Debug.LogWarning($"{nameof(amount)} ({amount}) should not be negative in {nameof(Hurtable)}. {nameof(gameObject)} {gameObject.name} is loosing health.");

            health.SetValue(Mathf.Min(health.GetValue() + amount, maxHealth.GetValue()));
        }

        public void SetMaxHealth(int amount)
        {
            if (amount <= 0) throw new ArgumentOutOfRangeException(nameof(amount), amount, $"Can't be negative or zero.");

            maxHealth.SetValue(amount);
        }
    }
}