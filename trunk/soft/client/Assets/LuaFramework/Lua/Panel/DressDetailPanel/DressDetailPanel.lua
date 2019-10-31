DressDetailPanel = {}
DressDetailPanel.Control = {}
local this = DressDetailPanel.Control

function DressDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.attr_text_ = this.transform_:Find("back_ground/panel_among/other_detail/content/attr_text")
    this.reforge_text_ = this.transform_:Find("back_ground/panel_among/other_detail/content/reforge_text")
    this.unlock_detail_ = this.transform_:Find("back_ground/panel_among/other_detail/content/unlock_detail")
    this.sure_btn_ = this.transform_:Find("back_ground/panel_among/sure_btn")
    this.attr_header_ = this.transform_:Find("back_ground/panel_among/other_detail/content/attr_header")
    this.reforge_header_ = this.transform_:Find("back_ground/panel_among/other_detail/content/reforge_header")
    this.unlock_header_ = this.transform_:Find("back_ground/panel_among/other_detail/content/unlock_header")
    this.gets_root_ = this.transform_:Find("back_ground/panel_among/other_detail/content/gets_root")

    this.t_equip_ = nil
    this.color_ = 0
    this.had_avatar_ = false
    this.had_get_ = false

    DressDetailPanel.RegisterBtnLister()
end

function DressDetailPanel.OnDestroy()
    this = {}
end

function DressDetailPanel.OnParam(params)
    this.t_equip_ = params[1]
    this.color_ = params[2]
    if this.color_ == nil then
        this.color_ = 0
    end
end

function DressDetailPanel.RegisterBtnLister()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", DressDetailPanel.OnCloseClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.sure_btn_.gameObject, "click", DressDetailPanel.OnSureBtnClick, nil)
end

function DressDetailPanel.Start(obj)
    DressDetailPanel.RreshPanel()
end

function DressDetailPanel.RreshPanel()
    DressDetailPanel.SetData()
    --刷顶部详情icon
    CommonPanel.SetDressEquipInfoPanel(this.t_equip_, this.color_, this.lua_script_, this.info_root_)
    --刷中间详情框
    this.attr_header_:Find("light_star_image").gameObject:SetActive(this.had_avatar_)
    this.attr_header_:Find("dark_star_image").gameObject:SetActive(not this.had_avatar_)
    this.reforge_header_:Find("light_star_image").gameObject:SetActive(this.had_avatar_)
    this.reforge_header_:Find("dark_star_image").gameObject:SetActive(not this.had_avatar_)
    this.unlock_header_:Find("light_star_image").gameObject:SetActive(this.had_avatar_)
    this.unlock_header_:Find("dark_star_image").gameObject:SetActive(not this.had_avatar_)
    local t_attr = Config.get_config_value("t_attr", this.t_equip_.attr)
    local min_t_level = Config.get_config_value("t_level", this.t_equip_.min_level)
    local max_t_level = Config.get_config_value("t_level", this.t_equip_.max_level)
    local min_base_value = min_t_level.std_attr * this.t_equip_.value / 100 * t_attr.value
    local max_base_value = max_t_level.std_attr * this.t_equip_.value / 100 * t_attr.value
    local max_q = this.t_equip_.max_q
    local min_color, max_color = GameSys.GetEquipColorRange()
    local min_attr_num = (min_color - 1) * 1
    local max_attr_num = (max_color - 1) * max_q
    this.attr_text_:GetComponent("Text").text = string.format("%s %s-%s", GameSys.GetAttrNameText(t_attr.id), GameSys.GetAttrValueText(t_attr.id, min_base_value), GameSys.GetAttrValueText(t_attr.id, max_base_value))
    this.reforge_text_:GetComponent("Text").text = string.format("%s %d-%d", "属性条数", min_attr_num, max_attr_num)
    local quality_text = GameSys.set_color(max_color, Config.get_config_value("t_color", max_color).name)
    local title = string.format("首次获得%s品质%s",quality_text, this.t_equip_.name)

    local reputation_num = this.t_equip_.reputation
    local slot_ins = CommonPanel.GetReputationUnlockSlot(title, reputation_num, this.had_get_)
    Util.ClearChild(this.unlock_detail_)
    slot_ins.transform:SetParent(this.unlock_detail_, false)
    slot_ins.transform:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)

    Util.ClearChild(this.gets_root_)
    local gets = GameSys.GetGetInfo(3, this.t_equip_.id)
    for i = 1, #gets do
        local get_res = CommonPanel.GetGetIcon(this.lua_script_, gets[i])
        get_res.transform:SetParent(this.gets_root_, false)
    end
end

function DressDetailPanel.SetData()
    local had_avatar, can_get, had_get = GameSys.GetDressState(this.t_equip_.id)
    this.had_avatar_ = had_avatar
    this.had_get_ = had_get
end

function DressDetailPanel.OnCloseClick(obj, params)
    DressDetailPanel.Close()
end

function DressDetailPanel.OnSureBtnClick(obj, params)
    DressDetailPanel.Close()
end

function DressDetailPanel.Close()
    GUIRoot.ClosePanel("DressDetailPanel")
end