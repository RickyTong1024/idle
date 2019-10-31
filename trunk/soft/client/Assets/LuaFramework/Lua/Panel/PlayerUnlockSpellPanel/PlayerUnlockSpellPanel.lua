PlayerUnlockSpellPanel = {}
PlayerUnlockSpellPanel.Control = {}
local this = PlayerUnlockSpellPanel.Control

function PlayerUnlockSpellPanel.Awake(obj, lua_script_)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = lua_script_
    this.spell_root_ = this.transform_:Find("panel_among/spell_scroll_rect/spell_root")
    this.unlock_spell_slot_ = this.transform_:Find("panel_among/unlock_spell_slot")
    this.null_spell_desc_ = this.transform_:Find("panel_among/null_spell_desc")
    this.unlock_scroll_grid_ = this.spell_root_:GetComponent("UIScrollGrid")

    this.unlock_spells_ = {}
    this.cur_unlock_spell_id_ = 0
    this.cur_unlock_spell_ = nil
    this.cur_click_index_ = 0

    this.is_self_ = true

    PlayerUnlockSpellPanel.InitUnlockList()
end

function PlayerUnlockSpellPanel.OnParam(params)
    this.is_self_ = params[1]
    PlayerUnlockSpellPanel.RegisterMessage()
end

function PlayerUnlockSpellPanel.RegisterMessage()
    if this.is_self_ then
        Message.register_net_handle(opcodes.SMSG_SPELL_GET, PlayerUnlockSpellPanel.OnSpellUnlock)
        Message.register_net_handle(opcodes.SMSG_SPELL_UPGRADE, PlayerUnlockSpellPanel.OnSpellUpgrade)
    end
end

function PlayerUnlockSpellPanel.OnDestroy(obj)
    PlayerUnlockSpellPanel.RemoveMessage()
    this = {}
end

function PlayerUnlockSpellPanel.RemoveMessage()
    if this.is_self_ then
        Message.remove_net_handle(opcodes.SMSG_SPELL_GET, PlayerUnlockSpellPanel.OnSpellUnlock)
        Message.remove_net_handle(opcodes.SMSG_SPELL_UPGRADE, PlayerUnlockSpellPanel.OnSpellUpgrade)
    end
end

function PlayerUnlockSpellPanel.Show()
    this.gameObject_:SetActive(true)
    PlayerUnlockSpellPanel.RefreshPanel()
end

function PlayerUnlockSpellPanel.Close()
    this.gameObject_:SetActive(false)
end

function PlayerUnlockSpellPanel.DirectShow()
    GUIRoot.ShowPanel("PlayerPanel", {true, nil , 2, 1})
end

function PlayerUnlockSpellPanel.RefreshPanel()
    PlayerUnlockSpellPanel.SetData()
    PlayerUnlockSpellPanel.RefreshUnlockList()
end

function PlayerUnlockSpellPanel.RefreshUnlockList()
    this.null_spell_desc_.gameObject:SetActive(#this.unlock_spells_ == 0)
    this.unlock_scroll_grid_:SetData(#this.unlock_spells_)
end

function PlayerUnlockSpellPanel.SetData()
    this.unlock_spells_ = {}
    local spell_info = Config.t_spell
    local player_spells = {}
    for _, v in pairs(spell_info) do
        if v.type == 1 then
            table.insert(player_spells, v)
        end
    end
    table.sort(player_spells, function(a, b)
        if a.unlock_level < b.unlock_level then
            return true
        elseif a.unlock_level > b.unlock_level then
            return false
        else
            return a.id < b.id
        end
    end)
    for i = 1, #player_spells do
        local t = PlayerUnlockSpellPanel.SetSpellData(player_spells[i])
        if t ~= nil then
            table.insert(this.unlock_spells_, t)
        end
    end
end

function PlayerUnlockSpellPanel.SetSpellData(t_spell)
    local had_spell_level = 0
    if this.is_self_ then
        had_spell_level = GameSys.GetSpellLevel(t_spell.id)
    else
        local spell_ids = PlayerPanel.otherDate.spell_ids
        for i = 1, #spell_ids do
            if spell_ids[i] == t_spell.id then
                had_spell_level = PlayerPanel.otherDate.spell_levels[i]
                break
            end
        end
    end
    local had_spell = had_spell_level > 0
    local max_level = false
    local spell_level = 0
    local t_next_level = nil
    if had_spell_level == 0 then
        spell_level = had_spell_level + 1
        t_next_level = Config.get_config_value("t_spell_level", 1)
        max_level = false
    else
        spell_level = had_spell_level
        t_next_level = Config.get_config_value("t_spell_level", spell_level + 1)
        max_level = t_next_level == nil
    end
    local unlock_level = 0
    local unlock_mats = {}
    local can_unlock = false
    if not had_spell then
        unlock_level = t_spell.unlock_level
        if this.is_self_ then
            can_unlock = PlayerData.player.level >= unlock_level
        end
    else
        if not max_level then
            local spell_item_id = Config.get_config_value("t_const", "spell_item").value
            local num1 = t_next_level.num
            local cur_num1 = 0
            if this.is_self_ then
                cur_num1 = GameSys.GetItemCount(spell_item_id)
                can_unlock = (cur_num1 >= num1)
            end
            unlock_mats = {
                { item_id = spell_item_id, need_num = num1, cur_num = cur_num1 }
            }
        end
    end
    local t = {
        ["t_spell"] = t_spell,
        ["had_spell"] = had_spell,
        ["spell_level"] = spell_level,
        ["max_level"] = max_level,
        ["can_unlock"] = can_unlock,
        ["unlock_level"] = unlock_level,
        ["unlock_mats"] = unlock_mats,
        ["slot_ins"] = nil,
    }
    return t
end

function PlayerUnlockSpellPanel.InitUnlockList()
    Util.ClearChild(this.spell_root_)
    this.unlock_scroll_grid_.prefab = this.unlock_spell_slot_.gameObject
    this.unlock_scroll_grid_.SetDataHandle = function(go, index)
        PlayerUnlockSpellPanel.SetSpellSlots(go, index + 1)
        go:SetActive(true)
    end
    this.unlock_scroll_grid_:Init()
    this.unlock_scroll_grid_:SetData(0)
end

function PlayerUnlockSpellPanel.SetSpellSlots(slot_ins, sort)
    local unlock_spell = this.unlock_spells_[sort]
    unlock_spell.slot_ins = slot_ins
    local t_spell = unlock_spell.t_spell
    local had_spell = unlock_spell.had_spell
    local is_max = unlock_spell.max_level
    local spell_root= slot_ins.transform:Find("spell_root")
    local detail_btn = slot_ins.transform:GetChild(3)
    local shard_condition = slot_ins.transform:Find("unlock_condition/shard_condition")
    local level_condition = slot_ins.transform:Find("unlock_condition/level_condition")
    local other_desc = slot_ins.transform:Find("other_desc")
    local spell_slot = nil
    if this.is_self_ then
        spell_slot = CommonPanel.GetSpellSlot(t_spell.id, unlock_spell.spell_level, this.lua_script_, { nil, PlayerUnlockSpellPanel.OnSpellunlockClick, { sort }, "unlock_spell_btn_" .. sort })
    else
        spell_slot = CommonPanel.GetSpellSlot(t_spell.id, unlock_spell.spell_level, this.lua_script_, nil)
    end
    spell_slot.transform:Find("back_image").gameObject:SetActive(false)
    local red_point = spell_slot.transform:Find("icon_root"):GetChild(0):Find("red_point")
    red_point.gameObject:SetActive(unlock_spell.can_unlock)
    if this.is_self_ then
        local unlock_btn = spell_slot.transform:Find("unlock_spell_btn_" .. sort)
        local btn_image = unlock_btn:GetComponent("Image")
        local btn_text = unlock_btn:Find("desc_text"):GetComponent("Text")
        local btn_icon_alias = ""
        local btn_desc_color = ""
        local btn_desc = ""
        if not had_spell then
            btn_desc = "解锁"
        else
            btn_desc = is_max and "Max" or "升级"
        end
        if not unlock_spell.can_unlock then
            btn_icon_alias = GameSys.GetLockBtnIconAlias()
            btn_desc_color = GameSys.GetlockBtnColor()
        else
            btn_icon_alias = not had_spell and GameSys.GetUnlockBtnIconAlias() or GameSys.GetUpgradekBtnIconAlias()
            btn_desc_color = not had_spell and GameSys.GetUnlockBtnColor() or GameSys.GetUpgradeBtnColor()
        end
        btn_text.text = GameSys.SetTextColor(btn_desc_color, btn_desc)
        btn_image.sprite = GameSys:GetCommonAtlas():GetSprite(btn_icon_alias)
    end
    Util.ClearChild(spell_root)
    Util.SetRoot(spell_slot.transform, spell_root)
    other_desc.gameObject:SetActive(not this.is_self_)
    if not this.is_self_ then
        local d = had_spell and ( is_max and "Max" or "已解锁" ) or "未解锁"
        other_desc:GetComponent("Text").text = d
    end
    detail_btn.gameObject.name = "spell_detail_btn_" .. sort
    GameSys.ButtonRegister(this.lua_script_, detail_btn.gameObject, "click", PlayerUnlockSpellPanel.OnDetailClick, { sort })
    shard_condition.gameObject:SetActive(had_spell)
    level_condition.gameObject:SetActive(not had_spell or is_max)
    if not had_spell then
        local level = unlock_spell.unlock_level
        level_condition:GetComponent("Text").text = string.format("角色等级%d级解锁", level)
    end
    if had_spell then
        Util.ClearChild(shard_condition)
        if not is_max then
            for i = 1, #unlock_spell.unlock_mats do
                local asset = {
                    type = 2,
                    value1 = unlock_spell.unlock_mats[i].item_id,
                    value2 = 0,
                    value3 = 0
                }
                local mat_rect = CommonPanel.GetMatRect(asset, unlock_spell.unlock_mats[i].need_num, "mat_spell_shard_" .. i .. "_" .. sort, this.lua_script_)
                Util.SetRoot(mat_rect.transform, shard_condition)
            end
        else
            level_condition:GetComponent("Text").text = string.format("达到最大等级")
        end
    end
end

function PlayerUnlockSpellPanel.OnDetailClick(obj, params)
    local index = params[1]
    GUIRoot.ShowPanel("SpellDetailPanel", { this.unlock_spells_[index].t_spell , this.unlock_spells_[index].spell_level, this.unlock_spells_[index].had_spell })
end

function PlayerUnlockSpellPanel.OnSpellunlockClick(obj, params)
    local index = params[1]
    this.cur_click_index_ = index
    this.cur_unlock_spell_ = this.unlock_spells_[index]
    local can_lock = this.cur_unlock_spell_.can_unlock
    local t_spell = this.cur_unlock_spell_.t_spell
    if not can_lock then
        if not this.cur_unlock_spell_.had_spell then
            GUIRoot.ShowPanel("MessagePanel", { "玩家等级不足" })
            return
        else
            if this.cur_unlock_spell_.max_level then
                GUIRoot.ShowPanel("MessagePanel", { "达到最大等级,无法提升" })
                return
            else
                GUIRoot.ShowPanel("MessagePanel", { "材料不足" })
                return
            end
        end
    end
    this.cur_unlock_spell_id_ = t_spell.id
    if not this.cur_unlock_spell_.had_spell then
        local msg = item_msg_pb.cmsg_spell_get()
        msg.spell_id = this.cur_unlock_spell_id_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_SPELL_GET, data, { opcodes.SMSG_SPELL_GET })
    else
        local msg = item_msg_pb.cmsg_spell_upgrade()
        msg.spell_id = this.cur_unlock_spell_id_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_SPELL_UPGRADE, data, { opcodes.SMSG_SPELL_UPGRADE })
    end
end

function PlayerUnlockSpellPanel.OnSpellUnlock(messsage)
    table.insert(PlayerData.player.spell_ids, this.cur_unlock_spell_id_)
    table.insert(PlayerData.player.spell_levels, 1)
    GUIRoot.ShowPanel("MessagePanel", { "解锁成功" })
    soundMgr:play_sound("enhance_success")
    PlayerUnlockSpellPanel.RefreshSlot(this.cur_click_index_)
    local msg = CommonMessage()
    msg.name = "unlock_spell_success"
    messMgr:AddCommonMessage(msg)
end

function PlayerUnlockSpellPanel.OnSpellUpgrade(message)
    soundMgr:play_sound("enhance_success")
    GUIRoot.ShowPanel("MessagePanel", { "升级成功" })
    local sort = GameSys.getIndex(PlayerData.player.spell_ids, this.cur_unlock_spell_.t_spell.id)
    local t_spell_level = Config.get_config_value("t_spell_level", PlayerData.player.spell_levels[sort] + 1)

    local spell_item = Config.get_config_value('t_const', 'spell_item').value
    PlayerData.remove_item(spell_item, t_spell_level.num)
    PlayerData.player.spell_levels[sort] = PlayerData.player.spell_levels[sort] + 1
    PlayerUnlockSpellPanel.RefreshSlot(this.cur_click_index_)
    local msg = CommonMessage()
    msg.name = "upgrade_spell_success"
    messMgr:AddCommonMessage(msg)
end

function PlayerUnlockSpellPanel.RefreshSlot(index)
    local unlock = this.unlock_spells_[index]
    local t_spell = unlock.t_spell
    local t = PlayerUnlockSpellPanel.SetSpellData(t_spell)
    t.slot_ins = unlock.slot_ins
    this.unlock_spells_[index] = t
    PlayerUnlockSpellPanel.SetSpellSlots(t.slot_ins, index)
end











