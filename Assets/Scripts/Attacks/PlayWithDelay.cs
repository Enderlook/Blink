using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(AudioSource)), AddComponentMenu("Game/Others/Play With Delay")]
    public class PlayWithDelay : MonoBehaviour
    {
        [SerializeField, Tooltip("Time in seconds before start playing.")]
        private float countDown = 1;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]

        private void Update()
        {
            if (countDown > 0)
            {
                countDown -= Time.deltaTime;
                if (countDown <= 0)
                {
                    GetComponent<AudioSource>().Play();
                    Destroy(this);
                }
            }
        }
    }
}