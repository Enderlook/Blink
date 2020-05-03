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

        private void Awake()
        {
            if (instance == null)
                instance = this;
            else
                throw new InvalidOperationException($"Only one instance of {nameof(CrystalAndPlayerTracker)} can ever exist.");
        }
    }
}