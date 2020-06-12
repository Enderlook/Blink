using Enderlook.Unity.Components;

using UnityEngine;
using UnityEngine.Audio;

namespace Game.Pickups.Orbs
{
    public abstract class Pickup : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Sound played when picked up.")]
        private AudioClip clip;

        [SerializeField, Tooltip("Audio Mixer Group used to play pick up sound.")]
        private AudioMixerGroup audioMixerGroup;

        protected void Pick()
        {
            AudioSourceUtils.PlayAndDestroy(clip, transform.position, audioMixerGroup);
            
            if (TryGetComponent(out TrailRenderer trailRenderer))
            {
                GetComponent<Collider>().enabled = false;
                enabled = false;
                Destroy(gameObject, trailRenderer.time * 2); // * 2 to be sure
            } else
                Destroy(gameObject);
        }
#pragma warning restore CS0649
    }
}