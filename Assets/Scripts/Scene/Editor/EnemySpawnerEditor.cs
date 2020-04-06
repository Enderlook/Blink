using Enderlook.Unity.Utils.UnityEditor;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using UnityEditor;

using UnityEngine;

namespace Game.Scene
{
    [CustomEditor(typeof(EnemySpawner))]
    public class EnemySpawnerEditor : Editor
    {
        private const string SPAWN_POINTS_PROPERTY_PATH = "spawnPoints";
        private const string DISTANCE_CHECK_PROPERTY_PATH = "distanceCheck";

        private static readonly GUIContent CLEAR_SPAWN_POINT_CONTENT = new GUIContent("Clear Spawn Points", "Clear the spawn points list.");
        private static readonly GUIContent CLEAR_HELPER_CONTENT = new GUIContent("Clear", "Clear spawn point helper.");
        private static readonly GUIContent FOLDOUT_CONTENT = new GUIContent("Editor", "Open editor only tools.");
        private static readonly GUIContent COLLIDER_CONTENT = new GUIContent("Collider Helper", "Drag a collider to auto setup an rectangle.");
        private static readonly GUIContent SURFACE_CONTENT = new GUIContent("Spawning Area", "Size of area where points will be generated.");
        private static readonly GUIContent CENTER_CONTENT = new GUIContent("Center Point", "Center of the spawning area.");
        private static readonly GUIContent DISTANCE_PER_POINT_CONTENT = new GUIContent("Distance Per Point", "Determine the distance between each spawning point.");
        private static readonly GUIContent FAST_DRAW_CONTENT = new GUIContent("Fast Draw", "If enable, spheres will use half as many discs to be drawn.");
        private static readonly GUIContent STORE_POINTS_CONTENT = new GUIContent("Store Points", "Stores the points in the spawnPoints array.");
        private static readonly GUIContent TOTAL_POINTS_CONTENT = new GUIContent("Points Amount", "Allowed | Failed | Total.");

        private static readonly FieldInfo spawnPointsInfo = typeof(EnemySpawner).GetField("spawnPoints", BindingFlags.NonPublic | BindingFlags.Instance);
        private Vector3[] SpawnPoints {
            get => (Vector3[])spawnPointsInfo.GetValue(target);
            set => spawnPointsInfo.SetValue(target, value);
        }

        private bool isExpanded = false;
        private Vector2 surface;
        private Vector3 center;
        private float distancePerPoint;
        private Vector3[] points;
        private bool fastDraw = false;

        private SerializedProperty spawnPointsProperty;
        private SerializedProperty distanceCheckProperty;

        private void OnEnable()
        {
            ClearHelper();
            spawnPointsProperty = serializedObject.FindProperty(SPAWN_POINTS_PROPERTY_PATH);
            distanceCheckProperty = serializedObject.FindProperty(DISTANCE_CHECK_PROPERTY_PATH);
        }

        private void OnSceneGUI()
        {
            if (!isExpanded)
                return;

            Vector3 newCenter = Handles.PositionHandle(center, Quaternion.identity);

            if (newCenter != center)
            {
                center = newCenter;
                Repaint();
            }

            Handles.color = Color.blue;
            Handles.DrawWireCube(center, new Vector3(surface.x, .1f, surface.y));

            for (int i = 0; i < points.Length; i++)
            {
                float distanceCheck = distanceCheckProperty.floatValue;

                Handles.color = IsAllowed(points[i]) ? Color.green : Color.red;
                Handles.DrawWireDisc(points[i], Vector3.forward, distanceCheck);
                Handles.DrawWireDisc(points[i], Vector3.right, distanceCheck);

                if (fastDraw)
                    continue;
                Handles.DrawWireDisc(points[i], new Vector3(.5f, 0, .5f), distanceCheck);
                Handles.DrawWireDisc(points[i], new Vector3(.5f, 0, -.5f), distanceCheck);
            }
        }

        public override void OnInspectorGUI()
        {
            this.DrawScriptField();

            EditorGUI.BeginChangeCheck();
            SerializedProperty spawnPointsProperty = serializedObject.FindProperty(SPAWN_POINTS_PROPERTY_PATH);

            EditorGUILayout.PropertyField(spawnPointsProperty, true);

            EditorGUILayout.PropertyField(distanceCheckProperty);

            if (isExpanded = EditorGUILayout.Foldout(isExpanded, FOLDOUT_CONTENT, true))
            {
                if (GUILayout.Button(CLEAR_SPAWN_POINT_CONTENT))
                    Clear();

                bool change = false;
                Collider collider = (Collider)EditorGUILayout.ObjectField(COLLIDER_CONTENT, null, typeof(Collider), allowSceneObjects: true);
                if (collider != null)
                {
                    center = collider.bounds.center;
                    surface = new Vector2(collider.bounds.size.x, collider.bounds.size.z);
                    change = true;
                }

                change = HasChanged(ref center, EditorGUILayout.Vector3Field(CENTER_CONTENT, center))
#pragma warning disable RCS1233 // Use short-circuiting operator.
                    | HasChanged(ref surface, EditorGUILayout.Vector2Field(SURFACE_CONTENT, surface))
                    | change;
#pragma warning restore RCS1233 // Use short-circuiting operator.

                if (HasChanged(ref distancePerPoint, EditorGUILayout.FloatField(DISTANCE_PER_POINT_CONTENT, distancePerPoint)) || change)
                    points = GetUniformPoints().ToArray();

                fastDraw = EditorGUILayout.Toggle(FAST_DRAW_CONTENT, fastDraw);

                int allowed = points.Count(IsAllowed);
                int total = points.Length;
                int failed = total - allowed;
                EditorGUILayout.LabelField(TOTAL_POINTS_CONTENT, new GUIContent($"{allowed} | {failed} | {total}", TOTAL_POINTS_CONTENT.tooltip));

                if (GUILayout.Button(STORE_POINTS_CONTENT))
                    Store();
                if (GUILayout.Button(CLEAR_HELPER_CONTENT))
                    ClearHelper();
            }

            if (EditorGUI.EndChangeCheck())
                serializedObject.ApplyModifiedProperties();
        }

        private void ClearHelper()
        {
            surface = Vector2.zero;
            center = Vector3.zero;
            distancePerPoint = 2;
            points = Array.Empty<Vector3>();
        }

        private void Clear()
        {
            SpawnPoints = Array.Empty<Vector3>();
            EditorUtility.SetDirty(target);
            Repaint();
        }

        private void Store()
        {
            EnemySpawner enemySpawner = (EnemySpawner)target;
            SpawnPoints = SpawnPoints.Concat(points.Where(IsAllowed)).ToArray();
            EditorUtility.SetDirty(target);
            ClearHelper();
            Repaint();
        }

        private IEnumerable<Vector3> GetUniformPoints()
        {
            Vector2 halfSurface = surface / 2;
            for (float x = -halfSurface.x; x < halfSurface.x; x += distancePerPoint)
                for (float z = -halfSurface.y; z < halfSurface.y; z += distancePerPoint)
                    yield return new Vector3(x + center.x, center.y, z + center.z);
        }

        private bool IsAllowed(Vector3 point) => Physics.OverlapSphere(point, distanceCheckProperty.floatValue).Length == 0;

        private bool HasChanged<T>(ref T variable, T newValue)
        {
            bool isEqual = variable.Equals(newValue);
            variable = newValue;
            return !isEqual;
        }
    }
}