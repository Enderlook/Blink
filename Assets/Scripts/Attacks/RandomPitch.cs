using UnityEngine;

namespace Game.Attacks
{
    [AddComponentMenu("Game/Attacks/Random Pitch")]
    [RequireComponent(typeof(AudioSource))]
    public class RandomPitch : MonoBehaviour
    {
        [SerializeField, Tooltip("Random pitch range.")]
        private Vector2 range = new Vector2(.8f, 1.2f);

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => GetComponent<AudioSource>().pitch = Random.Range(range.x, range.y);
    }
}