using Enderlook.Unity.Atoms;

using UnityEngine;

namespace Game.Creatures
{
    [AddComponentMenu("Game/Destroy When Die")]
    public class DestroyWhenDie : MonoBehaviour
    {
        [SerializeField, Tooltip("When value reach 0 the Game Object is destroyed.")]
        private IntEventReference healthEvent;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => healthEvent.Register(CheckIfDeath);

        private void CheckIfDeath(int health)
        {
            if (health == 0)
                Destroy(gameObject);
        }
    }
}