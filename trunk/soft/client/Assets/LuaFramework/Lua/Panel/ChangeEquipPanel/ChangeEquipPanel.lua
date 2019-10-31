ChangeEquipPanel = {}
ChangeEquipPanel.Control = {}
local this = ChangeEquipPanel.Control

function ChangeEquipPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform

    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.scroll_rect_ = this.transform_:Find("back_image/panel_among/scroll_rect"):GetComponent("ScrollRect")
    this.view_ = this.transform_:Find("back_image/panel_among/scroll_rect/view")
    this.content_root_ = this.transform_:Find("back_image/panel_among/scroll_rect/view/content_root")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.ins_grid_ = this.transform_:Find("back_image/panel_among/ins_grid")
    this.change_equip_slot_ = this.transform_:Find("back_image/panel_among/change_equip_slot")

    local view_rect = this.view_:GetComponent("RectTransform")
    this.view_height_ = view_rect.rect.height
    local corners = view_rect:GetWorldCorners()
    this.view_bottom_ = corners[0].y
    this.view_top_ = corners[1].y

    this.is_first_open_ = true

    this.equip_type_ = 0
    this.wear_equip_state_ = nil
    this.equip_states_ = {}
    this.open_index_ = 0
    this.slot_detail_inss_ = {}
    this.cur_open_index_ = 0
    this.cur_change_guid_ = "0"
    this.grid_inss_ = {}

    this.show_count_ = 0
    this.total_count_ = 0
    this.show_slot_states_ = {}
    this.content_height_ = 0
    this.open_ex_height_ = 0
    this.pre_offset_vec_ = 0

    ChangeEquipPanel.RegisterListers()
end

function ChangeEquipPanel.OnParam(params)
    this.equip_type_ = params[1]
end

function ChangeEquipPanel.OnDestroy(params)
    ChangeEquipPanel.RemoveListers()
    this = {}
end

function ChangeEquipPanel.RegisterListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ChangeEquipPanel.OnCloseBtnClick, nil)

    Message.register_net_handle(opcodes.SMSG_EQUIP_WEAR, ChangeEquipPanel.ChangeSuccess)
end

function ChangeEquipPanel.RemoveListers()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_WEAR, ChangeEquipPanel.ChangeSuccess)
end

function ChangeEquipPanel.Start(obj)
    ChangeEquipPanel.RefreshPanel()
end

function ChangeEquipPanel.RefreshPanel()
    ChangeEquipPanel.SetData()
    ChangeEquipPanel.CreateInsGrids()
    ChangeEquipPanel.InitScrollRect()

    ChangeEquipPanel.CreateShowEquipSlots()
end

function ChangeEquipPanel.SetData()
    this.wear_equip_state_ = nil
    this.cur_open_index_ = 0
    this.open_index_ = 0
    this.show_slot_states_ = {}
    this.grid_inss_ = {}
    local same_type_equips = {}
    for _, equip_info in pairs(PlayerData.equips) do
        local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
        if t_equip.type == this.equip_type_ and PlayerData.player.level >= t_equip.min_level then
            table.insert(same_type_equips, { equip_info, t_equip })
        end
    end
    local weared_guid = PlayerData.player.equip_slots[this.equip_type_]
    this.equip_states_ = {}
    this.slot_detail_inss_ = {}
    for i = 1, #same_type_equips do
        local equip_info = same_type_equips[i][1]
        local t_equip = same_type_equips[i][2]
        local total_power = GameSys.GetEquipPower(equip_info)
        local reforge_attrs = GameSys.GetEquipReforgeValue(equip_info)
        local enchant_attr = GameSys.GetEquipEnchantValue(equip_info)
        local had_enchant = PlayerData.equips[equip_info.guid].enchant_id ~= 0
        local is_weared = weared_guid == equip_info.guid

        table.insert(this.equip_states_, {
            ["equip_info"] = equip_info,
            ["t_equip"] = t_equip,
            ["total_power"] = total_power,
            ["reforge_attrs"] = reforge_attrs,
            ["enchant_attr"] = enchant_attr,
            ["had_enchant"] = had_enchant,
            ["is_weared"] = is_weared
        })
    end
    table.sort(this.equip_states_, function(a, b)
        if a.is_weared then
            this.wear_equip_state_ = a
            return true
        elseif b.is_weared then
            this.wear_equip_state_ = b
            return false
        end
        if not a.is_weared and not b.is_weared then
            if a.total_power ~= b.total_power then
                return a.total_power > b.total_power
            else
                if a.base_power ~= b.base_power then
                    return a.base_power > b.base_power
                else
                    return a.t_equip.id > b.t_equip.id
                end
            end
        end
    end)
    this.total_count_ = #this.equip_states_
end

function ChangeEquipPanel.CreateInsGrids()
    Util.ClearChild(this.content_root_)
    local count = #this.equip_states_
    for i = 1, count do
        local grid = GameObject.Instantiate(this.ins_grid_.gameObject)
        grid.name = "gird_".. i
        grid:SetActive(true)
        grid.transform:SetParent(this.content_root_,false)
        table.insert(this.grid_inss_, grid)
    end
end

function ChangeEquipPanel.InitScrollRect()
    local equip_count = #this.equip_states_
    local ori_height = this.ins_grid_:GetComponent("RectTransform").rect.height
    this.content_height_ = equip_count * ori_height + (equip_count - 1) * 10
    local content_rect = this.content_root_:GetComponent("RectTransform")
    content_rect.anchoredPosition = Vector2(0, 0)
    this.pre_offset_vec_ = 0
    this.lua_script_:AddScrollViewEvent(this.scroll_rect_.gameObject, ChangeEquipPanel.OnScroll, nil)
    content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
    if this.content_height_ > this.view_height_ then
        local c = (this.view_height_ + 10) / (ori_height +10)
        c = math.ceil(c)
        if equip_count > c then
            c = c + 1
        end
        this.show_count_ = c
    else
        this.show_count_ = equip_count
    end
end

function ChangeEquipPanel.CreateShowEquipSlots()
    for i = 1, this.show_count_ do
        local slot_ins = GameObject.Instantiate(this.change_equip_slot_.gameObject)
        slot_ins:SetActive(true)
        slot_ins.transform:SetParent(this.grid_inss_[i].transform, false)
        slot_ins.transform.localPosition = Vector3(0, 0, 0)
        table.insert(this.show_slot_states_,{
            sort = i,
            ins = slot_ins
        })
        ChangeEquipPanel.SetSlot(slot_ins, i)
    end
    if this.is_first_open_ then
        ChangeEquipPanel.SetSlotHeight(this.show_slot_states_[1].ins, this.show_slot_states_[1].sort, true)
        this.content_height_ = this.content_height_ + this.open_ex_height_ - 50
        local content_rect = this.content_root_:GetComponent("RectTransform")
        content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
        this.is_first_open_ = false
    end
end

function ChangeEquipPanel.SetSlot(slot_ins, sort)
    local equip_state = this.equip_states_[sort]

    local equip_slot_root = slot_ins.transform:Find("equip_slot_root")
    local power_slot = slot_ins.transform:Find("power_slot")
    local reforge_slot = slot_ins.transform:Find("reforge_slot")
    local enchant_slot = slot_ins.transform:Find("enchant_slot")
    local line_width = reforge_slot:Find("line"):GetComponent("RectTransform").rect.width

    ---
    Util.ClearChild(equip_slot_root)
    local equip_slot = CommonPanel.GetEquipChangeSlot(equip_state.equip_info, this.lua_script_, { equip_state.is_weared, ChangeEquipPanel.OnChangeBtnClick, { sort }, "change_equip_btn_" .. sort })
    equip_slot.transform:Find("back_image").gameObject:SetActive(false)
    Util.SetRoot(equip_slot.transform, equip_slot_root)
    ---
    local detail_btn = power_slot:GetChild(0)
    this.lua_script_:RemoveButtonEvent(detail_btn.gameObject, "click")
    detail_btn.gameObject.name = "equip_detail_btn_" .. sort
    GameSys.ButtonRegister(this.lua_script_, detail_btn.gameObject, "click", ChangeEquipPanel.OnEquipDetailClick, { sort })
    ---
    local reforge_attrs = reforge_slot:Find("reforge_attrs")
    local null_reforge_text = reforge_slot:Find("null_reforge_text")
    Util.ClearChild(reforge_attrs)
    for j = 1, #equip_state.reforge_attrs do
        local reforge_state = equip_state.reforge_attrs[j]
        local attr_text_ins = CommonPanel.GetEquipRandomAttrText(reforge_state, nil, 0, reforge_state.color, line_width)
        attr_text_ins.transform:SetParent(reforge_attrs)
        attr_text_ins.transform.localScale = Vector3.one
    end
    null_reforge_text.gameObject:SetActive(#equip_state.reforge_attrs == 0)
    local height_1 = 0
    if #equip_state.reforge_attrs == 0 then
        height_1 = 30 + 2 + 30
    else
        height_1 = 30 + 2 + 30 * math.ceil(#equip_state.reforge_attrs)
    end
    local rect_reforge = reforge_slot:GetComponent("RectTransform")
    rect_reforge.sizeDelta = Vector2(rect_reforge.sizeDelta.x, height_1)
    ---
    local null_enchant_text = enchant_slot:Find("null_enchant_text")
    local enchant_attr_root = enchant_slot:Find("enchant_attr_root")
    local enchant_icon = enchant_slot:Find("enchant_icon")
    Util.ClearChild(enchant_attr_root)
    enchant_icon.gameObject:SetActive(equip_state.had_enchant)
    null_enchant_text.gameObject:SetActive(not equip_state.had_enchant)
    if equip_state.had_enchant then
        local enchant_text_ins = CommonPanel.GetAttrText(equip_state.enchant_attr.t_attr.id, equip_state.enchant_attr.value, 0)
        enchant_text_ins.transform:SetParent(enchant_attr_root, false)
        local enchant_icon_alias = Config.get_config_value("t_equip_enchant", equip_state.equip_info.enchant_id).icon
        if enchant_icon_alias ~= "" then
            enchant_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(enchant_icon_alias)
        end
    end
    if sort == this.open_index_ then
        ChangeEquipPanel.SetSlotHeight(slot_ins, sort, true)
    else
        ChangeEquipPanel.SetSlotHeight(slot_ins, sort, false)
    end
end

function ChangeEquipPanel.SetSlotHeight(slot_ins, index, open)
    local reforge_slot = slot_ins.transform:Find("reforge_slot")
    local enchant_slot = slot_ins.transform:Find("enchant_slot")
    local height_2 = reforge_slot:GetComponent("RectTransform").rect.height
    local height_3 = enchant_slot:GetComponent("RectTransform").rect.height
    reforge_slot.gameObject:SetActive(open)
    enchant_slot.gameObject:SetActive(open)
    local height = 184
    if open then
        this.open_ex_height_ = height_2 + height_3
        height = 184 + this.open_ex_height_ - 50
    end
    local rect = slot_ins.transform:GetComponent("RectTransform")
    local old_size = rect.sizeDelta
    local new_size = Vector2(old_size.x, height)
    rect.sizeDelta = new_size
    if open then
        this.open_index_ = index
    end
    local grid_rect = slot_ins.transform.parent:GetComponent("RectTransform")
    grid_rect.sizeDelta = Vector2(grid_rect.sizeDelta.x, height)
end

function ChangeEquipPanel.OnChangeBtnClick(obj, params)
    local index = params[1]
    local equip_state = this.equip_states_[index]
    local is_weared = equip_state.is_weared
    if is_weared then
        local can_get_equip_count = GameSys.CanGetEquipNum()
        if can_get_equip_count <= 0 then
            GUIRoot.ShowPanel("MessagePanel", {"背包内装备容量不足"})
            return
        end
    end
    this.cur_change_guid_ = equip_state.equip_info.guid
    local msg = item_msg_pb.cmsg_equip_wear()
    msg.equip_guid = this.cur_change_guid_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_WEAR, data, { opcodes.SMSG_EQUIP_WEAR })
end

function ChangeEquipPanel.ChangeSuccess(message)
    if PlayerData.player.equip_slots[this.equip_type_] == this.cur_change_guid_ then
        PlayerData.player.equip_slots[this.equip_type_] = "0"
    else
        PlayerData.player.equip_slots[this.equip_type_] = this.cur_change_guid_
        PlayerData.task_operation(6) --穿装备任务
    end

    local msg = CommonMessage()
    msg.name = "wear_equip_success"
    messMgr:AddCommonMessage(msg)

    local common_msg = CommonMessage()
    common_msg.name = "check_power"
    messMgr:AddCommonMessage(common_msg)
    ChangeEquipPanel.Close()
end

function ChangeEquipPanel.OnEquipDetailClick(obj, params)
    local index = params[1]
    local content_rect = this.content_root_:GetComponent("RectTransform")
    local show_index = 1
    for i = 1, #this.show_slot_states_ do
        if index == this.show_slot_states_[i].sort then
            show_index = i
        end
    end
    local show_state = this.show_slot_states_[show_index]
    if index == this.open_index_ then
        ChangeEquipPanel.SetSlotHeight(show_state.ins, this.open_index_, false)
        this.content_height_ = this.content_height_ - this.open_ex_height_
        content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
        this.open_index_ = 0
    else
        if this.open_index_ == 0 then
            ChangeEquipPanel.SetSlotHeight(show_state.ins, index, true)
            this.content_height_ = this.content_height_ + this.open_ex_height_
            content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
        else
            local ori_open_index = nil
            for i = 1, #this.show_slot_states_ do
                if this.open_index_ == this.show_slot_states_[i].sort then
                    ori_open_index = i
                end
            end
            if ori_open_index == nil then
                local ori_rect = this.grid_inss_[this.open_index_]:GetComponent("RectTransform")
                ori_rect.sizeDelta = Vector2(ori_rect.sizeDelta.x, 184)
            else
                ChangeEquipPanel.SetSlotHeight(this.show_slot_states_[ori_open_index].ins, this.open_index_, false)
            end
            this.content_height_ = this.content_height_ - this.open_ex_height_
            content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
            ChangeEquipPanel.SetSlotHeight(show_state.ins, index, true)
            this.content_height_ = this.content_height_ + this.open_ex_height_
            content_rect.sizeDelta = Vector2(content_rect.sizeDelta.x, this.content_height_)
        end
    end
end

function ChangeEquipPanel.OnScroll(obj, vec, params)
    local y = vec.y
    if y - this.pre_offset_vec_ < 0 then  --向上滑
        local show_state = this.show_slot_states_[1]
        local ins = show_state.ins
        local corners = ins:GetComponent("RectTransform"):GetWorldCorners()
        local bottom = corners[0].y
        if bottom > this.view_top_ then
            local go_sort = this.show_slot_states_[#this.show_slot_states_].sort + 1
            if go_sort > this.total_count_ then
                return
            end
            ins.transform:SetParent(this.grid_inss_[go_sort].transform, false)
            ins.transform.localPosition = Vector3(0, 0, 0)
            ChangeEquipPanel.SetSlot(ins, go_sort)
            table.remove(this.show_slot_states_, 1)
            table.insert(this.show_slot_states_, {
                ["sort"] = go_sort,
                ["ins"] = ins
            })
        end

    else  --向下滑
        local show_state = this.show_slot_states_[#this.show_slot_states_]
        local ins = show_state.ins
        local corners = ins:GetComponent("RectTransform"):GetWorldCorners()
        local top = corners[1].y
        if top < this.view_bottom_ then
            local go_sort = this.show_slot_states_[1].sort - 1
            if go_sort < 1 then
                return
            end
            ins.transform:SetParent(this.grid_inss_[go_sort].transform, false)
            ins.transform.localPosition = Vector3(0, 0, 0)
            ChangeEquipPanel.SetSlot(ins, go_sort)
            table.remove(this.show_slot_states_, #this.show_slot_states_)
            table.insert(this.show_slot_states_, 1, {
                ["sort"] = go_sort,
                ["ins"] = ins
            })
        end
    end
    this.pre_offset_vec_ = vec.y
end

function ChangeEquipPanel.OnCloseBtnClick(obj, params)
    ChangeEquipPanel.Close()
end

function ChangeEquipPanel.Close()
    GUIRoot.ClosePanel("ChangeEquipPanel")
end