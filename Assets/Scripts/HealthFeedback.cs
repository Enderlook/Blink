using Enderlook.Unity.Atoms;
using Enderlook.Unity.Prefabs.FloatingText;
using Enderlook.Unity.Prefabs.HealthBarGUI;

using UnityEngine;

namespace Game.Creatures
{
    [RequireComponent(typeof(FloatingTextController))]
    public class HealthFeedback : MonoBehaviour
    {
        [SerializeField]
        private IntGetReference health;

        [SerializeField]
        private IntGetReference maxHealth;

        [SerializeField]
        private IntEventReference2 healthEvent2;

        [SerializeField]
        private HealthBar healthBar;

        private FloatingTextController floatingTextController;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            floatingTextController = GetComponent<FloatingTextController>();
            healthBar.ManualUpdate(health, maxHealth);
            healthEvent2.Register(OnHealthChange);
        }

        private void OnHealthChange(int newValue, int oldValue)
        {
            healthBar.Health = newValue;
            int difference = oldValue - newValue;
            if (difference > 0)
                floatingTextController.SpawnFloatingText(difference, Color.red);
            if (difference < 0)
                floatingTextController.SpawnFloatingText(-difference, Color.green);
        }
    }
}