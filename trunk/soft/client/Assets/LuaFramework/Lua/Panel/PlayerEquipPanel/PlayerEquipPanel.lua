PlayerEquipPanel = {}
PlayerEquipPanel.Control = {}
local this = PlayerEquipPanel.Control

function PlayerEquipPanel.Awake(obj, lua_behaviour)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = lua_behaviour
    this.equip_root_left_ = this.transform_:Find("panel_among/equips_root/equip_root_left")
    this.equip_root_right_ = this.transform_:Find("panel_among/equips_root/equip_root_right")
    this.attr_text_root_ = this.transform_:Find("panel_among/attribute_scroll/view/content")
    this.equips_root_ = this.transform_:Find("panel_among/equips_root")
    this.player_icon_ = this.transform_:Find("panel_among/player_icon")
    this.player_icon_.gameObject:SetActive(true)
    this.player_icon_click_ = this.transform_:Find("panel_among/player_icon_click")
    local r = this.player_icon_:GetComponent("RawImage")
    r.texture = Hall.Camera.targetTexture
    this.attribute_scroll_ = this.transform_:Find("panel_among/attribute_scroll")
    this.attr_detail_btn_ = this.transform_:Find("panel_among/attribute_scroll/attr_detail_btn")
    this.line_image_ = this.transform_:Find("panel_among/attribute_scroll/line_image")
    this.switch_pages_ = this.transform_:Find("panel_among/switch_pages")
    this.equip_page_ = this.transform_:Find("panel_among/switch_pages/equip_page"):GetComponent("Toggle")
    this.avatar_page_ = this.transform_:Find("panel_among/switch_pages/avatar_page"):GetComponent("Toggle")
    this.equip_slot_ = this.transform_:Find("equip_slot")
    this.attr_text_ = this.transform_:Find("attribute_text")

    this.equip_page_.isOn = true
    this.avatar_page_.isOn = false
    this.show_attr_detail_ = false

    this.lua_script_:AddBeginDragEvent(this.player_icon_click_.gameObject, PlayerEquipPanel.BeginDrag)
    this.lua_script_:AddOnDragEvent(this.player_icon_click_.gameObject, PlayerEquipPanel.OnDrag)
    this.lua_script_:AddEndDragEvent(this.player_icon_click_.gameObject, PlayerEquipPanel.EndDrag)

    this.is_self_ = true
    this.equip_slot_inss_ = {}
    this.attr_inss_ = {}
    this.equip_slot_states_ = {}
    this.dress_states_ = {}
    this.attr_id_table_ = {}
    this.all_attr_id_table_ = {}
    this.attr_states_ = {}

    this.role_id_ = 1001
    this.player_unit_x_ = 0
    this.is_draged_ = false

    PlayerEquipPanel.RegisterBtnListers()
end

function PlayerEquipPanel.OnDestroy(obj)
    Hall.Hide()
    PlayerEquipPanel.RemoveCommonMessage()
    this = {}
end

function PlayerEquipPanel.OnParam(params)
    this.is_self_ = params[1]
    PlayerEquipPanel.RegisterMessage()
    if this.is_self_ then
        this.role_id_ = PlayerData.player.role_id
    else
        this.role_id_ = PlayerPanel.otherDate.player_role
    end
    PlayerEquipPanel.CreateUnit(this.role_id_)
end



function PlayerEquipPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.attr_detail_btn_.gameObject, "click", PlayerEquipPanel.OnAttrDetailBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.equip_page_.gameObject, "toggle", PlayerEquipPanel.OnEquipPageClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.avatar_page_.gameObject, "toggle", PlayerEquipPanel.OnAvatarPageClick, nil)
end

function PlayerEquipPanel.RegisterMessage()
    if this.is_self_ then
        Message.register_handle("wear_equip_success", PlayerEquipPanel.WearEquipDone)
        Message.register_handle("enhance_equip_done", PlayerEquipPanel.EnhanceEquipDone)
        Message.register_handle("enchant_equip_success", PlayerEquipPanel.EnchantEquipDone)
        Message.register_handle("equip_reforge_success", PlayerEquipPanel.ReforgeEquipDone)
        Message.register_handle("change_rune_success", PlayerEquipPanel.InlayEquipDone)
        Message.register_handle("change_dress_success", PlayerEquipPanel.WearDressDone)
    end
end

function PlayerEquipPanel.RemoveCommonMessage()
    if this.is_self_ then
        Message.remove_handle("wear_equip_success", PlayerEquipPanel.WearEquipDone)
        Message.remove_handle("enhance_equip_done", PlayerEquipPanel.EnhanceEquipDone)
        Message.remove_handle("enchant_equip_success", PlayerEquipPanel.EnchantEquipDone)
        Message.remove_handle("equip_reforge_success", PlayerEquipPanel.ReforgeEquipDone)
        Message.remove_handle("change_rune_success", PlayerEquipPanel.InlayEquipDone)
        Message.remove_handle("change_dress_success", PlayerEquipPanel.WearDressDone)
    end
end

function PlayerEquipPanel.OnAttrDetailBtnClick(obj, params)
    this.show_attr_detail_ = not this.show_attr_detail_
    this.attr_detail_btn_.transform.localEulerAngles = Vector3(0, 0, this.attr_detail_btn_.transform.localEulerAngles.z + 180)
    PlayerEquipPanel.RefreshAttrTexts()
end

function PlayerEquipPanel.CreateUnit(role_id)
    Hall.Show(role_id)
end

function PlayerEquipPanel.BeginDrag(obj, event_data, params)
    this.is_draged_ = true
    this.player_unit_x_ = event_data.position.x
end

function PlayerEquipPanel.OnDrag(obj, event_data, params)
    local r = event_data.position.x - this.player_unit_x_
    this.player_unit_x_ = event_data.position.x
    Hall.Roll(-r * 0.5)
end

function PlayerEquipPanel.EndDrag(obj, event_data, params)
    this.is_draged_ = false
end

function PlayerEquipPanel.RefreshPanel()
    PlayerEquipPanel.SetData()
    if this.equip_page_.isOn then
        PlayerEquipPanel.RefreshEquips()
    elseif this.avatar_page_.isOn then
        PlayerEquipPanel.RefreshDress()
    end
    PlayerEquipPanel.RefreshUnit()
    PlayerEquipPanel.RefreshAttrTexts()
end

function PlayerEquipPanel.SetData()
    this.equip_slot_states_ = {}
    this.dress_states_ = {}
    for i = 1, 8 do
        this.equip_slot_states_[i] = {
            ["had_wear"] = false,
            ["equip_info"] = nil,
            ["runes"] = nil,
            ["enhance"] = 0,
            ["can_wear"] = false,
            ["max_power"] = true,
        }
        this.dress_states_[i] = {
            ["had_wear"] = false,
            ["dress_id"] = 0,
            ["can_wear"] = false
        }
    end
    if this.is_self_ then
        for i = 1, #PlayerData.player.equip_slots do
            local slot_state = this.equip_slot_states_[i]
            local equip_guid = PlayerData.player.equip_slots[i]
            slot_state.had_wear = equip_guid ~= "0"
            slot_state.equip_info = PlayerData.equips[equip_guid]
            slot_state.runes = GameSys.GetSlotRunes(i)
            slot_state.enhance = GameSys.GetEquipEnhance(slot_state.equip_info)
            slot_state.can_wear = GameSys.CanSlotWearEquip(i)
            slot_state.max_power = GameSys.IsMaxPowerEquip(slot_state.equip_info)
        end
        for i = 1, #PlayerData.player.equip_shows do
            local dress_id = PlayerData.player.equip_shows[i]
            this.dress_states_[i].had_wear = dress_id ~= 0
            this.dress_states_[i].dress_id = dress_id
            this.dress_states_[i].can_wear = GameSys.CanDressSlotWear(i)
        end
        this.attr_states_ = PlayerData.get_display_attr()
    else
        local otherDate = PlayerPanel.otherDate
        if otherDate == nil then
            return
        end
        local equips = {}
        for i = 1, #otherDate.player_equips do
            local equip_info = otherDate.player_equips[i]
            local equip_type = GameSys.GetEquipType(equip_info)
            equips[equip_type] = equip_info
        end
        for i = 1, 8 do
            local slot_state = this.equip_slot_states_[i]
            slot_state.had_wear = equips[i] ~= nil
            slot_state.equip_info = equips[i]
            slot_state.enhance = otherDate.player_equip_enhances[i]
            slot_state.runes = {
                otherDate.rune_slot1s[i],
                otherDate.rune_slot2s[i],
                otherDate.rune_slot3s[i]
            }
            slot_state.can_wear = false
            slot_state.max_power = true
        end
        for i = 1, #otherDate.player_equip_shows do
            local dress_id = otherDate.player_equip_shows[i]
            this.dress_states_[i].had_wear = dress_id ~= 0
            this.dress_states_[i].dress_id = dress_id
            this.dress_states_[i].can_wear = false
        end
        this.attr_states_ = {}
        for i = 1, #otherDate.player_attrs_ids do
            this.attr_states_[otherDate.player_attrs_ids[i]] = otherDate.player_attrs_values[i]
        end
    end
    this.attr_id_table_ = {}
    this.all_attr_id_table_ = {}
    local attr_config = Config.t_attr
    for id, info in pairs(attr_config) do
        if info.show == 1 then
            table.insert(this.attr_id_table_, id)
            table.insert(this.all_attr_id_table_, id)
        end
        if info.show == 2 then
            table.insert(this.all_attr_id_table_, id)
        end

    end
    table.sort(this.attr_id_table_, function(a, b)
        return a < b
    end)
    table.sort(this.all_attr_id_table_, function(a, b)
        return a < b
    end)
end

function PlayerEquipPanel.RefreshUnit()
    local dress_ids = PlayerEquipPanel.GetDressIds()
    local equip_ids = PlayerEquipPanel.GetEquipIds()
    local avatar_ids = GameSys.GetEquipAvatarIds(equip_ids, dress_ids)
    Hall.ChangePart(avatar_ids, this.role_id_)
end

function PlayerEquipPanel.GetEquipIds()
    local equips = {}
    for i = 1, #this.equip_slot_states_ do
        local equip_state = this.equip_slot_states_[i]
        if equip_state.had_wear then
            local equip_id = equip_state.equip_info.template_id
            equips[i] = equip_id
        else
            equips[i] = 0
        end
    end
    return equips
end

function PlayerEquipPanel.GetDressIds()
    local dress_ids = {}
    for i = 1, #this.dress_states_ do
        table.insert(dress_ids, this.dress_states_[i].dress_id)
    end
    return dress_ids
end

function PlayerEquipPanel.RefreshEquips()
    for i = 1, #this.equip_slot_states_ do
        local slot_state = this.equip_slot_states_[i]
        if this.equip_slot_inss_[i] ~= nil then
            PlayerEquipPanel.SetSlotIns(this.equip_slot_inss_[i], slot_state, i)
        else
            local slot_ins = GameObject.Instantiate(this.equip_slot_.gameObject)
            slot_ins:SetActive(true)
            local root = (i % 2 == 0) and this.equip_root_right_ or this.equip_root_left_
            slot_ins.transform:SetParent(root, false)
            this.equip_slot_inss_[i] = slot_ins
            PlayerEquipPanel.SetSlotIns(slot_ins, slot_state, i)
        end
    end
    local index = #this.equip_slot_inss_ - #this.equip_slot_states_
    if index > 0 then
        for i = index, #this.equip_slot_inss_ do
            this.equip_slot_inss_[i]:SetActive(true)
        end
    end
end

function PlayerEquipPanel.RefreshDress()
    for i = 1, #this.dress_states_ do
        local dress_states = this.dress_states_[i]
        if this.equip_slot_inss_[i] ~= nil then
            PlayerEquipPanel.SetDressSlotIns(this.equip_slot_inss_[i], dress_states, i)
        else
            local slot_ins = GameObject.Instantiate(this.equip_slot_.gameObject)
            slot_ins:SetActive(true)
            local root = (i % 2 == 0) and this.equip_root_right_ or this.equip_root_left_
            slot_ins.transform:SetParent(root, false)
            this.equip_slot_inss_[i] = slot_ins
            PlayerEquipPanel.SetDressSlotIns(slot_ins, dress_states, i)
        end
    end
    local index = #this.equip_slot_inss_ - #this.equip_slot_states_
    if index > 0 then
        for i = index, #this.equip_slot_inss_ do
            this.equip_slot_inss_[i]:SetActive(true)
        end
    end
end

function PlayerEquipPanel.SetSlotIns(slot_ins, slot_state, sort)
    local add_image = slot_ins.transform:Find("back_image/add_image")
    local equip_info = slot_ins.transform:Find("back_image/equip_info")
    local quality_icon = equip_info:Find("quality_icon")
    local equip_icon = equip_info:Find("equip_icon")
    local enchant_icon = equip_info:Find("enchant_icon")
    local enhance_text = equip_info:Find("enhance_text")
    local red_point = equip_info:Find("red_point")
    local runes = equip_info:Find("runes")
    local rune_1 = runes:Find("rune_1")
    local rune_2 = runes:Find("rune_2")
    local rune_3 = runes:Find("rune_3")
    local runes_ins = { rune_1, rune_2, rune_3 }

    equip_info.gameObject:SetActive(slot_state.had_wear)
    add_image.gameObject:SetActive(not slot_state.had_wear and slot_state.can_wear)
    if slot_state.had_wear then
        local quality_icon_alias = GameSys.GetEquipSlotQuality(slot_state.equip_info.color)
        quality_icon:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.lua_script_.gameObject.name):GetSprite(quality_icon_alias)
        local t_equip = Config.get_config_value("t_equip", slot_state.equip_info.template_id)
        local equip_icon_alias = t_equip.icon
        if equip_icon_alias ~= "" then
            equip_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(equip_icon_alias)
        end
        local enchant_id = slot_state.equip_info.enchant_id
        enchant_icon.gameObject:SetActive(enchant_id ~= 0)
        if enchant_id ~= 0 then
            local enchant_icon_alias = Config.get_config_value("t_equip_enchant", enchant_id).icon
            if enchant_icon_alias ~= "" then
                enchant_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(enchant_icon_alias)
            end
        end
        enhance_text:GetComponent("Text").text = "+" .. slot_state.enhance
        for i = 1, #slot_state.runes do
            local rune_id = slot_state.runes[i]
            runes_ins[i].gameObject:SetActive(rune_id ~= 0)
            if rune_id ~= 0 then
                local rune_icon_alias = GameSys.GetRuneAlias(rune_id)
                if rune_icon_alias ~= "" then
                    runes_ins[i]:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "rune"):GetSprite(rune_icon_alias)
                end
            end
        end
        red_point.gameObject:SetActive(not slot_state.max_power)
    end
    slot_ins.name = "this.equip_slot_" .. sort
    GameSys.ButtonRegister(this.lua_script_, slot_ins, "click", PlayerEquipPanel.OnEquipSlotClick, { sort })
end

function PlayerEquipPanel.SetDressSlotIns(slot_ins, dress_state, sort)
    local add_image = slot_ins.transform:Find("back_image/add_image")
    local equip_info = slot_ins.transform:Find("back_image/equip_info")
    local quality_icon = equip_info:Find("quality_icon")
    local equip_icon = equip_info:Find("equip_icon")
    local enchant_icon = equip_info:Find("enchant_icon")
    local enhance_back_image = equip_info:Find("enhance_back_image")
    local enhance_text = equip_info:Find("enhance_text")
    local runes = equip_info:Find("runes")
    local red_point = equip_info:Find("red_point")
    red_point.gameObject:SetActive(false)
    equip_info.gameObject:SetActive(dress_state.had_wear)
    add_image.gameObject:SetActive(not dress_state.had_wear and dress_state.can_wear)
    if dress_state.had_wear then
        local quality_icon_alias = GameSys.GetEquipSlotQuality(5)
        quality_icon:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.lua_script_.gameObject.name):GetSprite(quality_icon_alias)
        local t_equip = Config.get_config_value("t_equip", dress_state.dress_id)
        local equip_icon_alias = t_equip.icon
        if equip_icon_alias ~= "" then
            equip_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(equip_icon_alias)
        end
        enchant_icon.gameObject:SetActive(false)
        enhance_text.gameObject:SetActive(false)
        enhance_back_image.gameObject:SetActive(false)
        runes.gameObject:SetActive(false)
    end
    slot_ins.name = "this.equip_slot_" .. sort
    GameSys.ButtonRegister(this.lua_script_, slot_ins, "click", PlayerEquipPanel.OnEquipSlotClick, { sort })
end

function PlayerEquipPanel.RefreshAttrTexts()
    this.equips_root_.gameObject:SetActive(not this.show_attr_detail_)
    this.player_icon_click_.gameObject:SetActive(not this.show_attr_detail_)
    this.player_icon_.gameObject:SetActive(not this.show_attr_detail_)
    this.switch_pages_.gameObject:SetActive(not this.show_attr_detail_)

    if this.show_attr_detail_ then
        PlayerEquipPanel.RefreshAllAttr()
    else
        PlayerEquipPanel.RefreshLocalAttr()
    end
end

function PlayerEquipPanel.RefreshAllAttr()
    local rect = this.attribute_scroll_:GetComponent("RectTransform")
    rect.sizeDelta = Vector2(rect.sizeDelta.x, 850)
    PlayerEquipPanel.RefreshAttr(this.all_attr_id_table_)
end

function PlayerEquipPanel.RefreshLocalAttr()
    local rect = this.attribute_scroll_:GetComponent("RectTransform")
    rect.sizeDelta = Vector2(rect.sizeDelta.x, 180)
    PlayerEquipPanel.RefreshAttr(this.attr_id_table_)
end

function PlayerEquipPanel.RefreshAttr(id_table)
    for i = 1, #id_table, 2 do
        local id_1 = id_table[i]
        local id_2 = id_table[i + 1]
        local text_ins = this.attr_inss_[(i + 1) / 2]
        if text_ins ~= nil then
            if not text_ins.gameObject.activeSelf then
                text_ins.gameObject:SetActive(true)
            end
            PlayerEquipPanel.SetAttrIns(text_ins, id_1, id_2)
        else
            text_ins = GameObject.Instantiate(this.attr_text_.gameObject)
            if not text_ins.gameObject.activeSelf then
                text_ins.gameObject:SetActive(true)
            end
            text_ins.transform:SetParent(this.attr_text_root_)
            text_ins.transform.localScale = Vector3.one
            this.attr_inss_[(i + 1) / 2] = text_ins
            PlayerEquipPanel.SetAttrIns(text_ins, id_1, id_2)
        end
    end
    local max_count = math.ceil(#id_table / 2)
    if #this.attr_inss_ > max_count then
        for i = max_count + 1, #this.attr_inss_ do
            this.attr_inss_[i]:SetActive(false)
        end
    end
    local rect = this.attr_text_root_:GetComponent("RectTransform")
    rect.sizeDelta = Vector2(rect.sizeDelta.x, 30 * max_count + (max_count + 1) * 5)
    local line_ = 160
    if this.show_attr_detail_ then
        line_ = 830
    end
    this.line_image_:GetComponent("RectTransform").sizeDelta = Vector2(line_, 2)
end

function PlayerEquipPanel.SetAttrIns(attr_text_ins, id_1, id_2)
    local attr_title_text_1 = attr_text_ins.transform:Find("attr_title_text_1")
    local attr_value_text_1 = attr_text_ins.transform:Find("attr_value_text_1")
    local attr_title_text_2 = attr_text_ins.transform:Find("attr_title_text_2")
    local attr_value_text_2 = attr_text_ins.transform:Find("attr_value_text_2")
    local title_1 = GameSys.GetAttrNameText(id_1)
    local value_1 = this.attr_states_[id_1]
    attr_title_text_1:GetComponent("Text").text = title_1
    attr_value_text_1:GetComponent("Text").text = GameSys.GetAttrValueText(id_1, value_1)
    if id_2 ~= nil then
        local title_2 = GameSys.GetAttrNameText(id_2)
        local value_2 = this.attr_states_[id_2]
        attr_title_text_2:GetComponent("Text").text = title_2
        attr_value_text_2:GetComponent("Text").text = GameSys.GetAttrValueText(id_2, value_2)
    end
end

function PlayerEquipPanel.WearEquipDone(message)
    PlayerEquipPanel.RefreshPanel()
    PlayerEquipPanel.ChangeMapUnit()
end

function PlayerEquipPanel.EnhanceEquipDone(message)
    PlayerEquipPanel.RefreshPanel()
end

function PlayerEquipPanel.EnchantEquipDone(message)
    PlayerEquipPanel.RefreshPanel()
end

function PlayerEquipPanel.ReforgeEquipDone(message)
    PlayerEquipPanel.RefreshPanel()
end

function PlayerEquipPanel.InlayEquipDone(message)
    PlayerEquipPanel.RefreshPanel()
end

function PlayerEquipPanel.WearDressDone(message)
    PlayerEquipPanel.RefreshPanel()
    PlayerEquipPanel.ChangeMapUnit()
end

function PlayerEquipPanel.ChangeMapUnit()
    if this.is_self_ then
        local avatar_ids = GameSys.GetSelfEquipAvatarIds()
        Hall.MapChangePart(avatar_ids, this.role_id_)
    end
end

function PlayerEquipPanel.OnEquipSlotClick(obj, params)
    local index = params[1]
    local equip_type = index
    if this.equip_page_.isOn then
        local slot_state = this.equip_slot_states_[index]
        if slot_state.had_wear then
            if this.is_self_ then
                GUIRoot.ShowPanel("EquipDetailPanel", { slot_state.equip_info, equip_type })
            else
                GUIRoot.ShowPanel("EquipDetailPanel", { slot_state.equip_info, equip_type, slot_state.runes, slot_state.enhance })
            end
        else
            if slot_state.can_wear then
                GUIRoot.ShowPanel("ChangeEquipPanel", { equip_type })
            end
        end
    elseif this.avatar_page_.isOn then
        if not this.is_self_ then
            return
        end
        local dress_state = this.dress_states_[index]
        if dress_state.can_wear then
            GUIRoot.ShowPanel("ChangeDressPanel", { index, dress_state.dress_id })
        end
    end
end

function PlayerEquipPanel.OnEquipPageClick(obj, is_on, params)
    if is_on then
        PlayerEquipPanel.RefreshEquips()
    end
end

function PlayerEquipPanel.OnAvatarPageClick(obj, is_on, params)
    if is_on then
        PlayerEquipPanel.RefreshDress()
    end
end