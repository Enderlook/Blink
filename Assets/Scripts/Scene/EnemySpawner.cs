using Enderlook.Unity.Attributes;

using UnityEngine;

namespace Game.Scene
{
    public class EnemySpawner : MonoBehaviour
    {
        [SerializeField, Tooltip("Points where enemies can spawn"), DrawVectorRelativeToTransform]
        private Vector3[] spawnPoints; // Keep name in sync with EnemySpawnerEditor

        [SerializeField, Tooltip("Determine the radius checked for collision on each point.")]
        private float distanceCheck = 1;
    }
}