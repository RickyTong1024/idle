ArtifactDetailPanel = {}
ArtifactDetailPanel.Control = {}
local this = ArtifactDetailPanel.Control

function ArtifactDetailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_ = this.transform_:Find("back_ground/panel_among/info")
    this.detail_ = this.transform_:Find("back_ground/panel_among/detail")
    this.scroll_rect_ = this.detail_:GetComponent("ScrollRect")
    this.content_ = this.transform_:Find("back_ground/panel_among/detail/view/content")
    this.attr_header_ = this.transform_:Find("back_ground/panel_among/detail/view/content/attr_header")
    this.attr_detail_ = this.transform_:Find("back_ground/panel_among/detail/view/content/attr_detail")
    this.unlock_header_ = this.transform_:Find("back_ground/panel_among/detail/view/content/unlock_header")
    this.unlock_detail_ = this.transform_:Find("back_ground/panel_among/detail/view/content/unlock_detail")
    this.gets_root_ = this.transform_:Find("back_ground/panel_among/detail/view/content/gets_root")
    this.arrow_btn_ = this.transform_:Find("back_ground/panel_among/detail/arrow_btn")
    this.sure_btn_ = this.transform_:Find("back_ground/panel_among/sure_btn")

    this.t_artifact_ = nil
    this.cur_artifact_state_ = nil

    ArtifactDetailPanel.RegisterBtnsListers()
end

function ArtifactDetailPanel.OnDestroy()
    this = {}
end

function ArtifactDetailPanel.RegisterBtnsListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ArtifactDetailPanel.OnCloseBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.sure_btn_.gameObject, "click", ArtifactDetailPanel.OnSureBtnClick)
end

function ArtifactDetailPanel.OnParam(params)
    this.t_artifact_ = params[1]
end

function ArtifactDetailPanel.Start()
    ArtifactDetailPanel.RefreshPanel()
    GameSys.SetScrollArrow(this.scroll_rect_, this.arrow_btn_, this.lua_script_)
end

function ArtifactDetailPanel.RefreshPanel()
    ArtifactDetailPanel.SetData()
    CommonPanel.SetArtifactInfoPanel(this.t_artifact_, this.lua_script_, this.info_)
    ArtifactDetailPanel.RefreshAttrRect()
    ArtifactDetailPanel.RefreshUnlockRect()
    ArtifactDetailPanel.RefreshGetsRect()
    --设置高度
    GameSys.AdjustDetailBack(this.content_, this.detail_, this.panel_among_, this.back_ground_)
end

function ArtifactDetailPanel.SetData()
    this.cur_artifact_state_ = GameSys.GetArtifactState(this.t_artifact_.id)
end

function ArtifactDetailPanel.RefreshAttrRect()
    this.attr_header_:Find("light_star_image").gameObject:SetActive(this.cur_artifact_state_ == 1)
    this.attr_header_:Find("dark_star_image").gameObject:SetActive(not (this.cur_artifact_state_ == 1))
    Util.ClearChild(this.attr_detail_)
    local attrs = this.t_artifact_.attrs
    for i = 1, #attrs do
        local attr_ins = CommonPanel.GetAttrText(attrs[i].id, attrs[i].value, 0)
        attr_ins.transform:SetParent(this.attr_detail_, false)
    end
    this.attr_detail_.sizeDelta = Vector2(this.attr_detail_.sizeDelta.x, #attrs * 30)
end

function ArtifactDetailPanel.RefreshUnlockRect()
    this.unlock_header_:Find("light_star_image").gameObject:SetActive(this.cur_artifact_state_ == 1)
    this.unlock_header_:Find("dark_star_image").gameObject:SetActive(not (this.cur_artifact_state_ == 1))
    Util.ClearChild(this.unlock_detail_)
    local title_1 = string.format("获得%s图纸", this.t_artifact_.name)
    local reputation_1 = this.t_artifact_.unlock_reputation
    local slot_1 = CommonPanel.GetReputationUnlockSlot(title_1, reputation_1, this.cur_artifact_state_ >= 0)
    local title_2 = string.format("锻造出%s", this.t_artifact_.name)
    local reputation_2 = this.t_artifact_.has_reputation
    local slot_2 = CommonPanel.GetReputationUnlockSlot(title_2, reputation_2, this.cur_artifact_state_ == 1)
    slot_1.transform:SetParent(this.unlock_detail_, false)
    slot_2.transform:SetParent(this.unlock_detail_, false)
end

function ArtifactDetailPanel.RefreshGetsRect()
    local gets = GameSys.GetGetInfo(4, this.t_artifact_.id)
    Util.ClearChild(this.gets_root_)
    for i = 1, #gets do
        local get_res = CommonPanel.GetGetIcon(this.lua_script_, gets[i])
        get_res.transform:SetParent(this.gets_root_, false)
    end
end

function ArtifactDetailPanel.OnSureBtnClick(obj, params)
    ArtifactDetailPanel.Close()
end

function ArtifactDetailPanel.OnCloseBtnClick(obj, params)
    ArtifactDetailPanel.Close()
end

function ArtifactDetailPanel.Close()
    GUIRoot.ClosePanel("ArtifactDetailPanel")
end

