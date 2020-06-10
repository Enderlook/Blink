using UnityEngine;

namespace Game.Scene
{
    [AddComponentMenu("Game/Disable On Release"), DefaultExecutionOrder(-100)]
    public class DisableOnRelease : MonoBehaviour
    {
#if RELEASE
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
            => gameObject.SetActive(false);
#endif
    }
}