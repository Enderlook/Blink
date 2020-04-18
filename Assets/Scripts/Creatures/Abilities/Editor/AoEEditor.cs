using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

using Game.Creatures.AbilitiesSystem;

[CustomEditor(typeof(AreaOfEffect))]
public class AoEEditor : Editor
{
    private AreaOfEffect ability;

    public void OnEnable()
    {
        ability = (AreaOfEffect)target;
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
        {
            EditorGUILayout.PropertyField(serializedObject.FindProperty("abilityIcon"), GUIContent.none, GUILayout.Width(80f), GUILayout.Height(65f));
        }

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Attributes", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("target"), new GUIContent("Activatin Type"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("cooldown"), new GUIContent("Cooldown"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("animationName"), new GUIContent("Animation"));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Input Configuration", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();
        
        EditorGUILayout.PropertyField(serializedObject.FindProperty("keyButton"), new GUIContent("Keyboard Button"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("mouseButton"), new GUIContent("Mouse Button"));

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Setup", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.PropertyField(serializedObject.FindProperty("targetLayer"), new GUIContent("Target Layer"));

        EditorGUILayout.PropertyField(serializedObject.FindProperty("aoePrefab"), new GUIContent("AoE"));

        EditorGUILayout.Space();

        serializedObject.ApplyModifiedProperties();
    }
}
