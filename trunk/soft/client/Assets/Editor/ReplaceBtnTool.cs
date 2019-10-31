using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using UnityEditor.SceneManagement;
using System.IO;

public class ReplaceBtnTool : EditorWindow {
    [MenuItem("Tools/ReplaceBtnTool")]
    static void ReplaceBtn() {
        ReplaceBtnTool window = (ReplaceBtnTool)EditorWindow.GetWindow(typeof(ReplaceBtnTool), false, "替换按钮组件", true);
        window.Show();
    }


    private static GameObject panel_prefab;
    private void OnGUI() {
        EditorGUILayout.BeginHorizontal();
        panel_prefab = (GameObject)EditorGUILayout.ObjectField(panel_prefab, typeof(GameObject), true, GUILayout.Width(200));
        if (GUILayout.Button("替换", GUILayout.Width(100))) {
            //var asset_path = AssetDatabase.GetAssetPath(panel_prefab);
           // GameObject editable_prefab = AssetDatabase.LoadAssetAtPath<GameObject>(asset_path);

            Replace(panel_prefab);
           // TestCon.instance.StartCon("Re");
        }
        EditorGUILayout.EndHorizontal();

        if (GUILayout.Button("替换全部", GUILayout.Width(100))) {
            //var asset_path = AssetDatabase.GetAssetPath(panel_prefab);
            // GameObject editable_prefab = AssetDatabase.LoadAssetAtPath<GameObject>(asset_path);
            string panel_path = "Assets/res/ui/panels";
            string[] dirs = Directory.GetDirectories(panel_path);
            for (int i = 0; i < dirs.Length; i++) {
                //string dir = dirs[i].Replace("\\", "/");
                string dir = dirs[i];
                string[] files_1 = Directory.GetFiles(dir, "*.prefab");
                for (int j = 0; j < files_1.Length; j++) {
                    string file = files_1[j].Replace("\\", "/");
                    GameObject editable_prefab = AssetDatabase.LoadAssetAtPath<GameObject>(file);
                    Replace(editable_prefab);
                    Debug.Log("--------------------");
                }
            }

            //Replace(panel_prefab);
            // TestCon.instance.StartCon("Re");
        }
    }

   

    public class rr {
        public GameObject control;
        public Selectable.Transition cur_transition;
        public Image cur_image;
        public SpriteState cur_sp_state;
        public bool can_inter = true;
        public HideFlags cur_flags;
    }


    void Replace(GameObject go) {
        Button[] btns = go.transform.GetComponentsInChildren<Button>(true);
        Debug.Log(btns.Length);
        List<rr> r_list = new List<rr>();
        for (int i = btns.Length - 1; i >= 0; i--) {
            Button btn = btns[i];
            GameObject control = btn.gameObject;
            Debug.Log(btn.gameObject.name);
            rr r = new rr();
            r.control = control;
            r.cur_image = btn.targetGraphic as Image;
            r.can_inter = btn.interactable;
            r.cur_transition = btn.transition;
            if (r.cur_transition == Selectable.Transition.SpriteSwap) {
                r.cur_sp_state = btn.spriteState;
            }
            r.cur_flags = control.hideFlags;
            r_list.Add(r);
            
            Debug.Log(control.hideFlags);
            control.hideFlags = HideFlags.None;
            GameObject.DestroyImmediate(btn, true);



        }
        for (int i = 0; i < r_list.Count; i++) {
            GameObject con = r_list[i].control;

            CustomButton cur_btn = con.AddComponent<CustomButton>();
            cur_btn.interactable = r_list[i].can_inter;
            cur_btn.targetGraphic = r_list[i].cur_image;
            cur_btn.transition = r_list[i].cur_transition;
            if (r_list[i].cur_transition == Selectable.Transition.SpriteSwap) {
                cur_btn.spriteState = r_list[i].cur_sp_state;
            }
            con.hideFlags = r_list[i].cur_flags;
            Debug.Log(con.hideFlags);
        }


        //EditorUtility.SetDirty(go);
        //AssetDatabase.SaveAssets();
        PrefabUtility.SavePrefabAsset(go);
        Debug.Log(go.name+"完成");
    }

}
