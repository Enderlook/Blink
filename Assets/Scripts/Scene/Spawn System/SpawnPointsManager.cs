﻿using Enderlook.Extensions;

using System;

using UnityEngine;

namespace Game.Scene
{
    [Serializable]
    public class SpawnPointsManager
    {
        // Keep name fields in sync with EnemySpawnerEditor
#pragma warning disable CS0649
        [SerializeField, Tooltip("Points where enemies can spawn.")]
        private Vector3[] points;

        [SerializeField, Tooltip("Determine the radius checked for collision on each point.")]
        private float distanceCheck = 1;
#pragma warning restore CS0649

        private const float ADDITIONAL_CHECK = 0.1f;

        /// <summary>
        /// Produce a random spawn point that is not being seen by <paramref name="camera"/>.
        /// </summary>
        /// <param name="camera"><see cref="Camera"/> to check if the point is visible to.</param>
        /// <returns>A random point invisible to <paramref name="camera"/>.</returns>
        public Vector3 GetSpawnPoint(Camera camera)
        {
            if (points.Length == 0)
                throw new InvalidOperationException($"{nameof(points)} must not be empty.");

            while (true)
            {
                Vector3 point = points.RandomPick();

                const float negativeCheck = 0 - ADDITIONAL_CHECK;
                const float positiveCheck = 1 + ADDITIONAL_CHECK;

                Vector3 viewPosition = camera.WorldToViewportPoint(point);
                if (viewPosition.x < negativeCheck || viewPosition.x > positiveCheck
                    || viewPosition.y < negativeCheck || viewPosition.y > positiveCheck
                    || viewPosition.z <= 0)
                {
                    // Additional check to be sure
                    Vector3 point2 = new Vector3(point.x, 0, point.z);
                    viewPosition = camera.WorldToViewportPoint(point2);
                    if ((viewPosition.x < negativeCheck || viewPosition.x > positiveCheck
                        || viewPosition.y < negativeCheck || viewPosition.y > positiveCheck
                        || viewPosition.z <= 0)
                        && !Physics.CheckSphere(point, distanceCheck))
                        return point;
                }
            }
        }
    }
}