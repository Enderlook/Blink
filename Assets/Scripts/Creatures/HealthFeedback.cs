using Enderlook.Unity.Atoms;
using Enderlook.Unity.Prefabs.FloatingText;
using Enderlook.Unity.Prefabs.HealthBarGUI;

using UnityEngine;

namespace Game.Creatures
{
    [RequireComponent(typeof(FloatingTextController)), AddComponentMenu("Game/Creatures")]
    public class HealthFeedback : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private IntGetReference health;

        [SerializeField]
        private IntGetReference maxHealth;

        [SerializeField]
        private IntEventReference2 healthEvent2;

        [SerializeField]
        private IntEventReference maxHealthEvent;

        [SerializeField]
        protected HealthBar healthBar;
#pragma warning restore CS0649

        private FloatingTextController floatingTextController;

        protected virtual void Awake()
        {
            floatingTextController = GetComponent<FloatingTextController>();
            healthBar.ManualUpdate(health, maxHealth);
            healthEvent2.Register(OnHealthChange);
            maxHealthEvent.Register(OnMaxHealthChange);
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

        private void OnMaxHealthChange(int newValue) => healthBar.MaxHealth = newValue;
    }
}