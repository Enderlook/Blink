using UnityEngine;
using UnityEngine.UI;

namespace Game.Creatures.Player.AbilitySystem
{
    public class AbilityUI : MonoBehaviour
    {
        [SerializeField]
        private Image ablityImage;

        [SerializeField]
        private Image fade;

        [SerializeField]
        private Image frame;

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