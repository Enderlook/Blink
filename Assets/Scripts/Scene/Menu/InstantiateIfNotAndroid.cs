using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Instantiate If Not Android")]
    public class InstantiateIfNotAndroid : MonoBehaviour
    {
#pragma warning disable CS0649, CS0414
#if !UNITY_ANDROID || UNITY_EDITOR
#if UNITY_EDITOR
        [SerializeField]
        private bool addIfRemoteIsNotConnected = true;
#endif

        [SerializeField, Tooltip("Prefab to instantiate as child.")]
        private GameObject prefab;
#pragma warning restore CS0649, CS0414

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
#if !UNITY_ANDROID || UNITY_EDITOR
#if UNITY_EDITOR
            if (!UnityEditor.EditorApplication.isRemoteConnected && addIfRemoteIsNotConnected
#if IGNORE_UNITY_REMOTE
                && false
#endif
                )
#endif
                Instantiate(prefab, transform);
#endif
        }
#endif
    }
}