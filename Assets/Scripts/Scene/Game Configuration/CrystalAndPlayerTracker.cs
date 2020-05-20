using Game.Creatures;

using System;

using UnityEngine;

namespace Game.Scene
{
    public class CrystalAndPlayerTracker : MonoBehaviour
    {
        private static CrystalAndPlayerTracker instance;

#pragma warning disable CS0649
        [SerializeField]
        private Transform crystal;

        [SerializeField]
        private Transform player;
#pragma warning restore CS0649

        public static Vector3 CrystalPosition => instance.crystal.position;

        public static Vector3 PlayerPosition => instance.player.position;

        public static Transform Crystal => instance.crystal;

        public static Transform Player => instance.player;

        public static Hurtable CrystalHurtable => instance.crystalHurtable;

        private Hurtable crystalHurtable;

        private void Awake()
        {
            if (instance != null)
                throw new InvalidOperationException($"Only a single instance of {nameof(CrystalAndPlayerTracker)} can exist at the same time.");
            instance = this;
            crystalHurtable = crystal.GetComponent<Hurtable>();
        }
    }
}