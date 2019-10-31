BuyPanel = {}
BuyPanel.Control = {}
local this = BuyPanel.Control
BuyPanel.Type = {
    buy = 1,
    counter = 2
}

function BuyPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")
    this.btn_func = nil
    this.target_name_text = this.transform_:Find("background_image/panel_center/target_name_text"):GetComponent("LocalizationText")
    this.target_icon = this.transform_:Find("background_image/panel_center/target_icon")
    this.count_text = this.transform_:Find("background_image/panel_center/target_counter/count/count_text"):GetComponent("LocalizationText")
    this.sub_btn = this.transform_:Find("background_image/panel_center/target_counter/count/sub_btn")
    this.add_btn = this.transform_:Find("background_image/panel_center/target_counter/count/add_btn")
    this.sub_ten_btn = this.transform_:Find("background_image/panel_center/target_counter/count/sub_ten_btn")
    this.add_ten_btn = this.transform_:Find("background_image/panel_center/target_counter/count/add_ten_btn")
    this.target_btn_image = this.transform_:Find("background_image/panel_botton/target_btn_image")
    this.target_price = this.transform_:Find("background_image/panel_center/target_price")
    this.close_btn = this.transform_:Find("background_image/close_btn")
    this.select_num = 1
    BuyPanel.RegisterBtnListers()
end

function BuyPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.sub_btn.gameObject, "click", BuyPanel.SubOne)
    GameSys.ButtonRegister(this.lua_script, this.add_btn.gameObject, "click", BuyPanel.AddOne)
    GameSys.ButtonRegister(this.lua_script, this.sub_ten_btn.gameObject, "click", BuyPanel.SubTen)
    GameSys.ButtonRegister(this.lua_script, this.add_ten_btn.gameObject, "click", BuyPanel.AddTen)
    GameSys.ButtonRegister(this.lua_script, this.target_btn_image.gameObject, "click", BuyPanel.BuyFunction)
    GameSys.ButtonRegister(this.lua_script, this.close_btn.gameObject, "click", BuyPanel.HidePanel)
end

function BuyPanel.OnParam(param)
    this.counter_type = param[1]
    if this.counter_type == BuyPanel.Type.buy then
        this.buy_asset = param[2]
        this.cons_res = param[3]
        this.btn_func = param[4]
    elseif this.counter_type == BuyPanel.Type.counter then
        this.buy_asset = param[2]
        this.btn_func = param[3]
    end
    BuyPanel.Init()
end

function BuyPanel.OnDestroy()
    this = {}
end

function BuyPanel.Init()
    this.icon_res = CommonPanel.GetIcon2type(this.buy_asset, {}, this.lua_script)
    this.target_name_text.text = GameSys.GetAssetName(this.buy_asset)
    GameSys.ClearChild(this.target_icon)
    this.icon_res.transform:SetParent(this.target_icon, false)
    this.icon_res.transform.localScale = Vector3.one
    this.icon_res.transform.localPosition = Vector3.zero
    if this.counter_type == BuyPanel.Type.counter then
        this.target_price.gameObject:SetActive(false)
    elseif this.counter_type == BuyPanel.Type.buy then
        local t_res = Config.get_config_value("t_resource", this.cons_res.value1)
        this.target_price.transform:Find("price_icon"):GetComponent("Image").sprite = GameSys.GetCommonAtlas():GetSprite(t_res.small_icon)
        this.target_price:GetComponent("LocalizationText").text = this.cons_res.value2
    end
    this.select_num = 1
    this.count_text.text = this.select_num
    BuyPanel.Refresh()
end

function BuyPanel.Start()
end

function BuyPanel.SubOne()
    BuyPanel.ShowCount(-1)
end

function BuyPanel.AddOne()
    BuyPanel.ShowCount(1)
end

function BuyPanel.SubTen()
    BuyPanel.ShowCount(-10)
end

function BuyPanel.AddTen()
    BuyPanel.ShowCount(10)
end

function BuyPanel.ShowCount(num)
    local max_value = 100
    if this.counter_type == BuyPanel.Type.buy then
        max_value = this.cons_res.value3 > 100 and 100 or this.cons_res.value3
    elseif this.counter_type == BuyPanel.Type.counter then
        max_value = 100
    end
    this.select_num = this.select_num + num
    if(this.select_num <= 0) then
        this.select_num = 1
    elseif(this.select_num > max_value) then
        this.select_num = max_value
    end
    BuyPanel.Refresh()
end

function BuyPanel.Refresh()
    this.count_text.text = this.select_num
    if this.counter_type == BuyPanel.Type.buy then
        this.target_price:GetComponent("LocalizationText").text = GameSys.PriceEnoughColor(this.cons_res.value4 ~= nil and GameSys.GoodPrice(this.cons_res.value4, this.select_num) or this.select_num * this.cons_res.value2, GameSys.GetAssetCount(1, this.cons_res.value1) >= this.select_num * this.cons_res.value2)
    end
end

function BuyPanel.BuyFunction()
    if(this.btn_func ~= nil) then
        this.btn_func(this.select_num)
        BuyPanel.HidePanel()
    else
        local str = "未知错误"
        GUIRoot.ShowPanel("MessagePanel", {str})
    end
end

function BuyPanel.HidePanel()
    GUIRoot.ClosePanel("BuyPanel")
end








