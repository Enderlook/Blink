using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Target Area Of Damage Ability", menuName = "Game/Ability System/Components/Target Area Of Damage")]
    public class TargetAreaOfDamageAblityComponent : AreaOfDamageAbilityComponent
    {
#pragma warning disable CS0649
        [Header("Setup")]
        [SerializeField, Layer, Tooltip("Which layer is the floor.")]
        private int layer;        
#pragma warning restore CS0649

        private Camera camera;

        public override void Initialize(AbilitiesManager abilitiesManager) => camera = Camera.main;

        public override void Execute()
        {
            Vector2 position;
#if UNITY_ANDROID
#if UNITY_EDITOR
#if !IGNORE_UNITY_REMOTE
            if (!UnityEditor.EditorApplication.isRemoteConnected)
                position = Input.mousePosition;
            else
                position = Input.GetTouch(0).position;
#else

            if (Input.touchCount == 0)
                position = Input.mousePosition;
            else
                position = Input.GetTouch(0).position;
#endif
#endif
#else
            position = Input.mousePosition;
#endif
            Ray ray = camera.ScreenPointToRay(position);
            if (Physics.Raycast(ray, out RaycastHit hit, 1 << layer))
                InstantiatePrefab(hit.point);
        }
    }
}