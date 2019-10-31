MonsterDetailPanel = {}
MonsterDetailPanel.Control = {}
local this = MonsterDetailPanel.Control

function MonsterDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.detail_ = this.transform_:Find("back_ground/panel_among/detail")
    this.scroll_rect_ = this.detail_:GetComponent("ScrollRect")
    this.content_ = this.transform_:Find("back_ground/panel_among/detail/view/content")
    this.attr_header_ = this.transform_:Find("back_ground/panel_among/detail/view/content/attr_header")
    this.attr_detail_ = this.transform_:Find("back_ground/panel_among/detail/view/content/attr_detail")
    this.unlock_header_ = this.transform_:Find("back_ground/panel_among/detail/view/content/unlock_header")
    this.had_kill_header_ = this.transform_:Find("back_ground/panel_among/detail/view/content/had_kill_header")
    this.unlock_detail_ = this.transform_:Find("back_ground/panel_among/detail/view/content/unlock_detail")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/detail/arrow_btn")
    this.drop_detail_ = this.transform_:Find("back_ground/panel_among/drop_detail")
    this.drop_root_ = this.transform_:Find("back_ground/panel_among/drop_detail/drop_root")
    this.attr_text_ = this.transform_:Find("back_ground/attr_text")
    this.sure_btn_ = this.transform_:Find("back_ground/panel_among/sure_btn")

    this.t_mission_ = nil
    this.t_monster_ = nil
    this.t_role_ = nil
    this.t_reputation_ = nil
    this.reputation_state_ = {}

    MonsterDetailPanel.RegisterBtnListers()
    MonsterDetailPanel.RegisterMessage()
end

function MonsterDetailPanel.OnParam(params)
    this.t_mission_ = params[1]
    this.t_monster_ = params[2]
    this.t_role_ = params[3]
end

function MonsterDetailPanel.OnDestroy(obj)
    MonsterDetailPanel.RemoveMessage()
    this = {}
end

function MonsterDetailPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.sure_btn_.gameObject, "click", MonsterDetailPanel.OnSureBtnClick, nil, nil)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", MonsterDetailPanel.OnCloseClick, nil, nil)
end

function MonsterDetailPanel.RegisterMessage()

end

function MonsterDetailPanel.RemoveMessage()

end

function MonsterDetailPanel.Start(obj)
    MonsterDetailPanel.RefreshPanel()
end

function MonsterDetailPanel.RefreshPanel()
    MonsterDetailPanel.SetData()
    CommonPanel.SetMonsterInfoPanel(this.lua_script_, this.t_role_.id, this.t_monster_.level, this.t_mission_.diff, this.info_root_)
    MonsterDetailPanel.RefreshAttrRect()
    MonsterDetailPanel.RefreshUnlockRect()
    MonsterDetailPanel.RefreshDropRect()
    --设置高度
    GameSys.AdjustDetailBack(this.content_, this.detail_, this.panel_among_, this.back_ground_)
    --设置滑动按钮
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function MonsterDetailPanel.SetData()
    this.t_reputation_ = Config.get_config_value("t_role_reputation", this.t_role_.reputation)
    this.reputation_state_ = GameSys.GetMonsterReputationState(this.t_mission_.id, this.t_role_.id)
end

function MonsterDetailPanel.RefreshAttrRect()
    this.attr_header_:Find("dark_star_image").gameObject:SetActive(not this.reputation_state_.had_unlock)
    this.attr_header_:Find("light_star_image").gameObject:SetActive(this.reputation_state_.had_unlock)
    if this.attr_detail_.childCount ~= 10 then
        Util.ClearChild(this.attr_detail_)
        for i = 1, 10 do
            local attr_ins = GameObject.Instantiate(this.attr_text_.gameObject)
            attr_ins:SetActive(true)
            attr_ins.transform:SetParent(this.attr_detail_, false)
        end
        local per_height = this.attr_text_:GetComponent("RectTransform").rect.height
        GameSys.SetRectHeight(this.attr_detail_:GetComponent("RectTransform"), per_height * 10)
    end
    local attrs = {}
    for i = 1, 4 do
        local index = i
        if i == 4 then
            index = 3
        end
        table.insert(attrs, {
            attr_id = i,
            value = this.t_monster_.attrs[index].value * PlayerData.get_level_value(this.t_monster_.level, i),
        })
    end
    for i = 11, 16 do
        table.insert(attrs, {
            attr_id = i,
            value = PlayerData.get_level_value(this.t_monster_.level, i),
        })
    end

    local t_mission_random = Config.get_config_value('t_mission_random', this.t_mission_.diff)
    local bonus = t_mission_random.bonus
    bonus = bonus / 100
    attrs[1].value = attrs[1].value * (1 + bonus * 5)
    attrs[2].value = attrs[1].value * (1 + bonus)

    for i = 1, #attrs do
        local attr = attrs[i]
        local attr_ins = this.attr_detail_:GetChild(i - 1)
        local attr_name = GameSys.GetAttrNameText(attr.attr_id)
        local desc = string.format("%s %s", attr_name, GameSys.GetAttrValueText(attr.attr_id, attr.value))
        attr_ins:GetComponent("Text").text = desc
    end
end

function MonsterDetailPanel.RefreshUnlockRect()
    this.unlock_header_:Find("dark_star_image").gameObject:SetActive(not this.reputation_state_.had_unlock)
    this.unlock_header_:Find("light_star_image").gameObject:SetActive(this.reputation_state_.had_unlock)
    this.had_kill_header_:GetComponent("Text").text = string.format("已击杀 %s次", GameSys.unit_conversion(this.reputation_state_.cur_kill_num))
    local unlock_count = #this.t_reputation_.kill
    if this.unlock_detail_.childCount ~= unlock_count then
        Util.ClearChild(this.unlock_detail_)
        local per_height = 0
        for i = 1, unlock_count do
            local slot_ins = CommonPanel.GetReputationUnlockSlot()
            slot_ins:SetActive(true)
            slot_ins.transform:SetParent(this.unlock_detail_, false)
            if per_height == 0 then
                per_height = slot_ins:GetComponent("RectTransform").rect.height
            end
        end
        GameSys.SetRectHeight(this.unlock_detail_:GetComponent("RectTransform"), per_height * unlock_count)
    end
    for i = 1, unlock_count do
        local unlock_slot = this.unlock_detail_:GetChild(i - 1)
        local title = string.format("击杀 %s %s次", this.t_role_.name, GameSys.unit_conversion(this.t_reputation_.kill[i].num))
        CommonPanel.SetReputationUnlockSlot(unlock_slot, title, this.t_reputation_.kill[i].reputation, i <= this.reputation_state_.cur_unlock_level)
    end
    local color_str = this.reputation_state_.had_unlock and GameSys.GetNormalColor() or GameSys.GetLockColor()
    local b, color = ColorUtility.TryParseHtmlString(color_str, nil)
    this.had_kill_header_:GetComponent("Text").color = color
end

function MonsterDetailPanel.RefreshDropRect()
    Util.ClearChild(this.drop_root_)
    for i = 1, #this.t_mission_.drops do
        local drop = this.t_mission_.drops[i]
        local asset = {
            type = drop.type,
            value1 = drop.value1,
            value2 = 0,
            value3 = drop.value3,
        }
        local icon_ins = CommonPanel.GetIcon2type(asset, {"drop_icon_"..i}, this.lua_script_)
        icon_ins.transform:SetParent(this.drop_root_, false)
    end
end

function MonsterDetailPanel.OnSureBtnClick(obj, params)
    MonsterDetailPanel.Close()
end

function MonsterDetailPanel.OnCloseClick(obj, params)
    MonsterDetailPanel.Close()
end

function MonsterDetailPanel.Close()
    GUIRoot.ClosePanel("MonsterDetailPanel")
end