using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
using System.IO;

public class UpdateGUI : MonoBehaviour {
    [SerializeField]
    Slider process_slider;
    [SerializeField]
    Text process_text;
    [SerializeField]
    Text log_text;
    [SerializeField]
    GameObject select_rect;
    [SerializeField]
    Text desc_text;
    [SerializeField]
    Button sure_btn;
    [SerializeField]
    Text build_ver_text;
    [SerializeField]
    Text res_ver_text;

    GameManager gameManager;
    public static UpdateGUI instance;

    private Action sure_handle;
    private void Awake() {
        instance = this;

        gameManager = Main.instance.GameManager;
        if (gameManager == null) {
            return;
        }
     
        gameManager.OnCheckVerStart += CheckVerStart;
        gameManager.OnCheckVerEnd += CheckVerEnd;
        gameManager.OnCheckVerFail += CheckVerFail;
        gameManager.OnBuildUpdate += NeedBuildUpdate;

        gameManager.OnDecompressDirStart += DecompressDirStart;
        gameManager.OnDecompressDir += DecompressDir;
        gameManager.OnDecompressDirEnd += DecompressDirEnd;
        gameManager.OnGetVerFileStart += GetVerFileStart;
        gameManager.OnGetVerFileEnd += GetVerFileEnd;

        gameManager.OnCheckUpdateStart += CheckUpdateStart;
        gameManager.OnCheckUpdateFail += CheckUpdateFail;
        gameManager.OnCheckUpdateEnd += CheckUpdateEnd;
        gameManager.OnUpdateStart += UpdateStart;
        gameManager.OnUpdate += UpdateRes;
        gameManager.OnUpdateFail += UpdateFail;
        gameManager.OnUpdateEnd += UpdateEnd;

        gameManager.OnGetNewVerFileStart += GetNewVerFileStart;
        gameManager.OnGetNewVerFileFail += GetNewVerFileFail;
        gameManager.OnGetNewVerFileEnd += GetNewVerFileEnd;

        gameManager.OnChangeLocalResVer += ChangeLocalResVer;

        gameManager.OnGoLoginFileEnd += GoLoginFail;
        gameManager.OnReGoLogin += ReGoLogin;

        gameManager.OnEnterGame += EnterGame;

        sure_btn.onClick.AddListener(OnSureBtnClick);
    }

    private void Start() {
        RefreshPanel();
        gameManager.CheckVerInfo();
    }

    private void OnDestroy() {
        instance = null;

        gameManager.OnCheckVerStart -= CheckVerStart;
        gameManager.OnCheckVerEnd -= CheckVerEnd;
        gameManager.OnCheckVerFail -= CheckVerFail;
        gameManager.OnBuildUpdate -= NeedBuildUpdate;

        gameManager.OnDecompressDirStart -= DecompressDirStart;
        gameManager.OnDecompressDir -= DecompressDir;
        gameManager.OnDecompressDirEnd -= DecompressDirEnd;
        gameManager.OnGetVerFileStart -= GetVerFileStart;
        gameManager.OnGetVerFileEnd -= GetVerFileEnd;

        gameManager.OnCheckUpdateStart -= CheckUpdateStart;
        gameManager.OnCheckUpdateFail -= CheckUpdateFail;
        gameManager.OnCheckUpdateEnd -= CheckUpdateEnd;
        gameManager.OnUpdateStart -= UpdateStart;
        gameManager.OnUpdate -= UpdateRes;
        gameManager.OnUpdateFail -= UpdateFail;
        gameManager.OnUpdateEnd -= UpdateEnd;

        gameManager.OnGetNewVerFileStart -= GetNewVerFileStart;
        gameManager.OnGetNewVerFileFail -= GetNewVerFileFail;
        gameManager.OnGetNewVerFileEnd -= GetNewVerFileEnd;

        gameManager.OnChangeLocalResVer -= ChangeLocalResVer;

        gameManager.OnGoLoginFileEnd -= GoLoginFail;
        gameManager.OnReGoLogin -= ReGoLogin;

        sure_btn.onClick.RemoveAllListeners();
    }

    private void RefreshPanel() {
        process_slider.value = 0;
        process_slider.gameObject.SetActive(false);

        build_ver_text.gameObject.SetActive(true);
        int build_ver = platform_config_common.Version;
        build_ver_text.text = string.Format("pak:{0}", build_ver);

        int local_ver = Util.GetResVer();
        if (local_ver > 0) {
            res_ver_text.gameObject.SetActive(true);
            res_ver_text.text = string.Format("res:{0}", local_ver);
        }
    }

    private void CheckVerStart() {
        SetLogText("检查游戏版本");
        SliderPro(0);
    }

    private void CheckVerEnd() {
        SetLogText("检查游戏版本 完成");
        SliderPro(1);
    }

    private void CheckVerFail() {
        select_rect.gameObject.SetActive(true);
        desc_text.text = "版本对比失败,正尝试重新比对";
        sure_handle = OnCheckVerFailClick;
    }

    private void OnCheckVerFailClick() {
        select_rect.gameObject.SetActive(false);
    }

    private void NeedBuildUpdate() {
        select_rect.gameObject.SetActive(true);
        desc_text.text = "检测到当前版本过低,请下载最新版本";
        sure_handle = OnBuildUpdateClick;
    }

    private void OnBuildUpdateClick() {
        select_rect.gameObject.SetActive(false);
        //platform.LoadBuild()
    }

    private void DecompressDirStart() {
        SetLogText("解压游戏资源(解压过程不消耗流量)");
        SliderPro(0);
    }
    private void DecompressDir(string name, float progress) {
        SliderPro(progress);
    }

    private void DecompressDirEnd() {
        SliderPro(1);
        SetLogText("解压游戏资源 完成");
    }

    private void GetVerFileStart() {
        SetLogText("获取版本文件");
    }

    private void GetVerFileEnd() {
        SetLogText("获取版本文件 完成");
        int local_ver = Util.GetResVer();
        if (!res_ver_text.gameObject.activeSelf) {
            res_ver_text.gameObject.SetActive(true);
        }
        res_ver_text.text = string.Format("res:{0}", local_ver);
    }

    void CheckUpdateStart() {
        SetLogText("检查更新中");
        SliderPro(0);
    }

    void CheckUpdateFail() {
        SetLogText("检测更新失败,正在尝试重新更新");
    }

    void CheckUpdateEnd(float f) {
        if (f <= 0) {
            SetLogText("无更新内容");
        }
        else {
            SetLogText("总共有" + f + "M需的更新!");
        }
    }

    void UpdateStart() {
        //SetLogText("下载需更新的资源");
    }

    void UpdateRes(float p) {
        SliderPro(p);
    }

    void UpdateFail(string file_name) {
        SetLogText("下载"+ file_name+ "资源失败,正在尝试重新下载");
    }

    void UpdateEnd() {
        SetLogText("下载需更新的资源 完成");
    }

    void GetNewVerFileStart() {
        SetLogText("获取版本文件");
        SliderPro(0);
    }

    void GetNewVerFileFail() {
        SetLogText("获取版本文件失败,正在尝试重新获取");
    }

    void GetNewVerFileEnd() {
        SetLogText("获取版本文件完成，准备进入游戏");
        SliderPro(1);
    }

    void ChangeLocalResVer(int new_res_ver) {
        res_ver_text.text = string.Format("res:{0}", new_res_ver);
    }

    void GoLoginFail() {
        SetLogText("网络连接失败,正在尝试重新连接");
    }

    void ReGoLogin() {
        SetLogText("登录中...");
    }

    void EnterGame() {
        SetLogText("准备进入游戏...");
    }

    public void SetLogText(string content) {
        log_text.text = content;
    }

    void SliderPro(float progress) {
        if (process_slider == null) {
            return;
        }
        if (!process_slider.gameObject.activeSelf) {
            process_slider.gameObject.SetActive(true);
        }
        process_slider.value = progress;
        process_text.text = (int)((progress / 1) * 100) + "%";
    }

    void HideSlider() {
        if (process_slider != null) {
            process_slider.value = 0;
            process_slider.gameObject.SetActive(false);
        }
    }

    void OnSureBtnClick() {
        sure_handle?.Invoke();
    }
}
