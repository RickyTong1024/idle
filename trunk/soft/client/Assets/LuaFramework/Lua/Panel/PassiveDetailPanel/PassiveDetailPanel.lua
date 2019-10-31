PassiveDetailPanel = {}
PassiveDetailPanel.Control = {}
local this = PassiveDetailPanel.Control

function PassiveDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.back_image_ = this.transform_:Find("back_image")
    this.back_rect_ = this.back_image_:GetComponent("RectTransform")
    this.info_ = this.transform_:Find("back_image/panel_among/info")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.panel_among_ = this.transform_:Find("back_image/panel_among")
    this.cur_detail_ = this.transform_:Find("back_image/panel_among/cur_detail")
    this.cur_header_ = this.transform_:Find("back_image/panel_among/cur_detail/cur_header")
    this.cur_desc_text_ = this.transform_:Find("back_image/panel_among/cur_detail/cur_desc_text")
    this.next_detail_ = this.transform_:Find("back_image/panel_among/next_detail")
    this.next_desc_text_ = this.transform_:Find("back_image/panel_among/next_detail/next_desc_text")
    this.sure_btn_ = this.transform_:Find("back_image/panel_among/sure_btn")

    this.t_passive_ = nil
    this.is_lock_ = false

    PassiveDetailPanel.RegisterBtnListers()
end

function PassiveDetailPanel.OnDestroy()
    this = {}
end

function PassiveDetailPanel.OnParam(params)
    this.t_passive_ = params[1]
    this.is_lock_ = params[2]
end

function PassiveDetailPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PassiveDetailPanel.OnCloseClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.sure_btn_.gameObject, "click", PassiveDetailPanel.OnSureClick, nil)
end

function PassiveDetailPanel.Start(obj)
    PassiveDetailPanel.RefreshPanel()
end

function PassiveDetailPanel.RefreshPanel()
    --刷顶部
    CommonPanel.SetPassiveInfoPanel(this.lua_script_, this.t_passive_, this.info_)
    --刷中部详情
    this.next_detail_.gameObject:SetActive(not this.is_lock_)
    if this.is_lock_ then
        this.cur_header_:GetComponent("Text").text = "解锁后"
        local cur_desc = GameSys.GetPassiveDesc(this.t_passive_.id)
        this.cur_desc_text_:GetComponent("Text").text = cur_desc
    else
        this.cur_header_:GetComponent("Text").text = "当前阶段"
        local cur_desc = GameSys.GetPassiveDesc(this.t_passive_.id)
        this.cur_desc_text_:GetComponent("Text").text = cur_desc
        local next_id = this.t_passive_.next_spell
        if next_id == 0 then
            this.next_desc_text_:GetComponent("Text").text = "达到提升上限,无法提升"
        else
            local t_next_passive = Config.get_config_value("t_spell_passive", next_id)
            this.next_desc_text_:GetComponent("Text").text = GameSys.GetPassiveDesc(t_next_passive.id)
        end
        local next_desc_h = GameSys.AdjustDescTextHeight(this.next_desc_text_)
        local next_detail_height = math.abs(this.next_desc_text_.anchoredPosition.y) + next_desc_h
        GameSys.SetRectHeight(this.next_detail_, next_detail_height)

    end

    local cur_desc_h = GameSys.AdjustDescTextHeight(this.cur_desc_text_)
    local cur_detail_height = math.abs(this.cur_desc_text_.anchoredPosition.y) + cur_desc_h
    GameSys.SetRectHeight(this.cur_detail_, cur_detail_height)
    --设置高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.panel_among_)
    local h =  LayoutUtility.GetPreferredHeight(this.panel_among_)
    this.back_rect_.sizeDelta = Vector2(this.back_rect_.sizeDelta.x, h)
end

function PassiveDetailPanel.OnCloseClick(obj, params)
    PassiveDetailPanel.Close()
end

function PassiveDetailPanel.OnSureClick(obj, params)
    PassiveDetailPanel.Close()
end

function PassiveDetailPanel.Close()
    GUIRoot.ClosePanel("PassiveDetailPanel")
end