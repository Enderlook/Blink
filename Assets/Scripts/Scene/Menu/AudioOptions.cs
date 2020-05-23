using System;

using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

namespace Game.Scene
{
    public class AudioOptions : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private AudioMixer audioMixer;

        [SerializeField]
        private Slider masterSlider;

        [SerializeField]
        private Text masterValue;

        [SerializeField]
        private string masterParameter;

        [SerializeField]
        private Slider musicSlider;

        [SerializeField]
        private Text musicValue;

        [SerializeField]
        private string musicParameter;

        [SerializeField]
        private Slider soundSlider;

        [SerializeField]
        private Text soundValue;

        [SerializeField]
        private string soundParameter;
#pragma warning restore CS0649

        private const float lower = 0.0001f;
        private const float upper = 2;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            masterSlider.onValueChanged.AddListener(SetMasterVolume);
            masterSlider.minValue = lower;
            masterSlider.maxValue = upper;
            masterSlider.value = 1;

            musicSlider.onValueChanged.AddListener(SetMusicVolume);
            musicSlider.minValue = lower;
            musicSlider.maxValue = upper;
            musicSlider.value = 1;

            soundSlider.onValueChanged.AddListener(SetSoundVolume);
            soundSlider.minValue = lower;
            soundSlider.maxValue = upper;
            soundSlider.value = 1;
        }

        private void SetAmount(float amount, string parameter, Text text)
        {
            SetText(amount, text);
            audioMixer.SetFloat(parameter, ConvertToDecibel(amount));
        }

        private float ConvertToDecibel(double value)
            => (float)Math.Log10(Math.Max(value, lower)) * 20;

        private static void SetText(float amount, Text text)
            => text.text = ((int)(amount * 100 / upper)).ToString();
        public void SetMasterVolume(float amount)
            => SetAmount(amount, masterParameter, masterValue);

        public void SetMusicVolume(float amount)
            => SetAmount(amount, musicParameter, musicValue);

        public void SetSoundVolume(float amount)
            => SetAmount(amount, soundParameter, soundValue);
    }
}