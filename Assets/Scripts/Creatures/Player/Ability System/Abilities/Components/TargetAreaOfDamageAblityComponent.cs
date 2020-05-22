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
            Ray ray = camera.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out RaycastHit hit, 1 << layer))
                InstantiatePrefab(hit.point);
        }
    }
}