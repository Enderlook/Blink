using UnityEngine;
using UnityEngine.UI;

namespace Game.Creatures.Player.AbilitySystem
{
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

        public void SetLoadPercentage(float percentage)
        {
            float value = 1 - percentage;
            fade.fillAmount = value;
            frame.color = value == 0 ? fullColor : Color.white;
        }
    }
}