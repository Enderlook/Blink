using System;
using System.Collections;

using UnityEngine;
using UnityEngine.Advertisements;

namespace Game.Scene
{
    public class AdsManager : MonoBehaviour
    {
        private string gameID =
#if UNITY_ANDROID
        "3654749"
#elif UNITY_IOS
        "3654748"
#else
        null
#endif
        ;

        private bool testMode =
#if UNITY_EDITOR
        true
#else
        false
#endif
        ;

        private string adsType = "video";

        private bool HaveAds => !(gameID is null);

        private static AdsManager instance;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            // Avoid being instanced several times if player go to Main Menu several times.
            if (instance == null)
                instance = this;
            else
                Destroy(gameObject);

            DontDestroyOnLoad(gameObject);

            if (!HaveAds)
                return;
#if UNITY_ANDROID
            Advertisement.Initialize(gameID, testMode);
#endif
        }

#if UNITY_ANDROID
        public static void Play(Action<bool> callback) => instance.PlayAds(callback);

        private void PlayAds(Action<bool> callback)
        {
            if (HaveAds)
                StartCoroutine(Work());
            else
                callback?.Invoke(false);

            IEnumerator Work()
            {
                while (!Advertisement.IsReady(adsType))
                    yield return null;
                ShowOptions showOptions = new ShowOptions();
                if (!(callback is null))
                    showOptions.resultCallback += (result) => callback(result != ShowResult.Failed);
                Advertisement.Show(adsType, showOptions);
            }
        }
#else
        public static void Play(Action<bool> callback) => callback(true);
#endif
    }
}