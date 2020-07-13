using UnityEngine;
using UnityEngine.UI;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI"), RequireComponent(typeof(Toggle))]
    public class AbilityUI : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Image ablityImage;

        [SerializeField]
        private Image fade;

        [SerializeField]
        private Image frame;

        [SerializeField]
        private Color fullColor = Color.green;
#pragma warning restore CS0649

        private Toggle _toggle;
        private Toggle Toggle {
            get {
                // Fixes weird racing condition
                if (_toggle == null)
                    _toggle = GetComponent<Toggle>();
                return _toggle;
            }
        }

        private AbilityUIManager abilityUIManager;

        public bool IsOn => Toggle.isOn;

        public void Initialize(AbilityUIManager abilityUIManager) => this.abilityUIManager = abilityUIManager;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
#if UNITY_ANDROID
            Toggle.group = GetComponentInParent<ToggleGroup>();
#if UNITY_EDITOR && !IGNORE_UNITY_REMOTE
            if (!UnityEditor.EditorApplication.isRemoteConnected)
            {
                Toggle.SetIsOnWithoutNotify(false);
                Toggle.targetGraphic.color = Toggle.colors.normalColor;
                Toggle.enabled = false;
            }
#endif
#else
            Toggle.targetGraphic.color = _toggle.colors.normalColor;
            Toggle.enabled = false;
#endif
        }

        public void SetSprite(Sprite sprite) => ablityImage.sprite = sprite;

        public void SetLoadPercentage(Ability ability)
        {
            float value = 1 - ability.Percent;
            fade.fillAmount = value;

            if (value == 0)
            {
                bool work;
                if (ability is TriggerableAbility triggerableAbility)
                    work = !triggerableAbility.IsRunning;
                else
                    work = true;

                if (work)
                {
                    frame.color = fullColor;
#if UNITY_ANDROID
                    Toggle.interactable = true;
#endif
                    return;
                }
                frame.color = Color.white;
#if UNITY_ANDROID
                Toggle.interactable = false;
#endif
            }
        }

#if UNITY_ANDROID
        public void ManualToggle(bool isOn)
        {
            Toggle.SetIsOnWithoutNotify(isOn);
            Toggle.targetGraphic.color = isOn ? Toggle.colors.selectedColor : Toggle.colors.normalColor;
        }
#endif

        public void ToggleAbility(bool isOn)
        {
#if UNITY_ANDROID
            // Fixes odd bug that happens in Main Menu scene
            if (abilityUIManager == null)
                return;
            abilityUIManager.ToggleAbility(this);
#endif
        }
    }
}