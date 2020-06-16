using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Crystal
{
    public class CrystalAnimatorEvent : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Animator animator;
#pragma warning restore CS0649

        public void Teleportation()
        {
            animator.SetBool("Teleportation", false);
            Menu.Instance.Win();
        }    
    }
}
