using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Creatures.Player
{
    [AddComponentMenu("Game/Creatures/Player/Heal On Level Was Loaded"), RequireComponent(typeof(Hurtable))]
    public class HealOnLevelWasLoaded : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Range(0, 1), Tooltip("Percentage of restored health when level changes.")]
        private float healthPercent;
#pragma warning restore CS0649

        private Hurtable hurtable;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            hurtable = GetComponent<Hurtable>();
            SceneManager.sceneLoaded += Heal;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]    
        private void OnDestroy() => SceneManager.sceneLoaded -= Heal;

        private void Heal(UnityEngine.SceneManagement.Scene arg0, LoadSceneMode arg1)
            => hurtable.TakeHealing((int)(hurtable.MaxHealth * healthPercent));
    }
}