LoadingPanel = {}
LoadingPanel.Control = {}
local this = LoadingPanel.Control

function LoadingPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.ani_ = this.transform_:Find("ani")
end

function LoadingPanel.OnEnable()
    this.transform_:SetAsLastSibling()
    this.is_mid_ = false
    this.rad_ = 90
    if State.cur_state ~= State.state.ss_null then
        this.rad_ = 0
    end
    this.call_back_ = nil
    this.call_back_params_ = nil
    UpdateBeat:Add(LoadingPanel.Update, LoadingPanel)
end

function LoadingPanel.OnDisable()
    UpdateBeat:Remove(LoadingPanel.Update, LoadingPanel)
end

function LoadingPanel.OnDestroy()
    this = {}
end

function LoadingPanel.OnParam(params)
    this.call_back_ = params[1]
    this.call_back_params_ = params[2]
end

function LoadingPanel.OnReParam(params)
    LoadingPanel.OnParam(params)
end

function LoadingPanel.Update()
    if this.rad_ <= 180 then
        this.rad_ = this.rad_ + Time.deltaTime * 120
        local alpha_value = math.sin(math.rad(this.rad_))
        this.ani_:GetComponent("CanvasGroup").alpha = alpha_value
        if this.rad_ >= 90 and not this.is_mid_ then
            this.is_mid_ = true
            if this.call_back_ ~= nil then
                this.call_back_(this.call_back_params_)
            end
        end
    else
        GUIRoot.ClosePanel("LoadingPanel")
    end
end

