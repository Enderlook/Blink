using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Target Area Of Damage Ability", menuName = "Game/Abilities/Target Area Of Damage")]
    public class TargetAreaOfDamageAblity : AreaOfDamageAblity
    {
#pragma warning disable CS0649
        [Header("Setup")]

        [SerializeField, Tooltip("Cast from player?")]
        private bool castFromPlayer;

        [SerializeField, Layer, Tooltip("Which layer is the floor."), ShowIf(nameof(castFromPlayer), false)]
        private int layer;
        
#pragma warning restore CS0649

        private Camera camera;
        private Transform character;

        public override void PostInitialize(AbilitiesManager abilitiesManager)
        {
            character = abilitiesManager.transform;
            camera = Camera.main;
        }

        public override void Execute()
        {
            if (!castFromPlayer)
            {
                Ray ray = camera.ScreenPointToRay(Input.mousePosition);
                if (Physics.Raycast(ray, out RaycastHit hit, 1 << layer))
                    InstantiatePrefab(hit.point);
            }
            else
            {
                InstantiatePrefab(character.position);
            }
        }
    }
}