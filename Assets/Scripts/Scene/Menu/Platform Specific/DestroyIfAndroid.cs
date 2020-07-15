﻿using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Destroy If Android")]
    public class DestroyIfAndroid : MonoBehaviour
    {
#if UNITY_EDITOR
#pragma warning disable CS0649, CS0414
        [SerializeField]
        private bool notRemoveIfRemoteIsNotConnected;
#pragma warning restore CS0649, CS0414
#endif

#if UNITY_ANDROID
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
#if UNITY_EDITOR
            if (!(notRemoveIfRemoteIsNotConnected || UnityEditor.EditorApplication.isRemoteConnected)
#if IGNORE_UNITY_REMOTE
                && false
#endif
                )
#endif
                Destroy(gameObject);
        }
#endif
    }
}