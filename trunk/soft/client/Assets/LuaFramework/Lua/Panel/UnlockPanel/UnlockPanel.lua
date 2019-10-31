UnlockPanel = {}

UnlockPanel.Control = {}
local this = UnlockPanel.Control
UnlockPanel.open_count_ = 0

UnlockPanel.SHOW_TYPE = {
    unlock_nol = 0,
    unlock_forge = 1,
    unlock_equip_book = 2,
    unlock_rush_level = 3,
    unlock_artifact_book = 4
}

function UnlockPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

    this.back_ = this.transform_:Find("back")
    this.unlock_name_ = this.transform_:Find("back/unlock_name"):GetComponent("LocalizationText")
    this.unlock_desc_ = this.transform_:Find("back/unlock_desc"):GetComponent("LocalizationText")
    this.unloc_tag_icon_ = this.transform_:Find("back/unloc_tag_icon")
    this.time_ = nil
    this.unlock_index_ = 1
    this.unlock_ids_ = {}
    this.unlock_type_ = {}
    UnlockPanel.open_count_ = UnlockPanel.open_count_ + 1
end

function UnlockPanel.RegisterBtnListers()
end

function UnlockPanel.OnDestroy()
    UnlockPanel.open_count_ = UnlockPanel.open_count_ - 1
    if UnlockPanel.open_count_ ~= 0 then
        return
    end
    this.unlock_ids_ ={}
    this.unlock_type_ = {}
    UpdateBeat:Remove(UnlockPanel.Update, UnlockPanel)
    this = {}
end

function UnlockPanel.OnParam(param)
    local temp_unlock_data = param[1]
    local unlock_type = param[2]
    this.unlock_index_ = 1
    this.time_ = 2
    UnlockPanel.SetUnlockData(unlock_type, temp_unlock_data)
    UnlockPanel.Init()
    UpdateBeat:Remove(UnlockPanel.Update, UnlockPanel)
    UpdateBeat:Add(UnlockPanel.Update, UnlockPanel)
end

function UnlockPanel.SetUnlockData(u_type, u_data)
    for i = 1, #u_data do
        table.insert(this.unlock_ids_, u_data[i])
        table.insert(this.unlock_type_, u_type)
    end
end

function UnlockPanel.OnReParam(param)
    local temp_unlock_data = param[1]
    local unlock_type = param[2]
    UnlockPanel.SetUnlockData(unlock_type, temp_unlock_data)
end

function UnlockPanel.Init()
    if this.unlock_ids_[this.unlock_index_] ~= nil then
        soundMgr:play_sound("unlock")
        if this.unlock_type_[this.unlock_index_] == UnlockPanel.SHOW_TYPE.unlock_nol then
            local unlock = Config.get_config_value("t_unlock", this.unlock_ids_[this.unlock_index_])
            this.unloc_tag_icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "get"):GetSprite(unlock.icon)
            this.unlock_name_.text = unlock.name
            this.unlock_desc_.text = unlock.desc
        elseif this.unlock_type_[this.unlock_index_] == UnlockPanel.SHOW_TYPE.unlock_equip_book then
            local equip = Config.get_config_value("t_equip", this.unlock_ids_[this.unlock_index_])
            this.unlock_name_.text = "套装解锁"
            this.unlock_desc_.text = equip.name
            this.unloc_tag_icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "equip"):GetSprite(equip.icon)
        elseif this.unlock_type_[this.unlock_index_] == UnlockPanel.SHOW_TYPE.unlock_artifact_book then
            local artifact = Config.get_config_value("t_artifact", this.unlock_ids_[this.unlock_index_])
            this.unlock_name_.text = "神器解锁"
            this.unlock_desc_.text = artifact.name
            this.unloc_tag_icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "artifact"):GetSprite(artifact.icon)
        end
    end
end

function UnlockPanel.Update()
    this.time_ = this.time_ - Time.deltaTime
    if this.time_ <= 0 then
        this.time_ = 2
        this.unlock_index_ = this.unlock_index_ + 1
        if this.unlock_ids_[this.unlock_index_] ~= nil then
            UnlockPanel.Init()
            this.back_:GetComponent("Animator"):Play("falling", 0, 0)
        else
            UnlockPanel.Close()
        end
    end
end

function UnlockPanel.Close()
    GUIRoot.ClosePanel("UnlockPanel")
end



