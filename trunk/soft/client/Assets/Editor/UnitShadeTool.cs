using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System;

public class UnitShadeTool 
{
    [MenuItem("Tools/关闭unit阴影")]
    static void Execute() {
        string unit_dir_path = Application.dataPath + "/" + "res/unit";
        string[] unit_dirs = Directory.GetDirectories(unit_dir_path);
        for (int i = 0; i < unit_dirs.Length; i++) {
            string unit_name = unit_dirs[i].Replace("\\", "/").Replace(Application.dataPath + "/" + "res/unit/", "");
            string prefab_path = "Assets/res/unit/" + unit_name + "/" + unit_name + ".prefab";
            GameObject unit_prefab = AssetDatabase.LoadAssetAtPath<GameObject>(prefab_path);
            if (unit_prefab != null) {
                SkinnedMeshRenderer[] renders = unit_prefab.transform.GetComponentsInChildren<SkinnedMeshRenderer>();
                for (int j = 0; j < renders.Length; j++) {
                    if (renders[j].receiveShadows) {
                        Debug.LogError(unit_name + " "+ renders[j].gameObject.name+"-----------receiveShadows---------已修改");
                        renders[j].receiveShadows = false;
                        EditorUtility.SetDirty(unit_prefab);
                    }
                    if (renders[j].shadowCastingMode != UnityEngine.Rendering.ShadowCastingMode.On) {
                        Debug.LogError(unit_name + " " + renders[j].gameObject.name + "------------shadowCastingMode---------已修改");
                        renders[j].shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                        EditorUtility.SetDirty(unit_prefab);
                    }
                }
            }
        }
        AssetDatabase.SaveAssets();
        Debug.Log("完成");
    }
}
