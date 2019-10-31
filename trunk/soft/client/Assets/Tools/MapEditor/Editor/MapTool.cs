using UnityEngine;
using UnityEditor;

public class MapTool : EditorWindow
{
    private string m_name;
    static MapTool m_window;

    [MenuItem("Tools/MapTool")]
    static void Execute()
    {
        if (m_window == null)
            m_window = (MapTool)GetWindow(typeof(MapTool));
        m_window.Show();
    }

    void OnGUI()
    {
        m_name = EditorGUILayout.TextArea(m_name);
        GUILayout.BeginHorizontal();
        bool _ok = GUILayout.Button("新建", GUILayout.Width(120f));
        if (_ok)
        {
            new_map(m_name);
        }
        _ok = GUILayout.Button("读取", GUILayout.Width(120f));
        if (_ok)
        {
            load_map(m_name);
        }
        _ok = GUILayout.Button("保存", GUILayout.Width(120f));
        if (_ok)
        {
            save_map(m_name);
        }
        GUILayout.EndHorizontal();
    }

    void new_map(string name)
    {
        if (MapEditor.instance != null)
        {
            MapEditor.instance.new_map(name);
        }
    }

    void load_map(string name)
    {
        if (MapEditor.instance != null)
        {
            MapEditor.instance.load_map(name);
        }
    }

    void save_map(string name)
    {
        if (MapEditor.instance != null)
        {
            MapEditor.instance.save_map(name);
        }
    }
}
