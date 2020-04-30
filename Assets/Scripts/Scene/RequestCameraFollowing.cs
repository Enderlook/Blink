using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Scene
{
    public class RequestCameraFollowing : MonoBehaviour
    {
        [SerializeField]
        private Vector3 position;

        [SerializeField]
        private Vector3 rotation;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            Transform camera = Camera.main.transform;
            camera.position = position;
            camera.rotation = Quaternion.Euler(rotation);
            TransformFollower.AddTransformFollower(camera.gameObject, transform,
                false, true, false, true, false, false, false, false, false, false, false);
        }
    }
}