EquipInlayPanel = {}
EquipInlayPanel.Control = {}
local this = EquipInlayPanel.Control

function EquipInlayPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.info_root_ = this.transform_:Find("back_ground/info_root")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.inlay_detail_ = this.transform_:Find("back_ground/panel_among/inlay_detail")
    this.rune_slot_ = this.transform_:Find("back_ground/rune_slot")

    this.equip_guid_ = "0"
    this.equip_type_ = 0
    this.inlay_states_ = {}
    this.equip_state_ = {}

    EquipInlayPanel.RegisterBtnListers()
    EquipInlayPanel.RegisterMessage()
end

function EquipInlayPanel.OnDestroy(obj)
    EquipInlayPanel.RemoveMessage()
    this = {}
end

function EquipInlayPanel.OnParam(params)
    this.equip_guid_ = params[1]
    this.equip_type_ = params[2]
end

function EquipInlayPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EquipInlayPanel.OnCloseClick)
end

function EquipInlayPanel.RegisterMessage()
    Message.register_handle("change_rune_success", EquipInlayPanel.ChangeRuneDone)
end

function EquipInlayPanel.RemoveMessage()
    Message.remove_handle("change_rune_success", EquipInlayPanel.ChangeRuneDone)
end

function EquipInlayPanel.Start(obj)
    EquipInlayPanel.RefreshPanel()
end

function EquipInlayPanel.RefreshPanel()
    EquipInlayPanel.SetData()
    EquipInlayPanel.CreateRunes()

    local enhance = GameSys.GetEquipEnhance(this.equip_state_.equip_info)
    local runes = GameSys.GetSlotRunes(this.equip_type_)
    CommonPanel.SetSlotEquipInfoPanel(this.equip_state_.equip_info, enhance, runes, this.lua_script_, this.info_root_)
end

function EquipInlayPanel.SetData()
    local equip_info = PlayerData.equips[this.equip_guid_]
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    this.equip_state_ = {
        ["guid"] = this.equip_guid_,
        ["equip_info"] = equip_info,
        ["t_equip"] = t_equip
    }
    local rune_states = {}
    table.insert(rune_states, PlayerData.player.rune_slot1s[this.equip_type_])
    table.insert(rune_states, PlayerData.player.rune_slot2s[this.equip_type_])
    table.insert(rune_states, PlayerData.player.rune_slot3s[this.equip_type_])
    this.inlay_states_ = {}
    for i = 1, #rune_states do
        local t = {
            ["index"] = 0,
            ["is_inlayed"] = false,
            ["rune_id"] = 0,
            ["t_rune"] = nil
        }
        if rune_states[i] == 0 then
            t.is_inlayed = false
            t.rune_id = 0
        else
            t.is_inlayed = true
            t.rune_id = rune_states[i]
            t.t_rune = Config.get_config_value("t_rune", t.rune_id)
        end
        t.index = i
        table.insert(this.inlay_states_, t)
    end
end

function EquipInlayPanel.CreateRunes()
    Util.ClearChild(this.inlay_detail_)
    for i = 1, #this.inlay_states_ do
        local slot_ins = GameObject.Instantiate(this.rune_slot_.gameObject)
        slot_ins.transform:SetParent(this.inlay_detail_, false)
        slot_ins:SetActive(true)
        local add_btn = slot_ins.transform:GetChild(0)
        local rune_slot_root = slot_ins.transform:Find("rune_slot_root")

        local inlay_state = this.inlay_states_[i]
        add_btn.gameObject:SetActive(not inlay_state.is_inlayed)
        rune_slot_root.gameObject:SetActive(inlay_state.is_inlayed)
        if inlay_state.is_inlayed then
            Util.ClearChild(rune_slot_root)
            local rune_slot_ins = CommonPanel.GetRuneChangeSlot(inlay_state.t_rune.id, this.lua_script_, {false, EquipInlayPanel.OnChangeRuneClick, {inlay_state.index}, "change_rune_btn_"..inlay_state.index})
            Util.SetRoot(rune_slot_ins.transform, rune_slot_root)
        else
            add_btn.gameObject.name = "add_rune_btn_" .. inlay_state.index
            GameSys.ButtonRegister(this.lua_script_, add_btn.gameObject, "click", EquipInlayPanel.OnChangeRuneClick, {inlay_state.index})
        end
    end
end

function EquipInlayPanel.OnChangeRuneClick(obj, params)
    local index = params[1]
    local state = this.inlay_states_[index]
    GUIRoot.ShowPanel("ChangeRunePanel", { this.equip_type_, index })
    GUIRoot.ClosePanel("EquipInlayPanel")
end

function EquipInlayPanel.OnCloseClick(obj)
    EquipInlayPanel.Close()
end

function EquipInlayPanel.Close()
    GUIRoot.ClosePanel("EquipInlayPanel")
    GUIRoot.ShowPanel("EquipDetailPanel", { this.equip_state_.equip_info, this.equip_type_ })
end

function EquipInlayPanel.ChangeRuneDone(message)
    EquipInlayPanel.RefreshPanel()
end