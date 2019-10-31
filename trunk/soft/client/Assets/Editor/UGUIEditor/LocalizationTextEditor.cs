using UnityEditor.UI;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(LocalizationText), true)]
[CanEditMultipleObjects]
public class LocalizationTextEditor : GraphicEditor
{
	SerializedProperty m_Text;
	SerializedProperty m_LocalizationKey;
	SerializedProperty m_FontData;
	SerializedProperty m_KeyString;
    SerializedProperty m_ClientLanguage;
    SerializedProperty m_Underline;
    LocalizationText targetComp;

	protected override void OnEnable()
	{
		base.OnEnable();
		m_Text = serializedObject.FindProperty("m_Text");
		m_FontData = serializedObject.FindProperty("m_FontData");
		m_KeyString = serializedObject.FindProperty("m_KeyString");
        m_ClientLanguage = serializedObject.FindProperty("m_ClientLanguage");
        m_Underline = serializedObject.FindProperty("m_Underline");
        targetComp = target as LocalizationText;
	}

	public override void OnInspectorGUI()
	{
		serializedObject.Update();
        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(m_Underline);
        EditorGUILayout.PropertyField(m_ClientLanguage);
        EditorGUILayout.PropertyField(m_KeyString);
        if (EditorGUI.EndChangeCheck())
        {
            serializedObject.ApplyModifiedProperties();
            serializedObject.Update();
        }

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.PropertyField(m_Text);
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.PropertyField(m_FontData);
        AppearanceControlsGUI();
		RaycastControlsGUI();
		serializedObject.ApplyModifiedProperties();
	}
}
