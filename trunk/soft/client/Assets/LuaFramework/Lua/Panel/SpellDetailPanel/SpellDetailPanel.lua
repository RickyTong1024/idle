SpellDetailPanel = {}
SpellDetailPanel.Control = {}
local this = SpellDetailPanel.Control

function SpellDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.back_image_ = this.transform_:Find("back_image")
    this.back_rect_ = this.back_image_:GetComponent("RectTransform")
    this.panel_among_ = this.transform_:Find("back_image/panel_among")
    this.info_ = this.transform_:Find("back_image/panel_among/info")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.cur_level_detail_ = this.transform_:Find("back_image/panel_among/cur_level_detail")
    this.cur_header_ = this.transform_:Find("back_image/panel_among/cur_level_detail/cur_header")
    this.cur_desc_text_ = this.transform_:Find("back_image/panel_among/cur_level_detail/cur_desc_text")
    this.next_level_detail_ = this.transform_:Find("back_image/panel_among/next_level_detail")
    this.next_desc_text_ = this.transform_:Find("back_image/panel_among/next_level_detail/next_desc_text")
    this.sure_btn_ = this.transform_:Find("back_image/panel_among/sure_btn")
    
    this.t_spell_ = nil
    this.level_ = 0
    this.had_spell_ = false

    SpellDetailPanel.RegisterBtnListers()
end

function SpellDetailPanel.OnDestroy()
    this = {}
end

function SpellDetailPanel.OnParam(params)
    this.t_spell_ = params[1]
    this.level_ = params[2]
    this.had_spell_ = params[3]
end

function SpellDetailPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", SpellDetailPanel.OnCloseClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.sure_btn_.gameObject, "click", SpellDetailPanel.OnSureClick, nil)
end

function SpellDetailPanel.Start(obj)
    SpellDetailPanel.RefreshPanel()
end

function SpellDetailPanel.RefreshPanel()
    --刷顶部详情icon
    CommonPanel.SetSpellInfoPanel(this.lua_script_, this.t_spell_, this.level_, this.info_)
    --刷中间详情部分
    this.next_level_detail_.gameObject:SetActive(this.had_spell_)
    if this.had_spell_ then
        this.cur_header_:GetComponent("Text").text = "当前等级"
        local cur_desc = GameSys.GetSpellDesc(this.t_spell_.id, this.level_)
        this.cur_desc_text_:GetComponent("Text").text = cur_desc

        local t_next_level = Config.get_config_value("t_spell_level", this.level_ + 1)
        if t_next_level == nil then
            this.next_desc_text_:GetComponent("Text").text = "达到等级上限,无法提升"
        else
            this.next_desc_text_:GetComponent("Text").text = GameSys.GetSpellDesc(this.t_spell_.id, this.level_ + 1)
        end
        local next_desc_h = GameSys.AdjustDescTextHeight(this.next_desc_text_)
        local next_detail_height = math.abs(this.next_desc_text_.anchoredPosition.y) + next_desc_h
        GameSys.SetRectHeight(this.next_level_detail_, next_detail_height)
    else
        this.cur_header_:GetComponent("Text").text = "解锁后"
        local cur_desc = GameSys.GetSpellDesc(this.t_spell_.id, this.level_)
        this.cur_desc_text_:GetComponent("Text").text = cur_desc
    end
    local cur_desc_h = GameSys.AdjustDescTextHeight(this.cur_desc_text_)
    local cur_detail_height = math.abs(this.cur_desc_text_.anchoredPosition.y) + cur_desc_h
    GameSys.SetRectHeight(this.cur_level_detail_, cur_detail_height)
    --设置高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.panel_among_)
    local h =  LayoutUtility.GetPreferredHeight(this.panel_among_)
    this.back_rect_.sizeDelta = Vector2(this.back_rect_.sizeDelta.x, h)
end

function SpellDetailPanel.OnCloseClick(obj, params)
    SpellDetailPanel.Close()
end

function SpellDetailPanel.OnSureClick(obj, params)
    SpellDetailPanel.Close()
end

function SpellDetailPanel.Close()
     GUIRoot.ClosePanel("SpellDetailPanel")
end