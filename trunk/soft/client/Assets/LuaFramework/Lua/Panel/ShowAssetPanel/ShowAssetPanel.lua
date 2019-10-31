ShowAssetPanel = {}
ShowAssetPanel.Control = {}
local this = ShowAssetPanel.Control

function ShowAssetPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.lexecute_btn_ = this.transform_Find("back_image/execute_btn")
    this.nul_show_ = this.transform_:Find("back_image/info/view/nul_show")
    this.content_ = this.transform_:Find("back_image/info/view/content")
    this.asset_ = nil
    ShowAssetPanel.RegisterBtnsListers()
end

function ShowAssetPanel.RegisterBtnsListers()
    GameSys.ButtonRegister(this.lua_script_, this.lexecute_btn_.gameObject, "click", ShowAssetPanel.OnCloseBtnClick)
end

function ShowAssetPanel.OnParam(params)
    this.asset_ = params[1]
end

function ShowAssetPanel.Start(obj)
    ShowAssetPanel.Init()
end

function ShowAssetPanel.OnDestroy()
    this = {}
end

function ShowAssetPanel.Init()
    local null = true
    for i = 1, #this.asset_.assets do
        local asset = {}
        asset.type = this.asset_.assets[i].type
        asset.value1 = this.asset_.assets[i].value1
        asset.value2 = this.asset_.assets[i].value2
        asset.value3 = this.asset_.assets[i].value3
        local obj = CommonPanel.GetIcon2type(asset,{}, this.lua_script_)
        obj.transform:SetParent(this.content_, false)
        obj.transform.localScale = Vector3.one
        obj.transform.localPosition = Vector3.zero
    end

    for i = 1, #this.asset_.equips do
        local t_equip = Config.get_config_value("t_equip", this.asset_.equips[i].template_id)
        local obj = CommonPanel.GetEquipIcon(this.asset_.equips[i],{this.asset_.equips[i].template_id.."show_"..i, ShowAssetPanel.ShowTempEquip, {this.asset_.equips[i], t_equip.type, {0, 0, 0}, 0}}, this.lua_script_)
        obj.transform:SetParent(this.content_, false)
        obj.transform.localScale = Vector3.one
        obj.transform.localPosition = Vector3.zero
    end
    for i = 1, #this.asset_.pets do

        --PlayerData.add_pet(this.asset_.pets[i])
    end
    if #this.asset_.assets > 0 or #this.asset_.equips > 0 or #this.asset_.pets > 0 then
        null = false
    end
    if null then
        this.nul_show_.gameObject:SetActive(false)
    end

end

function ShowAssetPanel.ShowTempEquip(obj, params)
    GUIRoot.ShowPanel("EquipDetailPanel", params)
end

function ShowAssetPanel.OnCloseBtnClick(obj, params)
    ShowAssetPanel.Close()
end

function ShowAssetPanel.Close()
    GUIRoot.ClosePanel("ShowAssetPanel")
end

