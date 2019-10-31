ChangeSpellPanel = {}

ChangeSpellPanel.WearType = {
    auto = 1,
    manual = 2
}
ChangeSpellPanel.cur_wear_type = 2

ChangeSpellPanel.Control = {}
local this = ChangeSpellPanel.Control

function ChangeSpellPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.null_spell_desc_ = this.transform_:Find("back_image/panel_among/null_spell_desc")
    this.content_root_ = this.transform_:Find("back_image/panel_among/scroll_rect/content_root")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.spell_slot_ = this.transform_:Find("back_image/panel_among/spell_slot")

    this.cur_slot_index_ = 0 --玩家技能槽的序号
    this.wear_spell_id_ = 0 --最终佩戴的技能id
    this.spell_slot_states_ = {}

    ChangeSpellPanel.RegisterBtnListers()
    ChangeSpellPanel.RegisterMessage()
    ChangeSpellPanel.InitUIScroll()
end

function ChangeSpellPanel.OnDestroy(obj)
    ChangeSpellPanel.RemoveMessage()
    this = {}
end

function ChangeSpellPanel.OnParam(params)
    this.cur_slot_index_ = params[1]
end

function ChangeSpellPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ChangeSpellPanel.OnCloseBtnClick)
end

function ChangeSpellPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_SPELL_WEAR, ChangeSpellPanel.WearSpellSuccess)
    Message.register_net_handle(opcodes.SMSG_SPELL_PASSIVE_WEAR, ChangeSpellPanel.WearPassiveSuccess)
end

function ChangeSpellPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_SPELL_WEAR, ChangeSpellPanel.WearSpellSuccess)
    Message.remove_net_handle(opcodes.SMSG_SPELL_PASSIVE_WEAR, ChangeSpellPanel.WearPassiveSuccess)
end

function ChangeSpellPanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab = this.spell_slot_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function (go, index)
        ChangeSpellPanel.SetSpellSlots(go, index + 1)
        go:SetActive(true)
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function ChangeSpellPanel.Start(obj)
    ChangeSpellPanel.RefreshPanel()
end

function ChangeSpellPanel.RefreshPanel()
    ChangeSpellPanel.SetData()
    this.ui_scroll_grid_:SetData(#this.spell_slot_states_)
    this.null_spell_desc_.gameObject:SetActive(next(this.spell_slot_states_) == nil)
end

function ChangeSpellPanel.SetData()
    local spell_ids = {}
    spell_ids = PlayerData.player.spell_passive_ids
    this.spell_slot_states_ = {}

    for i = 1, #spell_ids do
        local t =  {
            ["id"] = nil,
            ["t_config"] = nil,
            ["is_in_cur_slot"] = nil,
        }
        local cur_slot_spell_id = 0
        local is_in_cur_slot = false
        local is_weared = false
        local t_config_name = ""
        is_weared = GameSys.IsPassiveWeared(spell_ids[i])
        cur_slot_spell_id = PlayerData.player.spell_passive_slots[this.cur_slot_index_]
        t_config_name = "t_spell_passive"
        is_in_cur_slot = (cur_slot_spell_id == spell_ids[i])
        if is_in_cur_slot then
            t.is_in_cur_slot = true
            t.id = spell_ids[i]
            t.t_config = Config.get_config_value(t_config_name, spell_ids[i])
            table.insert(this.spell_slot_states_, t)
        else
            if not is_weared then
                t.is_in_cur_slot = false
                t.id = spell_ids[i]
                t.t_config = Config.get_config_value(t_config_name, spell_ids[i])
                table.insert(this.spell_slot_states_, t)
            end
        end
    end
    table.sort(this.spell_slot_states_, function (a, b)
        if a.is_in_cur_slot then
            return true
        end
        if b.is_in_cur_slot then
            return false
        end
        return a.id < b.id
    end)
end

function ChangeSpellPanel.SetSpellSlots(go, sort)
    local spell_slot_state =  this.spell_slot_states_[sort]
    local slot_ins = nil
    slot_ins = CommonPanel.GetPassiveSlot(spell_slot_state.t_config.id, this.lua_script_, {spell_slot_state.is_in_cur_slot, ChangeSpellPanel.OnChangeBtnClick, {sort}, "change_spell_btn_"..sort})
    Util.ClearChild(go.transform)
    slot_ins.transform:SetParent(go.transform, false)
    slot_ins:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
end

function ChangeSpellPanel.OnChangeBtnClick(obj, params)
    local index = params[1]
    this.wear_spell_id_ = this.spell_slot_states_[index].id
    ChangeSpellPanel.ChangePassive(this.wear_spell_id_, this.cur_slot_index_)
end

function ChangeSpellPanel.ChangeSpell(spell_id, slot_index)
    ChangeSpellPanel.cur_wear_type = ChangeSpellPanel.WearType.manual
    local msg = item_msg_pb.cmsg_spell_wear()
    msg.spell_id = spell_id
    msg.slot = slot_index
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_SPELL_WEAR, data, { opcodes.SMSG_SPELL_WEAR })
end

function ChangeSpellPanel.ChangePassive(id, slot_index)
    ChangeSpellPanel.cur_wear_type = ChangeSpellPanel.WearType.manual
    local msg = item_msg_pb.cmsg_spell_passive_wear()
    msg.spell_passive_id = id
    msg.slot = slot_index
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_SPELL_PASSIVE_WEAR, data, { opcodes.SMSG_SPELL_PASSIVE_WEAR })
end

function ChangeSpellPanel.OnCloseBtnClick(obj)
    ChangeSpellPanel.Close()
end

function ChangeSpellPanel.WearSpellSuccess(message)
    if ChangeSpellPanel.cur_wear_type ~= ChangeSpellPanel.WearType.manual then
        return
    end
    if this.wear_spell_id_ == PlayerData.player.spell_slots[this.cur_slot_index_] then
        PlayerData.player.spell_slots[this.cur_slot_index_] = 0
    else
        local old_index = GameSys.getIndex(PlayerData.player.spell_slots, this.wear_spell_id_)
        if old_index ~= nil then
            PlayerData.player.spell_slots[old_index] = 0
        end
        PlayerData.player.spell_slots[this.cur_slot_index_] = this.wear_spell_id_
        PlayerData.task_operation(8)
    end
    ChangeSpellPanel.ChangeDone()
end

function ChangeSpellPanel.WearPassiveSuccess(message)
    if ChangeSpellPanel.cur_wear_type ~= ChangeSpellPanel.WearType.manual then
        return
    end
    if this.wear_spell_id_ == PlayerData.player.spell_passive_slots[this.cur_slot_index_] then
        PlayerData.player.spell_passive_slots[this.cur_slot_index_] = 0
    else
        local old_index = GameSys.getIndex(PlayerData.player.spell_passive_slots, this.wear_spell_id_)
        if old_index ~= nil then
            PlayerData.player.spell_passive_slots[old_index] = 0
        end
        PlayerData.player.spell_passive_slots[this.cur_slot_index_] = this.wear_spell_id_
    end
    ChangeSpellPanel.ChangeDone()
end

function ChangeSpellPanel.ChangeDone()
    local msg = CommonMessage()
    msg.name = "change_spell_success"
    messMgr:AddCommonMessage(msg)

    local common_msg = CommonMessage()
    common_msg.name = "check_power"
    messMgr:AddCommonMessage(common_msg)
    ChangeSpellPanel.Close()
end

function ChangeSpellPanel.Close()
    GUIRoot.ClosePanel("ChangeSpellPanel")
end