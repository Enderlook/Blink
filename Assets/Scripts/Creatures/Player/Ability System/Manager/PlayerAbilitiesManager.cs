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

#if UNITY_ANDROID
            bool hasAbilityBeenCasted = false;
#endif

            for (int i = 0; i < abilities.Count; i++)
            {
                (Ability ability, Control control) = abilities[i];
                if (ability.UseTimer)
                {
                    ability.Charge(Time.deltaTime);
                    UIManager.UpdateAbility(i);
                }

                if (!Console.IsConsoleEnabled
                    && ability.IsReady
#if UNITY_ANDROID
#if UNITY_EDITOR
                    && (UnityEditor.EditorApplication.isRemoteConnected
                        ? UIManager.CanUseAbility(i) && (ability.IsSelf || Input.touchCount > 0)
                        : control.HasUserRequestTrigger())
#else
                    && !UIManager.MustCancelRequest()
                    && Input.touchCount > 0
#endif
#else
                    && control.HasUserRequestTrigger()
#endif
                )
                {
                    ability.Execute();
                    UIManager.UpdateAbility(i);
#if UNITY_ANDROID
#if UNITY_EDITOR
                    if (UnityEditor.EditorApplication.isRemoteConnected)
#endif
                        hasAbilityBeenCasted = true;
#endif
                    break;
                }
#if UNITY_ANDROID
            }
            if (hasAbilityBeenCasted
#if UNITY_EDITOR
                    && UnityEditor.EditorApplication.isRemoteConnected
#endif
            )
                UIManager.ToggleAbility(0);
#endif
        }

        public void SetAbilities(ControlledAbilitiesPack abilities)
        {
            base.SetAbilities(abilities);
            this.abilities = abilities;
            foreach (Ability ability in (AbilitiesPack)abilities)
            {
                if (ability.UseTimer)
                    ability.ChargeToMaximum();
            }
        }

        public void ChargeManualAbilities(float amount)
        {
            for (int i = 0; i < abilities.Count; i++)
            {
                Ability ability = ((AbilitiesPack)abilities)[i];
                if (ability.UseTimer)
                    continue;
                ability.Charge(amount);
                UIManager.UpdateAbility(i);
            }
        }
    }
}
