using UnityEngine.UI;

namespace UnityEditor.UI {
    [CustomEditor(typeof(CustomButton), true)]
    [CanEditMultipleObjects]
    public class CustomButtonEditor : ButtonEditor {
        SerializedProperty m_OnDown;
        SerializedProperty m_OnUp;
        SerializedProperty m_CustomClick;

        protected override void OnEnable() {
            base.OnEnable();
            m_OnDown = serializedObject.FindProperty("m_OnPointDown");
            m_OnUp = serializedObject.FindProperty("m_OnPointUp");
            m_CustomClick = serializedObject.FindProperty("m_OnCustomClick");
        }

        public override void OnInspectorGUI() {
            base.OnInspectorGUI();
            EditorGUILayout.Space();

            serializedObject.Update();
            EditorGUILayout.PropertyField(m_OnDown);
            EditorGUILayout.PropertyField(m_OnUp);
            EditorGUILayout.PropertyField(m_CustomClick);
            serializedObject.ApplyModifiedProperties();
        }
    }
}

