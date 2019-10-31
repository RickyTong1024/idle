SelectPanel = {}

--启动事件--
SelectPanel.Control = {}
local this = SelectPanel.Control
function SelectPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.single_panel = this.transform_:Find("background_image/panel_botton/single_panel")
    this.double_panel = this.transform_:Find("background_image/panel_botton/double_panel")
    local btn_single = this.single_panel:Find('single')
    local btn_double_yes = this.double_panel:Find('ok')
    local btn_double_no = this.double_panel:Find('cancel')
    this.label_des_ = this.transform_:Find("background_image/panel_center/desc"):GetComponent('LocalizationText')
    GameSys.ButtonRegister(this.lua_script_, btn_single.gameObject, "click", SelectPanel.SingleSelect)
    GameSys.ButtonRegister(this.lua_script_, btn_double_yes.gameObject, "click", SelectPanel.DoubleSelectYes)
    GameSys.ButtonRegister(this.lua_script_, btn_double_no.gameObject, "click", SelectPanel.DoubleSelectNo)
    this.single_func_ = nil
    this.double_func_yes_ = nil
    this.double_func_no_ = nil
    this.gameObject_:SetActive(false)
end

function SelectPanel.OnDestroy()
    this = {}
end

function SelectPanel.OnParam(param)
    this.single_func_ = nil
    this.double_func_yes_ = nil
    this.double_func_no_ = nil
    if(#param <= 2) then
        SelectPanel.ShowSingleDialog(param)
    else
        SelectPanel.ShowDoubleDialog(param)
    end
end

function SelectPanel.OnReParam(param)
    SelectPanel.OnParam(param)
end

function SelectPanel.ShowSingleDialog(param)
    this.label_des_.text = param[1]
    this.single_func_ = param[2]
    this.single_panel.gameObject:SetActive(true)
    this.gameObject_.gameObject:SetActive(true)
end

function SelectPanel.ShowDoubleDialog(param)
    this.label_des_.text = param[1]
    this.double_func_yes_ = param[2]
    this.double_func_no_ = param[3]
    this.double_panel.gameObject:SetActive(true)
    this.gameObject_.gameObject:SetActive(true)
end

function SelectPanel.SingleSelect()
    if(this.single_func_ ~= nil) then
        this.single_func_()
    end
    GUIRoot.ClosePanel("SelectPanel")
end

function SelectPanel.DoubleSelectYes()
    if(this.double_func_yes_ ~= nil) then
        this.double_func_yes_()
    end
    GUIRoot.ClosePanel("SelectPanel")
end

function SelectPanel.DoubleSelectNo()
    if(this.double_func_no_ ~= nil) then
        this.double_func_no_()
    end
    GUIRoot.ClosePanel("SelectPanel")
end


