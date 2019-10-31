EquipEnhancePanel = {}
EquipEnhancePanel.Control = {}
local this = EquipEnhancePanel.Control

function EquipEnhancePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.detail_ = this.transform_:Find("back_ground/panel_among/attr_back_image")
    this.scroll_rect_ = this.detail_:GetComponent("ScrollRect")
    this.content_ = this.transform_:Find("back_ground/panel_among/attr_back_image/view/content")
    this.enhance_level_root_ = this.transform_:Find("back_ground/panel_among/attr_back_image/view/content/enhance_level_root")
    this.max_level_text_ = this.transform_:Find("back_ground/panel_among/max_level_text")
    this.base_attr_root_ = this.transform_:Find("back_ground/panel_among/attr_back_image/view/content/base_attr_root")
    this.reforge_attr_title_ = this.transform_:Find("back_ground/panel_among/attr_back_image/view/content/reforge_attr_title")
    this.reforge_attr_root_ = this.transform_:Find("back_ground/panel_among/attr_back_image/view/content/reforge_attr_root")
    this.mats_root_ = this.transform_:Find("back_ground/panel_among/mat_detail/mats_root")
    this.enhance_btn_ = this.transform_:Find("back_ground/panel_among/enhance_btn")
    this.gold_price_text_ = this.transform_:Find("back_ground/panel_among/enhance_btn/gold_price_text")
    this.success_rate_text_ = this.transform_:Find("back_ground/panel_among/enhance_btn/success_rate_text")
    this.gold_icon_ = this.transform_:Find("back_ground/panel_among/enhance_btn/gold_price_text/mul_text/gold_icon")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/attr_back_image/arrow_btn")
    this.enhance_attr_text_ = this.transform_:Find("back_ground/enhance_attr_text")

    this.equip_guid_ = "0"
    this.equip_type_ = 0
    this.equip_info_ = nil
    this.equip_state_ = {}
    this.mat_state_ = {}
    this.gold_state_ = {}

    EquipEnhancePanel.RegisterBtnListers()
    EquipEnhancePanel.RegisterMessage()
end

function EquipEnhancePanel.OnDestroy()
    EquipEnhancePanel.RemoveMessage()
    this = {}
end

function EquipEnhancePanel.OnParam(params)
    this.equip_guid_ = params[1]
    this.equip_type_ = params[2]
    this.equip_info_ = PlayerData.equips[this.equip_guid_]
end

function EquipEnhancePanel.Start()
    EquipEnhancePanel.RefreshPanel()
end

function EquipEnhancePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.enhance_btn_.gameObject, "click", EquipEnhancePanel.OnEnhanceBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EquipEnhancePanel.OnCloseBtnClick)
end

function EquipEnhancePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_EQUIP_ENHANCE, EquipEnhancePanel.EnhanceDone)
end

function EquipEnhancePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_ENHANCE, EquipEnhancePanel.EnhanceDone)
end

function EquipEnhancePanel.RefreshPanel()
    EquipEnhancePanel.SetData()
    local enhance = GameSys.GetEquipEnhance(this.equip_info_)
    local runes = GameSys.GetSlotRunes(this.equip_type_)
    --刷顶部icon
    CommonPanel.SetSlotEquipInfoPanel(this.equip_info_, enhance, runes, this.lua_script_, this.info_root_)
    --刷最大强化等级
    this.max_level_text_:GetComponent("Text").text = string.format("最大强化等级 %d级", this.equip_state_.max_enhance)
    --刷中间强化详情
    Util.ClearChild(this.enhance_level_root_)
    local level_text = GameObject.Instantiate(this.enhance_attr_text_.gameObject)
    level_text.gameObject:SetActive(true)
    Util.SetRoot(level_text.transform, this.enhance_level_root_)
    if not this.equip_state_.is_max_enhance then
        EquipEnhancePanel.SetEnhanceText(level_text, "等级", this.equip_state_.cur_enhance, this.equip_state_.next_enhance)
    else
        EquipEnhancePanel.SetEnhanceText(level_text, "等级", this.equip_state_.cur_enhance, "Max")
    end
    Util.ClearChild(this.base_attr_root_)
    local base_attr_text = GameObject.Instantiate(this.enhance_attr_text_.gameObject)
    base_attr_text.gameObject:SetActive(true)
    Util.SetRoot(base_attr_text.transform, this.base_attr_root_)
    local cur_base_attr_str = GameSys.GetAttrValueText(this.equip_state_.cur_base_attr.attr_id, this.equip_state_.cur_base_attr.value)
    local next_base_attr_str = ""
    if not this.equip_state_.is_max_enhance then
        next_base_attr_str = GameSys.GetAttrValueText(this.equip_state_.next_base_attr.attr_id, this.equip_state_.next_base_attr.value)
    else
        next_base_attr_str = "Max"
    end
    EquipEnhancePanel.SetEnhanceText(base_attr_text, GameSys.GetAttrNameText(this.equip_state_.cur_base_attr.attr_id), cur_base_attr_str, next_base_attr_str)
    this.reforge_attr_title_.gameObject:SetActive(this.equip_state_.had_reforge)
    this.reforge_attr_root_.gameObject:SetActive(this.equip_state_.had_reforge)
    local height = 0
    local per_height = this.enhance_attr_text_.transform:GetComponent("RectTransform").rect.height
    if this.equip_state_.had_reforge then
        Util.ClearChild(this.reforge_attr_root_)
        for i = 1, #this.equip_state_.cur_reforge_attr do
            local reforge_attr_text = GameObject.Instantiate(this.enhance_attr_text_.gameObject)
            reforge_attr_text.gameObject:SetActive(true)
            Util.SetRoot(reforge_attr_text.transform, this.reforge_attr_root_)
            local cur_reforge_state = this.equip_state_.cur_reforge_attr[i]
            local title = ""
            local cur_reforge_attr_str = ""
            local attr_type = cur_reforge_state.attr_type  ---1 是属性 2 是技能
            if attr_type == 1 then
                title = GameSys.GetAttrNameText(cur_reforge_state.t_attr.id)
                cur_reforge_attr_str = GameSys.GetAttrValueText(cur_reforge_state.t_attr.id, cur_reforge_state.value)
            else
                title = Config.get_config_value("t_spell", cur_reforge_state.spell_id).name
                cur_reforge_attr_str = "LV ".. cur_reforge_state.value
            end
            
            local next_refore_attr_str = ""
            if attr_type == 1 then
                if not GameSys.IsPerAttr(cur_reforge_state.t_attr.id) then
                    if this.equip_state_.is_max_enhance then
                        next_refore_attr_str = "Max"
                    else
                        local next_reforge_state = this.equip_state_.next_refore_attr[i]
                        next_refore_attr_str = GameSys.GetAttrValueText(next_reforge_state.t_attr.id, next_reforge_state.value)
                    end
                else
                    next_refore_attr_str = "不能提升"
                end
            else
                next_refore_attr_str = "不能提升"
            end
            EquipEnhancePanel.SetEnhanceText(reforge_attr_text, title, cur_reforge_attr_str, next_refore_attr_str, this.equip_state_.cur_reforge_attr[i].color)
            height = height + per_height
        end
    end
    GameSys.SetRectHeight(this.reforge_attr_root_, height)
    --刷材料
    Util.ClearChild(this.mats_root_)
    if this.mat_state_.need_mat then
        local mat_ins = GameSys.GetMatIcon(this.mat_state_.mat_id, this.mat_state_.cur_count, this.mat_state_.need_count, "enhance_mat_icon", this.lua_script_)
        Util.SetRoot(mat_ins.transform, this.mats_root_)
    end
    --刷按钮
    this.gold_price_text_.gameObject:SetActive(this.gold_state_.need_gold)
    if this.gold_state_.need_gold then
        local content = GameSys.unit_conversion(this.gold_state_.need_count)
        this.gold_price_text_:GetComponent("Text").text = GameSys.MatEnoughColor(content, this.gold_state_.is_enough)
    end
    this.success_rate_text_:GetComponent("Text").text = string.format("%s:%d%%", "成功率", this.equip_state_.success_rate)
    this.success_rate_text_.gameObject:SetActive(not this.equip_state_.is_max_enhance)
    --设置高度
    GameSys.AdjustDetailBack(this.content_, this.detail_, this.panel_among_, this.back_ground_)
    --设置滑动按钮
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function EquipEnhancePanel.SetEnhanceText(text_ins, header, cur_value_str, next_value_str, color)
    local header_text = text_ins.transform:Find("header"):GetComponent("Text")
    local cur_value_text = text_ins.transform:Find("cur_value"):GetComponent("Text")
    local next_value_text = text_ins.transform:Find("next_value"):GetComponent("Text")
    if color ~= nil then
        header = GameSys.set_color(color, header)
        cur_value_str = GameSys.set_color(color, cur_value_str)
        next_value_str = GameSys.set_color(color, next_value_str)
    end
    header_text.text = header
    cur_value_text.text = cur_value_str
    next_value_text.text = next_value_str
end

function EquipEnhancePanel.SetData()
    this.equip_state_ = {
        ["cur_enhance"] = 0,
        ["max_enhance"] = 0,
        ["is_max_enhance"] = false,
        ["next_enhance"] = 0,
        ["cur_base_attr"] = {},
        ["next_base_attr"] = {},
        ["had_reforge"] = false,
        ["cur_reforge_attr"] = {},
        ["next_refore_attr"] = {},
        ["success_rate"] = 0,
    }
    local enhance = GameSys.GetEquipEnhance(this.equip_info_)
    this.equip_state_.cur_enhance = enhance
    local t_equip = Config.get_config_value("t_equip", this.equip_info_.template_id)
    this.equip_state_.max_enhance = t_equip.enhance_limit
    this.equip_state_.is_max_enhance =  this.equip_state_.cur_enhance >= this.equip_state_.max_enhance
    this.equip_state_.next_enhance = enhance + 1
    local t_next_enhance = Config.get_config_value("t_equip_enhance", this.equip_state_.next_enhance)

    local base_attr = GameSys.GetEquipBaseAttr(this.equip_info_)
    this.equip_state_.cur_base_attr = {
        ["attr_id"] = base_attr.t_attr.id,
        ["value"] = base_attr.total_value
    }
    if not this.equip_state_.is_max_enhance then
        local next_base_attr = GameSys.GetEquipBaseAttr(this.equip_info_, enhance + 1)
        this.equip_state_.next_base_attr = {
            ["attr_id"] = next_base_attr.t_attr.id,
            ["value"] = next_base_attr.total_value
        }
    end
    this.equip_state_.had_reforge = #this.equip_info_.attr_ids > 0
    if this.equip_state_.had_reforge then
        local refore_attrs = GameSys.GetEquipReforgeValue(this.equip_info_)
        for i = 1, #refore_attrs do
            table.insert(this.equip_state_.cur_reforge_attr, {
                ["attr_type"] = refore_attrs[i].attr_type,
                ["t_attr"] = refore_attrs[i].t_attr,
                ["spell_id"] = refore_attrs[i].spell_id,
                ["value"] = refore_attrs[i].value + refore_attrs[i].enhance_value,
                ["color"] = refore_attrs[i].color
            })
        end
        if not this.equip_state_.is_max_enhance then
            local next_refore_attrs = GameSys.GetEquipReforgeValue(this.equip_info_, enhance + 1)
            for i = 1, #refore_attrs do
                table.insert(this.equip_state_.next_refore_attr, {
                    ["attr_type"] = next_refore_attrs[i].attr_type,
                    ["t_attr"] = next_refore_attrs[i].t_attr,
                    ["spell_id"] = refore_attrs[i].spell_id,
                    ["value"] =  next_refore_attrs[i].value + next_refore_attrs[i].enhance_value,
                    ["color"] = next_refore_attrs[i].color
                })
            end
        end
    end
    if not this.equip_state_.is_max_enhance then
        this.equip_state_.success_rate = t_next_enhance.prob
    end
    this.mat_state_ = {
        ["need_mat"] = true,
        ["mat_id"] = 0,
        ["need_count"] = 0,
        ["cur_count"] = 0,
        ["is_enough"] = false
    }
    if this.equip_state_.is_max_enhance then
        this.mat_state_.need_mat = false
    else
        this.mat_state_.mat_id = t_next_enhance.item_id
        this.mat_state_.need_count = t_next_enhance.item_num
        local num = GameSys.GetItemCount(this.mat_state_.mat_id)
        this.mat_state_.cur_count = num
        this.mat_state_.is_enough = num >= this.mat_state_.need_count
    end

    this.gold_state_ = {
        ["need_gold"] = true,
        ["need_count"] = 0,
        ["cur_gold"] = 0,
        ["is_enough"] = false
    }
    if this.equip_state_.is_max_enhance then
        this.gold_state_.need_gold = false
    else
        this.gold_state_.need_count = t_next_enhance.gold
        this.gold_state_.cur_gold = PlayerData.player.gold
        this.gold_state_.is_enough = this.gold_state_.cur_gold >= this.gold_state_.need_count
    end
end

function EquipEnhancePanel.OnEnhanceBtnClick()
    if this.equip_state_.is_max_enhance then
        GUIRoot.ShowPanel("MessagePanel", { "达到强化上限，无法强化" })
        return
    end
    if not this.mat_state_.is_enough then
        GUIRoot.ShowPanel("MessagePanel", { "材料不足，无法强化" })
        return
    end
    if not this.gold_state_.is_enough then
        GUIRoot.ShowPanel("MessagePanel", { "金币不足，无法强化" })
        return
    end
    local msg = item_msg_pb.cmsg_equip_enhance()
    msg.equip_guid = this.equip_guid_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_ENHANCE, data, { opcodes.SMSG_EQUIP_ENHANCE })
end

function EquipEnhancePanel.OnCloseBtnClick()
    EquipEnhancePanel.Close()
end

function EquipEnhancePanel.Close()
    GUIRoot.ClosePanel("EquipEnhancePanel")
    GUIRoot.ShowPanel("EquipDetailPanel", { this.equip_info_, this.equip_type_ })
end

function EquipEnhancePanel.EnhanceDone(message)
    local msg = item_msg_pb.smsg_equip_enhance()
    msg:ParseFromString(message.luabuff)
    local enhance_result = msg.result
    local enhance = GameSys.GetEquipEnhance(this.equip_info_)
    local t_equip_enhance = Config.get_config_value('t_equip_enhance', enhance + 1)
    PlayerData.remove_item(this.mat_state_.mat_id, this.mat_state_.need_count)
    PlayerData.add_resource(1, -this.gold_state_.need_count)

    if enhance_result then
        soundMgr:play_sound("enhance_success")
        PlayerData.player.equip_enhances[this.equip_type_] = PlayerData.player.equip_enhances[this.equip_type_] + 1
        GUIRoot.ShowPanel("MessagePanel", { "强化成功" })
    else
        soundMgr:play_sound("enhance_down")
        PlayerData.player.equip_enhances[this.equip_type_] = PlayerData.player.equip_enhances[this.equip_type_] - t_equip_enhance.fail
        GUIRoot.ShowPanel("MessagePanel", { "强化失败" })
    end

    local msg_common = CommonMessage()
    msg_common.name = "enhance_equip_done"
    messMgr:AddCommonMessage(msg_common)
    EquipEnhancePanel.RefreshPanel()
end
