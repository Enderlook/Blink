using Game.Others;

using UnityEngine;
using UnityEngine.Audio;

namespace Game.Pickups
{
    public abstract class Orb : MonoBehaviour
    {
        [SerializeField, Tooltip("Sound played when picked up.")]
        private AudioClip clip;

        [SerializeField, Tooltip("Audio Mixer Group used to play pick up sound.")]
        private AudioMixerGroup audioMixerGroup;

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
            AudioSourceSpawner.Play(clip, transform.position, audioMixerGroup);
            Destroy(gameObject);
        }
    }
}