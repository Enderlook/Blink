using Game.Creatures;
using Game.Scene;

using System.Collections;

using UnityEngine;

namespace Game.Attacks
{
    [RequireComponent(typeof(Collider)), AddComponentMenu("Game/Attacks/Heal Player And Crystal")]
    public class HealPlayerAndCrystal : MonoBehaviour
    {
        public static void AddComponentTo(GameObject source, float timeToHeal, int playerHealing, int crystalHealing)
        {
            HealPlayerAndCrystal component = source.AddComponent<HealPlayerAndCrystal>();

            component.StartCoroutine(Work());

            IEnumerator Work()
            {
                yield return new WaitForSeconds(timeToHeal);
                CrystalAndPlayerTracker.CrystalHurtable.TakeHealing(crystalHealing);
                CrystalAndPlayerTracker.Player.GetComponent<Hurtable>().TakeHealing(playerHealing);
                Destroy(component);
            }
        }
    }
}
