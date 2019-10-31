using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEditor.Build.Reporting;

public class Packager {
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();
    static BuildTarget cur_target = BuildTarget.NoTarget;


    [MenuItem("BuildResource/Build iPhone Resource", false, 100)]
    public static void BuildiPhoneResource() {
        BuildTarget target;
#if UNITY_5
        target = BuildTarget.iOS;
#else
        target = BuildTarget.iOS;
#endif
        cur_target = BuildTarget.iOS;
        BuildAssetResource(target);
    }

    [MenuItem("BuildResource/Build Android Resource", false, 101)]
    public static void BuildAndroidResource() {
        cur_target = BuildTarget.Android;
        BuildAssetResource(BuildTarget.Android);
    }

    [MenuItem("BuildResource/Build Windows Resource", false, 102)]
    public static void BuildWindowsResource() {
        cur_target = BuildTarget.StandaloneWindows;
        BuildAssetResource(BuildTarget.StandaloneWindows);
    }

    [MenuItem("BuildResource/清除数据目录", false, 103)]
    public static void ClearDataDir() {
        string dir = "c:/" + "death" + "/";
        if (Directory.Exists(dir)) {
            Directory.Delete(dir, true);
        }
        UnityEngine.Debug.Log("数据目录清除完成");
    }

    [MenuItem("BuildResource/查看关联", false, 104)]
    public static void GetDependent()
    {
        GameObject[] gos = Selection.gameObjects;
        if (gos.Length == 0)
            return;

        GameObject go = gos[0];
        string[] ss = AssetDatabase.GetDependencies(AssetDatabase.GetAssetPath(go), false);
        for (int i = 0; i < ss.Length; ++i)
        {
            UnityEngine.Debug.Log(ss[i]);
        }
    }

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target , bool is_zip = true) {
        if (Directory.Exists(Util.DataPath)) {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath)) {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh();

        maps.Clear();

        HandleLuaBundle();  //先处理lua包
        HandleUIBundle();   //处理UI包
        BuildConfifBundle(); //处理配置包
        HandleEffectBundle(); //处理effect包
        HandleUIEffectBundle(); //处理ui_effect包
        HandleUnitBundle(); //处理角色包
        HandleUnitConfigBundle();//处理角色行为配置包
        HandleMusicBundle(); //处理音乐包
        HandleUISoundBundle(); //处理界面音效包
        HandleMapBundle();  //处理地图包
        HandleMapConfigBundle(); //处理地图配置包
        HandleSceneBackBundeld(); // 处理战斗场景背景包
        HandleStoryBackBundeld(); // 处理剧情背景包
        HandleSceneObjsBundle(); //处理场景节点包

        string resPath = "Assets/" + platform_config_common.AssetDir;
        BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), BuildAssetBundleOptions.UncompressedAssetBundle, target);
        BuildFileIndex();
        string luaTempDir = Application.dataPath + "/" + platform_config_common.LuaTempDir;
        if (Directory.Exists(luaTempDir)) Directory.Delete(luaTempDir, true);
        string sceneTempDir = AppDataPath + "/TempScene";
        if (Directory.Exists(sceneTempDir)) Directory.Delete(sceneTempDir, true);
        if (is_zip) {
            BuildZip(); 
        }
        BuildVerFile();
        AssetDatabase.Refresh();
    }

    //打包一个文件夹下的资源成一个包
    static void AddBuildMap(string bundleName, string pattern, string path) {
        string[] files = Directory.GetFiles(path, pattern);
        List<string> fin_files = new List<string>();
        for (int i = 0; i < files.Length; i++) {
            string ext = Path.GetExtension(files[i]);
            if (ext.Equals(".meta")) {
                continue;
            }
            fin_files.Add(files[i]);
        }
        if (fin_files.Count == 0) return;
        for (int i = 0; i < fin_files.Count; i++) {
            fin_files[i] = fin_files[i].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName.ToLower();
        build.assetNames = fin_files.ToArray();
        maps.Add(build);
    }

    static void AddBuildMap(string bundleName, string[] patterns, string path) {
        List<string> flie_list = new List<string>();
        for (int i = 0; i < patterns.Length; i++) {
            string[] files_1 = Directory.GetFiles(path, patterns[i]);
            for (int j = 0; j < files_1.Length; j++) {
                flie_list.Add(files_1[j]);
            }
        }
        string[] files = flie_list.ToArray();
        List<string> fin_files = new List<string>();
        for (int i = 0; i < files.Length; i++) {
            string ext = Path.GetExtension(files[i]);
            if (ext.Equals(".meta")) {
                continue;
            }
            fin_files.Add(files[i]);
        }
        if (fin_files.Count == 0) return;
        for (int i = 0; i < fin_files.Count; i++) {
            fin_files[i] = fin_files[i].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName.ToLower();
        build.assetNames = fin_files.ToArray();
        maps.Add(build);
    }

    //打包一个文件夹下（包括子文件夹下）的资源为一个包
    static void AddBuildsMap(string bundleName, string pattern, string path) {
        string[] files = Directory.GetFiles(path, pattern, SearchOption.AllDirectories);
        List<string> fin_files = new List<string>();
        for (int j = 0; j < files.Length; j++) {
            string ext = Path.GetExtension(files[j]);
            if (ext.Equals(".meta")) {
                continue;
            }
            fin_files.Add(files[j]);
        }
        if (fin_files.Count <= 0) {
            return;
        }
        for (int k = 0; k < fin_files.Count; k++) {
            fin_files[k] = fin_files[k].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName.ToLower();
        build.assetNames = fin_files.ToArray();
        maps.Add(build);
    }

    //把一个文件夹下的每个资源打一个包
    static void AddMap(string ab_name_pre, string pattern, string path) {
        string[] files = Directory.GetFiles(path, pattern);
        List<string> fin_files = new List<string>();
        for (int j = 0; j < files.Length; j++) {
            string ext = Path.GetExtension(files[j]);
            if (ext.Equals(".meta")) {
                continue;
            }
            fin_files.Add(files[j]);
        }
        if (fin_files.Count <= 0) {
            return;
        }
        for (int k = 0; k < fin_files.Count; k++) {
            fin_files[k] = fin_files[k].Replace('\\', '/');
        }
        for (int i = 0; i < fin_files.Count; i++) {
            string fin_file = fin_files[i];
            string name_ = fin_file.Replace("Assets/"+ab_name_pre, string.Empty);
            string ext = Path.GetExtension(fin_file);
            string name = name_.Replace(ext, platform_config_common.ExtName);
            string ab_name = ab_name_pre + name;
            AssetBundleBuild build = new AssetBundleBuild();
            build.assetBundleName = ab_name.ToLower();
            build.assetNames = new string[] { fin_file };
            maps.Add(build);
        }
    }


    /// <summary>
    /// 处理Lua代码包
    /// </summary>
    static void HandleLuaBundle(bool is_bytemode = true) {
        UnityEngine.Debug.Log("HandleLuaBundle");
        string streamDir = Application.dataPath + "/" + platform_config_common.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);

        string[] srcDirs = { CustomSettings.luaDir, CustomSettings.FrameworkPath + "/ToLua/Lua" };
        for (int i = 0; i < srcDirs.Length; i++) {
            if (is_bytemode) {
                string sourceDir = srcDirs[i];
                string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
                int len = sourceDir.Length;

                if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\') {
                    --len;
                }
                for (int j = 0; j < files.Length; j++) {
                    string str = files[j].Remove(0, len);
                    string dest = streamDir + str + ".bytes";
                    string dir = Path.GetDirectoryName(dest);
                    Directory.CreateDirectory(dir);
                    EncodeLuaFile(files[j], dest);
                }
            }
            else {
                ToLuaMenu.CopyLuaBytesFiles(srcDirs[i], streamDir);
            }
        }
        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++) {
            string name = dirs[i].Replace(streamDir, string.Empty);
            name = name.Replace('\\', '_').Replace('/', '_');
            name = "lua/lua_" + name.ToLower() + platform_config_common.ExtName;

            string path = "Assets" + dirs[i].Replace(Application.dataPath, "");
            AddBuildMap(name, "*.bytes", path);
        }
        AddBuildMap("lua/lua" + platform_config_common.ExtName, "*.bytes", "assets/" + platform_config_common.LuaTempDir);

        //-------------------------------处理非Lua文件----------------------------------
        string luaPath = AppDataPath + "/StreamingAssets/lua/";
        for (int i = 0; i < srcDirs.Length; i++) {
            paths.Clear(); files.Clear();
            string luaDataPath = srcDirs[i].ToLower();
            Recursive(luaDataPath);
            foreach (string f in files) {
                if (f.EndsWith(".meta") || f.EndsWith(".lua")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string path = Path.GetDirectoryName(luaPath + newfile);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                string destfile = path + "/" + Path.GetFileName(f);
                File.Copy(f, destfile, true);
            }
        }
        AssetDatabase.Refresh();
        UnityEngine.Debug.Log("HandleLuaBundle is over");
    }

    static void HandleUIBundle() {
        UnityEngine.Debug.Log("HandleUIBundle");

        //先处理公共资源
        AddBuildMap("res/ui/common" + platform_config_common.ExtName, "*.*", "Assets/res/ui/common");
        //处理icon图集
        AddMap("res/ui/atlas/", "*.spriteatlas", "Assets/res/ui/atlas");
        //处理panel
        string panel_path = "Assets/res/ui/panels";
        string[] dirs = Directory.GetDirectories(panel_path);
        for (int i = 0; i < dirs.Length; i++) {
            string dir = dirs[i];
            AddBuildMap("res/ui/panels/" + dir.Replace('\\', '/').Replace(panel_path + "/", string.Empty) + platform_config_common.ExtName, new string [] { "*.prefab", "*.spriteatlas" }, dir);
        }

        UnityEngine.Debug.Log("HandleUIBundle is over");
    }

    static void BuildConfifBundle() {
        UnityEngine.Debug.Log("BuildConfBundle");

        AddBuildMap("res/config" + platform_config_common.ExtName, "*.txt", "Assets/res/config");

        UnityEngine.Debug.Log("BuildConfBundle is over");
    }

    static void HandleEffectBundle() {
        UnityEngine.Debug.Log("HandleEffectBundle");

        AddMap("res/effect/", "*.prefab", "Assets/res/effect");

        UnityEngine.Debug.Log("HandleEffectBundle is over");
    }

    static void HandleUIEffectBundle() {
        UnityEngine.Debug.Log("HandleUIEffectBundle");

        AddMap("res/effect/ui_effect/", "*.prefab", "Assets/res/effect/ui_effect");

        UnityEngine.Debug.Log("HandleUIEffectBundle is over");
    }


    static void HandleUnitBundle() {
        UnityEngine.Debug.Log("HandleUnitBundle");

        string unit_path = "Assets/res/unit";
        string[] dirs = Directory.GetDirectories(unit_path);
        for (int i = 0; i < dirs.Length; i++) {
            string dir = dirs[i];
            string ab_name = "res/unit/" + dir.Replace('\\', '/').Replace(unit_path + "/", "") + platform_config_common.ExtName;
            AddBuildMap(ab_name, "*.prefab", dir);
        }

        UnityEngine.Debug.Log("HandleUnitBundle is over");
    }

    static void HandleUnitConfigBundle() {
        UnityEngine.Debug.Log("HandleUnitConfigBundle");

        AddBuildMap("res/unit_config" + platform_config_common.ExtName, "*.xml", "Assets/res/unit_config");

        UnityEngine.Debug.Log("HandleUnitConfigBundle is over");
    }

   
    static void HandleMusicBundle() {
        UnityEngine.Debug.Log("BuildMusicBundle");

        AddMap("res/music/", "*.mp3", "Assets/res/music");
        AddMap("res/music/", "*.mav", "Assets/res/music");

        UnityEngine.Debug.Log("BuildMusicBundle is over");
    }

    static void HandleUISoundBundle() {
        UnityEngine.Debug.Log("HandleUISoundBundle");
    
        AddMap("res/sound/", "*.mp3", "Assets/res/sound");
        AddMap("res/sound/", "*.mav", "Assets/res/sound");

        UnityEngine.Debug.Log("HandleUISoundBundle is over");
    }

    static void HandleMapBundle() {
        UnityEngine.Debug.Log("HandleMapBundle");

        AddMap("res/map/", "*.jpg", "Assets/res/map");       

        UnityEngine.Debug.Log("HandleMapBundle is over");
    }

    static void HandleMapConfigBundle() {
        UnityEngine.Debug.Log("HandleMapBundle");

        AddBuildMap("res/map_config" + platform_config_common.ExtName, "*.txt", "Assets/res/map_config");

        UnityEngine.Debug.Log("HandleMapBundle is over");
    }


    static void HandleSceneBackBundeld() {
        UnityEngine.Debug.Log("HandleSceneBackBundeld");

        AddMap("res/scene/", "*.jpg", "Assets/res/scene");

        UnityEngine.Debug.Log("HandleSceneBackBundeld is over"); 
    }

    static void HandleStoryBackBundeld() {
        UnityEngine.Debug.Log("HandleStoryBackBundeld");

        AddMap("res/story/", "*.jpg", "Assets/res/story");

        UnityEngine.Debug.Log("HandleStoryBackBundeld is over");
    }

    static void HandleSceneObjsBundle() {
        UnityEngine.Debug.Log("HandleSceneObjsBundle");

        AddMap("res/scene_objs/", "*.prefab", "Assets/res/scene_objs");

        UnityEngine.Debug.Log("HandleSceneObjsBundle is over");
    }

    static void BuildSceneBundle(BuildTarget target) {
        UnityEngine.Debug.Log("BuildSceneBundle");

        string assetPath = AppDataPath + "/TempScene/";
        string assetfile = string.Empty;
        string assetdir = string.Empty;
        if (Directory.Exists(assetPath)) {
            Directory.Delete(assetPath, true);
        }
        Directory.CreateDirectory(assetPath);

        foreach (UnityEditor.EditorBuildSettingsScene s in UnityEditor.EditorBuildSettings.scenes) {
            if (s.path.Contains("start")) {
                continue;
            }
            string[] names = s.path.Split('/');
            string bundlename = names[names.Length - 1].Replace(".unity", platform_config_common.ExtName).ToLower();
            assetfile = assetPath + bundlename;
            string[] levels = { s.path };
            BuildReport report = BuildPipeline.BuildPlayer(levels, assetfile, target, BuildOptions.BuildAdditionalStreamedScenes);
            BuildSummary summary = report.summary;

            if (summary.result == BuildResult.Succeeded) {
                UnityEngine.Debug.Log("Build succeeded: " + summary.totalSize + " bytes");
            }

            if (summary.result == BuildResult.Failed) {
                UnityEngine.Debug.Log("Build failed");
            }
            AssetDatabase.Refresh();
        }

        UnityEngine.Debug.Log("BuildSceneBundle is over");
    }

    static void CopySceneBundle(BuildTarget target) {
        UnityEngine.Debug.Log("CopySceneBundle");

        string assetPath = AppDataPath + "/TempScene/";
        string copy_path = AppDataPath + "/StreamingAssets/res/scene/";
        if (!Directory.Exists(assetPath)) {
            BuildSceneBundle(target);
        }
        if (!Directory.Exists(copy_path)) {
            Directory.CreateDirectory(copy_path);
        }
        string[] filenames = Directory.GetFiles(assetPath);
        foreach (string filename in filenames) {
            string[] names = filename.Split('/');
            if (File.Exists(copy_path + names[names.Length - 1])) {
                File.Delete(copy_path + names[names.Length - 1]);
            }
            File.Copy(filename, copy_path + names[names.Length - 1]);
        }

        UnityEngine.Debug.Log("CopySceneBundle is over");
    }


    static void BuildFileIndex() {
        UnityEngine.Debug.Log("BuildFileIndex");

        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        paths.Clear(); files.Clear();
        Recursive(resPath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++) {
            string file = files[i];
            string ext = Path.GetExtension(file);
            if (file.EndsWith(".meta") || file.Contains(".DS_Store")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            long length = File.ReadAllBytes(file).Length;
            sw.WriteLine(value + "|" + md5 + "|" + (float)length / 1024);
        }
        sw.Close(); fs.Close();

        UnityEngine.Debug.Log("BuildFileIndex is over");
    }

    static void BuildZip() {
        UnityEngine.Debug.Log("BuildZip");

        zipUtil.CompressDirProgress cdp = CompressDirProgress;
        zipUtil.CompressDirFinish cdf = CompressDirFinish;
        zipUtil.CompressDir("Assets/StreamingAssets", "Assets/res.zip", cdp, cdf);
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath)) {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        File.Copy("Assets/res.zip", "Assets/StreamingAssets/res.zip");
        File.Delete("Assets/res.zip");

        UnityEngine.Debug.Log("BuildZip is over");
    }

    static void CompressDirProgress(string name, float progress) {
        EditorUtility.DisplayProgressBar("压缩", name, progress);
    }

    static void CompressDirFinish() {
        EditorUtility.ClearProgressBar();
    }

    static void BuildVerFile() {
        UnityEngine.Debug.Log("BuildVerFile");

        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/ver.txt";
        if (File.Exists(newFilePath)) {
            File.Delete(newFilePath);
        }
        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        sw.WriteLine(platform_config_common.ResVersion);
        sw.Close(); fs.Close();

        UnityEngine.Debug.Log("BuildVerFile is over");
        UnityEngine.Debug.Log("-----------------BuildResource Is Over-----------------");
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path) {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names) {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs) {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }

    static void UpdateProgress(int progress, int progressMax, string desc) {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    public static void EncodeLuaFile(string srcFile, string outFile) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true;
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            if (cur_target == BuildTarget.StandaloneWindows) {
                isWin = true;
                luaexe = "luajit.exe";
                args = "-b -g " + srcFile + " " + outFile;
                exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";                
            }
            else if(cur_target == BuildTarget.Android) {
                isWin = true;
                luaexe = "luajit.exe";
                args = "-b -g " + srcFile + " " + outFile;
                exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit_android/";
            }
        }
        else if (Application.platform == RuntimePlatform.OSXEditor) {
            isWin = false;
            luaexe = "./luajit";
            args = "-b -g " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit_mac/";
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.UseShellExecute = isWin;
        info.ErrorDialog = true;
        UnityEngine.Debug.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }
}