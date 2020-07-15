using Enderlook.Unity.Atoms;
using Enderlook.Unity.Prefabs.FloatingText;
using Enderlook.Unity.Prefabs.HealthBarGUI;

using UnityEngine;

namespace Game.Creatures
{
    [RequireComponent(typeof(FloatingTextController)), AddComponentMenu("Game/Creatures")]
    public class HealthFeedback : MonoBehaviour, IStunnable
    {
        private static readonly Color orange = ((Color.red + Color.yellow) / 2) + new Color(0, 0, 0, .5f);

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

        private float stunUntil;

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
                floatingTextController.SpawnFloatingText(difference, stunUntil >= Time.time ? orange : Color.red);
            if (difference < 0)
                floatingTextController.SpawnFloatingText(-difference, Color.green);
        }

        private void OnMaxHealthChange(int newValue) => healthBar.MaxHealth = newValue;

        public void Stun(float duration) => stunUntil = Time.time + duration;
    }
}