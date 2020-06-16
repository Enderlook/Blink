using Game.Scene;

using System;

using UnityEngine;

using Console = Game.Scene.CLI.Console;

namespace Game.Creatures.Player.AbilitySystem
{
    [RequireComponent(typeof(Animator)), AddComponentMenu("Game/Ability System/Managers/Player Abilites Manager")]
    public class PlayerAbilitiesManager : AbilitiesManager
    {
        [NonSerialized]
        private ControlledAbilitiesPack abilities;

#if UNITY_EDITOR
        [SerializeField]
        private Joystick joystick;
#endif

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (GameManager.HasWon)
                return;

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
                    &&
#if UNITY_ANDROID
#if UNITY_EDITOR && !IGNORE_UNITY_REMOTE
                    (UnityEditor.EditorApplication.isRemoteConnected ?
#endif
                        UIManager.CanUseAbility(i)
                        && (ability.IsSelf || Input.touchCount > (joystick.IsDragging ? 1 : 0))
#if UNITY_EDITOR && !IGNORE_UNITY_REMOTE
                        : control.HasUserRequestTrigger())
#else
#endif
#else
                    control.HasUserRequestTrigger()
#endif
                )
                {
                    ability.Execute();
                    UIManager.UpdateAbility(i);
#if UNITY_ANDROID
#if UNITY_EDITOR && !IGNORE_UNITY_REMOTE
                    if (UnityEditor.EditorApplication.isRemoteConnected)
#endif
                        hasAbilityBeenCasted = true;
#endif
                    break;
                }
            }
#if UNITY_ANDROID
            if (hasAbilityBeenCasted
#if UNITY_EDITOR && !IGNORE_UNITY_REMOTE
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
