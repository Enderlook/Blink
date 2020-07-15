using UnityEngine;

namespace Game.Scene
{
    public class Tutorial : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Animator animator;

        [SerializeField]
        private string[] parametersAnimation;
#pragma warning restore CS0649

        public void NextAnimation() => animator.SetTrigger(parametersAnimation[0]);

        public void CloseAnimation() => animator.SetBool(parametersAnimation[1], true);
    }
}
