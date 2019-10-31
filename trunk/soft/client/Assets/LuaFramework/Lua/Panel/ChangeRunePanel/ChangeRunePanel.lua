ChangeRunePanel = {}
ChangeRunePanel.Control = {}
local this = ChangeRunePanel.Control
ChangeRunePanel.ChangeRuneType = {
    wear = 1,
    unload = 2,
    change = 3
}

function ChangeRunePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.content_root_ = this.transform_:Find("back_image/panel_among/scroll_rect/content_root")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.null_spell_desc_ = this.transform_:Find("back_image/panel_among/null_spell_desc")
    this.rune_slot_ = this.transform_:Find("back_image/panel_among/rune_slot")

    this.cur_equip_slot_type_ = 0
    this.cur_rune_slot_index_ = 0
    this.cur_rune_slot_weard_ = false
    this.cur_slot_rune_id_ = 0
    this.cur_change_type_ = ChangeRunePanel.ChangeRuneType.wear
    this.cur_change_rune_id_ = 0
    this.runes_ = {}

    ChangeRunePanel.RegisterBtnListers()
    ChangeRunePanel.RegisterMessage()
    ChangeRunePanel.InitUIScroll()
end

function ChangeRunePanel.OnDestroy(obj)
    ChangeRunePanel.RemoveMessage()
    this = {}
end

function ChangeRunePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ChangeRunePanel.OnCloseBtnClick)
end

function ChangeRunePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_RUNE_WEAR, ChangeRunePanel.ChangeRuneSuccess)
end

function ChangeRunePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_RUNE_WEAR, ChangeRunePanel.ChangeRuneSuccess)
end

function ChangeRunePanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab =this.rune_slot_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function(go, index)
        ChangeRunePanel.SetRuneSlot(go, index + 1)
        if not go.activeSelf then
            go:SetActive(true)
        end
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function ChangeRunePanel.OnParam(params)
    this.cur_equip_slot_type_ = params[1]
    this.cur_rune_slot_index_ = params[2]
end

function ChangeRunePanel.Start(obj)
    ChangeRunePanel.RefreshPanel()
end

function ChangeRunePanel.RefreshPanel()
    ChangeRunePanel.SetData()
    this.ui_scroll_grid_:SetData(#this.runes_)
    this.null_spell_desc_.gameObject:SetActive(next(this.runes_) == nil)
end

function ChangeRunePanel.SetData()
    this.runes_ = {}
    local cur_slot_states = {}
    table.insert(cur_slot_states, PlayerData.player.rune_slot1s)
    table.insert(cur_slot_states, PlayerData.player.rune_slot2s)
    table.insert(cur_slot_states, PlayerData.player.rune_slot3s)
    local remove_types = {}
    for i = 1, #cur_slot_states do
        if i ~= this.cur_rune_slot_index_ then
            local id = cur_slot_states[i][this.cur_equip_slot_type_]
            local type = 0
            if id ~= 0 then
                type = Config.get_config_value("t_rune", id).type
            end
            table.insert(remove_types, type)
        end
    end
    local slot_rune_id = cur_slot_states[this.cur_rune_slot_index_][this.cur_equip_slot_type_]
    this.cur_slot_rune_id_ = slot_rune_id
    this.cur_rune_slot_weard_ = (slot_rune_id ~= 0)
    local cur_rune_num = 0
    for i = 1, #PlayerData.player.rune_ids do
        if PlayerData.player.rune_ids[i] == this.cur_slot_rune_id_ then
            cur_rune_num = PlayerData.player.rune_nums[i]
            break
        end
    end
    if cur_rune_num == 0 and this.cur_rune_slot_weard_ then
        table.insert(this.runes_, {
            ["rune_id"] = this.cur_slot_rune_id_,
            ["t_rune"] = Config.get_config_value("t_rune", this.cur_slot_rune_id_),
            ["rune_num"] = 0,
            ["is_weared"] = true
        })
    end
    for i = 1, #PlayerData.player.rune_ids do
        local t = {
            ["rune_id"] = 0,
            ["t_rune"] = nil,
            ["rune_num"] = 0,
            ["is_weared"] = false
        }
        local rune_id = PlayerData.player.rune_ids[i]
        t.rune_id = rune_id
        local t_rune = Config.get_config_value("t_rune", rune_id)
        t.t_rune = t_rune
        t.rune_num = PlayerData.player.rune_nums[i]
        t.is_weared = (this.cur_slot_rune_id_ == rune_id)
        if t_rune ~= nil then
            if t_rune.type ~= remove_types[1] and t_rune.type ~= remove_types[2] then
                table.insert(this.runes_, t)
            end
        end
    end
    table.sort(this.runes_, function (a, b)
        if a.is_weared then
            return true
        end
        if b.is_weared then
            return false
        end
        if a.rune_id % 1000 > b.rune_id % 1000 then
            return true
        elseif a.rune_id % 1000 < b.rune_id % 1000 then
            return false
        else
            return a.t_rune.type > b.t_rune.type
        end
    end)
end

function ChangeRunePanel.SetRuneSlot(slot_ins, sort)
    local rune_state= this.runes_[sort]
    if slot_ins.transform.childCount > 0 then
        local child = slot_ins.transform:GetChild(0)
        local btn = child:GetChild(3)
        this.lua_script_:RemoveButtonEvent(btn.gameObject, "click")
    end
    Util.ClearChild(slot_ins.transform)
    local rune_ins = CommonPanel.GetRuneChangeSlot(rune_state.rune_id, this.lua_script_, {rune_state.is_weared, ChangeRunePanel.OnChangeBtnClick, {sort}, "change_rune_btn_"..sort})
    local desc_text = rune_ins.transform:Find("text_root/desc_text")
    desc_text.gameObject:SetActive(true)
    desc_text:GetComponent("Text").text = "数量:"..rune_state.rune_num
    rune_ins.transform:SetParent(slot_ins.transform, false)
    rune_ins:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
end

function ChangeRunePanel.OnChangeBtnClick(obj, params)
    local index = params[1]
    local rune = this.runes_[index]
    this.cur_change_rune_id_ = rune.rune_id
    local msg = item_msg_pb.cmsg_rune_wear()
    if this.cur_rune_slot_weard_ then
        if this.cur_slot_rune_id_ == this.cur_change_rune_id_ then
            this.cur_change_type_ = ChangeRunePanel.ChangeRuneType.unload  --卸下
        else
            this.cur_change_type_ = ChangeRunePanel.ChangeRuneType.change  -- 更换
        end
    else
        if rune.rune_num <= 0 then
            GUIRoot.ShowPanel("MessagePanel",  {"数量不足"})
            return
        end
        this.cur_change_type_ = ChangeRunePanel.ChangeRuneType.wear  --装备
    end
    msg.type = this.cur_change_type_
    msg.slot = this.cur_equip_slot_type_
    msg.rune_slot = this.cur_rune_slot_index_
    msg.rune_id = this.cur_change_rune_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_RUNE_WEAR ,data, {opcodes.SMSG_RUNE_WEAR})
end

function ChangeRunePanel.ChangeRuneSuccess(message)
    --this.cur_change_type_ 更换的类型
    --this.cur_equip_slot_type_ 装备槽类型
    --this.cur_rune_slot_index_ 宝石槽序号
    --this.cur_change_rune_id_ 当前更换的宝石id
    --在这里处理更换成功的逻辑
    if this.cur_rune_slot_index_ == 1 then
        if this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.wear then
            PlayerData.player.rune_slot1s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.unload then
            PlayerData.add_rune(PlayerData.player.rune_slot1s[this.cur_equip_slot_type_], 1)
            PlayerData.player.rune_slot1s[this.cur_equip_slot_type_] = 0
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.change then
            PlayerData.add_rune(PlayerData.player.rune_slot1s[this.cur_equip_slot_type_], 1)
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
            PlayerData.player.rune_slot1s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
        end
    elseif this.cur_rune_slot_index_ == 2 then
        if this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.wear then
            PlayerData.player.rune_slot2s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.unload then
            PlayerData.add_rune(PlayerData.player.rune_slot2s[this.cur_equip_slot_type_], 1)
            PlayerData.player.rune_slot2s[this.cur_equip_slot_type_] = 0
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.change then
            PlayerData.add_rune(PlayerData.player.rune_slot2s[this.cur_equip_slot_type_], 1)
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
            PlayerData.player.rune_slot2s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
        end
    elseif this.cur_rune_slot_index_ == 3 then
        if this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.wear then
            PlayerData.player.rune_slot3s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.unload then
            PlayerData.add_rune(PlayerData.player.rune_slot3s[this.cur_equip_slot_type_], 1)
            PlayerData.player.rune_slot3s[this.cur_equip_slot_type_] = 0
        elseif this.cur_change_type_ == ChangeRunePanel.ChangeRuneType.change then
            PlayerData.add_rune(PlayerData.player.rune_slot3s[this.cur_equip_slot_type_], 1)
            PlayerData.remove_rune(this.cur_change_rune_id_, 1)
            PlayerData.player.rune_slot3s[this.cur_equip_slot_type_] = this.cur_change_rune_id_
        end
    end
    local msg = CommonMessage()
    msg.name = "change_rune_success"
    messMgr:AddCommonMessage(msg)

    local common_msg = CommonMessage()
    common_msg.name = "check_power"
    messMgr:AddCommonMessage(common_msg)
    ChangeRunePanel.Close()
end

function ChangeRunePanel.OnCloseBtnClick(obj)
    ChangeRunePanel.Close()
end

function ChangeRunePanel.Close()
    GUIRoot.ClosePanel("ChangeRunePanel")
    local equip_guid = PlayerData.player.equip_slots[this.cur_equip_slot_type_]
    if equip_guid ~= 0 then
        GUIRoot.ShowPanel("EquipInlayPanel", {equip_guid, this.cur_equip_slot_type_})
    end
end