using Enderlook.Unity.Components.Destroy;

using UnityEngine;
using UnityEngine.Audio;

namespace Game.Others
{
    public static class AudioSourceSpawner
    {
        public static void Play(AudioClip clip, Vector3 position = default, AudioMixerGroup audioMixerGroup = null)
        {
            GameObject gameObject = new GameObject("Sound");
            gameObject.transform.position = position;
            AudioSource source = gameObject.AddComponent<AudioSource>();
            source.clip = clip;
            source.outputAudioMixerGroup = audioMixerGroup;
            gameObject.AddComponent<RandomPitch>();
            source.Play();
            gameObject.AddComponent<DestroyWhenAudioSourceEnds>();
        }
    }
}