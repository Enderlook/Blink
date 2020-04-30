using Enderlook.Unity.Attributes;

using System.Linq;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Abilites Manager")]
    [RequireComponent(typeof(Animator))]
    public class AbilitiesManager : MonoBehaviour
    {
        private Ability[] abilities;

        [SerializeField, IsProperty, Tooltip("Where ablities which requires a shooting point does shoot.")]
        public Transform ShootingPosition;

        public Animator Animator { get; private set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => Animator = GetComponent<Animator>();

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (abilities == null)
            {
                Debug.LogWarning("Abilities was null. We will try on next frame.");
                return;
            }

            foreach (Ability ability in abilities)
            {
                ability.UpdateBehaviour(Time.deltaTime);
                ability.TryExecute();
            }
        }

        public void ActiveSkill(string key) => abilities.First(e => e.Key == key).TriggerFromAnimator();

        public void InstantReload()
        {
            foreach (Ability ability in abilities)
                ability.UpdateBehaviour(100);
        }

        public void SetAbilities(Ability[] abilities)
        {
            this.abilities = abilities;
            foreach (Ability ability in abilities)
                ability.Initialize(this);

            FindObjectOfType<AbilityUIManager>().SetAbilities(abilities);
        }
    }
}
