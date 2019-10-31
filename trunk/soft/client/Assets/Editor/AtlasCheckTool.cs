using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using UnityEngine.UI;
using UnityEngine.U2D;

public class AtlasCheckTool : EditorWindow {
    /// <summary>
    /// 查找引用
    /// </summary>
    [MenuItem("Tools/AtlasCheckTool")]
    static void SearchRefrence() {
        AtlasCheckTool window = (AtlasCheckTool)EditorWindow.GetWindow(typeof(AtlasCheckTool), false, "界面预设图集引用", true);
        window.Show();
    }

    private static GameObject panel_prefab;
    private void OnGUI() {
        EditorGUILayout.BeginHorizontal();
        panel_prefab = (GameObject)EditorGUILayout.ObjectField(panel_prefab, typeof(GameObject), true, GUILayout.Width(200));
        if (GUILayout.Button("检查", GUILayout.Width(100))) {
            Check(panel_prefab);
        }
        EditorGUILayout.EndHorizontal();
        if (GUILayout.Button("检查所有", GUILayout.Width(100))) {
            string[] floders = new string[] { "Assets/res/ui/panels" };
            string[] guids = AssetDatabase.FindAssets("t:Prefab", floders);
            int length = guids.Length;
            for (int i = 0; i < length; i++) {
                string filePath = AssetDatabase.GUIDToAssetPath(guids[i]);
                GameObject panel_prefab = AssetDatabase.LoadAssetAtPath<GameObject>(filePath);
                Check(panel_prefab);
            }
        }
      
    }

    void Check(GameObject panel_prefab) {
        string path = AssetDatabase.GetAssetPath(panel_prefab);
        path = path.Replace("\\", "/").Replace(".prefab", ".spriteatlas");
        SpriteAtlas atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(path);
        SpriteAtlas common_atlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>("Assets/res/ui/common/common.spriteatlas");
        Image[] allImages = panel_prefab.GetComponentsInChildren<Image>(true);
        List<bool> results = new List<bool>();
        for (int i = 0; i < allImages.Length; i++) {
            Image image = allImages[i];
            Sprite sp = image.sprite;
            if (sp == null) {
                continue;
            }
            bool in_atlas = false;
            if (atlas != null) {
                in_atlas = atlas.CanBindTo(sp);
            }
            bool in_commonn = false;
            if (common_atlas != null) {
                in_commonn = common_atlas.CanBindTo(sp);
            }
            if (in_atlas && in_commonn) {
                Debug.LogError(image.name + " sprite:" + sp.name + "存在common 和 " + atlas.name + "中");
            }
            if (!in_atlas && !in_commonn) {
                Debug.LogError(image.name + " sprite:" + sp.name + "属于外来图集");
            }
            bool result = false;
            if ((in_atlas && !in_commonn) || (!in_atlas && in_commonn)) {
                result = true;
            }
            results.Add(result);
        }
        bool result_fin = true;
        foreach (var item in results) {
            if (!item) {
                result_fin = false;
                Debug.LogError(panel_prefab.name + "图片图集不正确");
                Debug.LogError("------------------------------------------------------");
                break;
            }
        }
        if (result_fin) {
            Debug.Log(panel_prefab.name + "图片图集正确");
            Debug.Log("------------------------------------------------------");
        }
        
    }

}