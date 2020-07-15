using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class AbilityComponent : ScriptableObject
    {
        public virtual void Initialize(AbilitiesManager abilitiesManager) { }

        public abstract void Execute();
    }
}