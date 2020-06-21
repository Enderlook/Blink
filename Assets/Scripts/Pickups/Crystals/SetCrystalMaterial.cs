using UnityEngine;

namespace Game.Pickups.Crystals
{
    [AddComponentMenu("Game/Pickups/Crystals/Set Crystal Material"), RequireComponent(typeof(MeshRenderer))]
    public class SetCrystalMaterial : MonoBehaviour
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            GetComponent<MeshRenderer>().material = CrystalDropConfiguration.Material;
            GetComponent<Light>().color = CrystalDropConfiguration.LightColor;
            Destroy(this);
        }
    }
}