using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures.Crystal
{
    [AddComponentMenu("Game/Creatures/Crystal/Cracking"), RequireComponent(typeof(MeshRenderer))]
    public class CrystalCracking : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private IntGetReference health;

        [SerializeField]
        private IntGetReference maxHealth;

        [SerializeField]
        private IntEventReference healthEvent;
#pragma warning restore CS0649

        private Material material;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            healthEvent.Register(OnChange);
            MeshRenderer meshRenderer = GetComponent<MeshRenderer>();
            material = new Material(meshRenderer.material);
            meshRenderer.material = material;
            material.SetFloat("_Health", (float)health / maxHealth);
        }

        public void OnChange(int _) => material.SetFloat("_Health", (float)health / maxHealth);
    }
}