using Enderlook.Unity.Attributes;
using Enderlook.Unity.Components;

using UnityEngine;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Creatures/Enemy/Health Bar Spawn")]
    public class HealthBarSpawn : HealthFeedback, IDie
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Determines in which point relative to this transfor does the healh bar spawns."), DrawVectorRelativeToTransform]
        private Vector3 healthBarSpawnPosition;
#pragma warning restore CS0649

        private GameObject healthBarParent;

        protected override void Awake()
        {
            healthBarParent = new GameObject($"Enemy Health Bar Follower of {gameObject.name}");
            //parent.transform.rotation = EnemySpawner.Camera.transform.rotation;            
            healthBar = Instantiate(healthBar, healthBarParent.transform);
            base.Awake();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            healthBarParent.transform.position = transform.position + healthBarSpawnPosition;
            TransformFollower.AddTransformFollower(healthBarParent, transform,
                false, true, true, true,
                false, false, false, false,
                false, false, false);
        }

        void IDie.Die() => Destroy(healthBarParent);
    }
}
