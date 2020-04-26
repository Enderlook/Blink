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

        public void SetSprite(Sprite sprite) => ablityImage.sprite = sprite;

        public void SetLoadPercentage(float percentage) => fade.fillAmount = 1 - percentage;
    }
}