using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Crystal
{
    public class CrystalAnimatorEvent : MonoBehaviour
    {
        [SerializeField]
        private Animator animator;

        public void Teleportation()
        {
            animator.SetBool("Teleportation", false);
            Menu.Instance.Win();
        }
    
    }
}
