using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using LitJson;
using UnityEngine.Networking;

public class GameManager : MonoBehaviour {
    private List<string> downloadFiles = new List<string>();
    private List<string> hadDownloadFiles = new List<string>();

    public event Action OnCheckVerStart;
    public event Action OnCheckVerEnd;
    public event Action OnCheckVerFail;
    public event Action OnBuildUpdate;

    public event Action OnDecompressDirStart;
    public event Action<string, float> OnDecompressDir;
    public event Action OnDecompressDirEnd;
    public event Action OnGetVerFileStart;
    public event Action OnGetVerFileEnd;

    public event Action OnCheckUpdateStart;
    public event Action OnCheckUpdateFail;
    public event Action<float> OnCheckUpdateEnd;
    public event Action OnUpdateStart;
    public event Action<float> OnUpdate;
    public event Action<string> OnUpdateFail;
    public event Action OnUpdateEnd;
    public event Action OnGetNewVerFileStart;
    public event Action OnGetNewVerFileFail;
    public event Action OnGetNewVerFileEnd;

    public event Action<int> OnChangeLocalResVer;

    public event Action OnGoLoginFileEnd;
    public event Action OnReGoLogin;

    public event Action OnEnterGame;

    private JsonData ver_info;

    private void Start() {
        downloadFiles.Clear();
        hadDownloadFiles.Clear();
        if (platform_config_common.DebugMode)
        {
            EnterLoginState();
            return;
        }
        GameObject go = Resources.Load<GameObject>("UpdateGUI/UpdateGUI");
        if (go != null)
        {
            Transform p = transform.Find("Update_UI/UIRoot");
            GameObject prefab = Instantiate<GameObject>(go, p);
            prefab.transform.localScale = Vector3.one;
            Util.AdjustUGUI(prefab);
        }
    }

    //检查版本文件
    public void CheckVerInfo() {
        StartCoroutine(CheckVer());
    }

    IEnumerator CheckVer() {
        if (platform_config_common.DebugMode) {
            yield break;
        }
        OnCheckVerStart?.Invoke();
        //加载Url
        string url = platform_config_common.oss_url;
        string random = DateTime.Now.ToString("yyyymmddhhmmss");
        string version = platform_config_common.Version.ToString();
        string verUrl = url + "ver" + version + ".json?v=" + random;
        UnityWebRequest wb = UnityWebRequest.Get(verUrl);
        wb.timeout = 10;
        yield return wb.SendWebRequest();
        if (wb.isHttpError || wb.isNetworkError) {
            OnCheckUpdateFail?.Invoke();
            yield return new WaitForSeconds(2f);
            StartCoroutine(CheckVer());
            yield break;

        }
        OnCheckVerEnd?.Invoke();
        ver_info = JsonMapper.ToObject(wb.downloadHandler.text);
        platform_config_common.updateBuildUrl = ver_info["update_build_url"].ToString();
        platform_config_common.updateResUrl = ver_info["update_res_url"].ToString();
        if (int.Parse(ver_info["build_ver"].ToString()) > platform_config_common.Version) {
            //大版本更新
            OnBuildUpdate?.Invoke();
        }
        else {
            CheckExtractResource();
        }
    }

    //检查外部资源 开启 解压 或者 更新
    public void CheckExtractResource() {
        //非debug模式下进行
        if (platform_config_common.DebugMode) {
            return;
        }
        string outVerFile = Util.DataPath + "ver.txt";
        bool out_ver_exit = File.Exists(outVerFile);
        if (!out_ver_exit) {
            //外部文件不存在 新包 解压资源
            StartCoroutine(OnExtractResource());    //解压游戏资源
        }
        else {
            //老包 检查更新
            StartCoroutine(CheckUpdateResource());
        }
    }

    IEnumerator OnExtractResource() {
        OnDecompressDirStart?.Invoke();

        string dataPath = Util.DataPath;  //数据目录
        string resPath = Util.AppContentPath() + "res.zip"; //游戏包资源目录
        string copyPath = dataPath + "res.zip";
        if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
        Directory.CreateDirectory(dataPath);
        zipUtil.DecompressDirProgress decompressPro = new zipUtil.DecompressDirProgress(ShowDecompressPro);
        zipUtil.DecompressDirFinish findecompressPro = new zipUtil.DecompressDirFinish(FinDecompressPro);
        if (File.Exists(copyPath)) {
            File.Delete(copyPath);
        }
        if (Application.platform == RuntimePlatform.Android) {
            UnityWebRequest wb = UnityWebRequest.Get(resPath);
            yield return wb.SendWebRequest();
            if (wb.isDone) {
                File.WriteAllBytes(copyPath, wb.downloadHandler.data);
                StartCoroutine(zipUtil.DecompressDir(copyPath, dataPath, decompressPro, findecompressPro));
            }
            yield return 0;
        }
        else {
            File.Copy(Util.AppContentPath() + "res.zip", copyPath);
            StartCoroutine(zipUtil.DecompressDir(copyPath, dataPath, decompressPro, findecompressPro));
        }
    }
    //解压进度条展示
    void ShowDecompressPro(string name, float process) {
        OnDecompressDir?.Invoke(name, process);
    }
    //解压完成
    void FinDecompressPro() {
        OnDecompressDirEnd?.Invoke();
        StartCoroutine(GetVerFile());
    }

    IEnumerator GetVerFile() {  //取到 ver.txt 到dataPath
        OnGetVerFileStart?.Invoke();

        string dataPath = Util.DataPath;  //数据目录
        string resPath = Util.AppContentPath(); //游戏包资源目录
        string ver_infile = resPath + "ver.txt";
        string ver_outfile = dataPath + "ver.txt";
        string copy_path = Util.DataPath + "res.zip";
        if (File.Exists(copy_path)) {
            File.Delete(copy_path);
        }
        if (File.Exists(ver_outfile)) {
            File.Delete(ver_outfile);
        }
        if (Application.platform == RuntimePlatform.Android) {
            UnityWebRequest wb = UnityWebRequest.Get(ver_infile);
            yield return wb.SendWebRequest();
            if (wb.isDone) {
                File.WriteAllBytes(ver_outfile, wb.downloadHandler.data);
            }
        }
        else {
            File.Copy(ver_infile, ver_outfile, true);
        }
        yield return 0;
        //解包完成  
        OnGetVerFileEnd?.Invoke();

        Debug.Log("解包完成");
        yield return new WaitForSeconds(0.1f);
        //游戏资源 解压完后 开始热更
        StartCoroutine(CheckUpdateResource());
    }
    //检查更新资源
    IEnumerator CheckUpdateResource() {
        //非更新模式,不检测热更
        if (!platform_config_common.UpdateMode) {
            UpdateComplete();
            yield break;
        }

        int local_ver = Util.GetResVer();
        int cur_res_ver = int.Parse(ver_info["res_ver"].ToString());
        if (local_ver >= cur_res_ver) {
            //本地资源版本号 不小于 远端资源版本号 不更新 进游戏
            UpdateComplete();
            yield break;
        }

        //开始热更
        OnCheckUpdateStart?.Invoke();

        string dataPath = Util.DataPath;  //数据目录
        string message = string.Empty;
        string random = DateTime.Now.ToString("yyyymmddhhmmss");
        string listUrl = platform_config_common.updateResUrl + "files.txt?v=" + random;
        Debug.Log("LoadUpdate---->>>" + listUrl);

        UnityWebRequest wb = UnityWebRequest.Get(listUrl);
        yield return wb.SendWebRequest();
        if (wb.isHttpError || wb.isNetworkError) {
            OnCheckUpdateFail?.Invoke();
            //检查更新失败  2S 后再次检查
            yield return new WaitForSeconds(2f);
            StartCoroutine(CheckUpdateResource());
            yield break;
        }
        string localfile_txt = Util.DataPath + "files.txt";
        if (!Directory.Exists(Util.DataPath)) {
            Directory.CreateDirectory(Util.DataPath);
        }
        if (File.Exists(localfile_txt)) {
            File.Delete(localfile_txt);
        }
        try {
            File.WriteAllBytes(localfile_txt, wb.downloadHandler.data);
        }
        catch (IOException e) {
            Debug.Log(e.Message);
        }
        yield return 0;

        string filesText = wb.downloadHandler.text;
        string[] files = filesText.Split('\n');
        float file_length = 0;  //用来统计总更新大小
        for (int i = 0; i < files.Length; i++) {
            if (string.IsNullOrEmpty(files[i])) continue;
            string[] keyValue = files[i].Split('|');
            string f = keyValue[0];
            string localfile = (dataPath + f).Trim();
            string path = Path.GetDirectoryName(localfile);
            if (!Directory.Exists(path)) {
                Directory.CreateDirectory(path);
            }
            bool canUpdate = !File.Exists(localfile);
            if (!canUpdate) {
                string remoteMd5 = keyValue[1].Trim();
                string localMd5 = Util.md5file(localfile);
                //md5不匹配 需要更新
                canUpdate = !remoteMd5.Equals(localMd5);
                //旧文件在 OnResourceUpdate 中删除
            }
            //需要更新的文件放入 更新列表中
            if (canUpdate) {
                downloadFiles.Add(keyValue[0]);
                file_length += float.Parse(keyValue[2]);
            }
        }
        double update_length = Math.Round(file_length / 1024, 2);
        Debug.Log("总共有有" + update_length + "M需的更新!");
        OnCheckUpdateEnd?.Invoke((float)update_length);
        if (file_length <= 0) {
            //没有需要更新的内容,获取版本文件
            StartCoroutine(UpdateVerFlie());
            yield break;
        }
        else {
            //有更新内容  开启更新
            StartCoroutine(OnResourceUpdate(0));
        }
    }

    //开始热更
    IEnumerator OnResourceUpdate(int start_index) {
        OnUpdateStart?.Invoke();
        int finfileCount = start_index;
        Debug.Log("开始热更");
        for (int i = start_index; i < downloadFiles.Count; i++) {
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string fileUrl = platform_config_common.updateResUrl + downloadFiles[i] + "?v=" + random;
            string localfile = Util.DataPath + downloadFiles[i];
            UnityWebRequest wb = UnityWebRequest.Get(fileUrl);
            yield return wb.SendWebRequest();
            if (wb.isHttpError || wb.isNetworkError) {
                OnUpdateFail?.Invoke(downloadFiles[i]);
                //下载失败 ,等待两秒后重新 下载更新
                yield return new WaitForSeconds(2f);
                StartCoroutine(OnResourceUpdate(finfileCount));
                yield break;
            }

            string localdir = Path.GetDirectoryName(localfile);
            if (!Directory.Exists(localdir)) {
                Directory.CreateDirectory(localdir);
            }
            //有旧的把旧的删了
            if (File.Exists(localfile)) {
                File.Delete(localfile);
            }
            try {
                //把新的放进去
                File.WriteAllBytes(localfile, wb.downloadHandler.data);
            }
            catch (IOException e) {
                Debug.Log(e.Message);
            }
            hadDownloadFiles.Add(localfile);
            finfileCount++;
            float p = (float)finfileCount / (float)downloadFiles.Count;
            OnUpdate.Invoke(p);
        }
        yield return new WaitForSeconds(0.1f);
        Debug.Log("更新完成,热更内容: ");
        for (int i = 0; i < downloadFiles.Count; i++) {
            Debug.Log(downloadFiles[i]);
        }
        downloadFiles.Clear();
        hadDownloadFiles.Clear();
        // 更新资源文件 files.txt
        OnUpdateEnd?.Invoke();
        yield return new WaitForSeconds(0.1f);
        StartCoroutine(UpdateVerFlie());  //更新最新的版本文件
    }

    IEnumerator UpdateVerFlie() {
        OnGetNewVerFileStart?.Invoke();
        Debug.Log("获取新版本文件");
        string dataPath = Util.DataPath;
        string random = DateTime.Now.ToString("yyyyMMddHHmmss");
        string verurl = platform_config_common.updateResUrl + "ver.txt?v=" + random;
        string localver = dataPath + "ver.txt";
        UnityWebRequest wb = UnityWebRequest.Get(verurl);
        yield return wb.SendWebRequest();
        if (wb.isHttpError || wb.isNetworkError) {
            OnGetNewVerFileFail.Invoke();
            yield return new WaitForSeconds(2f);
            StartCoroutine(UpdateVerFlie());
            yield break;
        }

        if (File.Exists(localver)) {
            File.Delete(localver);
        }
        try {
            File.WriteAllBytes(localver, wb.downloadHandler.data);
        }
        catch (IOException e) {
            Debug.Log(e.Message);
        }
        yield return 0;
        OnChangeLocalResVer?.Invoke(int.Parse(wb.downloadHandler.text));
        Debug.Log("获取新版本文件 完成");
        OnGetNewVerFileEnd?.Invoke();
        yield return new WaitForSeconds(0.1f);
        UpdateComplete();   //热更流程结束,资源初始化结束
    }

    void UpdateComplete() {   //热更流程完成
        OnEnterGame?.Invoke();
        EnterLoginState();
    }

    public void EnterLoginState() {
        StartCoroutine(GoLogin());
    }

    IEnumerator GoLogin() {
        string url = platform_config_common.oss_url;
        string random = DateTime.Now.ToString("yyyymmddhhmmss");
        string version = platform_config_common.Version.ToString();
        string serverUrl = url + "server" + ".json?v=" + random;
        UnityWebRequest wb = UnityWebRequest.Get(serverUrl);
        wb.timeout = 10;
        yield return wb.SendWebRequest();
        if (wb.isHttpError || wb.isNetworkError) {
            OnGoLoginFileEnd?.Invoke();
            yield return new WaitForSeconds(2f);
            OnReGoLogin?.Invoke();
            StartCoroutine(GoLogin());
            yield break;
        }

        JsonData server_info = JsonMapper.ToObject(wb.downloadHandler.text);
        platform_config_common.hostIp = server_info["host_ip"].ToString();

        Main.instance.LuaManager.InitStart();   //Lua初始化
        //Debug.Log("准备工作完成，可以进入登陆State");
        if (!platform_config_common.DebugMode) {
            GameObject.Destroy(UpdateGUI.instance.gameObject);
        }
        Transform update_root = transform.Find("Update_UI");
        GameObject.Destroy(update_root.gameObject);
        GC.Collect();
    }
}