using UnityEngine;

namespace Game.Pickups.Orbs
{
    public abstract class Orb : Pickup
    {
        protected int value = 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start() => AutoSize();

        private void AutoSize() => transform.localScale *= Mathf.Pow(value + 4, .25f) - .5f;

        public void SetValue(int value)
        {
            this.value = value;
            AutoSize();
        }
    }
}