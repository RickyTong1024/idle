EquipReforgePanel = {}
EquipReforgePanel.Control = {}
local this = EquipReforgePanel.Control

function EquipReforgePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.attr_back_image_ = this.transform_:Find("back_ground/panel_among/attr_back_image")
    this.attr_scroll_rect_ = this.transform_:Find("back_ground/panel_among/attr_back_image/attr_scroll_rect")
    this.scroll_rect_ = this.attr_scroll_rect_:GetComponent("ScrollRect")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.attrs_ = this.transform_:Find("back_ground/panel_among/attr_back_image/attr_scroll_rect/view/attrs")
    this.mats_root_ = this.transform_:Find("back_ground/panel_among/mat_detail/mats_root")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.gold_price_text_ = this.transform_:Find("back_ground/panel_among/reforge_btn/gold_price_text")
    this.reforge_btn_ = this.transform_:Find("back_ground/panel_among/reforge_btn")
    this.color_2_toggle_ = this.transform_:Find("back_ground/panel_among/attr_back_image/quality_toggles/color_2_toggle"):GetComponent("Toggle")
    this.color_3_toggle_ = this.transform_:Find("back_ground/panel_among/attr_back_image/quality_toggles/color_3_toggle"):GetComponent("Toggle")
    this.color_4_toggle_ = this.transform_:Find("back_ground/panel_among/attr_back_image/quality_toggles/color_4_toggle"):GetComponent("Toggle")
    this.color_5_toggle_ = this.transform_:Find("back_ground/panel_among/attr_back_image/quality_toggles/color_5_toggle"):GetComponent("Toggle")
    this.toggle_header_ = this.transform_:Find("back_ground/panel_among/attr_back_image/toggle_header")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/attr_back_image/arrow_btn")

    this.color_2_toggle_.isOn = false
    this.color_3_toggle_.isOn = false
    this.color_4_toggle_.isOn = false
    this.color_5_toggle_.isOn = false

    this.equip_guid_ = "0"
    this.equip_type_ = 0
    this.equip_state_ = {}
    this.mat_state_ = {}
    this.cur_select_color_ = 0

    EquipReforgePanel.RegisterBtnListers()
    EquipReforgePanel.RegisterMessage()
end

function EquipReforgePanel.OnDestroy()
    EquipReforgePanel.RemoveMessage()
    this = {}
end

function EquipReforgePanel.OnParam(params)
    this.equip_guid_ = params[1]
    this.equip_type_ = params[2]
end

function EquipReforgePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.reforge_btn_.gameObject, "click", EquipReforgePanel.OnReforgeBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EquipReforgePanel.OnCloseBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.color_2_toggle_.gameObject, "toggle", EquipReforgePanel.OnSelectColor2Click)
    GameSys.ButtonRegister(this.lua_script_, this.color_3_toggle_.gameObject, "toggle", EquipReforgePanel.OnSelectColor3Click)
    GameSys.ButtonRegister(this.lua_script_, this.color_4_toggle_.gameObject, "toggle", EquipReforgePanel.OnSelectColor4Click)
    GameSys.ButtonRegister(this.lua_script_, this.color_5_toggle_.gameObject, "toggle", EquipReforgePanel.OnSelectColor5Click)

end

function EquipReforgePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_EQUIP_REFORGE, EquipReforgePanel.ReforgeSuccess)
end

function EquipReforgePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_REFORGE, EquipReforgePanel.ReforgeSuccess)
end

function EquipReforgePanel.Start(obj)
    EquipReforgePanel.RefreshPanel()
    this.color_2_toggle_.transform:Find("Label"):GetComponent("Text").text = GameSys.set_color(2, Config.get_config_value("t_color", 2).name)
    this.color_3_toggle_.transform:Find("Label"):GetComponent("Text").text = GameSys.set_color(3, Config.get_config_value("t_color", 3).name)
    this.color_4_toggle_.transform:Find("Label"):GetComponent("Text").text = GameSys.set_color(4, Config.get_config_value("t_color", 4).name)
    this.color_5_toggle_.transform:Find("Label"):GetComponent("Text").text = GameSys.set_color(5, Config.get_config_value("t_color", 5).name)
    this.color_2_toggle_.isOn = true
end

function EquipReforgePanel.RefreshPanel()
    EquipReforgePanel.SetData()
    local is_weared = GameSys.IsEquipWeared(this.equip_state_.equip_info)
    local enhance = GameSys.GetEquipEnhance(this.equip_state_.equip_info)
    local runes = GameSys.GetSlotRunes(this.equip_type_)
    if is_weared then
        CommonPanel.SetSlotEquipInfoPanel(this.equip_state_.equip_info, enhance, runes, this.lua_script_, this.info_root_)
    else
        CommonPanel.SetEquipInfoPanel(this.equip_state_.equip_info, this.lua_script_, this.info_root_)
    end
    local attr_contents = GameSys.GetEquipReforgeValue(this.equip_state_.equip_info)
    Util.ClearChild(this.attrs_)
    local attr_text_width = this.toggle_header_.transform:GetComponent("RectTransform").rect.width
    local height = 0
    for i = 1, #attr_contents do
        local attr_content = attr_contents[i]
        local attr_text_ins = CommonPanel.GetEquipRandomAttrText(attr_content, attr_content.per, enhance, attr_content.color, attr_text_width)
        attr_text_ins.transform:SetParent(this.attrs_)
        attr_text_ins.transform.localScale = Vector3.one
        local h = attr_text_ins:GetComponent("RectTransform").sizeDelta.y
        height = height + h
    end
    GameSys.SetRectHeight(this.attrs_, height)
    GameSys.SetRectHeight(this.attr_scroll_rect_, height + 20)
    GameSys.SetRectHeight(this.attr_back_image_, height + 20 + 100 + 35)
    --设置下总高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.panel_among_)
    local total_h =  LayoutUtility.GetPreferredHeight(this.panel_among_)
    if total_h > 940 then
        local sub = total_h - 940
        GameSys.SetRectHeight(this.attr_scroll_rect_, this.attr_scroll_rect_.sizeDelta.y - sub)
        GameSys.SetRectHeight(this.attr_back_image_, this.attr_back_image_.sizeDelta.y - sub)
        total_h = 940
    end
    GameSys.SetRectHeight(this.back_ground_, total_h)
    --设置下滑动按钮
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function EquipReforgePanel.SetData()
    local equip_info = PlayerData.equips[this.equip_guid_]
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    this.equip_state_ = {
        ["guid"] = this.equip_guid_,
        ["equip_info"] = equip_info,
        ["t_equip"] = t_equip,
    }
    this.mat_state_ = {}
    local color_config = Config.t_color
    for color in pairs(color_config) do
        local t_equip_discompose = Config.get_config_value("t_equip_discompose", color)
        if t_equip_discompose ~= nil then
            local item_id = t_equip_discompose.item
            local item_num = t_equip.cz_item_num
            local cur_num = GameSys.GetItemCount(item_id)
            local enough = cur_num >= item_num
            local had = GameSys.hasInTable(equip_info.attr_colors, color)
            this.mat_state_[color] = {
                ["item_id"] = item_id,
                ["item_num"] = item_num,
                ["cur_num"] = cur_num,
                ["enough"] = enough,
                ["had_color"] = had
            }
        end
    end
end

function EquipReforgePanel.RefreshMat(color)
    Util.ClearChild(this.mats_root_)
    local mat = this.mat_state_[color]
    if mat == nil then
        return
    end
    local asset = {
        type = 2,
        value1 = mat.item_id,
        value2 = 0,
        value3 = 0
    }
    local mat_icon = CommonPanel.GetIcon2type(asset, { "reforge_mat_icon_btn" }, this.lua_script_)
    local num_text = mat_icon.transform:Find("generic")
    num_text.gameObject:SetActive(true)
    num_text:GetComponent("Text").text = GameSys.MatEnoughColor(string.format("%d/%d", mat.item_num, mat.cur_num), mat.enough)
    mat_icon.transform:SetParent(this.mats_root_)
    mat_icon.transform.localScale = Vector3.one
end

function EquipReforgePanel.ReforgeSuccess(message)
    local msg = item_msg_pb.smsg_equip_reforge()
    msg:ParseFromString(message.luabuff)
    if msg.equip.template_id ~= this.equip_state_.t_equip.id then
        return
    end
    soundMgr:play_sound("enhance_success")
    local mat = this.mat_state_[this.cur_select_color_]
    PlayerData.equips[this.equip_guid_] = msg.equip
    PlayerData.remove_item(mat.item_id, mat.item_num)
    --刷新界面
    EquipReforgePanel.RefreshPanel()
    EquipReforgePanel.RefreshMat(this.cur_select_color_)
    local msg = CommonMessage()
    msg.name = "equip_reforge_success"
    messMgr:AddCommonMessage(msg)
end

function EquipReforgePanel.OnSelectColor2Click(obj, is_on)
    if is_on then
        EquipReforgePanel.RefreshMat(2)
        this.cur_select_color_ = 2
    end
end

function EquipReforgePanel.OnSelectColor3Click(obj, is_on)
    if is_on then
        EquipReforgePanel.RefreshMat(3)
        this.cur_select_color_ = 3
    end
end

function EquipReforgePanel.OnSelectColor4Click(obj, is_on)
    if is_on then
        EquipReforgePanel.RefreshMat(4)
        this.cur_select_color_ = 4
    end
end

function EquipReforgePanel.OnSelectColor5Click(obj, is_on)
    if is_on then
        EquipReforgePanel.RefreshMat(5)
        this.cur_select_color_ = 5
    end
end

function EquipReforgePanel.OnReforgeBtnClick(obj)
    local mat = this.mat_state_[this.cur_select_color_]
    if mat == nil then
        GUIRoot.ShowPanel("MessagePanel", {"未知错误"})
        return
    end
    if not mat.enough then
        GUIRoot.ShowPanel("MessagePanel", { "材料不足，无法重铸" })
        return
    end
    if not mat.had_color then
        GUIRoot.ShowPanel("MessagePanel", { "没有此品质的属性,不能重铸" })
        return
    end
    local msg = item_msg_pb.cmsg_equip_reforge()
    msg.equip_guid = this.equip_guid_
    msg.color = this.cur_select_color_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_REFORGE, data, { opcodes.SMSG_EQUIP_REFORGE })
end

function EquipReforgePanel.OnCloseBtnClick(obj)
    EquipReforgePanel.Close()
end

function EquipReforgePanel.Close()
    GUIRoot.ClosePanel("EquipReforgePanel")
    GUIRoot.ShowPanel("EquipDetailPanel", { this.equip_state_.equip_info, this.equip_type_ })
end