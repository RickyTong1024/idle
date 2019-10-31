SellPanel = {}

SellPanel.Control = {}
local this = SellPanel.Control
function SellPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

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
    this.btn_func = nil
    this.sell_asset = nil --- {asset 格式 sell_asset.type(资产类型),sell_asset.value1（资产id）,sell_asset.value2(含有的数量),sell_asset.value3(预留)}
    this.cons_res = nil --- {cons_res 格式 cons_res.type(资产类型),cons_res.value1（资产id）,cons_res.value2(单价),cons_res.value3(购买上限)}
    this.select_num = 1
    SellPanel.RegisterBtnListers()
end

function SellPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.sub_btn.gameObject, "click", SellPanel.SubOne)
    GameSys.ButtonRegister(this.lua_script, this.add_btn.gameObject, "click", SellPanel.AddOne)
    GameSys.ButtonRegister(this.lua_script, this.sub_ten_btn.gameObject, "click", SellPanel.SubTen)
    GameSys.ButtonRegister(this.lua_script, this.add_ten_btn.gameObject, "click", SellPanel.AddTen)
    GameSys.ButtonRegister(this.lua_script, this.target_btn_image.gameObject, "click", SellPanel.BuyFunction)
    GameSys.ButtonRegister(this.lua_script, this.close_btn.gameObject, "click", SellPanel.HidePanel)
end

function SellPanel.OnParam(param)
    this.sell_asset = param[1]
    this.cons_res = param[2]
    this.btn_func = param[3]
    SellPanel.Init()
end

function SellPanel.OnDestroy()
    this = {}
end

function SellPanel.Init()
    this.icon_res = CommonPanel.GetIcon2type(this.sell_asset, {}, this.lua_script)
    this.target_name_text.text = GameSys.GetAssetName(this.sell_asset)
    GameSys.ClearChild(this.target_icon)
    this.icon_res.transform:SetParent(this.target_icon, false)
    this.icon_res.transform.localScale = Vector3.one
    this.icon_res.transform.localPosition = Vector3.zero
    SellPanel.Refresh()
end

function SellPanel.Start()
end

function SellPanel.SubOne()
    SellPanel.ShowCount(-1)
end

function SellPanel.AddOne()
    SellPanel.ShowCount(1)
end

function SellPanel.SubTen()
    SellPanel.ShowCount(-10)
end

function SellPanel.AddTen()
    SellPanel.ShowCount(10)
end

function SellPanel.ShowCount(num)
    if this.cons_res.value3 > 100 then
        this.cons_res.value3 = 100
    end
    this.select_num = this.select_num + num
    if(this.select_num <= 0) then
        this.select_num = 1
    elseif(this.select_num > this.cons_res.value3) then
        this.select_num = this.cons_res.value3
    end
    SellPanel.Refresh()
end

function SellPanel.Refresh()
    this.count_text.text = this.select_num
    this.target_price:GetComponent("LocalizationText").text = this.select_num * this.cons_res.value2
end

function SellPanel.BuyFunction()
    if(this.btn_func ~= nil) then
        this.btn_func(this.sell_asset.value1, this.select_num)
        SellPanel.HidePanel()
    else
        local str = "未知错误"
        GUIRoot.ShowPanel("MessagePanel", {str})
    end
end

function SellPanel.HidePanel()
    GUIRoot.ClosePanel("SellPanel")
end








