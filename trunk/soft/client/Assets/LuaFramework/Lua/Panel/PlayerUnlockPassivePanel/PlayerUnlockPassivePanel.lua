PlayerUnlockPassivePanel = {}
PlayerUnlockPassivePanel.Control = {}
local this = PlayerUnlockPassivePanel.Control

function PlayerUnlockPassivePanel.Awake(obj, lua_script)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = lua_script
    this.attach_root_ = this.transform_:Find("panel_among/attach_scroll_rect/attach_root")
    this.scroll_grid_ = this.attach_root_:GetComponent("UIScrollGrid")
    this.unlock_attach_slot_ = this.transform_:Find("panel_among/unlock_attach_slot")
    this.null_spell_desc_ = this.transform_:Find("panel_among/null_spell_desc")
    this.passive_root_ = this.transform_:Find("panel_among/passive_root")
    this.passive_slot_ = this.transform_:Find("passive_slot")

    this.passive_queues_ = {}  --所有被动的集合 一路为一组
    this.unlock_passives_ = {} --当前界面上要操作的被动
    this.cur_attach_queue_ = {} --当前正在操作的被动的那一路被动数组
    this.cur_unlock_passive_id_ = 0 --当前正在解锁的被动id
    this.change_passive_slot_index_ = 0 --解锁/升级 的被动在被动槽子上的的槽子索引
    this.cur_queue_index_ = 0 --当前解锁/升级 的被动在哪一路
    this.passive_slot_states_ = {} --所有被动槽子状态
    this.passive_slot_inss_ = {} --所有被动槽子实体

    this.is_self_ = true

    PlayerUnlockPassivePanel.InitScrollGrid()
end

function PlayerUnlockPassivePanel.OnDestroy(obj)
    PlayerUnlockPassivePanel.RemoveMessage()
    this = {}
end


function PlayerUnlockPassivePanel.OnParam(params)
    this.is_self_ = params[1]
    PlayerUnlockPassivePanel.RegisterMessage()
end

function PlayerUnlockPassivePanel.InitScrollGrid()
    this.scroll_grid_.prefab = this.unlock_attach_slot_.gameObject
    this.scroll_grid_.SetDataHandle = function(go, index)
        PlayerUnlockPassivePanel.SetAttchSlots(go, index + 1)
        go:SetActive(true)
    end
    this.scroll_grid_:Init()
    this.scroll_grid_:SetData(0)
end

function PlayerUnlockPassivePanel.RegisterMessage()
    if this.is_self_ then
        Message.register_net_handle(opcodes.SMSG_SPELL_PASSIVE_GET, PlayerUnlockPassivePanel.OnPassiveUnlock)
        Message.register_net_handle(opcodes.SMSG_SPELL_PASSIVE_WEAR, PlayerUnlockPassivePanel.ChangeAttachSlot)
        AssetsChangeControl.AddPetLevelChanged(PlayerUnlockPassivePanel.OnPetLevelChange)
        Message.register_handle("change_spell_success", PlayerUnlockPassivePanel.OnSelectPassiveDone)
    end
end

function PlayerUnlockPassivePanel.RemoveMessage()
    if this.is_self_ then
        Message.remove_net_handle(opcodes.SMSG_SPELL_PASSIVE_GET, PlayerUnlockPassivePanel.OnPassiveUnlock)
        Message.remove_net_handle(opcodes.SMSG_SPELL_PASSIVE_WEAR, PlayerUnlockPassivePanel.ChangeAttachSlot)
        AssetsChangeControl.RemovePetLevelChanged(PlayerUnlockPassivePanel.OnPetLevelChange)
        Message.remove_handle("change_spell_success", PlayerUnlockPassivePanel.OnSelectPassiveDone)
    end
end

function PlayerUnlockPassivePanel.Show()
    this.gameObject_:SetActive(true)
    PlayerUnlockPassivePanel.RefreshPanel()
end

function PlayerUnlockPassivePanel.Close()
    this.gameObject_:SetActive(false)
end

function PlayerUnlockPassivePanel.DirectShow()
    GUIRoot.ShowPanel("PlayerPanel", {true, nil , 2, 2})
end

function PlayerUnlockPassivePanel.RefreshPanel()
    PlayerUnlockPassivePanel.SetData()
    PlayerUnlockPassivePanel.SetPassiveSlotData()
    PlayerUnlockPassivePanel.RefreshUnlockList()
    PlayerUnlockPassivePanel.RefreshPassiveSlots()
end

function PlayerUnlockPassivePanel.RefreshUnlockList()
    this.null_spell_desc_.gameObject:SetActive(#this.unlock_passives_ == 0)
    this.scroll_grid_:SetData(#this.unlock_passives_)
end

function PlayerUnlockPassivePanel.RefreshPassiveSlots()
    for i = 1, #this.passive_slot_states_ do
        local passive_state = this.passive_slot_states_[i]
        if this.passive_slot_inss_[i] == nil then
            local passive_ins = GameObject.Instantiate(this.passive_slot_.gameObject)
            passive_ins:SetActive(true)
            this.passive_slot_inss_[i] = passive_ins
            passive_ins.transform:SetParent(this.passive_root_, false)
            PlayerUnlockPassivePanel.SetPassiveSlot(passive_ins, passive_state, i)
        else
            PlayerUnlockPassivePanel.SetPassiveSlot(this.passive_slot_inss_[i], passive_state, i)
        end
    end
end

function PlayerUnlockPassivePanel.SetPassiveSlot(slot_ins, passive_state, sort)
    local add_image = slot_ins.transform:Find("add_image")
    local mask = slot_ins.transform:Find("mask")
    local passive_icon = slot_ins.transform:Find("mask/passive_icon")
    local passive_name = slot_ins.transform:Find("name_text")
    add_image.gameObject:SetActive(not passive_state.had_passive)
    mask.gameObject:SetActive(passive_state.had_passive)
    passive_name.gameObject:SetActive(passive_state.had_passive)
    local btn = slot_ins.transform:GetComponent("Button")
    btn.gameObject.name = "change_passive_btn_"..sort
    btn.interactable = passive_state.can_click_change
    if passive_state.can_click_change then
        GameSys.ButtonRegister(this.lua_script_, btn.gameObject, "click", PlayerUnlockPassivePanel.OnChangePassiveClick, { sort })
    end
    if passive_state.had_passive then
        local icon_alias = passive_state.t_passive.icon
        if icon_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "spell"):GetSprite(icon_alias)
            if sprite ~= nil then
                passive_icon:GetComponent("Image").sprite = sprite
            end
        end
        passive_name:GetComponent("Text").text = passive_state.t_passive.name
    end
end

function PlayerUnlockPassivePanel.SetData()
    local spell_info = Config.t_spell_passive
    local player_attachs = {}
    for _, v in pairs(spell_info) do
        if v.class == PlayerData.player.role_id then
            table.insert(player_attachs, v)
        end
    end
    table.sort(player_attachs, function(a, b)
        return a.id < b.id
    end)
    this.passive_queues_ = {}
    for i = 1, #player_attachs do
        local t_passive = player_attachs[i]
        if GameSys.IsBasePassive(t_passive.id) then
            local passive_queue = PlayerUnlockPassivePanel.GetAttachQueue({ t_passive })
            table.insert(this.passive_queues_, passive_queue)
        end
    end
    local player_passive_ids = {}
    if this.is_self_ then
        player_passive_ids = PlayerData.player.spell_passive_ids
    else
        player_passive_ids = PlayerPanel.otherDate.spell_passive_ids
    end
    this.unlock_passives_ = {}
    for i = 1, #this.passive_queues_ do
        local queue = this.passive_queues_[i]
        local had_learned = false
        local t_passive = queue[1]
        for j = 1, #queue do
            if GameSys.hasInTable(player_passive_ids, queue[j].id) then
                t_passive = queue[j]
                had_learned = true
                break
            end
        end
        local t = PlayerUnlockPassivePanel.SetPassiveData(t_passive, i, had_learned)
        table.insert(this.unlock_passives_, t)
    end
end

function PlayerUnlockPassivePanel.SetPassiveSlotData()
    --被动佩戴情况
    local passive_ids = {}
    if this.is_self_ then
        passive_ids = PlayerData.player.spell_passive_slots
    else
        passive_ids = PlayerPanel.otherDate.spell_passive_slots
    end
    this.passive_slot_states_ = {}
    for i = 1, #passive_ids do
        local passive_state = {
            ["had_passive"] = false,
            ["t_passive"] = nil,
            ["can_click_change"] = false
        }
        passive_state.had_passive = passive_ids[i] ~= 0
        if passive_state.had_passive then
            passive_state.t_passive = Config.get_config_value("t_spell_passive", passive_ids[i])
        end
        passive_state.can_click_change = this.is_self_
        table.insert(this.passive_slot_states_, passive_state)
    end
end

function PlayerUnlockPassivePanel.SetPassiveData(t_passive, sort, had_learned)
    local is_base = GameSys.IsBasePassive(t_passive.id)
    local is_lock = is_base and not had_learned
    local is_max = false
    local next_spell = t_passive.next_spell
    is_max = next_spell == 0
    local t_next_passive = nil
    if is_lock then
        t_next_passive = t_passive
    else
        if not is_max then
            t_next_passive = Config.get_config_value("t_spell_passive", next_spell)
        end
    end
    local pet_conditions = {}
    if not is_max then
        for j = 1, #t_next_passive.unlock do
            local unlock = t_next_passive.unlock[j]
            if unlock.param1 ~= 0 then
                local p = {
                    ["pet_id"] = unlock.param1,
                    ["had_pet"] = false,
                    ["pet_guid"] = "0",
                    ["pet_level"] = 0,
                    ["need_level"] = unlock.param2,
                    ["level_enough"] = false
                }
                if this.is_self_ then
                    local had_pet, pet_guid = GameSys.HadPet(unlock.param1)
                    p.had_pet = had_pet
                    p.pet_guid = pet_guid
                    if had_pet then
                        p.pet_level = PlayerData.pets[pet_guid].level
                        p.level_enough = p.pet_level >= p.need_level
                    end
                end
                table.insert(pet_conditions, p)
            end
        end
    end

    local can_unlock = not is_max
    for i = 1, #pet_conditions do
        if not pet_conditions[i].level_enough then
            can_unlock = false
            break
        end
    end

    local t = {
        ["is_max"] = is_max,
        ["t_passive"] = t_passive,
        ["t_next_passive"] = t_next_passive,
        ["is_lock"] = is_lock,
        ["sort"] = sort,
        ["pet_conditions"] = pet_conditions,
        ["can_unlock"] = can_unlock,
        ["slot_ins"] = nil
    }
    return t
end

function PlayerUnlockPassivePanel.GetAttachQueue(t_passives)
    local passives = t_passives
    while passives[#passives].next_spell ~= "" do
        local t_spell = passives[#passives]
        local attach = Config.get_config_value("t_spell_passive", t_spell.next_spell)
        if attach == nil then
            return passives
        end
        table.insert(passives, attach)
    end
    return passives
end

function PlayerUnlockPassivePanel.SetAttchSlots(slot_ins, sort)
    local unlock_attach = this.unlock_passives_[sort]
    unlock_attach.slot_ins = slot_ins
    local t_passive = unlock_attach.t_passive
    local is_lock = unlock_attach.is_lock
    local is_max = unlock_attach.is_max

    local attach_root = slot_ins.transform:Find("attach_root")
    local detail_btn = slot_ins.transform:GetChild(3)
    local pet_condition = slot_ins.transform:Find("unlock_condition/pet_condition")
    local max_desc = slot_ins.transform:Find("max_desc")
    local other_desc = slot_ins.transform:Find("other_desc")
    local attach_slot = nil
    if this.is_self_ then
        attach_slot = CommonPanel.GetPassiveSlot(t_passive.id, this.lua_script_, { nil, PlayerUnlockPassivePanel.OnPassiveUnlockClick, { sort }, "unlock_attach_btn_" .. sort })
    else
        attach_slot = CommonPanel.GetPassiveSlot(t_passive.id, this.lua_script_, nil)
    end
    local red_point = attach_slot.transform:Find("icon_root"):GetChild(0):Find("red_point")
    red_point.gameObject:SetActive(unlock_attach.can_unlock)
    attach_slot.transform:Find("back_image").gameObject:SetActive(false)
    if this.is_self_ then
        local unlock_btn = attach_slot.transform:Find("unlock_attach_btn_" .. sort)
        local btn_image = unlock_btn:GetComponent("Image")
        local btn_text = unlock_btn:Find("desc_text"):GetComponent("Text")
        local btn_icon_alias = ""
        local btn_desc_color = ""
        local btn_desc = ""
        if is_lock then
            btn_desc = "解锁"
        else
            btn_desc = is_max and "Max" or "升级"
        end
        if not unlock_attach.can_unlock then
            btn_icon_alias = GameSys.GetLockBtnIconAlias()
            btn_desc_color = GameSys.GetlockBtnColor()
        else
            btn_icon_alias = is_lock and GameSys.GetUnlockBtnIconAlias() or GameSys.GetUpgradekBtnIconAlias()
            btn_desc_color = is_lock and GameSys.GetUnlockBtnColor() or GameSys.GetUpgradeBtnColor()
        end
        btn_text.text = GameSys.SetTextColor(btn_desc_color, btn_desc)
        btn_image.sprite = GameSys:GetCommonAtlas():GetSprite(btn_icon_alias)
    end
    other_desc.gameObject:SetActive(not this.is_self_)
    if not this.is_self_ then
        local d = is_lock and "未解锁" or (is_max and "Max" or "已解锁")
        other_desc:GetComponent("Text").text = d
    end
    Util.ClearChild(attach_root)
    Util.SetRoot(attach_slot.transform, attach_root)
    detail_btn.gameObject.name = "spell_detail_btn_" .. sort
    GameSys.ButtonRegister(this.lua_script_, detail_btn.gameObject, "click", PlayerUnlockPassivePanel.OnDetailClick, { sort })

    Util.ClearChild(pet_condition)
    if not is_max then
        for j = 1, #unlock_attach.pet_conditions do
            local pet_state = unlock_attach.pet_conditions[j]
            local asset = {
                type = 6,
                value1 = pet_state.pet_id,
                value2 = 0,
                value3 = 0
            }
            local mat_ins = CommonPanel.GetMatRect(asset, pet_state.need_level, "mat_" .. sort .. "pet_icon_btn_" .. j, this.lua_script_, this.is_self_)
            mat_ins.transform:SetParent(pet_condition)
            mat_ins.transform.localScale = Vector3.one
        end
    end
    max_desc.gameObject:SetActive(is_max)
end

function PlayerUnlockPassivePanel.OnDetailClick(obj, params)
    local index = params[1]
    local unlock_passive = this.unlock_passives_[index]
    local is_lock = unlock_passive.is_lock
    GUIRoot.ShowPanel("PassiveDetailPanel", { unlock_passive.t_passive, is_lock })
end

function PlayerUnlockPassivePanel.OnPassiveUnlockClick(obj, params)
    local index = params[1]
    this.cur_queue_index_ = index
    local unlock_attach = this.unlock_passives_[index]
    local can_unlock = unlock_attach.can_unlock
    local is_max = unlock_attach.is_max
    local t_passive = unlock_attach.t_passive
    if not can_unlock then
        if is_max then
            GUIRoot.ShowPanel("MessagePanel", { "达到提升上限,无法提升" })
        else
            GUIRoot.ShowPanel("MessagePanel", { "宠物条件不满足" })
        end
        return
    end
    if unlock_attach.is_lock then
        this.cur_unlock_passive_id_ = t_passive.id
    else
        this.cur_unlock_passive_id_ = unlock_attach.t_next_passive.id
    end
    this.cur_attach_queue_ = this.passive_queues_[unlock_attach.sort]
    local msg = item_msg_pb.cmsg_spell_passive_get()
    msg.spell_passive_id = this.cur_unlock_passive_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_SPELL_PASSIVE_GET, data, { opcodes.SMSG_SPELL_PASSIVE_GET })

end

function PlayerUnlockPassivePanel.OnPassiveUnlock(messsage)
    local unlock_passive = this.unlock_passives_[this.cur_queue_index_]
    local index = 0
    for i = 1, #this.cur_attach_queue_ do
        if this.cur_attach_queue_[i].id == this.cur_unlock_passive_id_ then
            index = i
            break
        end
    end
    if unlock_passive.is_lock then
        table.insert(PlayerData.player.spell_passive_ids, this.cur_unlock_passive_id_)
        GUIRoot.ShowPanel("MessagePanel", { "解锁成功" })
        soundMgr:play_sound("enhance_success")
        --刷新
        PlayerUnlockPassivePanel.RefreshSlot(index, this.cur_queue_index_)

        local msg = CommonMessage()
        msg.name = "unlock_passive_success"
        messMgr:AddCommonMessage(msg)

        this.change_passive_slot_index_ = 0
        for i = 1, #PlayerData.player.spell_passive_slots do
            if PlayerData.player.spell_passive_slots[i] == 0 then
                this.change_passive_slot_index_ = i
                break
            end
        end
        if this.change_passive_slot_index_ > 0 then
            ChangeSpellPanel.cur_wear_type = ChangeSpellPanel.WearType.auto
            local msg = item_msg_pb.cmsg_spell_passive_wear()
            msg.spell_passive_id = this.cur_unlock_passive_id_
            msg.slot = this.change_passive_slot_index_
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_SPELL_PASSIVE_WEAR, data, { opcodes.SMSG_SPELL_PASSIVE_WEAR })
        end
    else
        soundMgr:play_sound("enhance_success")
        GUIRoot.ShowPanel("MessagePanel", { "升级成功" })
        local pre_attach_id = this.cur_attach_queue_[index - 1].id
        local sort = GameSys.getIndex(PlayerData.player.spell_passive_ids, pre_attach_id)
        PlayerData.player.spell_passive_ids[sort] = this.cur_unlock_passive_id_
        --刷新
        PlayerUnlockPassivePanel.RefreshSlot(index, this.cur_queue_index_)

        local msg = CommonMessage()
        msg.name = "upgrade_passive_success"
        messMgr:AddCommonMessage(msg)
        local is_slot, slot_index = GameSys.hasInTable(PlayerData.player.spell_passive_slots, pre_attach_id)
        if is_slot then
            ChangeSpellPanel.cur_wear_type = ChangeSpellPanel.WearType.auto
            local msg = item_msg_pb.cmsg_spell_passive_wear()
            msg.spell_passive_id = this.cur_unlock_passive_id_
            this.change_passive_slot_index_ = slot_index
            msg.slot = this.change_passive_slot_index_
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_SPELL_PASSIVE_WEAR, data, { opcodes.SMSG_SPELL_PASSIVE_WEAR })
        end
    end
end

function PlayerUnlockPassivePanel.ChangeAttachSlot(message)
    if ChangeSpellPanel.cur_wear_type ~= ChangeSpellPanel.WearType.auto then
        return
    end
    PlayerData.player.spell_passive_slots[this.change_passive_slot_index_] = this.cur_unlock_passive_id_
    ChangeSpellPanel.ChangeDone()
end

function PlayerUnlockPassivePanel.RefreshSlot(passive_index, queue_index)
    local t_passive = this.cur_attach_queue_[passive_index]
    if t_passive == nil then
        table.remove(this.unlock_passives_, queue_index)
        PlayerUnlockPassivePanel.RefreshUnlockList()
    else
        local had_learned = false
        for i = 1, #PlayerData.player.spell_passive_ids do
            if PlayerData.player.spell_passive_ids[i] == t_passive.id then
                had_learned = true
                break
            end
        end
        local t = PlayerUnlockPassivePanel.SetPassiveData(t_passive, queue_index, had_learned)
        t.slot_ins = this.unlock_passives_[queue_index].slot_ins
        this.unlock_passives_[queue_index] = t
        if t.slot_ins ~= nil then
            PlayerUnlockPassivePanel.SetAttchSlots(t.slot_ins, queue_index)
        end
    end
end

function PlayerUnlockPassivePanel.OnPetLevelChange(pet)
    local pet_id = pet.template_id
    local level = pet.level
    local sorts = {}
    for i = 1, #this.unlock_passives_ do
        local pet_conditions = this.unlock_passives_[i].pet_conditions
        for j = 1, #pet_conditions do
            if pet_conditions[j].pet_id == pet_id then
                pet_conditions[j].pet_level = level
                pet_conditions[j].level_enough = level >= pet_conditions[j].need_level
                table.insert(sorts, i)
            end
        end
    end
    for i = 1, #sorts do
        this.scroll_grid_:UpdateItemAt(sorts[i] - 1)
    end
end

function PlayerUnlockPassivePanel.OnChangePassiveClick(obj, params)
    local slot_sort = params[1]
    GUIRoot.ShowPanel("ChangeSpellPanel", { slot_sort })
end
--更换完被动 刷新被动穿戴情况
function PlayerUnlockPassivePanel.OnSelectPassiveDone(message)
    PlayerUnlockPassivePanel.SetPassiveSlotData()
    PlayerUnlockPassivePanel.RefreshPassiveSlots()
end