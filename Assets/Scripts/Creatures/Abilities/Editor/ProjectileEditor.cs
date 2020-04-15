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
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Name", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        ability.AbilityName = EditorGUILayout.TextField(ability.AbilityName);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Description", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        ability.Description = EditorGUILayout.TextArea(ability.Description, EditorStyles.textField, GUILayout.MaxHeight(65f));
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Attributes", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        ability.IconType = (Ability.IconTypes)EditorGUILayout.EnumPopup("Icon Type", ability.IconType);

        if (ability.IconType != Ability.IconTypes.None)
            ability.AbilityIcon = (Sprite)EditorGUILayout.ObjectField(ability.AbilityIcon, typeof(Sprite), false, GUILayout.Width(65f), GUILayout.Height(65f));

        ability.Cooldown = EditorGUILayout.FloatField("Cooldown", ability.Cooldown);

        ability.Damage = EditorGUILayout.FloatField("Damage", ability.Damage);

        ability.AnimationName = EditorGUILayout.TextField("Animation", ability.AnimationName);

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Input Configuration", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        ability.KeyButton = (KeyCode)EditorGUILayout.EnumPopup("Keyboard Button", ability.KeyButton);

        ability.ThisMouseButton = (Ability.MouseButton)EditorGUILayout.EnumPopup("Mouse Button", ability.ThisMouseButton);

        ability.CanBeHoldDown = EditorGUILayout.Toggle("Can Be Hold Down", ability.CanBeHoldDown);

        EditorGUILayout.Space();

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("Setup", EditorStyles.boldLabel);
        EditorGUILayout.EndHorizontal();

        ability.Prefab = (GameObject)EditorGUILayout.ObjectField("Projectile", ability.Prefab, typeof(GameObject), false);

        ability.ShotSFX = (AudioClip)EditorGUILayout.ObjectField("Shot SFX", ability.ShotSFX, typeof(AudioClip), false);

        ability.HitSFX = (AudioClip)EditorGUILayout.ObjectField("Hit SFX", ability.HitSFX, typeof(AudioClip), false);
        
        //ability.ShotPosition = (Transform)EditorGUILayout.ObjectField("Shot Position", ability.ShotPosition, typeof(Transform), false);

        GUILayout.Space(65f);

        EditorGUILayout.BeginHorizontal();

        if (GUILayout.Button("Save"))
            EditorUtility.SetDirty(ability);

        EditorGUILayout.EndHorizontal();

    }
}
