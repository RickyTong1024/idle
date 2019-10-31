using UnityEngine;
using UnityEditor;

public class UnitTool : EditorWindow
{
    private string m_name;
    private string m_name1;
    private string m_name2;
    static UnitTool m_window;

    [MenuItem("Tools/UnitTool")]
    static void Execute()
    {
        if (m_window == null)
            m_window = (UnitTool)GetWindow(typeof(UnitTool));
        m_window.Show();
    }

    void OnGUI()
    {
        m_name = EditorGUILayout.TextArea(m_name);
        bool _ok = GUILayout.Button("武器", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("weapon", m_name);
        }
        _ok = GUILayout.Button("头盔", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("helmet", m_name);
        }
        _ok = GUILayout.Button("身体", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("body", m_name);
        }
		_ok = GUILayout.Button("手套", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("glove", m_name);
        }
		_ok = GUILayout.Button("肩膀", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("shoulder", m_name);
        }
		_ok = GUILayout.Button("鞋子", GUILayout.Width(120f));
        if (_ok)
        {
            ChangePart("shoes", m_name);
        }
   
    }

    void ChangePart(string part, string name)
    {
        if (UnitEditor.instance != null)
        {
            UnitEditor.instance.ChangePart(part, name);
        }
    }
}
