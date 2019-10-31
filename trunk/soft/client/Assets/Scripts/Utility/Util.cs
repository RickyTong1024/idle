using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using UnityEngine.SceneManagement;
using zlib;
using System.Xml.Linq;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class Util {
    public static byte[] Compress(byte[] inputBytes) {
        using (MemoryStream ms = new MemoryStream()) {
            using (ZOutputStream zOut = new ZOutputStream(ms, zlib.zlibConst.Z_DEFAULT_COMPRESSION)) {
                zOut.Write(inputBytes, 0, inputBytes.Length);
                zOut.finish();
                return ms.ToArray();
            }
        }
    }

    public static byte[] Decompress(byte[] inputBytes) {
        using (MemoryStream ms = new MemoryStream()) {
            using (ZOutputStream zOut = new ZOutputStream(ms)) {
                zOut.Write(inputBytes, 0, inputBytes.Length);
                zOut.finish();
                return ms.ToArray();
            }
        }
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(GameObject go, string subnode) {
        return Child(go.transform, subnode);
    }

    public static void SetRoot(Transform t, Transform p) {
        t.SetParent(p);
        t.localScale = Vector3.one;
        t.localPosition = Vector3.zero;
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(Transform go, string subnode) {
        Transform tran = go.Find(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }


    public static Transform FindSub(Transform trans, string goName) {
        Transform child = trans.Find(goName);
        if (child != null)
            return child;

        Transform go = null;
        for (int i = 0; i < trans.childCount; i++) {
            child = trans.GetChild(i);
            go = FindSub(child, goName);
            if (go != null)
                return go;
        }
        return null;
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(GameObject go, string subnode) {
        return Peer(go.transform, subnode);
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(Transform go, string subnode) {
        Transform tran = go.parent.Find(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }

    public static Transform GetParentComponent<T>(Transform tr, bool isSelf = false) {
        if (isSelf) {
            if (tr.GetComponent<T>() != null) {
                return tr;
            }
        }
        Transform parent = tr.parent;
        if (parent == null) {
            return null;
        }
        if (parent.GetComponent<T>() != null) {
            return parent;
        }
        return GetParentComponent<T>(parent);
    }

    public static Transform GetParentComponent_ex(string type, Transform tr, bool isSelf = false) {
        if (isSelf) {
            if (tr.GetComponent(type) != null) {
                return tr;
            }
        }
        Transform parent = tr.parent;
        if (parent == null) {
            return null;
        }
        if (parent.GetComponent(type) != null) {
            return parent;
        }
        return GetParentComponent_ex(type, parent);
    }

    public static void AdjustUGUI(GameObject go) {
        RectTransform rc = go.transform as RectTransform;
        if (rc != null) {
            rc.anchorMin = Vector2.zero;
            rc.anchorMax = Vector2.one;
            rc.offsetMin = Vector2.zero;
            rc.offsetMax = Vector2.zero;
        }
    }

    /// <summary>
    /// 计算字符串的MD5值
    /// </summary>
    public static string md5(string source) {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
        byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
        md5.Clear();

        string destString = "";
        for (int i = 0; i < md5Data.Length; i++) {
            destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
        }
        destString = destString.PadLeft(32, '0');
        return destString;
    }

    /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    public static string md5file(string file) {
        try {
            FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++) {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex) {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }

    /// <summary>
    /// 清除所有子节点
    /// </summary>
    public static void ClearChild(Transform go) {
        if (go == null) return;
        for (int i = go.childCount - 1; i >= 0; i--) {
            GameObject.Destroy(go.GetChild(i).gameObject);
        }
    }

    public static void RetainChild(Transform go, params string[] names) {
        if (go == null) return;
        for (int i = go.childCount - 1; i >= 0; i--) {
            GameObject c = go.GetChild(i).gameObject;
            bool b = false;
            for (int j = 0; j < names.Length; j++) {
                if (c.name == names[j]) {
                    b = true;
                    break;
                }
            }
            if (b) {
                continue;
            }
            GameObject.Destroy(c);
        }
    }

    public static void CopySkinnedMeshRenderer(SkinnedMeshRenderer src, GameObject p, Transform bone_root) {
        List<CombineInstance> combineInstances = new List<CombineInstance>();
        for (int sub = 0; sub < src.sharedMesh.subMeshCount; ++sub) {
            CombineInstance ci = new CombineInstance();
            ci.mesh = src.sharedMesh;
            ci.subMeshIndex = sub;
            combineInstances.Add(ci);
        }

        List<Transform> bones = new List<Transform>();
        for (int j = 0; j < src.bones.Length; j++) {
            Transform[] ts = bone_root.GetComponentsInChildren<Transform>();
            for (int index = 0; index < ts.Length; index++) {
                if (src.bones[j].name.Equals(ts[index].name)) {
                    bones.Add(ts[index]);
                    break;
                }
            }
        }

        List<Material> materials = new List<Material>();
        materials.AddRange(src.sharedMaterials);

        SkinnedMeshRenderer dest = p.AddComponent<SkinnedMeshRenderer>();
        dest.sharedMesh = new Mesh();
        dest.sharedMesh.CombineMeshes(combineInstances.ToArray(), false, false);
        dest.bones = bones.ToArray();
        dest.rootBone = bone_root;
        dest.materials = materials.ToArray();
    }

    /// <summary>
    /// 清理内存
    /// </summary>
    public static void ClearMemory() {
        GC.Collect(); Resources.UnloadUnusedAssets();
        LuaManager mgr = Main.instance.LuaManager;
        if (mgr != null) mgr.LuaGC();
    }

    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath {
        get {
            string game = platform_config_common.AppName.ToLower();
            if (Application.isMobilePlatform) {
                return Application.persistentDataPath + "/" + game + "/";
            }
            if (platform_config_common.DebugMode) {
                return Application.dataPath + "/" + platform_config_common.AssetDir + "/";
            }
            if (Application.platform == RuntimePlatform.OSXEditor) {
                int i = Application.dataPath.LastIndexOf('/');
                return Application.dataPath.Substring(0, i + 1) + game + "/";
            }
            return "c:/" + game + "/";
        }
    }

    public static string GetRelativePath() {
        if (Application.isEditor)
            return "file://" + System.Environment.CurrentDirectory.Replace("\\", "/") + "/Assets/" + platform_config_common.AssetDir + "/";
        else if (Application.isMobilePlatform || Application.isConsolePlatform)
            return "file:///" + DataPath;
        else // For standalone player.
            return "file://" + Application.streamingAssetsPath + "/";
    }

    /// <summary>
    /// 取得行文本
    /// </summary>
    public static string GetFileText(string path) {
        return File.ReadAllText(path);
    }

    /// <summary>
    /// 网络可用
    /// </summary>
    public static bool NetAvailable {
        get {
            return Application.internetReachability != NetworkReachability.NotReachable;
        }
    }

    /// <summary>
    /// 是否是无线
    /// </summary>
    public static bool IsWifi {
        get {
            return Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork;
        }
    }

    /// <summary>
    /// 应用程序内容路径
    /// </summary>
    public static string AppContentPath() {
        string path = string.Empty;
        switch (Application.platform) {
            case RuntimePlatform.Android:
            path = "jar:file://" + Application.dataPath + "!/assets/";
            break;
            case RuntimePlatform.IPhonePlayer:
            path = Application.dataPath + "/Raw/";
            break;
            default:
            path = Application.dataPath + "/" + platform_config_common.AssetDir + "/";
            break;
        }
        return path;
    }

    /// <summary>
    /// 执行Lua方法
    /// </summary>
    public static void CallLuaFunction(string module, string func_name) {
        LuaManager luaManager = null;
        if (Main.instance != null) {
            luaManager = Main.instance.LuaManager;
        }
        else {
            luaManager = GameObject.FindObjectOfType<LuaManager>();
        }
        if (luaManager == null) {
            return;
        }
        luaManager.CallLuaFunction(module, func_name);
    }

    public static void CallLuaFunction<T>(string module, string func_name, T arg1) {
        LuaManager luaManager = null;
        if (Main.instance != null) {
            luaManager = Main.instance.LuaManager;
        }
        else {
            luaManager = GameObject.FindObjectOfType<LuaManager>();
        }
        if (luaManager == null) {
            return;
        }
        luaManager.CallLuaFunction<T>(module, func_name, arg1);
    }

    public static R InvokeLuaFunction<R>(string module, string func_name) {
        LuaManager luaManager = null;
        if (Main.instance != null) {
            luaManager = Main.instance.LuaManager;
        }
        else {
            luaManager = GameObject.FindObjectOfType<LuaManager>();
        }
        if (luaManager == null) {
            return default;
        }
        return luaManager.InvokeLuaFunction<R>(module, func_name);
    }
    public static R InvokeLuaFunction<T, R>(string module, string func_name, T arg1) {
        LuaManager luaManager = null;
        if (Main.instance != null) {
            luaManager = Main.instance.LuaManager;
        }
        else {
            luaManager = GameObject.FindObjectOfType<LuaManager>();
        }
        if (luaManager == null) {
            return default;
        }
        return luaManager.InvokeLuaFunction<T, R>(module, func_name, arg1);
    }

    /// <summary>
    /// 检查运行环境
    /// </summary>
    public static bool CheckEnvironment() {
#if UNITY_EDITOR
        int resultId = Util.CheckRuntimeFile();
        if (resultId == -1) {
            Debug.LogError("没有找到框架所需要的资源，单击Game菜单下Build xxx Resource生成！！");
            EditorApplication.isPlaying = false;
            return false;
        }
        else if (resultId == -2) {
            Debug.LogError("没有找到Wrap脚本缓存，单击Lua菜单下Gen Lua Wrap Files生成脚本！！");
            EditorApplication.isPlaying = false;
            return false;
        }
        if (SceneManager.GetActiveScene().name == "Test" && !platform_config_common.DebugMode) {
            Debug.LogError("测试场景，必须打开调试模式，platform_config_common.DebugMode = true！！");
            EditorApplication.isPlaying = false;
            return false;
        }
#endif
        return true;
    }

    public static int CheckRuntimeFile() {
        if (!Application.isEditor) return 0;
        string streamDir = Application.dataPath + "/StreamingAssets/";
        if (!Directory.Exists(streamDir)) {
            return -1;
        }
        else {
            string[] files = Directory.GetFiles(streamDir);
            if (files.Length == 0) return -1;

            if (!File.Exists(streamDir + "files.txt")) {
                return -1;
            }
        }
        string sourceDir = platform_config_common.LuaFrameworkRoot + "/ToLua/Source/Generate/";
        if (!Directory.Exists(sourceDir)) {
            return -2;
        }
        else {
            string[] files = Directory.GetFiles(sourceDir);
            if (files.Length == 0) return -2;
        }
        return 0;
    }

    //取得res_ver
    public static int GetResVer() {
        string outVerFile = Util.DataPath + "ver.txt";
        if (File.Exists(outVerFile)) {
            StreamReader sr = new StreamReader(outVerFile);
            int local_ver = int.Parse(sr.ReadLine());
            sr.Close();
            return local_ver;
        }
        return -1;
    }

    public static void Log(string str) {
        Debug.Log(str);
    }

    public static void LogWarning(string str) {
        Debug.LogWarning(str);
    }

    public static void LogError(string str) {
        Debug.LogError(str);
    }

    public static XDocument GetXDocument(TextAsset xml) {
        StringReader stringReader = new StringReader(xml.text);
        XDocument x_dcu = new XDocument();
        x_dcu = XDocument.Load(stringReader);
        return x_dcu;
    }

    public static XDocument GetXDocument(string str)
    { 
        StringReader stringReader = new StringReader(str);
        XDocument x_dcu = new XDocument();
        x_dcu = XDocument.Load(stringReader);
        return x_dcu;
    }

    public static XElement GetXElement(XContainer node, string node_name) {
        XElement element = node.Element(node_name);
        return element;
    }

    public static List<XElement> GetXElementList(XContainer node) {
        IEnumerable<XElement> nodes = node.Elements();
        List<XElement> list = new List<XElement>();
        foreach (var item in nodes) {
            list.Add(item);
        }
        return list;
    }

    public static List<XElement> GetXElementList(XContainer node, string node_name) {
        IEnumerable<XElement> nodes = node.Elements(node_name);
        List<XElement> list = new List<XElement>();
        foreach (var item in nodes) {
            list.Add(item);
        }
        return list;
    }

    public static XAttribute GetXAttribute(XElement x, string attr_name) {
        return x.Attribute(attr_name);
    }

    public static List<XAttribute> GetXAttributeList(XElement x) {
        IEnumerable<XAttribute> attrs = x.Attributes();
        List<XAttribute> list = new List<XAttribute>();
        foreach (var item in attrs) {
            list.Add(item);
        }
        return list;
    }

    public static List<XAttribute> GetXAttributeList(XElement x, string attr_name) {
        IEnumerable<XAttribute> attrs = x.Attributes(attr_name);
        List<XAttribute> list = new List<XAttribute>();
        foreach (var item in attrs) {
            list.Add(item);
        }
        return list;
    }

    public static UnityEngine.Object LoadAssetAtPath(string path, Type type) {
#if UNITY_EDITOR
        return UnityEditor.AssetDatabase.LoadAssetAtPath(path, type);
#else
        return null;
#endif
    }

    public static float GetClipLength(Animator animator, string name)
    {
        float length = 0;
        AnimationClip[] clips = animator.runtimeAnimatorController.animationClips;
        foreach (AnimationClip clip in clips)
        {
            if (clip.name.Equals(name))
            {
                length = clip.length;
                break;
            }
        }
        return length;
    }

    //刷像素
    public static void RefreshTexture(Texture2D texture, int start_pos, int end_pos, float r, float g, float b, float a) {
        if (start_pos < 1 && start_pos > texture.width) {
            return;
        }
        int x1 = start_pos - 1;
        int x2 = end_pos;
        Color c = new Color(r, g, b, a);
        for (int i = x1; i < x2; i++) {
            for (int j = 0; j < texture.height; j++) {
                texture.SetPixel(i, j, c);
            }
        }
        texture.Apply();
    }
}
