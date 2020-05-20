using UnityEngine;

namespace Game.Pickups.Crystals
{
    public enum CrystalElement
    {
        Air,
        Earth,
        Fire,
        Water,
    }

    [AddComponentMenu("Game/Pickups/Crystals/Crystal Drop Configuration"), DefaultExecutionOrder(-1)]
    public class CrystalDropConfiguration : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Primary color of crystal material.")]
        private Color primaryColor;

        [SerializeField, Tooltip("Secondary color of crystal material.")]
        private Color secondaryColor;

        [SerializeField, Tooltip("Material of crystal drops and rods.")]
        private Material material;

        [SerializeField, Tooltip("Crystal type effect.")]
        private CrystalElement element;
#pragma warning restore CS0649

        private static CrystalDropConfiguration instance;

        public static Material Material => instance.material;

        public static CrystalElement Element => instance.element;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            instance = this;

            material = new Material(material);

            material.SetColor("_Primary", primaryColor);
            material.SetColor("_Secondary", secondaryColor);
        }
    }
}