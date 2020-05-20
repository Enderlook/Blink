using Enderlook.Unity.Components;

using UnityEngine;
using UnityEngine.Audio;

namespace Game.Pickups.Orbs
{
    public abstract class Orb : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Sound played when picked up.")]
        private AudioClip clip;

        [SerializeField, Tooltip("Audio Mixer Group used to play pick up sound.")]
        private AudioMixerGroup audioMixerGroup;
#pragma warning restore CS0649

        protected int value = 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => AutoSize();

        private void AutoSize() => transform.localScale *= Mathf.Pow(value + 4, .25f) - .5f;

        public void SetValue(int value)
        {
            this.value = value;
            AutoSize();
        }

        protected void Pickup()
        {
            AudioSourceUtils.PlayAndDestroy(clip, transform.position, audioMixerGroup);
            Destroy(gameObject);
        }
    }
}