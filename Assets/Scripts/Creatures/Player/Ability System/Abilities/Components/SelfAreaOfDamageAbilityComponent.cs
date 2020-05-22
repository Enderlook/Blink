using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Self Area Of Damage Ability", menuName = "Game/Ability System/Components/Self Area Of Damage")]
    public class SelfAreaOfDamageAbilityComponent : AreaOfDamageAbilityComponent
    {
        private Transform player;

        public override void Initialize(AbilitiesManager manager)
            => player = manager.transform;

        public override void Execute() => InstantiatePrefab(player.position, player.rotation);
    }
}