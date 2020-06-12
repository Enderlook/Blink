using System.Linq;

using UnityEngine;

namespace Game.Pickups
{
    [AddComponentMenu("Game/Pickups/Spawn Recover")]
    public class SpawnRecover : MonoBehaviour
    {
        [SerializeField, Range(0, 1), Tooltip("Amount of childs recover when regenerated.")]
        private float regenerationRate = 1;

        public void Regenerate()
        {
            foreach (Transform child in transform.Cast<Transform>())
            {
                if (Random.value < regenerationRate)
                    child.gameObject.SetActive(true);
            }
        }
    }
}