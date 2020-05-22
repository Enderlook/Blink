using Game.Creatures;

using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Area of Freezing")]
    public class AreaOfFreezing : AreaOfEffect
    {
        [Header("Configuration")]
        [SerializeField, Tooltip("Freeze duration")]
        private float freezeDuration = 2;

        [SerializeField, Tooltip("Material applied to renderers.")]
        private Material material;

        protected override void ProduceEffect(GameObject otherGameObject)
        {
            if (duration > 0)
            {
                foreach (IStunnable stunnable in otherGameObject.GetComponents<IStunnable>())
                    stunnable.Stun(freezeDuration);

                MaterialApplier.AddComponentTo<SkinnedMeshRenderer>(otherGameObject, freezeDuration, material);
            }
        }

        public static void AddComponentTo(GameObject source, float timeToFreeze, float duration, Material material, LayerMask hitLayer = default)
        {
            AreaOfFreezing component = source.AddComponent<AreaOfFreezing>();
            component.duration = duration / 2;
            component.freezeDuration = duration / 2;
            component.warmupTime = timeToFreeze;
            component.hitLayer = hitLayer;
            component.material = material;

            MaterialApplier.AddComponentTo<Renderer>(source, component.duration, material);
        }
    }
}
