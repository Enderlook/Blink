using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Self Area Of Damage Ability", menuName = "Game/Abilities/Self Area Of Damage")]
    public class SelfAreaOfDamageAbility : AreaOfDamageAblity
    {
        private Transform player;

        public override void PostInitialize(AbilitiesManager abilitiesManager)
            => player = abilitiesManager.transform;

        public override void Execute() => InstantiatePrefab(player.position);
    }
}