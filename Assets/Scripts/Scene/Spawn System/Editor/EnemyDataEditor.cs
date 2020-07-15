using Enderlook.Unity.Utils.UnityEditor;

using System;
using System.Collections.Generic;
using System.Reflection;

using UnityEditor;

using UnityEngine;

namespace Game.Scene
{
    [CustomEditor(typeof(EnemyData))]
    public class EnemyDataEditor : Editor
    {
        private readonly static GUIContent STEP_CONTENT = new GUIContent("Step", "Determined the difficulty step of each row in the following table.");
        private readonly static MethodInfo getValueEnemyData = typeof(EnemyData).GetMethod("GetValueEditorOnly", BindingFlags.NonPublic | BindingFlags.Instance);

        private float step = 1;

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginChangeCheck();
            this.DrawScriptField();

            EditorGUILayout.PropertyField(serializedObject.FindProperty("enemyPrefab"), true);

            SerializedProperty difficultyThresholdProperty = serializedObject.FindProperty("difficultyThreshold");
            EditorGUILayout.PropertyField(difficultyThresholdProperty, true);

            SerializedProperty difficultyCapProperty = serializedObject.FindProperty("difficultyCap");
            EditorGUILayout.PropertyField(difficultyCapProperty, true);

            SerializedProperty weightProperty = serializedObject.FindProperty("weight");
            EditorGUILayout.PropertyField(weightProperty, true);

            SerializedProperty healthProperty = serializedObject.FindProperty("health");
            EditorGUILayout.PropertyField(healthProperty, true);

            DrawTable(
                ref step,
                difficultyThresholdProperty.floatValue,
                difficultyCapProperty.floatValue,
                new[] { weightProperty, healthProperty },
                (property, difficulty) => (float)getValueEnemyData.Invoke(target, new object[] { property.vector2Value, difficulty })
            );

            if (EditorGUI.EndChangeCheck())
                serializedObject.ApplyModifiedProperties();
        }

        public static void DrawTable(ref float step, float min, float length, IEnumerable<SerializedProperty> rows, Func<SerializedProperty, float, float> predicate)
        {
            step = EditorGUILayout.FloatField(STEP_CONTENT, step);
            if (step <= 0)
                step = .1f;

            EditorGUILayout.BeginHorizontal(GUI.skin.box);
            float limit = min + length;

            EditorGUILayout.BeginVertical(GUI.skin.box);
            GUILayout.Label("Difficulty", EditorStyles.boldLabel);
            for (float i = min; i <= limit; i += step)
                GUILayout.Label((Mathf.Round(i * 100) / 100f).ToString());
            GUILayout.EndVertical();

            foreach (SerializedProperty property in rows)
            {
                EditorGUILayout.BeginVertical(GUI.skin.box);
                GUILayout.Label(property.GetGUIContent(), EditorStyles.boldLabel);
                for (float i = min; i <= limit; i += step)
                    GUILayout.Label((Mathf.Round(predicate(property, i) * 100) / 100f).ToString());
                EditorGUILayout.EndVertical();
            }
            EditorGUILayout.EndHorizontal();
        }
    }
}