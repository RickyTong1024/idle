using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;


public class CheckPackagerTool {
    static AssetBundleManifest manifest;

    [MenuItem("BuildResource/ClearAssetBundles", false, 107)]
    public static void Clear() {
        AssetBundle.UnloadAllAssetBundles(true);
    }

    [MenuItem("BuildResource/CheckPackager", false, 106)]
    public static void Check() {
        TempPackager();
        CheckPanel();
        CheckUnit();
        CheckEffect();
        CheckFinsh();
        Debug.Log("检查完成!");
    }

    static void CheckFinsh() {
        AssetBundle.UnloadAllAssetBundles(true);
    }

    static void TempPackager() {
        bool isExists = false;
        string zipFile = Application.streamingAssetsPath + "/" + "res.zip";
        string verFile = Application.streamingAssetsPath + "/" + "ver.txt";
        if (File.Exists(verFile) && !File.Exists(zipFile)) {
            isExists = true;
        }
        if (!isExists) {
            Packager.BuildAssetResource(BuildTarget.StandaloneWindows, false);
        }
        string uri = Application.streamingAssetsPath + "/" + platform_config_common.AssetDir;
        if (!File.Exists(uri)) return;
        AssetBundle assetbundle = AssetBundle.LoadFromFile(uri);
        manifest = assetbundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
    }

    static void CheckPanel() {
        string panel_path = Application.streamingAssetsPath + "/" + "res/ui/panels";
        string[] files = Directory.GetFiles(panel_path);
        List<string> bundles = new List<string>();
        for (int i = 0; i < files.Length; i++) {
            string file = files[i];
            if (Path.GetExtension(file).Equals(".unity3d")) {
                bundles.Add(file);
            }
        }
        for (int i = 0; i < bundles.Count; i++) {
            string bunle = bundles[i].Replace('\\', '/');
            // AssetBundle assetBundle = AssetBundle.LoadFromFile(bunle);
            // AssetBundleManifest manifest = assetBundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
            string ab_name = bunle.Replace(Application.streamingAssetsPath + "/", string.Empty);
            string[] dependencies = manifest.GetAllDependencies(ab_name);
            if (dependencies.Length != 1) {
                Debug.LogError(ab_name + "   panel只应该有唯一依赖");
            }
            foreach (var item in dependencies) {
                if (item != "res/ui/common/common.unity3d") {
                    Debug.LogError(ab_name + "   panel依赖错误");
                }
            }
            // assetBundle.Unload(true);
        }
    }

    static void CheckUnit() {
        string unit_path = Application.streamingAssetsPath + "/" + "res/unit";
        string[] files = Directory.GetFiles(unit_path);
        List<string> bundles = new List<string>();
        for (int i = 0; i < files.Length; i++) {
            string file = files[i];
            if (Path.GetExtension(file).Equals(".unity3d")) {
                bundles.Add(file);
            }
        }
        for (int i = 0; i < bundles.Count; i++) {
            string bunle = bundles[i].Replace('\\', '/');
            string ab_name = bunle.Replace(Application.streamingAssetsPath + "/", string.Empty);
            string[] dependencies = manifest.GetAllDependencies(ab_name);
            if (dependencies.Length > 0) {
                Debug.LogError(ab_name + "   unit 应不存在依赖 , 依赖有误！！！");
            }
        }
    }

    static void CheckEffect() {
        string effect_path = Application.streamingAssetsPath + "/" + "res/effect";
        string[] files = Directory.GetFiles(effect_path);
        List<string> bundles = new List<string>();
        for (int i = 0; i < files.Length; i++) {
            string file = files[i];
            if (Path.GetExtension(file).Equals(".unity3d")) {
                bundles.Add(file);
            }
        }
        for (int i = 0; i < bundles.Count; i++) {
            string bunle = bundles[i].Replace('\\', '/');
            string ab_name = bunle.Replace(Application.streamingAssetsPath + "/", string.Empty);
            string[] dependencies = manifest.GetAllDependencies(ab_name);
            if (dependencies.Length > 0) {
                Debug.LogError(ab_name + "   effect 应不存在依赖 , 依赖有误！！！");
            }
        }
    }
}
