using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Scene
{
    public class RequestCameraFollowing : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Vector3 position;

        [SerializeField]
        private Vector3 rotation;
#pragma warning restore CS0649

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