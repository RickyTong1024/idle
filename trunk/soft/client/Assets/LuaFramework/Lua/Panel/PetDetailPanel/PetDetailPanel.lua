PetDetailPanel = {}
PetDetailPanel.Control = {}
local this = PetDetailPanel.Control

function PetDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.other_detail_ = this.transform_:Find("back_ground/panel_among/other_detail")
    this.content_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content")
    this.scroll_rect_ = this.other_detail_:GetComponent("ScrollRect")
    this.attr_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/attr_header")
    this.attr_null_text_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/attr_null_text")
    this.attr_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/attr_detail")
    this.talent_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/talent_header")
    this.talent_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/talent_detail")
    this.reward_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/reward_detail")
    this.reward_header_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/reward_header")
    this.gets_root_ = this.transform_:Find("back_ground/panel_among/other_detail/view/content/gets_root")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/other_detail/arrow_btn")
    this.upgrade_btn_ = this.transform_:Find("back_ground/panel_among/upgrade_btn")
    this.enhance_btn_ = this.transform_:Find("back_ground/panel_among/enhance_btn")
    this.synt_btn_ = this.transform_:Find("back_ground/panel_among/synt_btn")
    this.talent_slot_ = this.transform_:Find("back_ground/talent_slot")

    this.cur_pet_id_ = 0
    this.cur_pet_guid_ = "0"
    this.pet_state_ = {}
    this.need_scroll_arrow_ = false

    PetDetailPanel.RegisterBtnListers()
end

function PetDetailPanel.OnDestroy(obj)
    this = {}
end

function PetDetailPanel.OnParam(params)
    this.cur_pet_guid_ = params[1]
    this.cur_pet_id_ = params[2]
end

function PetDetailPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PetDetailPanel.OnCloseClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.upgrade_btn_.gameObject, "click", PetDetailPanel.OnUpGradeClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.enhance_btn_.gameObject, "click", PetDetailPanel.OnEnhance, nil)
    GameSys.ButtonRegister(this.lua_script_, this.synt_btn_.gameObject, "click", PetDetailPanel.OnSyntClick, nil)
end

function PetDetailPanel.Start(obj)
    PetDetailPanel.RefreshPanel()
end

function PetDetailPanel.SetData()
    this.pet_state_ = {
        ["t_pet"] = nil,
        ["had_pet"] = this.cur_pet_guid_ ~= "0",
        ["pet_info"] = nil,
        ["t_pet_level"] = nil,
        ["is_weared"] = false,
        ["had_get"] = false
    }
    this.pet_state_.t_pet = Config.get_config_value("t_pet", this.cur_pet_id_)
    if this.pet_state_.had_pet then
        this.pet_state_.pet_info = PlayerData.pets[this.cur_pet_guid_]
        this.pet_state_.t_pet_level = Config.get_config_value("t_level", this.pet_state_.pet_info.level)
        this.pet_state_.is_weared = GameSys.IsPetWeared(this.cur_pet_guid_)
        local index = GameSys.getIndex(PlayerData.player.pet_ids, this.pet_state_.t_pet.id)
        local had_get = PlayerData.player.pet_unlocks[index] == 1
        this.pet_state_.had_get = had_get
    else
        this.pet_state_.t_pet_level = Config.get_config_value("t_level", 1)
    end
end

function PetDetailPanel.RefreshPanel()
    PetDetailPanel.SetData()
    --刷顶部详情icon
    CommonPanel.SetPetInfoPanel(this.pet_state_.pet_info, this.pet_state_.t_pet.id,this.lua_script_, this.info_root_)
    --刷中间详情框
    PetDetailPanel.RefreshAttrRect()
    PetDetailPanel.RefreshTalentRect()
    PetDetailPanel.RefreshReputationRect()
    PetDetailPanel.RefreshGetsRect()
    --刷底部按钮
    if this.pet_state_.had_pet then
        this.upgrade_btn_.gameObject:SetActive(not GameSys.PetNeedEnhance(this.pet_state_.pet_info.level, this.pet_state_.pet_info.enhance))
        this.enhance_btn_.gameObject:SetActive(GameSys.PetNeedEnhance(this.pet_state_.pet_info.level, this.pet_state_.pet_info.enhance))
    else
        this.upgrade_btn_.gameObject:SetActive(false)
        this.enhance_btn_.gameObject:SetActive(false)
    end
    this.synt_btn_.gameObject:SetActive(not this.pet_state_.had_pet)
    --设置总高度
    GameSys.AdjustDetailBack(this.content_, this.other_detail_, this.panel_among_, this.back_ground_)
    --设置下滑动箭头
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end


function PetDetailPanel.RefreshAttrRect()
    this.attr_header_:Find("light_star_image").gameObject:SetActive(this.pet_state_.had_pet)
    this.attr_header_:Find("dark_star_image").gameObject:SetActive(not this.pet_state_.had_pet)
    local attrs = {}
    local level = 1
    if this.pet_state_.pet_info then
        level = this.pet_state_.pet_info.level
    end
    attrs = GameSys.GetPetAttrs(level, this.cur_pet_id_)
    local has_attr = next(attrs) ~= nil
    this.attr_detail_.gameObject:SetActive(has_attr)
    this.attr_null_text_.gameObject:SetActive(not has_attr)
    if attrs then
        PetDetailPanel.SetAttrs(this.attr_detail_, attrs)
    end
end

function PetDetailPanel.SetAttrs(root, attrs)
    Util.ClearChild(root)
    local height = 0
    for i = 1, #attrs do
        local attr = attrs[i]
        if attr.t_attr ~= nil then
            local attr_text_ins = nil
            attr_text_ins = CommonPanel.GetAttrText(attr.t_attr.id, attr.value, 0)
            attr_text_ins.transform:SetParent(root)
            attr_text_ins.transform.localScale = Vector3.one
            height = height + attr_text_ins.transform:GetComponent("RectTransform").sizeDelta.y
        end
    end
    local rectTr = root.transform:GetComponent("RectTransform")
    local old_size = rectTr.sizeDelta
    rectTr.sizeDelta = Vector2(old_size.x, height)
end

function PetDetailPanel.RefreshTalentRect()
    this.talent_header_:Find("light_star_image").gameObject:SetActive(this.pet_state_.had_pet)
    this.talent_header_:Find("dark_star_image").gameObject:SetActive(not this.pet_state_.had_pet)
    local enhance = this.pet_state_.pet_info and this.pet_state_.pet_info.enhance or 0
    local talents = GameSys.GetPetTalents(this.pet_state_.t_pet.id, enhance)
    Util.ClearChild(this.talent_detail_)
    for i = 1, #talents do
        local talent = talents[i]
        local slot_ins = GameObject.Instantiate(this.talent_slot_.gameObject)
        slot_ins:SetActive(true)
        slot_ins.transform:SetParent(this.talent_detail_, false)
        local icon_root = slot_ins.transform:Find("icon_root")
        local talent_name = slot_ins.transform:Find("talent_name")
        local talent_desc = slot_ins.transform:Find("talent_desc")
        local icon = CommonPanel.GetPetTalentIcon(talent.t_pet_talent.id, this.lua_script_, nil)
        Util.SetRoot(icon.transform, icon_root)
        local name_content  = ""
        local talent_desc_content = ""
        name_content = talent.t_pet_talent.name
        talent_desc_content = GameSys.GetPetTalentDesc(talent.t_pet_talent.id, enhance)
        talent_name:GetComponent("Text").text = name_content .. " LV" .. (enhance + 1)
        talent_desc:GetComponent("Text").text = talent_desc_content
    end
    local rectTr = this.talent_detail_:GetComponent("RectTransform")
    local old_size = rectTr.sizeDelta
    rectTr.sizeDelta = Vector2(old_size.x, 60 * (#talents) + 10 * (#talents - 1))
end

function PetDetailPanel.RefreshReputationRect()
    this.reward_header_:Find("light_star_image").gameObject:SetActive(this.pet_state_.had_pet)
    this.reward_header_:Find("dark_star_image").gameObject:SetActive(not this.pet_state_.had_pet)
    Util.ClearChild(this.reward_detail_)
    local title = string.format("合成 %s", this.pet_state_.t_pet.name)
    local unlock_slot = CommonPanel.GetReputationUnlockSlot(title, this.pet_state_.t_pet.reputation, this.pet_state_.had_get )
    unlock_slot.transform:SetParent(this.reward_detail_, false)
    unlock_slot:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
end

function PetDetailPanel.RefreshGetsRect()
    Util.ClearChild(this.gets_root_)
    local gets = GameSys.GetGetInfo(6, this.cur_pet_id_)
    for i = 1, #gets do
        local get_res = CommonPanel.GetGetIcon(this.lua_script_, gets[i])
        get_res.transform:SetParent(this.gets_root_, false)
    end
end

function PetDetailPanel.SetDetailRect()
    this.need_scroll_arrow_ = GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function PetDetailPanel.OnUpGradeClick(obj, params)
    GUIRoot.ShowPanel("PetUpgradePanel", {this.cur_pet_guid_, this.cur_pet_id_})
    PetDetailPanel.Close()
end

function PetDetailPanel.OnEnhance(obj, params)
    GUIRoot.ShowPanel("PetEnhancePanel", { this.cur_pet_guid_, this.cur_pet_id_ })
    PetDetailPanel.Close()
end

function PetDetailPanel.OnSyntClick(obj, params)
    GUIRoot.ShowPanel("PetSyntPanel", { this.cur_pet_id_ })
    PetDetailPanel.Close()
end

function PetDetailPanel.OnCloseClick(obj, params)
    PetDetailPanel.Close()
end

function PetDetailPanel.Close()
    GUIRoot.ClosePanel("PetDetailPanel")
end