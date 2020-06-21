using Enderlook.Extensions.code.Linq;
using Enderlook.Unity.Utils.UnityEditor;

using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

using UnityEditor;

using UnityEngine;

namespace Game.Scene
{
    [CustomEditor(typeof(EnemyLevelData))]
    public class EnemyLevelDataEditor : Editor
    {
        private readonly static GUIContent RANGE_CONTENT = new GUIContent("Range", "Determines the difficulty range showed in the table.");

        private readonly static MethodInfo getValueEnemyLevelData = typeof(EnemyLevelData).GetMethod("GetValue", BindingFlags.NonPublic | BindingFlags.Static);
        private readonly static MethodInfo getValueEnemyLevelDataEditorOnly = typeof(EnemyLevelData).GetMethod("GetValueEditorOnly", BindingFlags.NonPublic | BindingFlags.Static);
        private readonly static MethodInfo getValueEnemyData = typeof(EnemyData).GetMethod("GetValue", BindingFlags.NonPublic | BindingFlags.Instance);
        private readonly static FieldInfo health = typeof(EnemyData).GetField("health", BindingFlags.NonPublic | BindingFlags.Instance);
        private readonly static FieldInfo damage = typeof(EnemyData).GetField("damage", BindingFlags.NonPublic | BindingFlags.Instance);

        private bool show;

        private float step = 1;
        private Vector2 range = new Vector2(1, 10);

        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            if (show = EditorGUILayout.Foldout(show, "Stats", true))
            {
                SerializedProperty maximumEnemies = serializedObject.FindProperty("maximumEnemies");
                SerializedProperty enemiesPerSecond = serializedObject.FindProperty("enemiesPerSecond");
                if (EditorApplication.isPlaying)
                {
                    EditorGUILayout.LabelField("Spawning Stats", EditorStyles.boldLabel);
                    EditorGUILayout.BeginVertical(GUI.skin.box);
                    EditorGUILayout.LabelField("Current Difficulty", GameManager.Difficulty.ToString());

                    EditorGUILayout.LabelField("Maximum Enemies", getValueEnemyLevelData.Invoke(null, new object[] { maximumEnemies.vector4Value }).ToString());

                    EditorGUILayout.LabelField("Enemies/Seconds", getValueEnemyLevelData.Invoke(null, new object[] { enemiesPerSecond.vector4Value }).ToString());
                    EditorGUILayout.EndVertical();

                    SerializedProperty enemiesData = serializedObject.FindProperty("enemiesData");
                    (string name, float weight, float health, float damage)[] items = new (string name, float weight, float health, float damage)[enemiesData.arraySize];
                    for (int i = 0; i < enemiesData.arraySize; i++)
                    {
                        EnemyData enemyData = (EnemyData)enemiesData.GetArrayElementAtIndex(i).GetTargetObjectOfProperty();
                        items[i] = (enemyData.name ?? "", enemyData.GetWeight(), GetHealth(enemyData), GetDamage(enemyData));
                    }

                    float total = items.Sum(e => e.weight);

                    (string name, float weight, float percent, float health, float damage)[] refineds =
                        items.Select(e => (e.name, Round(e.weight), Round(e.weight / total * 100), Round(e.health), Round(e.damage))).ToArray();

                    (int, int, int, int, int) col = refineds.Aggregate(
                        (0, 0, 0, 0, 0),
                        ((int a, int b, int c, int d, int e) cum, (string name, float weight, float percent, float health, float damage) cur) =>
                          (Mathf.Max(cum.a, cur.name.Length),
                          Mathf.Max(cum.b, cur.weight.ToString().Length),
                          Mathf.Max(cum.c, cur.percent.ToString().Length),
                          Mathf.Max(cum.d, cur.health.ToString().Length),
                          Mathf.Max(cum.e, cur.damage.ToString().Length))
                        );

                    StringBuilder sb = new StringBuilder();
                    EditorGUILayout.LabelField("Enemies stats", EditorStyles.boldLabel);

                    EditorGUILayout.BeginHorizontal(GUI.skin.box);

                    IEnumerable<string> GetFields((string, float, float, float, float) e)
                    {
                        yield return e.Item1;
                        yield return e.Item2.ToString();
                        yield return e.Item3.ToString() + "%";
                        yield return e.Item4.ToString();
                        yield return e.Item5.ToString();
                    }

                    foreach (IEnumerable<string> item in refineds
                        .Select(GetFields)
                        .Prepend(new string[] { "Name", "Weigth", "Chance", "Health", "Damage" })
                        .Transpose())
                    {
                        EditorGUILayout.BeginVertical(GUI.skin.box);
                        foreach (string part in item)
                            GUILayout.Label(part);
                        EditorGUILayout.EndVertical();
                    }
                    EditorGUILayout.EndHorizontal();

                    EditorUtility.SetDirty(target);
                }
                else
                {
                    range = EditorGUILayout.Vector2Field(RANGE_CONTENT, range);
                    EnemyDataEditor.DrawTable(
                        ref step,
                        range.x,
                        range.y,
                        new[] { maximumEnemies, enemiesPerSecond },
                        (property, difficulty) => (float)getValueEnemyLevelDataEditorOnly.Invoke(null, new object[] { property.vector4Value, difficulty })
                    );
                }
            }
        }

        private float Round(float value) => Mathf.Round(value * 100) / 100;

        private static float GetHealth(EnemyData enemyData) => (float)getValueEnemyData.Invoke(enemyData, new object[] { health.GetValue(enemyData) });

        private static float GetDamage(EnemyData enemyData) => (float)getValueEnemyData.Invoke(enemyData, new object[] { damage.GetValue(enemyData) });
    }
}