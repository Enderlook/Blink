using Game.Pickups;

using System;
using System.Collections;

using UnityEngine;

namespace Game.Creatures.Player.AbilitySystem
{
    [CreateAssetMenu(fileName = "Recover All Spawners Ability", menuName = "Game/Ability System/Components/Recover All Spawners")]
    public class RecoverAllSpawnersComponent : AbilityComponent
    {
        [SerializeField, Tooltip("Time in seconds to execute ability.")]
        private float timeToExecute = 1;

        private MonoBehaviour caller;

        public override void Initialize(AbilitiesManager manager)
            => caller = manager;

        public override void Execute()
        {
            caller.StartCoroutine(Work());

            IEnumerator Work()
            {
                yield return new WaitForSeconds(timeToExecute);

                SpawnRecover[] spawnRecovers = FindObjectsOfType<SpawnRecover>();
                for (int i = 0; i < spawnRecovers.Length; i++)
                    spawnRecovers[i].Regenerate();
            }
        }
    }
}