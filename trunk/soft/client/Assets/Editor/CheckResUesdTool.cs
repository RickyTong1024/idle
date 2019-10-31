using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CheckResUesdTool : EditorWindow {
    [MenuItem("Tools/CheckResUesdTool")]
    static void ReplaceBtn() {
        CheckResUesdTool window = (CheckResUesdTool)EditorWindow.GetWindow(typeof(CheckResUesdTool), false, "替换按钮组件", true);
        window.Show();
    }

    private void OnGUI() {
        EditorGUILayout.BeginVertical();
        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查全部", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "all");
        }
        //if (GUILayout.Button("Mark", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "CheckMark", "all");
        //}
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "all");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查config", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "config");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "config");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查effect", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "effect");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "effect");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查map", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "map");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "map");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查map_config", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "map_config");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "map_config");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查music", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "music");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "music");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查scene", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "scene");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "scene");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查scene_objs", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "scene_objs");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "scene_objs");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查sound", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "sound");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "sound");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查story", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "story");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "story");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查ui", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "ui");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "ui");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查unit", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "unit");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "unit");
        //}
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("检查unit_config", GUILayout.Width(100))) {
            Util.CallLuaFunction<string>("resMgr", "ResLog", "unit_config");
        }
        //if (GUILayout.Button("Diff", GUILayout.Width(100))) {
        //    Util.CallLuaFunction<string>("resMgr", "Diff", "unit_config");
        //}
        EditorGUILayout.EndHorizontal();
        GUILayout.Label("--------------------------");
        GUILayout.Space(5);
        if (GUILayout.Button("销毁所有界面", GUILayout.Width(100))) {
            Util.CallLuaFunction("GUIRoot", "Finish");
        }
    

        EditorGUILayout.EndVertical();
    }

}
