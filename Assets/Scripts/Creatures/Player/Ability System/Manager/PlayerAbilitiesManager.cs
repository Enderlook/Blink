using Game.Scene.CLI;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [RequireComponent(typeof(Animator)), AddComponentMenu("Game/Ability System/Managers/Player Abilites Manager")]
    public class PlayerAbilitiesManager : AbilitiesManager
    {
        private ControlledAbilitiesPack abilities;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (abilities == null)
            {
                Debug.LogWarning($"{nameof(abilities)} was null. We will try on next frame.");
                return;
            }

            for (int i = 0; i < abilities.Count; i++)
            {
                (Ability ability, Control control) = abilities[i];
                ability.Charge(Time.deltaTime);
                if (!Console.IsConsoleEnabled && ability.IsReady && control.HasUserRequestTrigger())
                    ability.Execute();
                UIManager.UpdateAbility(i);
            }
        }

        public void SetAbilities(ControlledAbilitiesPack abilities)
        {
            base.SetAbilities(abilities);
            this.abilities = abilities;
            foreach (Ability ability in (AbilitiesPack)abilities)
                ability.ChargeToMaximum();
        }
    }
}
