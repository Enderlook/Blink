using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Destroy If Not Android")]
    public class DestroyIfNotAndroid : MonoBehaviour
    {
#if !UNITY_ANDROID || UNITY_EDITOR
        [SerializeField]
        private bool removeIfRemoteIsNotConnected = true;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
#if UNITY_EDITOR && UNITY_ANDROID
            if (!UnityEditor.EditorApplication.isRemoteConnected && removeIfRemoteIsNotConnected)
#endif
                Destroy(gameObject);
        }
#endif
    }
}