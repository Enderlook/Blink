using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Self Area Of Damage Ability", menuName = "Game/Ability System/Abilities/Self Area Of Damage")]
    public class SelfAreaOfDamageAbility : AreaOfDamageAblity
    {
        private Transform player;

        public override void PostInitialize(AbilitiesManager manager)
            => player = manager.transform;

        protected override void ExecuteEnd() => InstantiatePrefab(player.position);
    }
}