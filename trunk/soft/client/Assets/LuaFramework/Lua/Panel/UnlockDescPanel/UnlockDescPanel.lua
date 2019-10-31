UnlockDescPanel = {}
UnlockDescPanel.Control = {}
local this = UnlockDescPanel.Control

function UnlockDescPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.unlock_condition_ = this.transform_:Find("back/unlock_condition"):GetComponent("LocalizationText")
    this.unlock_desc_ = this.transform_:Find("back/unlock_desc"):GetComponent("LocalizationText")
    UnlockDescPanel.RegisterBtnListers()
end

function UnlockDescPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.gameObject_.gameObject, "click", UnlockDescPanel.Close)
end

function UnlockDescPanel.OnParam(param)
    local unlock_id_ = param[1]
    UnlockDescPanel.Init(unlock_id_)
end

function UnlockDescPanel.OnDestroy()
    this = {}
end

function UnlockDescPanel.Init(unlock_id)
    if unlock_id ~= nil then
        local unlock = Config.get_config_value("t_unlock", unlock_id)
        if unlock ~= nil then
            this.unlock_desc_.text = unlock.desc
            this.unlock_condition_.text = string.format("解锁条件: %s", unlock.condition)
        end
    end
end

function UnlockDescPanel.Close()
    GUIRoot.ClosePanel("UnlockDescPanel")
end



