using UnityEngine;
using UnityEditor;

using Game.Creatures.AbilitiesSystem;

[CustomEditor(typeof(Projectile))]
public class ProjectileEditor : Editor
{
    private Projectile ability;

    public void OnEnable()
    {
        ability = (Projectile)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Name", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.PropertyField(serializedObject.FindProperty("abilityName"), GUIContent.none);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Description", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.PropertyField(serializedObject.FindProperty("description"), GUIContent.none, GUILayout.MaxHeight(65f));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Icon", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("iconType"), new GUIContent("Icon Type"));

        if (ability.IconType != Ability.IconTypes.None)
            ability.AbilityIcon = (Sprite)EditorGUILayout.ObjectField(ability.AbilityIcon, typeof(Sprite), false, GUILayout.Width(65f), GUILayout.Height(65f));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Attributes", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();


        EditorGUILayout.PropertyField(serializedObject.FindProperty("cooldown"), new GUIContent("Cooldown"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("damage"), new GUIContent("Damage"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("animationName"), new GUIContent("Animation"));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Input Configuration", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("keyButton"), new GUIContent("Keyboard Button"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("mouseButton"), new GUIContent("Mouse Button"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("canBeHoldDown"), new GUIContent("Can Be Hold"));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Setup", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("projectile"), new GUIContent("Projectile"));

        EditorGUILayout.Space();

        serializedObject.ApplyModifiedProperties();

    }
}
