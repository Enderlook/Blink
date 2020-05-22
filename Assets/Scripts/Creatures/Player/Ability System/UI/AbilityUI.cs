using UnityEngine;
using UnityEngine.UI;

namespace Game.Creatures.Player.AbilitySystem
{
    [AddComponentMenu("Game/Ability System/UI/Ability UI")]
    public class AbilityUI : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Image ablityImage;

        [SerializeField]
        private Image fade;

        [SerializeField]
        private Image frame;
#pragma warning restore CS0649

        [SerializeField]
        private Color fullColor = Color.green;

        public void SetSprite(Sprite sprite) => ablityImage.sprite = sprite;

        public void SetLoadPercentage(Ability ability)
        {
            float value = 1 - ability.Percent;
            fade.fillAmount = value;

            if (value == 0)
            {
                if (ability is TriggerableAbility triggerableAbility && !triggerableAbility.IsRunning)
                {
                    frame.color = fullColor;
                    return;
                }
                frame.color = Color.white;
            }
        }
    }
}