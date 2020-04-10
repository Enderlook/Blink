using Enderlook.Unity.Utils.UnityEditor;

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

using UnityEditor;

using UnityEngine;

namespace Game.Scene
{
    [CustomPropertyDrawer(typeof(SpawnPointsManager))]
    public class SpawnPointsManagerDrawer : PropertyDrawer
    {
        // Values in miliseconds
        private const int MAXIMUM_PHYSICS_TIME = 5;
        private const int MAXIMUM_RENDERING_TIME = 10;

        private const string pointsPath = "points";
        private const string distanceCheckPath = "distanceCheck";
        private const string DISTANCE_PER_POINT_CANNOT_BE_ZERO = "Distance Per Point can not be zero";

        private static readonly GUIContent EDITOR_FOLDOUT_CONTENT = new GUIContent("Generator", "Open editor only generation tools.");
        private static readonly GUIContent CLEAR_SPAWN_POINT_CONTENT = new GUIContent("Clear Points", "Clear the points list.");
        private static readonly GUIContent COLLIDER_CONTENT = new GUIContent("Collider Helper", "Drag a collider to auto setup an rectangle.");
        private static readonly GUIContent CENTER_CONTENT = new GUIContent("Center Point", "Center of the spawning area.");
        private static readonly GUIContent SURFACE_CONTENT = new GUIContent("Spawning Area", "Size of area where points will be generated.");
        private static readonly GUIContent DISTANCE_PER_POINT_CONTENT = new GUIContent("Distance Per Point", "Determine the distance between each spawning point.");
        private static readonly GUIContent FAST_DRAW_CONTENT = new GUIContent("Fast Draw", "If enable, spheres will use half as many discs to be drawn.");
        private static readonly GUIContent TOTAL_POINTS_CONTENT = new GUIContent("Points Amount", "Allowed | Failed | Total.");
        private static readonly GUIContent STORE_POINTS_CONTENT = new GUIContent("Store Points", "Stores the points in the spawnPoints array.");
        private static readonly GUIContent CLEAR_HELPER_CONTENT = new GUIContent("Clear", "Clear spawn point helper.");

        private static readonly FieldInfo pointsFieldInfo = typeof(SpawnPointsManager).GetField("points", BindingFlags.NonPublic | BindingFlags.Instance);

        private static List<WeakReference<SpawnPointsManagerDrawer>> drawers = new List<WeakReference<SpawnPointsManagerDrawer>>();
        private static IEnumerator validatorProcessor;

        private bool isExpanded;
        private bool isEditorExpanded;
        private bool fastDraw;

        private SpawnPointsManager spawnPointsManager;
        private SerializedProperty pointsProperty;
        private SerializedProperty distanceCheckProperty;

        private Vector3 center = Vector3.zero;
        private Vector2 surface = Vector2.zero;
        private float distancePerPoint = 1;
        private float distanceCheck;

        private Vector3[] points = Array.Empty<Vector3>();
        private bool[] allowedPoints = Array.Empty<bool>();

        private IEnumerator validator;

        private Vector3[] Points {
            get => (Vector3[])pointsFieldInfo.GetValue(spawnPointsManager);
            set => pointsFieldInfo.SetValue(spawnPointsManager, value);
        }

        static SpawnPointsManagerDrawer()
        {
            validatorProcessor = ProcessValidators();
            // This is executed when scene is draw
            SceneView.duringSceneGui += UpdateSceneGUIs;
            // This is executed as many times as possible
            EditorApplication.update += ProcessValidatorChunk;
        }

        private static void ProcessValidatorChunk() => validatorProcessor.MoveNext();

        private static IEnumerator ProcessValidators()
        {
            while (true)
            {
                for (int i = drawers.Count - 1; i >= 0; i--)
                {
                    WeakReference<SpawnPointsManagerDrawer> drawer = drawers[i];
                    if (drawer.TryGetTarget(out SpawnPointsManagerDrawer target))
                    {
                        target.ValdiateChunk();
                        yield return true;
                    }
                    else
                        drawers.RemoveAt(i);
                }
            }
        }

        private static void UpdateSceneGUIs(SceneView sceneView)
        {
            for (int i = drawers.Count - 1; i >= 0; i--)
                if (drawers[i].TryGetTarget(out SpawnPointsManagerDrawer drawer))
                    try
                    {
                        drawer.OnSceneGUI();
                    }
                    catch (Exception) { } // Catch when drawer has been disposed but it wasn't garbage collected yet.
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            if (spawnPointsManager is null)
            {
                drawers.Add(new WeakReference<SpawnPointsManagerDrawer>(this));
                spawnPointsManager = (SpawnPointsManager)property.GetTargetObjectOfProperty();
                pointsProperty = property.FindPropertyRelative(pointsPath);
                distanceCheckProperty = property.FindPropertyRelative(distanceCheckPath);
                validator = ValidatePoints().GetEnumerator();
            }

            EditorGUI.BeginProperty(position, label, property);
            EditorGUI.BeginChangeCheck();

            if (isExpanded = EditorGUILayout.Foldout(isExpanded, label, true))
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(pointsProperty, true);
                EditorGUILayout.PropertyField(distanceCheckProperty);
                distanceCheck = distanceCheckProperty.floatValue;

                if (isEditorExpanded = EditorGUILayout.Foldout(isEditorExpanded, EDITOR_FOLDOUT_CONTENT, true))
                {
                    EditorGUI.indentLevel++;

                    if (GUILayout.Button(CLEAR_SPAWN_POINT_CONTENT))
                        ClearPoints();

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
                    {
                        if (distancePerPoint > 0)
                            GenerateUniformPoints();
                        else
                            EditorGUILayout.HelpBox(DISTANCE_PER_POINT_CANNOT_BE_ZERO, MessageType.Error);
                    }

                    fastDraw = EditorGUILayout.Toggle(FAST_DRAW_CONTENT, fastDraw);

                    int allowed = points.Count(IsAllowed);
                    int total = points.Length;
                    int failed = total - allowed;
                    EditorGUILayout.LabelField(TOTAL_POINTS_CONTENT, new GUIContent($"{allowed} | {failed} | {total}", TOTAL_POINTS_CONTENT.tooltip));

                    if (GUILayout.Button(STORE_POINTS_CONTENT))
                        StorePoints();

                    if (GUILayout.Button(CLEAR_HELPER_CONTENT))
                        ClearDrawer();

                    EditorGUI.indentLevel--;
                }
                EditorGUI.indentLevel--;
            }

            if (EditorGUI.EndChangeCheck())
                property.serializedObject.ApplyModifiedProperties();
            EditorGUI.EndProperty();
        }

        private void ClearPoints() => Points = Array.Empty<Vector3>();

        private void StorePoints()
        {
            ClearPoints();
            Points = points;
        }

        private void ClearDrawer()
        {
            points = Array.Empty<Vector3>();
            surface = Vector2.zero;
            center = Vector3.zero;
            distancePerPoint = 1;
        }

        private bool HasChanged<T>(ref T variable, T newValue)
        {
            bool isEqual = variable.Equals(newValue);
            variable = newValue;
            return !isEqual;
        }

        private void GenerateUniformPoints()
        {
            List<Vector3> list = new List<Vector3>();
            Vector2 halfSurface = surface / 2;
            for (float x = -halfSurface.x; x < halfSurface.x; x += distancePerPoint)
                for (float z = -halfSurface.y; z < halfSurface.y; z += distancePerPoint)
                    list.Add(new Vector3(x + center.x, center.y, z + center.z));

            points = list.ToArray();
            allowedPoints = new bool[points.Length];
        }

        private IEnumerable ValidatePoints()
        {
            while (true)
            {
                int time = DateTime.Now.Millisecond;
                int length = points.Length;
                for (int i = 0; i < length; i++)
                {
                    allowedPoints[i] = IsAllowed(points[i]);
                    // We don't check all the time because it's expensive.
                    if (i % 10 == 0 && DateTime.Now.Millisecond - time >= MAXIMUM_PHYSICS_TIME)
                    {
                        yield return true;
                        time = DateTime.Now.Millisecond;
                    }
                }
                yield return false;
            }
        }

        private bool IsAllowed(Vector3 point) => !Physics.CheckSphere(point, distanceCheck);

        private void ValdiateChunk() => validator.MoveNext();

        private void OnSceneGUI()
        {
            if (!isExpanded)
                return;

            Vector3 newCenter = Handles.PositionHandle(center, Quaternion.identity);

            if (newCenter != center)
                center = newCenter;

            Handles.color = Color.blue;
            Handles.DrawWireCube(center, new Vector3(surface.x, .1f, surface.y));

            // Draw points

            int timePerRender = DateTime.Now.Millisecond;

            int pointsLength = points.Length;

            for (int i = 0; i < pointsLength; i++)
            {
                float distanceCheck = distanceCheckProperty.floatValue;

                Vector3 point = points[i];

                Handles.color = allowedPoints[i] ? Color.green : Color.red;
                Handles.DrawWireDisc(point, Vector3.forward, distanceCheck);
                Handles.DrawWireDisc(point, Vector3.right, distanceCheck);

                if (fastDraw)
                    continue;

                Handles.DrawWireDisc(point, new Vector3(.5f, 0, .5f), distanceCheck);
                Handles.DrawWireDisc(point, new Vector3(.5f, 0, -.5f), distanceCheck);
            }

            if (pointsLength > 0)
            {
                timePerRender = DateTime.Now.Millisecond - timePerRender;
                if (timePerRender > MAXIMUM_RENDERING_TIME && !fastDraw)
                    fastDraw = true;
            }
        }
    }
}