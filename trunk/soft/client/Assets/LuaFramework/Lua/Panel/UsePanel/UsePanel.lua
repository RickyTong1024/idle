UsePanel = {}

UsePanel.Control = {}
local this = UsePanel.Control

function UsePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")
    
    this.target_name_text = this.transform_:Find("background_image/panel_center/target_name_text"):GetComponent("LocalizationText")
    this.target_icon = this.transform_:Find("background_image/panel_center/target_icon")
    this.count_text = this.transform_:Find("background_image/panel_center/target_counter/count/count_text"):GetComponent("LocalizationText")
    this.sub_btn = this.transform_:Find("background_image/panel_center/target_counter/count/sub_btn")
    this.add_btn = this.transform_:Find("background_image/panel_center/target_counter/count/add_btn")
    this.sub_ten_btn = this.transform_:Find("background_image/panel_center/target_counter/count/sub_btn/sub_ten_btn")
    this.add_ten_btn = this.transform_:Find("background_image/panel_center/target_counter/count/add_btn/add_ten_btn")
    this.target_btn_image = this.transform_:Find("background_image/panel_botton/target_btn_image")
    this.close_btn = this.transform_:Find("background_image/close_btn")
    this.btn_func = nil
    this.m_asset = {}
    this.select_num = 1
    UsePanel.RegisterBtnListers()
end

function UsePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.sub_btn.gameObject, "click", UsePanel.SubOne)
    GameSys.ButtonRegister(this.lua_script, this.add_btn.gameObject, "click", UsePanel.AddOne)
    GameSys.ButtonRegister(this.lua_script, this.sub_ten_btn.gameObject, "click", UsePanel.SubTen)
    GameSys.ButtonRegister(this.lua_script, this.add_ten_btn.gameObject, "click", UsePanel.AddTen)
    GameSys.ButtonRegister(this.lua_script, this.target_btn_image.gameObject, "click", UsePanel.UseFunction)
    GameSys.ButtonRegister(this.lua_script, this.close_btn.gameObject, "click", UsePanel.HidePanel)
end

function UsePanel.OnParam(param)
    this.m_asset = param[1]
    this.btn_func = param[2]
    UsePanel.Init()
end

function UsePanel.OnDestroy()
    this = {}
end
function UsePanel.SubOne()
    UsePanel.ShowCount(-1)
end

function UsePanel.AddOne()
    UsePanel.ShowCount(1)
end

function UsePanel.SubTen()
    UsePanel.ShowCount(-10)
end

function UsePanel.AddTen()
    UsePanel.ShowCount(10)
end

function UsePanel.ShowCount(num)
    this.select_num = this.select_num + num
    local player_item_num = GameSys.GetAssetCount(this.m_asset.type, this.m_asset.value1)
    if(this.select_num <= 0) then
        this.select_num = 1
    elseif(this.select_num > player_item_num)  then
        this.select_num = player_item_num
    elseif(this.select_num > 100) then
        this.select_num = 100
    end
    this.count_text.text = this.select_num
end

function UsePanel.UseFunction()
    if(this.btn_func ~= nil) then
        this.btn_func(this.select_num)
    else
        local str = "未知错误"
        GUIRoot.ShowPanel("MessagePanel", {str})
    end
end

function UsePanel.HidePanel()
    GUIRoot.ClosePanel("UsePanel")
end

function UsePanel.Start()
end

function UsePanel.Init()
    local icon_res = CommonPanel.GetIcon2type(this.m_asset, {}, this.lua_script)
    this.target_name_text.text = GameSys.GetAssetName(this.m_asset)
    this.count_text.text = this.select_num
    GameSys.ClearChild(this.target_icon)
    icon_res.transform:SetParent(this.target_icon, false)
    icon_res.transform.localScale = Vector3.one
    icon_res.transform.localPosition = Vector3.zero
end

