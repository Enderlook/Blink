using System;
using System.Linq;

using UnityEngine;

namespace Game
{
    public class MaterialApplier : MonoBehaviour
    {
        private float timer;

        private Renderer[] renderers;

        private (Animator animator, float speed)[] animators;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            timer -= Time.deltaTime;
            if (timer <= 0)
            {
                foreach (Renderer renderer in renderers)
                {
                    Material[] materials = renderer.materials;
                    Array.Resize(ref materials, materials.Length - 1);
                    renderer.materials = materials;
                }
                foreach ((Animator animator, float speed) in animators)
                    animator.speed = speed;
                Destroy(this);
            }
        }

        public static void AddComponentTo<T>(GameObject gameObject, float duration, Material material)
            where T : Renderer
        {
            MaterialApplier materialApplier = gameObject.GetComponent<MaterialApplier>();
            if (materialApplier != null)
            {
                materialApplier.timer = duration;
                return;
            }

            materialApplier = gameObject.AddComponent<MaterialApplier>();
            materialApplier.timer = duration;

            materialApplier.renderers = gameObject.GetComponentsInChildren<T>();
            foreach (Renderer renderer in materialApplier.renderers)
            {
                Material[] materials = renderer.materials;
                Array.Resize(ref materials, materials.Length + 1);
                materials[materials.Length - 1] = material;
                renderer.materials = materials;
            }

            materialApplier.animators = gameObject.GetComponentsInChildren<Animator>().Select(e => {
                float speed = e.speed;
                e.speed = 0;
                return (e, speed);
            }).ToArray();
        }
    }
}
