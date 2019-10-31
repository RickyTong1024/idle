AssetWindowPanel = {}
AssetWindowPanel.Control = {}
local this = AssetWindowPanel.Control

AssetWindowPanel.SHOW_TYPE = {
    show = 1, -- 展示
    sell = 2, -- 出售
}

function AssetWindowPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ =  this.transform_:GetComponent('LuaUIBehaviour')
    this.back_image_ = this.transform_:Find("back_image")
    this.panel_among_ = this.transform_:Find("back_image/panel_among")
    this.info_ = this.transform_:Find("back_image/panel_among/info")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.detail_ = this.transform_:Find("back_image/panel_among/detail")
    this.execute_btn_ = this.transform_:Find("back_image/panel_among/execute_btn")
    this.btn_text_ = this.transform_:Find("back_image/panel_among/execute_btn/btn_text")
    this.desc_text_ = this.transform_:Find("back_image/panel_among/detail/desc_text")
    this.null_text_ = this.transform_:Find("back_image/panel_among/detail/null_text")
    this.gets_root_ = this.transform_:Find("back_image/panel_among/detail/gets_root")

    this.cur_type_ = AssetWindowPanel.SHOW_TYPE.show
    this.asset_ = nil

    AssetWindowPanel.RegisterBtnsListers()
end

function AssetWindowPanel.OnDestroy()
    this = {}
end

function AssetWindowPanel.RegisterBtnsListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", AssetWindowPanel.OnCloseBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.execute_btn_.gameObject, "click", AssetWindowPanel.OnExecuteBtnClick)
end

function AssetWindowPanel.OnParam(params)
    this.cur_type_ = params[1]
    this.asset_ = params[2]
end

function AssetWindowPanel.Start(obj)
    AssetWindowPanel.RefreshPanel()
end

function AssetWindowPanel.RefreshPanel()
    --刷详细图标
    local asset = {
        type = this.asset_.type,
        value1 = this.asset_.value1,
        value2 = 0,
        value3 = 0
    }
    CommonPanel.SetAssetInfoPanel(this.lua_script_, asset, this.info_)
    --刷中间详情
    local config = GameSys.GetAssetConfig(asset)
    local desc = config.desc
    this.desc_text_.gameObject:SetActive(desc ~= nil)
    this.null_text_.gameObject:SetActive(desc == nil)
    if desc ~= nil then
        this.desc_text_:GetComponent("Text").text = desc
    end
    GameSys.AdjustDescTextHeight(this.desc_text_)
    Util.ClearChild(this.gets_root_)
    local get_info = GameSys.GetGetInfo(asset.type, asset.value1)
    if get_info ~= nil then
        for i = 1, #get_info do
            local icon_ins = CommonPanel.GetGetIcon(this.lua_script_, get_info[i])
            icon_ins.transform:SetParent(this.gets_root_, false)
        end
    end
    --设详情的高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.detail_)
    local h = math.abs(this.gets_root_.anchoredPosition.y)
    h = this.gets_root_.sizeDelta.y / 2 + h + 10
    this.detail_.sizeDelta = Vector2(this.detail_.sizeDelta.x, h)

    --刷按钮
    if this.cur_type_ == AssetWindowPanel.SHOW_TYPE.show then
        this.btn_text_:GetComponent("Text").text = "确定"
    elseif this.cur_type_ == AssetWindowPanel.SHOW_TYPE.sell then
        this.btn_text_:GetComponent("Text").text = "出售"
    end
    --刷高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.panel_among_)
    local height = LayoutUtility.GetPreferredHeight(this.panel_among_)
    this.back_image_.sizeDelta = Vector2(this.back_image_.sizeDelta.x, height)
end

function AssetWindowPanel.OnExecuteBtnClick(obj, params)
    if this.cur_type_ == AssetWindowPanel.SHOW_TYPE.show then
        AssetWindowPanel.Close()
    elseif this.cur_type_ == AssetWindowPanel.SHOW_TYPE.sell then
        local config = GameSys.GetAssetConfig(this.asset_)
        if config.sell == nil then
            AssetWindowPanel.Close()
            return
        end
        local resource = {}
        resource.type = 1
        resource.value1 = this.asset_.id
        resource.value2 = config.sell
        resource.value3 = this.asset_.value2

        local params = {this.asset_, resource, BagPanel.SellItem}
        GUIRoot.ShowPanel("SellPanel", params)
        AssetWindowPanel.Close()
    end
end

function AssetWindowPanel.OnCloseBtnClick(obj, params)
    AssetWindowPanel.Close()
end

function AssetWindowPanel.Close()
    GUIRoot.ClosePanel("AssetWindowPanel")
end

