StartPanel = {}
StartPanel.Control = {}
local this = StartPanel.Control

function StartPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.sgc_back_ = this.transform_:Find("panel_among/back_ground")
    this.login_panel_ = this.transform_:Find("panel_among/login_panel")
    this.login_username_input_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/login_username_input"):GetComponent("InputField")
    this.login_password_input_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/login_password_input"):GetComponent("InputField")
    this.tour_login_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/btns/tour_login_btn")
    this.retrieve_password_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/btns/retrieve_password_btn")
    this.modify_password_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/btns/modify_password_btn")
    this.register_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/btns/register_btn")
    this.close_login_panel_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/close_login_panel_btn")
    this.sure_login_btn_ = this.transform_:Find("panel_among/login_panel/back_ground/panel_among/sure_login_btn")
    this.tour_panel_ = this.transform_:Find("panel_among/tour_panel")
    this.close_tour_panel_btn_ = this.transform_:Find("panel_among/tour_panel/back_ground/close_tour_panel_btn")
    this.sure_tour_btn_ = this.transform_:Find("panel_among/tour_panel/back_ground/panel_among/sure_tour_btn")
    this.bind_panel_ = this.transform_:Find("panel_among/bind_panel")
    this.close_bind_panel_btn_ = this.transform_:Find("panel_among/bind_panel/back_ground/close_bind_panel_btn")
    this.bind_username_input_ = this.transform_:Find("panel_among/bind_panel/back_ground/panel_among/bind_username_input"):GetComponent("InputField")
    this.bind_password_input_ = this.transform_:Find("panel_among/bind_panel/back_ground/panel_among/bind_password_input"):GetComponent("InputField")
    this.re_bind_password_input_ = this.transform_:Find("panel_among/bind_panel/back_ground/panel_among/re_bind_password_input"):GetComponent("InputField")
    this.sure_bind_btn_ = this.transform_:Find("panel_among/bind_panel/back_ground/panel_among/sure_bind_btn")
    this.go_register_btn_ = this.transform_:Find("panel_among/tour_panel/back_ground/panel_among/go_register_btn")
    this.register_panel_ = this.transform_:Find("panel_among/register_panel")
    this.close_register_panel_btn_ = this.transform_:Find("panel_among/register_panel/back_ground/close_register_panel_btn")
    this.reg_username_input_ = this.transform_:Find("panel_among/register_panel/back_ground/panel_among/reg_username_input"):GetComponent("InputField")
    this.reg_password_input_ = this.transform_:Find("panel_among/register_panel/back_ground/panel_among/reg_password_input"):GetComponent("InputField")
    this.re_reg_password_input_ = this.transform_:Find("panel_among/register_panel/back_ground/panel_among/re_reg_password_input"):GetComponent("InputField")
    this.sure_register_btn_ = this.transform_:Find("panel_among/register_panel/back_ground/panel_among/sure_register_btn")
    this.retrievet_password_panel_ = this.transform_:Find("panel_among/retrievet_password_panel")
    this.close_retrievent_panel_btn_ = this.transform_:Find("panel_among/retrievet_password_panel/back_ground/close_retrievent_panel_btn")
    this.retrievent_mail_input_ = this.transform_:Find("panel_among/retrievet_password_panel/back_ground/panel_among/retrievent_mail_input"):GetComponent("InputField")
    this.sure_retrivent_btn_ = this.transform_:Find("panel_among/retrievet_password_panel/back_ground/panel_among/sure_retrivent_btn")
    this.modify_password_panel_ = this.transform_:Find("panel_among/modify_password_panel")
    this.close_modify_panel_btn_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/close_modify_panel_btn")
    this.mod_username_input_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/panel_among/mod_username_input"):GetComponent("InputField")
    this.mod_old_password_input_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/panel_among/mod_old_password_input"):GetComponent("InputField")
    this.mod_new_password_input_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/panel_among/mod_new_password_input"):GetComponent("InputField")
    this.re_mod_new_password_input_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/panel_among/re_mod_new_password_input"):GetComponent("InputField")
    this.sure_modify_btn_ = this.transform_:Find("panel_among/modify_password_panel/back_ground/panel_among/sure_modify_btn")
    this.start_game_panel_ = this.transform_:Find("panel_among/start_game_panel")
    this.start_game_btn_ = this.transform_:Find("panel_among/start_game_panel/start_game_btn")
    this.sure_agree_toggle_ = this.transform_:Find("panel_among/start_game_panel/sure_agree_toggle"):GetComponent("Toggle")
    this.username_btn_ = this.transform_:Find("panel_among/start_game_panel/username_btn")
    this.start_username_text_ = this.transform_:Find("panel_among/start_game_panel/username_btn/start_username_text")
    this.agree_btn_ = this.transform_:Find("panel_among/start_game_panel/sure_agree_toggle/sure_title/agree_text/agree_btn")
    this.transit_panel_ = this.transform_:Find("panel_among/transit_panel")
    this.gonggao_panel_ = this.transform_:Find("panel_among/gonggao_panel")
    this.close_gonggao_panel_btn_ = this.transform_:Find("panel_among/gonggao_panel/back_ground/close_gonggao_panel_btn")
    this.gonggao_text_ = this.transform_:Find("panel_among/gonggao_panel/back_ground/panel_among/text_back/view/gonggao_text")
    this.sure_gonggao_btn_ = this.transform_:Find("panel_among/gonggao_panel/back_ground/panel_among/sure_gonggao_btn")
    this.agree_panel_ = this.transform_:Find("panel_among/agree_panel")
    this.close_agree_panel_btn_ = this.transform_:Find("panel_among/agree_panel/back_ground/close_agree_panel_btn")
    this.agree_scroll_ = this.transform_:Find("panel_among/agree_panel/back_ground/panel_among/text_back"):GetComponent("ScrollRect")
    this.agree_text_ = this.transform_:Find("panel_among/agree_panel/back_ground/panel_among/text_back/view/agree_text")
    this.sure_agreen_btn_ = this.transform_:Find("panel_among/agree_panel/back_ground/panel_among/sure_agreen_btn")

    this.had_account_ = false
    this.had_login_ = false
    this.login_username_ = ""
    this.login_password_ = ""

    this.cur_token_ = ""
    this.game_server_ = ""
    this.game_server_port_ = 0
    this.server_id_ = 0
    this.had_read_agree_ = false

    this.weihu_info_ = {}

    this.test_ = false

	timerMgr:AddTimer("TransitPanelActive", function (param)
        StartPanel.ShowGonggaoPanel()
        this.transit_panel_.gameObject:SetActive(true)
        end , {}, 2.5)

    StartPanel.CloseAllPanels()
    StartPanel.RegisterBtnListen()
    StartPanel.RegisterMessage()
end

function StartPanel.CloseAllPanels()
    this.login_panel_.gameObject:SetActive(false)
    this.tour_panel_.gameObject:SetActive(false)
    this.bind_panel_.gameObject:SetActive(false)
    this.register_panel_.gameObject:SetActive(false)
    this.retrievet_password_panel_.gameObject:SetActive(false)
    this.modify_password_panel_.gameObject:SetActive(false)
    this.start_game_panel_.gameObject:SetActive(false)
    this.gonggao_panel_.gameObject:SetActive(false)
    this.agree_panel_.gameObject:SetActive(false)
end

function StartPanel.OnDestroy()
    StartPanel.RemoveMessage()
    this = {}
end

function StartPanel.RegisterBtnListen()
    GameSys.ButtonRegister(this.lua_script_, this.sure_login_btn_.gameObject, "click", StartPanel.OnSureLoginClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.tour_login_btn_.gameObject, "click", StartPanel.OnTourLoginClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.retrieve_password_btn_.gameObject, "click", StartPanel.OnRetrivePasswordClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.modify_password_btn_.gameObject, "click", StartPanel.OnModifyPasswordClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.register_btn_.gameObject, "click", StartPanel.OnRegisterClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_login_panel_btn_.gameObject, "click", StartPanel.OnCloseLoginPanelClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_agree_toggle_.gameObject, "toggle", StartPanel.OnAgreeToggleClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.username_btn_.gameObject, "click", StartPanel.OnUsernameClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_tour_btn_.gameObject, "click", StartPanel.OnSureTourLoginClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.go_register_btn_.gameObject, "click", StartPanel.OnGoRegisterClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_tour_panel_btn_.gameObject, "click", StartPanel.OnCloseTourPanelClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_bind_panel_btn_.gameObject, "click", StartPanel.OnCloseBindClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_bind_btn_.gameObject, "click", StartPanel.OnSureBindClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_register_btn_.gameObject, "click", StartPanel.OnSureRegisterClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_register_panel_btn_.gameObject, "click", StartPanel.OnCloseRegisterPanelClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_modify_btn_.gameObject, "click", StartPanel.OnSureModpasswordClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_modify_panel_btn_.gameObject, "click", StartPanel.OnCloseModifyPasswordClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_retrivent_btn_.gameObject, "click", StartPanel.OnSureRetriventClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_retrievent_panel_btn_.gameObject, "click", StartPanel.OnCloseRetrieventClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.start_game_btn_.gameObject, "click", StartPanel.OnStartBtnClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_gonggao_panel_btn_.gameObject, "click", StartPanel.OnCloseGonggaoBtnClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_gonggao_btn_.gameObject, "click", StartPanel.OnGonggaoSureBtnClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.agree_btn_.gameObject, "click", StartPanel.OnAgreeBtnClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.close_agree_panel_btn_.gameObject, "click", StartPanel.OnCloseAgreeBtnClick, nil, true)
    GameSys.ButtonRegister(this.lua_script_, this.sure_agreen_btn_.gameObject, "click", StartPanel.OnAgreeSureBtnClick, nil, false)

    GameSys.ButtonRegister(this.lua_script_, this.transit_panel_.gameObject, "click", StartPanel.OnTransitBtnClick, nil, false)
end

function StartPanel.RegisterMessage()

end

function StartPanel.RemoveMessage()

end

function StartPanel.Start(obj)
    GameSys.ScreenSca(this.sgc_back_)
    local sgc = this.sgc_back_:GetComponent("SkeletonGraphic")
    local sgc_height = sgc.Skeleton.Data.Height
    local size = GUIRoot.UICamera.orthographicSize
    local y = size * 2 * 100
    local s_y = sgc.transform.localScale.y
    sgc:GetComponent("RectTransform").anchoredPosition = Vector2(0, -(sgc_height * s_y - y) / 2)
end

function StartPanel.SetData()
    this.had_login_ = false
    this.had_account_ = PlayerPrefs.HasKey("username") and PlayerPrefs.HasKey("password")
end

function StartPanel.RefreshPanel()
    StartPanel.SetData()
    if this.had_account_ then
        local username = PlayerPrefs.GetString("username")
        local password = PlayerPrefs.GetString("password")
        StartPanel.HttpLogin(username, password)
    else
        StartPanel.ShowLoginPanel()
    end
end

function StartPanel.OnTransitBtnClick()
    if platform_config_common.third_login == 0 then
        this.transit_panel_.gameObject:SetActive(false)
        if this.test_ then
            StartPanel.ShowTestPanel()
            return
        end
        StartPanel.RefreshPanel()
    elseif platform_config_common.third_login == 1 then
        log("第三方登陆");
    end
end

function StartPanel.LoginSuccess()
    StartPanel.CloseAllPanels()
    StartPanel.ShowStartGamePanel()
end
-------------------------------------登陆界面----------------------------------------

function StartPanel.ShowLoginPanel()
    this.login_panel_.gameObject:SetActive(true)
    StartPanel.RefreshLoginPanel()
end

function StartPanel.CloseLoginPanel()
    this.login_panel_.gameObject:SetActive(false)
end

function StartPanel.RefreshLoginPanel()
    this.login_username_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入账号"
    this.login_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入密码"
    this.login_username_input_.text = ""
    this.login_password_input_.text = ""

    this.close_login_panel_btn_.gameObject:SetActive(this.had_login_)
    if this.had_login_ and GameSys.IsTour(this.login_username_) then
        this.tour_login_btn_:Find("Text"):GetComponent("Text").text = "游客绑定"
    else
        this.tour_login_btn_:Find("Text"):GetComponent("Text").text = "游客登陆"
    end
end

---确认登陆
function StartPanel.OnSureLoginClick(obj)
    local username = this.login_username_input_.text
    local password = this.login_password_input_.text
    StartPanel.SureLogin(username, password)
end

function StartPanel.SureLogin(username, password)
    local result = 0
    if GameSys.CheckMail(username) then
        result = result + 1
    end
    if result == 1 then
        if GameSys.CheckPassWord(password) then
            result = result + 1
        end
    end
    if result == 2 then
        StartPanel.HttpLogin(username, password)
    end
end

function StartPanel.HttpLogin(username, password)
    local wwwf = WWWForm.New()
    wwwf:AddField("mail", username)
    wwwf:AddField("password", password)
    GUIRoot.ShowPanel("MaskPanel")
    this.login_username_ = username
    this.login_password_ = password
    networkMgr:lua_post(platform_config_common.login_url .. "login", wwwf, StartPanel.LoginCallBack, StartPanel.LoginFailCallBack)
end

---登陆回调
function StartPanel.LoginCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    this.cur_token_ = ss.token
    if (code == 0) then
        GUIRoot.ShowPanel("MessagePanel", { "登陆成功" })
        PlayerPrefs.SetString('username', this.login_username_)
        PlayerPrefs.SetString('password', this.login_password_)
        PlayerPrefs.Save()
        this.had_login_ = true
        StartPanel.LoginSuccess()
        return
    else
        StartPanel.ShowFailMessage(code)
        if not this.login_panel_.gameObject.activeSelf then
            StartPanel.ShowLoginPanel()
        end
    end
end

---登陆失败回调
function StartPanel.LoginFailCallBack()
    StartPanel.HttpFail()
    if not this.login_panel_.gameObject.activeSelf then
        StartPanel.ShowLoginPanel()
    end
end

function StartPanel.OnTourLoginClick(obj)
    if this.had_login_ and GameSys.IsTour(this.login_username_) then
        StartPanel.CloseLoginPanel()
        StartPanel.ShowBindPanel()
    else
        StartPanel.CloseLoginPanel()
        StartPanel.ShowTourPanel()
    end
end

function StartPanel.OnRetrivePasswordClick(obj)
    StartPanel.CloseLoginPanel()
    StartPanel.ShowRetrievePassworldPanel()
end

function StartPanel.OnModifyPasswordClick(obj)
    StartPanel.CloseLoginPanel()
    StartPanel.ShowModifyPasswordPanel()
end

function StartPanel.OnRegisterClick(obj)
    StartPanel.CloseLoginPanel()
    StartPanel.ShowRegisterPanel()
end

function StartPanel.OnCloseLoginPanelClick(obj)
    if this.had_login_ then
        StartPanel.CloseLoginPanel()
        StartPanel.ShowStartGamePanel()
    end
end

---------------------------------------公告界面-----------------------------------------
function StartPanel.ShowGonggaoPanel()
    this.gonggao_panel_.gameObject:SetActive(true)
    StartPanel.RefreshGonggaoPanel()
end

function StartPanel.CloseGonggaoGamePanel()
    this.gonggao_panel_.gameObject:SetActive(false)
end

function StartPanel.RefreshGonggaoPanel()
    StartPanel.GetGonggaoContent()
end

function StartPanel.GetGonggaoContent()
    GUIRoot.ShowPanel("MaskPanel")
    local random = os.date("%Y%m%d%H%M%S")
    local gonggao_url = platform_config_common.oss_url .. "gonggao.txt?v=" .. random
    networkMgr:lua_get(gonggao_url, StartPanel.GetGonggaoCallBack, StartPanel.GetGonggaoFail)
end

function StartPanel.GetGonggaoCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local gonggao_content = www.text
    this.gonggao_text_:GetComponent("Text").text = gonggao_content
end

function StartPanel.GetGonggaoFail()
    StartPanel.HttpFail()
    --获取失败 2s后重新拉
    timerMgr:AddTimer("GetGonggaoContent", StartPanel.GetGonggaoContent, 2)
end

function StartPanel.OnCloseGonggaoBtnClick()
    StartPanel.CloseGonggaoGamePanel()
end

function StartPanel.OnGonggaoSureBtnClick()
    StartPanel.CloseGonggaoGamePanel()
end
---------------------------------------开始界面-----------------------------------------
function StartPanel.ShowStartGamePanel()
    this.start_game_panel_.gameObject:SetActive(true)
    StartPanel.RefreshStartGamePanel()
end

function StartPanel.CloseStartGamePanel()
    this.start_game_panel_.gameObject:SetActive(false)
end

function StartPanel.RefreshStartGamePanel()
    this.start_username_text_:GetComponent("Text").text = this.cur_token_
    this.had_read_agree_ = false
    if not PlayerPrefs.HasKey("had_read_agree") then
        this.had_read_agree_ = false
    else
        this.had_read_agree_ = (PlayerPrefs.GetString("had_read_agree") == "yes")
    end
    this.sure_agree_toggle_.isOn = this.had_read_agree_
end

function StartPanel.OnStartBtnClick()
    if this.had_read_agree_ then
        StartPanel.CheckWeihu()
    else
        GUIRoot.ShowPanel("MessagePanel", { "请阅读游戏许可及服务协议并同意后，可进入游戏" })
    end
end

function StartPanel.CheckWeihu()
    GUIRoot.ShowPanel("MaskPanel")
    local random = os.date("%Y%m%d%H%M%S")
    local weihu_url = platform_config_common.oss_url .. "weihu" .. platform_config_common.Version .. ".json?v=" .. random
    networkMgr:lua_get(weihu_url, StartPanel.CheckWeihuaCallBack, StartPanel.CheckWeihuaFail)
end

function StartPanel.CheckWeihuaCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local is_weihu = tonumber(ss.on) == 1
    local weihu_text = tostring(ss.text)
    local white_ids = ss.white_ids
    this.weihu_info_ = {
        ["is_weihu"] = is_weihu,
        ["weihu_text"] = weihu_text,
        ["white_ids"] = white_ids
    }
    local tip_weihu = StartPanel.CheckTipWeihu(this.login_username_)
    if tip_weihu then
        GUIRoot.ShowPanel("MessagePanel", { this.weihu_info_.weihu_text })
    else
        StartPanel.GoStorageServer()
    end
end

function StartPanel.CheckWeihuaFail()
    StartPanel.HttpFail()
    --2秒后重新拉
    timerMgr:AddTimer("CheckWeihu", StartPanel.CheckWeihu, 2)
end

function StartPanel.CheckTipWeihu(username)
    local tip_weihu = false
    if this.weihu_info_.is_weihu then
        tip_weihu = true
        local is_white = false
        for i = 1, #this.weihu_info_.white_ids do
            if this.weihu_info_.white_ids[i].id == username then
                is_white = true
                break
            end
        end
        if is_white then
            tip_weihu = false
        end
    end
    return tip_weihu
end

function StartPanel.GoStorageServer()
    local wwwf = WWWForm.New()
    wwwf:AddField("token", this.cur_token_)
    GUIRoot.ShowPanel("MaskPanel")
    networkMgr:lua_post(platform_config_common.storage_url .. "get", wwwf, StartPanel.StorageCallBack, StartPanel.StorageFailCallBack)
end

---进储存服回调
function StartPanel.StorageCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local res = ss.res
    if res == 0 then
        this.server_id_ = ss.serverid
        this.game_server_ = ss.server
        this.game_server_port_ = ss.port
        PlayerData.login_info = {
            ["token"] = this.cur_token_,
            ["pass_word"] = this.login_password_,
            ["game_server"] = this.game_server_,
            ["game_server_port"] = 9000 + this.game_server_port_ * 10 + 1,
            ["server_id"] = this.server_id_,
            ["platform"] = "test",
            ["lang"] = platform_config_common.lang
        }
        GameTcp.Connect(PlayerData.login_info.game_server, PlayerData.login_info.game_server_port)
    elseif res == -1 then
        GUIRoot.ShowPanel("MessagePanel", "token长度错误")
    elseif res == -2 then
        GUIRoot.ShowPanel("MessagePanel", "未知错误")
    elseif res == -3 then
        GUIRoot.ShowPanel("MessagePanel", "当前渠道没有服务器")
    end
end

---进储存服失败回调
function StartPanel.StorageFailCallBack()
    StartPanel.HttpFail()
    if not this.login_panel_.gameObject.activeSelf then
        StartPanel.ShowLoginPanel()
    end
end

function StartPanel.OnAgreeToggleClick(obj, is_on)
    this.had_read_agree_ = is_on
    local str = this.had_read_agree_ and "yes" or "no"
    PlayerPrefs.SetString("had_read_agree", str)
    PlayerPrefs.Save()
end

function StartPanel.OnUsernameClick(obj)
    StartPanel.CloseStartGamePanel()
    StartPanel.ShowLoginPanel()
end

----------------------------------------用户协议------------------------------
function StartPanel.ShowAgreePanel()
    this.agree_panel_.gameObject:SetActive(true)
    this.agree_scroll_.verticalNormalizedPosition = 1
end

function StartPanel.CloseAgreePanel()
    this.agree_panel_.gameObject:SetActive(false)
end

function StartPanel.OnAgreeBtnClick(obj, param)
    StartPanel.ShowAgreePanel()
end

function StartPanel.OnCloseAgreeBtnClick(obj, param)
    StartPanel.CloseAgreePanel()
end

function StartPanel.OnAgreeSureBtnClick(obj, param)
    StartPanel.CloseAgreePanel()
end

----------------------------------------游客登陆------------------------------
function StartPanel.ShowTourPanel()
    this.tour_panel_.gameObject:SetActive(true)
end

function StartPanel.CloseTourPanel()
    this.tour_panel_.gameObject:SetActive(false)
end

function StartPanel.OnSureTourLoginClick()
    local wwwf = WWWForm.New()
    wwwf:AddField("tour", "")
    GUIRoot.ShowPanel("MaskPanel")
    networkMgr:lua_post(platform_config_common.login_url .. "tourist", wwwf, StartPanel.TourLoginCallBack, StartPanel.TourLoginFailCallBack)
end

function StartPanel.TourLoginCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    if (code == 1) then
        local mail = ss.mail
        local password = ss.password
        PlayerPrefs.SetString("username", mail)
        PlayerPrefs.SetString("password", password)
        PlayerPrefs.Save()
        this.had_login_ = true
        this.cur_token_ = ss.token
        this.login_username_ = mail
        this.login_password_ = password
        StartPanel.LoginSuccess()
    else
        StartPanel.ShowFailMessage(code)
        StartPanel.CloseTourPanel()
        if not this.login_panel_.gameObject.activeSelf then
            StartPanel.ShowLoginPanel()
        end
    end
end

function StartPanel.TourLoginFailCallBack()
    StartPanel.HttpFail()
end

function StartPanel.OnGoRegisterClick()
    StartPanel.CloseTourPanel()
    StartPanel.ShowRegisterPanel()
end

function StartPanel.OnCloseTourPanelClick(obj)
    StartPanel.CloseTourPanel()
    StartPanel.ShowLoginPanel()
end

--------------------------------------注册界面--------------------------------------
function StartPanel.ShowRegisterPanel()
    this.register_panel_.gameObject:SetActive(true)
    StartPanel.RefreshRegisterPanel()
end

function StartPanel.RefreshRegisterPanel()
    this.reg_username_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入邮箱"
    this.reg_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入密码"
    this.re_reg_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "再次输入账号"
    this.reg_username_input_.text = ""
    this.reg_password_input_.text = ""
    this.re_reg_password_input_.text = ""
end

function StartPanel.CloseRegisterPanel()
    this.register_panel_.gameObject:SetActive(false)
end

--确认注册
function StartPanel.OnSureRegisterClick()
    local username = this.reg_username_input_.text
    local password = this.reg_password_input_.text
    local re_password = this.re_reg_password_input_.text
    local result = 0
    if GameSys.CheckMail(username) then
        result = result + 1
    end
    if result == 1 then
        if (password ~= re_password) then
            GUIRoot.ShowPanel("MessagePanel", { '俩次输入的密码不一致' })
        else
            if GameSys.CheckPassWord(password) then
                result = result + 1
            end
        end
    end
    if (result == 2) then
        StartPanel.SureRegister(username, password)
    end
end

function StartPanel.SureRegister(username, password)
    local wwwf = WWWForm.New()
    wwwf:AddField("mail", username)
    wwwf:AddField("phone", "")
    wwwf:AddField("password", password)
    GUIRoot.ShowPanel("MaskPanel")
    networkMgr:lua_post(platform_config_common.login_url .. "reg", wwwf, StartPanel.RegisterCallBack, StartPanel.RegisterFailCallBack)
end

--注册回调
function StartPanel.RegisterCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    if (code == 1) then
        GUIRoot.ShowPanel("MessagePanel", { "注册成功" })
        local username = this.reg_username_input_.text
        local password = this.reg_password_input_.text
        PlayerPrefs.SetString('username', username)
        PlayerPrefs.SetString('password', password)
        PlayerPrefs.Save()
        this.cur_token_ = ss.token
        this.login_username_ = username
        this.login_password_ = username
        this.had_login_ = true
        StartPanel.LoginSuccess()
    else
        StartPanel.ShowFailMessage(code)
    end
end

--注册失败回调
function StartPanel.RegisterFailCallBack()
    StartPanel.HttpFail()
end

function StartPanel.OnCloseRegisterPanelClick(obj)
    StartPanel.CloseRegisterPanel()
    StartPanel.ShowLoginPanel()
end

---------------------------修改密码---------------------------
function StartPanel.ShowModifyPasswordPanel()
    this.modify_password_panel_.gameObject:SetActive(true)
    StartPanel.RefreshModifyPasswordPanel()
end

function StartPanel.RefreshModifyPasswordPanel()
    this.mod_username_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入账号"
    this.mod_old_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入原密码"
    this.mod_new_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入新密码"
    this.re_mod_new_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "再次输入新密码"
    this.mod_username_input_.text = ""
    this.mod_old_password_input_.text = ""
    this.mod_new_password_input_.text = ""
    this.re_mod_new_password_input_.text = ""
end

function StartPanel.CloseModifyPasswordPanel()
    this.modify_password_panel_.gameObject:SetActive(false)
end

--确认修改密码
function StartPanel.OnSureModpasswordClick()
    local username = this.mod_username_input_.text
    local password = this.mod_old_password_input_.text
    local newpassword = this.mod_new_password_input_.text
    local repassword = this.re_mod_new_password_input_.text
    local result = 0
    if GameSys.CheckMail(username) then
        result = result + 1
    end
    if result == 1 then
        if GameSys.CheckPassWord(password) then
            result = result + 1
        end
    end
    if result == 2 then
        if (newpassword ~= repassword) then
            GUIRoot.ShowPanel("MessagePanel", { '俩次输入的密码不一致' })
        elseif GameSys.CheckPassWord(newpassword) then
            result = result + 1
        end
    end
    if result == 3 then
        local wwwf = WWWForm.New()
        wwwf:AddField("mail", username)
        wwwf:AddField("old_password", password)
        wwwf:AddField("password", newpassword)
        GUIRoot.ShowPanel("MaskPanel")
        networkMgr:lua_post(platform_config_common.login_url .. "chpwd", wwwf, StartPanel.ModifyPasswordCallBack, StartPanel.ModifyFailCallBack)
    end
end

--修改密码回调
function StartPanel.ModifyPasswordCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    if (code == 0) then
        GUIRoot.ShowPanel("MessagePanel", { "修改密码成功" })
        local username = this.mod_username_input_.text
        local password = this.mod_new_password_input_.text
        StartPanel.CloseModifyPasswordPanel()
        if this.had_login_ then
            if username == this.login_username_ then
                PlayerPrefs.SetString('username', username)
                PlayerPrefs.SetString('password', password)
                PlayerPrefs.Save()
            else
                this.had_login_ = false
            end
        end
        StartPanel.ShowLoginPanel()
        this.login_username_input_.text = username
        this.login_password_input_.text = password
        return
    else
        StartPanel.ShowFailMessage(code)
    end
end


--修改密码失败
function StartPanel.ModifyFailCallBack()
    StartPanel.HttpFail()
end

function StartPanel.OnCloseModifyPasswordClick()
    StartPanel.CloseModifyPasswordPanel()
    StartPanel.ShowLoginPanel()
end

---------------------------找回密码---------------------------
function StartPanel.ShowRetrievePassworldPanel()
    this.retrievet_password_panel_.gameObject:SetActive(true)
    StartPanel.RefreshRetrievePassworldPanel()
end

function StartPanel.RefreshRetrievePassworldPanel()
    this.retrievent_mail_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入绑定的邮箱"
    this.retrievent_mail_input_.text = ""
end

function StartPanel.CloseRetrievePassworldPanel()
    this.retrievet_password_panel_.gameObject:SetActive(false)
end

function StartPanel.OnSureRetriventClick(obj)
    local mail = this.retrievent_mail_input_.text
    local result = 0
    if GameSys.CheckMail(mail) then
        result = result + 1
    end
    if result == 1 then
        local wwwf = WWWForm.New()
        wwwf:AddField("mail", mail)
        wwwf:AddField("lang", platform_config_common.lang)
        GUIRoot.ShowPanel("MaskPanel")
        networkMgr:lua_post(platform_config_common.login_url .. "recovery", wwwf, StartPanel.RetriventPasswordCallBack, StartPanel.RetriventailCallBack)
    end
end

function StartPanel.RetriventPasswordCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    if (code == 0) then
        GUIRoot.ShowPanel("MessagePanel", { "账号密码已发送至你的邮箱" })
        StartPanel.CloseRetrievePassworldPanel()
        StartPanel.ShowLoginPanel()
    else
        StartPanel.ShowFailMessage(code)
    end
end

function StartPanel.RetriventailCallBack()
    StartPanel.HttpFail()
end

function StartPanel.OnCloseRetrieventClick(obj)
    StartPanel.CloseRetrievePassworldPanel()
    StartPanel.ShowLoginPanel()
end

---------------------------游客绑定---------------------------
function StartPanel.ShowBindPanel()
    this.bind_panel_.gameObject:SetActive(true)
    StartPanel.RefreshBindPanel()
end

function StartPanel.CloseBindPanel()
    this.bind_panel_.gameObject:SetActive(false)
end

function StartPanel.RefreshBindPanel()
    this.bind_username_input_.text = ""
    this.bind_username_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入要绑定的邮箱"
    this.bind_password_input_.text = ""
    this.bind_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "输入密码"
    this.re_bind_password_input_.text = ""
    this.re_bind_password_input_.transform:Find("Placeholder"):GetComponent("Text").text = "再次输入密码"
end

function StartPanel.OnSureBindClick(obj)
    local username = this.bind_username_input_.text
    local password = this.bind_password_input_.text
    local re_password = this.re_bind_password_input_.text
    local result = 0
    if GameSys.CheckMail(username) then
        result = result + 1
    end
    if result == 1 then
        if (password ~= re_password) then
            GUIRoot.ShowPanel("MessagePanel", { '俩次输入的密码不一致' })
        else
            if GameSys.CheckPassWord(password) then
                result = result + 1
            end
        end
    end
    if result == 2 then
        local tour_username = this.login_username_
        local tour_password = this.login_password_
        local wwwf = WWWForm.New()
        wwwf:AddField("mail", username)
        wwwf:AddField("password", password)
        wwwf:AddField("old_mail", tour_username)
        wwwf:AddField("old_password", tour_password)
        GUIRoot.ShowPanel("MaskPanel")
        networkMgr:lua_post(platform_config_common.login_url .. "bind", wwwf, StartPanel.BindCallBack, StartPanel.BindFailCallBack)
    end
end

function StartPanel.BindCallBack(www)
    GUIRoot.ClosePanel("MaskPanel")
    local ss = json.decode(www.text)
    local code = ss.res
    if (code == 0) then
        GUIRoot.ShowPanel("MessagePanel", { "绑定成功" })
        local username = this.bind_username_input_.text
        local password = this.bind_password_input_.text
        PlayerPrefs.SetString('username', username)
        PlayerPrefs.SetString('password', password)
        PlayerPrefs.Save()
        this.login_username_ = username
        this.login_password_ = password
        this.cur_token_ = ss.token
        StartPanel.CloseBindPanel()
        StartPanel.ShowStartGamePanel()
    elseif code == 1 then
        GUIRoot.ShowPanel("MessagePanel", { "游客账号无效" })
    else
        StartPanel.ShowFailMessage(code)
    end
end

function StartPanel.BindFailCallBack()
    StartPanel.HttpFail()
end

function StartPanel.OnCloseBindClick(obj)
    StartPanel.CloseBindPanel()
    StartPanel.ShowLoginPanel()
end
---------------------------------------------------------------------------
function StartPanel.HttpFail()
    GUIRoot.ClosePanel("MaskPanel")
    GUIRoot.ShowPanel("MessagePanel", { "服务器连接失败,请检查网络连接" })
end

function StartPanel.DisConnect()
    GUIRoot.ShowPanel("MessagePanel", { "与服务器断开连接" })
end

function StartPanel.ShowFailMessage(code)
    if (code == -1) then
        GUIRoot.ShowPanel("MessagePanel", { "邮箱已注册" })
    elseif (code == -2) then
        GUIRoot.ShowPanel("MessagePanel", { "未注册用户" })
    elseif (code == -3) then
        GUIRoot.ShowPanel("MessagePanel", { "邮箱格式错误" })
    elseif (code == -4) then
        GUIRoot.ShowPanel("MessagePanel", { "密码错误" })
    elseif (code == -5) then
        GUIRoot.ShowPanel("MessagePanel", { "邮件发送错误" })
    elseif (code == -6) then
        GUIRoot.ShowPanel("MessagePanel", { "长度错误" })
    else
        GUIRoot.ShowPanel("MessagePanel", { "预期之外的错误" })
    end
end

-------------------------------测试用(无账号服)-------------------------------------

function StartPanel.ShowTestPanel()
    StartPanel.SetData()
    local test_login_panel_ = this.transform:Find("panel_among/test_login_panel")
    test_login_panel_.gameObject:SetActive(true)
    local login_username_input = this.transform:Find("panel_among/test_login_panel/back_ground/panel_among/login_username_input"):GetComponent("InputField")
    local login_password_input = this.transform:Find("panel_among/test_login_panel/back_ground/panel_among/login_password_input"):GetComponent("InputField")
    if this.had_account_ then
        login_username_input.text = PlayerPrefs.GetString("username")
        login_password_input.text = PlayerPrefs.GetString("password")
    else
        login_username_input.text = ""
        login_password_input.text = ""
    end
    local test_sure_login_btn_ = this.transform:Find("panel_among/test_login_panel/back_ground/panel_among/test_sure_login_btn")
    GameSys.ButtonRegister(this.lua_script_, test_sure_login_btn_.gameObject, "click", StartPanel.OnTestLoginClick)
end

function StartPanel.OnTestLoginClick(obj)
    local login_username_input = this.transform:Find("panel_among/test_login_panel/back_ground/panel_among/login_username_input"):GetComponent("InputField")
    local login_password_input = this.transform:Find("panel_among/test_login_panel/back_ground/panel_among/login_password_input"):GetComponent("InputField")
    local username = login_username_input.text
    if username == "" then
        GUIRoot.ShowPanel("MessagePanel", { "账号不能为空" })
        return
    end
    this.cur_token_ = username
    local password = login_password_input.text
    this.login_password_ = password
    PlayerPrefs.SetString("username", username)
    PlayerPrefs.SetString("password", password)
    GameTcp.Connect("192.168.2.147", 9001)
end

