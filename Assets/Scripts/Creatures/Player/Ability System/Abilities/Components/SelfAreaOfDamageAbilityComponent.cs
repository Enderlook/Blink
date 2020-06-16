using Game.Scene;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Self Area Of Damage Ability", menuName = "Game/Ability System/Components/Self Area Of Damage")]
    public class SelfAreaOfDamageAbilityComponent : AreaOfDamageAbilityComponent
    {
        [SerializeField]
        private bool useCrystal = false;

        private Transform target;

        public override void Initialize(AbilitiesManager manager) => target = useCrystal ? CrystalAndPlayerTracker.Crystal : manager.transform;

        public override void Execute()
        {
            if (useCrystal) 
                InstantiatePrefab(target.position); 
            else 
                InstantiatePrefab(target.position, target.rotation);
        }
    }
}