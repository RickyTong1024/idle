EquipEnchantPanel = {}
EquipEnchantPanel.Control = {}
local this = EquipEnchantPanel.Control

function EquipEnchantPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.enchant_icon_ = this.transform_:Find("back_ground/panel_among/enchant_icon")
    this.enchant_attrs_ = this.transform_:Find("back_ground/panel_among/enchant_attrs")
    this.enchant_btn_ = this.transform_:Find("back_ground/panel_among/enchant_btn")
    this.enchant_ex_btn_ = this.transform_:Find("back_ground/panel_among/enchant_ex_btn")
    this.jewel_price_text_ = this.transform_:Find("back_ground/panel_among/enchant_ex_btn/jewel_price_text")
    this.gold_price_text_ = this.transform_:Find("back_ground/panel_among/enchant_btn/gold_price_text")

    this.equip_guid_ = "0"
    this.equip_type_ = 0
    this.equip_state_ = {}
    this.money_state_ = {}
    this.cur_pay_type_ = 1  --1 金币 2 钻石

    EquipEnchantPanel.RegisterBtnListers()
    EquipEnchantPanel.RegisterMessage()
end

function EquipEnchantPanel.OnDestroy(obj)
    EquipEnchantPanel.RemoveMessage()
    this = {}
end

function EquipEnchantPanel.OnParam(params)
    this.equip_guid_ = params[1]
    this.equip_type_ = params[2]
end

function EquipEnchantPanel.Start(obj)
    EquipEnchantPanel.RefreshPanel()
end

function EquipEnchantPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.enchant_btn_.gameObject, "click", EquipEnchantPanel.OnEnchantBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.enchant_ex_btn_.gameObject, "click", EquipEnchantPanel.OnEnchantExBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EquipEnchantPanel.OnCloseBtnClick)
end

function EquipEnchantPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_EQUIP_ENCHANT, EquipEnchantPanel.OnEnchantExSuccess)
end

function EquipEnchantPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_ENCHANT, EquipEnchantPanel.OnEnchantExSuccess)
end

function EquipEnchantPanel.RefreshPanel()
    EquipEnchantPanel.SetData()

    local is_weared = GameSys.IsEquipWeared(this.equip_state_.equip_info)
    if is_weared then
        local enhance = GameSys.GetEquipEnhance(this.equip_state_.equip_info)
        local runes = GameSys.GetSlotRunes(this.equip_type_)
        CommonPanel.SetSlotEquipInfoPanel(this.equip_state_.equip_info, enhance, runes, this.lua_script_, this.info_root_)
    else
        CommonPanel.SetEquipInfoPanel(this.equip_state_.equip_info, this.lua_script_, this.info_root_)
    end
    this.enchant_icon_.gameObject:SetActive(this.equip_state_.had_enchant)
    this.enchant_attrs_.gameObject:SetActive(this.equip_state_.had_enchant)
    if this.equip_state_.had_enchant then
        local t_equip_enchant = Config.get_config_value("t_equip_enchant", this.equip_state_.equip_info.enchant_id)
        local enchant_icon_alias = t_equip_enchant.icon
        if enchant_icon_alias ~= "" then
            this.enchant_icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(enchant_icon_alias)
        end
        local attr = GameSys.GetEquipEnchantValue(this.equip_state_.equip_info)
        Util.ClearChild(this.enchant_attrs_)
        if attr ~= nil then
            local attr_text_ins = CommonPanel.GetAttrText(attr.t_attr.id, attr.value, 1, t_equip_enchant.color)
            attr_text_ins.transform:SetParent(this.enchant_attrs_)
            attr_text_ins.transform.localScale = Vector3.one
        end
    end
    this.gold_price_text_:GetComponent("Text").text = GameSys.PriceEnoughColor(GameSys.unit_conversion(this.money_state_.gold.need_num), this.money_state_.gold.is_enough)
    this.jewel_price_text_:GetComponent("Text").text = GameSys.PriceEnoughColor(GameSys.unit_conversion(this.money_state_.jewel.need_num), this.money_state_.jewel.is_enough)
end

function EquipEnchantPanel.SetData()
    local equip_info = PlayerData.equips[this.equip_guid_]
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    local cur_gold = PlayerData.player.gold
    local cur_jewel = PlayerData.player.jewel
    local enchant_count = equip_info.enchant_count
    local price_increase = Config.get_config_value("t_const", "equip_enchant_price_increase").value
    price_increase = (price_increase) / 100 + 1
    local need_gold = toInt(t_equip.fprice * math.pow(price_increase, enchant_count))
    local need_jewel = Config.get_config_value("t_const", "equip_enchant_price_crystal").value
    local gold_enough = (cur_gold >= need_gold)
    local jewel_enough = (cur_jewel >= need_jewel)
    this.equip_state_ = {
        ["guid"] = this.equip_guid_,
        ["equip_info"] = equip_info,
        ["t_equip"] = t_equip,
        ["had_enchant"] = (equip_info.enchant_id ~= 0)
    }
    this.money_state_ = {
        ["gold"] = {
            ["need_num"] = need_gold,
            ["cur_num"] = cur_gold,
            ["is_enough"] = gold_enough
        },
        ["jewel"] = {
            ["need_num"] = need_jewel,
            ["cur_num"] = cur_jewel,
            ["is_enough"] = jewel_enough
        }
    }
end

function EquipEnchantPanel.OnEnchantBtnClick(obj)
    if not this.money_state_.gold.is_enough then
        GUIRoot.ShowPanel("MessagePanel", { "金币不足，无法附魔" })
        return
    end
    this.cur_pay_type_ = 1
    local msg = item_msg_pb.cmsg_equip_enchant()
    msg.type = this.cur_pay_type_
    msg.equip_guid = this.equip_guid_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_ENCHANT, data, { opcodes.SMSG_EQUIP_ENCHANT })
end

function EquipEnchantPanel.OnEnchantExBtnClick(obj)
    if not this.money_state_.jewel.is_enough then
        GUIRoot.ShowPanel("MessagePanel", { "钻石不足，无法附魔" })
        return
    end
    this.cur_pay_type_ = 2
    local msg = item_msg_pb.cmsg_equip_enchant()
    msg.type = this.cur_pay_type_
    msg.equip_guid = this.equip_guid_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_ENCHANT, data, { opcodes.SMSG_EQUIP_ENCHANT })
end

function EquipEnchantPanel.OnCloseBtnClick(obj)
    EquipEnchantPanel.Close()
end

function EquipEnchantPanel.OnEnchantExSuccess(message)
    local msg = item_msg_pb.smsg_equip_enchant()
    msg:ParseFromString(message.luabuff)
    if this.cur_pay_type_ == 1 then
        PlayerData.add_resource(1, -this.money_state_.gold.need_num)
        PlayerData.equips[this.equip_guid_].enchant_count = PlayerData.equips[this.equip_guid_].enchant_count + 1
    elseif this.cur_pay_type_ == 2 then
        PlayerData.add_resource(2, -this.money_state_.jewel.need_num)
    end
    PlayerData.equips[this.equip_guid_].enchant_id = msg.enchant_id
    PlayerData.equips[this.equip_guid_].enchant_value = msg.enchant_value
    -- 每日任务
    PlayerData.daily_schedule(1008, 1)
    AssetsChangeControl.OnDailyChanged()
    local common_msg = CommonMessage()
    common_msg.name = "enchant_equip_success"
    messMgr:AddCommonMessage(common_msg)
    EquipEnchantPanel.RefreshPanel()
end

function EquipEnchantPanel.Close()
    GUIRoot.ClosePanel("EquipEnchantPanel")
    GUIRoot.ShowPanel("EquipDetailPanel", { this.equip_state_.equip_info, this.equip_type_ })
end