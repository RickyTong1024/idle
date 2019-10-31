EquipDetailPanel = {}
EquipDetailPanel.Control = {}
local this = EquipDetailPanel.Control

function EquipDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.other_detail_ = this.transform_:Find("back_ground/panel_among/other_detail")
    this.scroll_rect_ = this.other_detail_:GetComponent("ScrollRect")
    this.content_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content")
    this.attr_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/attr_header")
    this.attr_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/attr_detail")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/other_detail/arrow_btn")
    this.reforge_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/reforge_header")
    this.reforge_null_text_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/reforge_null_text")
    this.reforge_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/reforge_detail")
    this.enchant_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/enchant_header")
    this.enchant_null_text_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/enchant_null_text")
    this.enchant_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/enchant_detail")
    this.inlay_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/inlay_header")
    this.inlay_null_text_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/inlay_null_text")
    this.inlay_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/inlay_detail")
    this.inlay_slot_ = this.transform_:Find("inlay_slot")
    this.btns_ = this.transform_:Find("back_ground/panel_among/btns")
    this.btns_mask_ = this.transform_:Find("back_ground/panel_among/btns_mask")
    this.btns_root_ = this.transform_:Find("back_ground/panel_among/btns/btns_root")
    this.enhance_btn_ = this.transform_:Find("back_ground/panel_among/btns/btns_root/enhance_btn")
    this.enchant_btn_ = this.transform_:Find("back_ground/panel_among/btns/btns_root/enchant_btn")
    this.reforge_btn_ = this.transform_:Find("back_ground/panel_among/btns/btns_root/reforge_btn")
    this.inlay_btn_ = this.transform_:Find("back_ground/panel_among/btns/btns_root/inlay_btn")
    this.develop_close_btn_ = this.transform_:Find("back_ground/panel_among/btns/btns_root/develop_close_btn")
    this.wear_btn_ = this.transform_:Find("back_ground/panel_among/btns/wear_btn")
    this.wear_btn_text_ = this.transform_:Find("back_ground/panel_among/btns/wear_btn/wear_btn_text")
    this.develop_open_btn_ = this.transform_:Find("back_ground/panel_among/btns/develop_open_btn")
    this.decompose_btn_ = this.transform_:Find("back_ground/panel_among/btns/decompose_btn")
    
    this.equip_info_ = nil
    this.equip_type_ = 0
    this.runes_ = {}
    this.enhance_ = 0
    this.t_equip_ = nil
    this.is_self_ = true
    this.can_operate_ = true
    this.is_in_slot_ = false

    EquipDetailPanel.RegisterBtnListers()
end

function EquipDetailPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.wear_btn_.gameObject, "click", EquipDetailPanel.OnWearBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.develop_open_btn_.gameObject, "click", EquipDetailPanel.OnDevelopOpenBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.develop_close_btn_.gameObject, "click", EquipDetailPanel.OnDevelopCloseBtnClick)
    UnlockManger.RegisterFunBtn({5001, this.enhance_btn_.gameObject, "click", EquipDetailPanel.OnEnhanceBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({5003, this.enchant_btn_.gameObject, "click", EquipDetailPanel.OnEnchantBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({5002, this.reforge_btn_.gameObject, "click", EquipDetailPanel.OnReforgeBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({5004, this.inlay_btn_.gameObject, "click", EquipDetailPanel.OnInlayBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({5006, this.decompose_btn_.gameObject, "click", EquipDetailPanel.OnDecomposeClick, nil ,this.lua_script_, true})
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EquipDetailPanel.OnClosetnClick)
    GameSys.ButtonRegister(this.lua_script_, this.btns_mask_.gameObject, "click", EquipDetailPanel.OnDevelopCloseBtnClick)
end

function EquipDetailPanel.OnDestroy(obj)
    UnlockManger.RemoveFunBtn({5001})
    UnlockManger.RemoveFunBtn({5002})
    UnlockManger.RemoveFunBtn({5003})
    UnlockManger.RemoveFunBtn({5004})
    UnlockManger.RemoveFunBtn({5006})
    this = {}
end

function EquipDetailPanel.OnParam(params)
    this.equip_info_ = params[1]
    this.is_self_ = GameSys.HadEquip(this.equip_info_.guid)
    if this.is_self_ then
        this.equip_type_ = params[2]
        this.can_operate_ = params[3]
        if this.can_operate_ == nil then
            this.can_operate_ = true
        end
        this.runes_ = GameSys.GetSlotRunes(this.equip_type_)
        this.enhance_ = GameSys.GetEquipEnhance(this.equip_info_)
    else
        this.equip_type_ = params[2]
        this.runes_ = params[3]
        this.enhance_ = params[4]
    end
    this.is_in_slot_ = GameSys.IsEquipWeared(this.equip_info_)
    local template_id = this.equip_info_.template_id
    this.t_equip_ = Config.get_config_value("t_equip", template_id)
end

function EquipDetailPanel.Start(obj)
    EquipDetailPanel.RefreshPanel()
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function EquipDetailPanel.RefreshPanel()
    EquipDetailPanel.SetData()
    --刷顶部详情icon
    EquipDetailPanel.RefreshInfoIcon()
    --刷中间详情框
    EquipDetailPanel.RefreshDetail()
    --刷底部按钮
    EquipDetailPanel.RefreshBtns()
    --设置高度
    GameSys.AdjustDetailBack(this.content_, this.other_detail_, this.panel_among_, this.back_ground_)
end

function EquipDetailPanel.SetData()

end

function EquipDetailPanel.RefreshInfoIcon()
    if not this.is_self_ then
        return
    end
    if this.is_in_slot_ then
        CommonPanel.SetSlotEquipInfoPanel(this.equip_info_, this.enhance_, this.runes_, this.lua_script_, this.info_root_)
    else
        CommonPanel.SetEquipInfoPanel(this.equip_info_, this.lua_script_, this.info_root_)
    end
end

function EquipDetailPanel.RefreshDetail()
    EquipDetailPanel.RefreshAttrDetail()
    EquipDetailPanel.RefreshReforgeDetail()
    EquipDetailPanel.RefreshEnchantDetail()
    EquipDetailPanel.RefreshInlayDetail()
end

function EquipDetailPanel.RefreshBtns()
    this.btns_mask_.gameObject:SetActive(false)
    if not this.is_self_  then
        this.wear_btn_.gameObject:SetActive(false)
        this.develop_open_btn_.gameObject:SetActive(false)
        this.decompose_btn_.gameObject:SetActive(false)
        CommonPanel.SetSlotEquipInfoPanel(this.equip_info_, this.enhance_, this.runes_, this.lua_script_, this.info_root_)
    else
        if not this.can_operate_ then
            this.btns_.gameObject:SetActive(false)
        else
            this.btns_.gameObject:SetActive(true)
            this.btns_root_.gameObject:SetActive(false)
            this.enhance_btn_.gameObject:SetActive(this.is_in_slot_)
            this.inlay_btn_.gameObject:SetActive(this.is_in_slot_)
            this.wear_btn_.gameObject:SetActive(this.is_in_slot_)
            this.decompose_btn_.gameObject:SetActive(not this.is_in_slot_)
            if this.is_in_slot_ then
                this.wear_btn_text_:GetComponent("Text").text = "更换"
            end
        end
    end
end

function EquipDetailPanel.RefreshAttrDetail()
    this.attr_header_:Find("light_star_image").gameObject:SetActive(true)
    this.attr_header_:Find("dark_star_image").gameObject:SetActive(false)
    local base_attr = GameSys.GetEquipBaseAttr(this.equip_info_)
    local per = this.equip_info_.percent
    Util.ClearChild(this.attr_detail_)
    local attr_text_ins = CommonPanel.GetEquipBaseAttrText(base_attr, per, this.enhance_, nil)
    attr_text_ins.transform:SetParent(this.attr_detail_, false)
end

function EquipDetailPanel.RefreshReforgeDetail()
    local attrs = GameSys.GetEquipReforgeValue(this.equip_info_)
    local has_attr = next(attrs) ~= nil
    this.reforge_header_:Find("light_star_image").gameObject:SetActive(has_attr)
    this.reforge_header_:Find("dark_star_image").gameObject:SetActive(not has_attr)
    this.reforge_detail_.gameObject:SetActive(has_attr)
    this.reforge_null_text_.gameObject:SetActive(not has_attr)
    if has_attr then
        Util.ClearChild(this.reforge_detail_)
        local height = 0
        for i = 1, #attrs do
            local attr = attrs[i]
            local attr_text_ins = CommonPanel.GetEquipRandomAttrText(attr, attr.per, this.enhance_, attr.color)
            attr_text_ins.transform:SetParent(this.reforge_detail_)
            attr_text_ins.transform.localScale = Vector3.one
            height = height + attr_text_ins.transform:GetComponent("RectTransform").sizeDelta.y
        end
        local rectTr = this.reforge_detail_.transform:GetComponent("RectTransform")
        local old_size = rectTr.sizeDelta
        if height < 30 then
            height = 30
        end
        rectTr.sizeDelta = Vector2(old_size.x, height)
    end
end

function EquipDetailPanel.RefreshEnchantDetail()
    local had_enchanted = (this.equip_info_.enchant_id ~= 0)
    this.enchant_header_:Find("light_star_image").gameObject:SetActive(had_enchanted)
    this.enchant_header_:Find("dark_star_image").gameObject:SetActive(not had_enchanted)
    this.enchant_detail_.gameObject:SetActive(had_enchanted)
    this.enchant_null_text_.gameObject:SetActive(not had_enchanted)
    local enchant_icon = this.enchant_detail_:Find("enchant_icon")
    enchant_icon.gameObject:SetActive(had_enchanted)
    if had_enchanted then
        local t_enchant = Config.get_config_value("t_equip_enchant", this.equip_info_.enchant_id)
        local enchant_icon_alias = t_enchant.icon
        if enchant_icon_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(enchant_icon_alias)
            enchant_icon:GetComponent("Image").sprite = sprite
        end
        local attr = GameSys.GetEquipEnchantValue(this.equip_info_)
        Util.RetainChild(this.enchant_detail_, "enchant_icon")
        local attr_text_ins = CommonPanel.GetAttrText(attr.t_attr.id, attr.value, 0, t_enchant.color)
        attr_text_ins.transform:SetParent(this.enchant_detail_, false)
    end
end

function EquipDetailPanel.RefreshInlayDetail()
    local need_refreh = this.is_in_slot_ or not this.is_self_
    this.inlay_header_.gameObject:SetActive(need_refreh)
    if not need_refreh then
        this.inlay_null_text_.gameObject:SetActive(false)
        this.inlay_detail_.gameObject:SetActive(false)
        return
    end
    local is_inlayed = false
    for i = 1, #this.runes_ do
        if this.runes_[i] ~= 0 then
            is_inlayed = true
            break
        end
    end
    this.inlay_header_:Find("light_star_image").gameObject:SetActive(is_inlayed)
    this.inlay_header_:Find("dark_star_image").gameObject:SetActive(not is_inlayed)
    this.inlay_detail_.gameObject:SetActive(is_inlayed)
    this.inlay_null_text_.gameObject:SetActive(not is_inlayed)
    local height = 0
    if is_inlayed then
        for i = 1, 3 do
            if this.runes_[i] ~= 0 then
                local slot_ins = GameObject.Instantiate(this.inlay_slot_.gameObject)
                slot_ins:SetActive(true)
                slot_ins.transform:SetParent(this.inlay_detail_)
                slot_ins.transform.localScale = Vector3.one
                local rune_id = this.runes_[i]
                local t_rune = Config.get_config_value("t_rune", rune_id)
                local icon_alias = t_rune.icon
                local rune_icon = slot_ins.transform:Find("rune_icon")
                local attr_text_root = slot_ins.transform:Find("attr_text_root")
                if icon_alias ~= "" then
                    rune_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "rune"):GetSprite(icon_alias)
                end
                Util.ClearChild(attr_text_root)
                local attr_text = CommonPanel.GetAttrText(t_rune.attr_id, t_rune.attr_value, 0)
                Util.SetRoot(attr_text.transform, attr_text_root)
                height = height + slot_ins.transform:GetComponent("RectTransform").sizeDelta.y
            end
        end
        local rectTr = this.inlay_detail_.transform:GetComponent("RectTransform")
        local old_size = rectTr.sizeDelta
        rectTr.sizeDelta = Vector2(old_size.x, height)
    end
end

function EquipDetailPanel.OnWearBtnClick(obj)
    GUIRoot.ShowPanel("ChangeEquipPanel", { this.equip_type_ })
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnDevelopOpenBtnClick(obj)
    this.btns_root_.gameObject:SetActive(true)
    this.develop_open_btn_.gameObject:SetActive(false)
    this.btns_mask_.gameObject:SetActive(true)
end

function EquipDetailPanel.OnDevelopCloseBtnClick(obj)
    this.btns_root_.gameObject:SetActive(false)
    this.develop_open_btn_.gameObject:SetActive(true)
    this.btns_mask_.gameObject:SetActive(false)
end

function EquipDetailPanel.OnEnhanceBtnClick(obj)
    GUIRoot.ShowPanel("EquipEnhancePanel", { this.equip_info_.guid, this.equip_type_ })
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnEnchantBtnClick(obj)
    GUIRoot.ShowPanel("EquipEnchantPanel", { this.equip_info_.guid, this.equip_type_ })
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnReforgeBtnClick(obj)
    GUIRoot.ShowPanel("EquipReforgePanel", { this.equip_info_.guid, this.equip_type_ })
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnInlayBtnClick(obj)
    GUIRoot.ShowPanel("EquipInlayPanel", { this.equip_info_.guid, this.equip_type_ })
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnDecomposeClick(obj, params)
    BagPanel.EquipDecompose()
    EquipDetailPanel.Close()
end

function EquipDetailPanel.OnClosetnClick(obj)
    EquipDetailPanel.Close()
end

function EquipDetailPanel.Close()
    GUIRoot.ClosePanel("EquipDetailPanel")
end

