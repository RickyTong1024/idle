RechargePanel = {}
--启动事件--
RechargePanel.Control = {}
local this = RechargePanel.Control
function RechargePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.back_btn_ = obj.transform:Find("back_ground/back_btn")
    this.icon_res_ = obj.transform:Find("back_ground/icon_res")
    this.recharge_group_content_ = obj.transform:Find("back_ground/recharge_center_panel/recharge_group_background/recharge_group_content")
    this.super_list_ = nil
    this.recharge_list_ = {}
    RechargePanel.RegisterBtnMessage()
    RechargePanel.RegisterMessage()
end

function RechargePanel.OnDestroy()
    RechargePanel.RemoveMessage()
    this = {}
end

function RechargePanel.Start(obj)
    RechargePanel.InitSuperList()
end

function RechargePanel.RegisterBtnMessage()
    GameSys.ButtonRegister(this.lua_script_, this.back_btn_.gameObject, "click", RechargePanel.OnCloseBtnClick)
end

function RechargePanel.RegisterMessage()
    Message.register_handle("recharge_success", RechargePanel.RefreshRechargeList)
end

function RechargePanel.RemoveMessage()
    Message.remove_handle("recharge_success", RechargePanel.RefreshRechargeList)
end

function RechargePanel.RefreshRechargeList()
    RechargePanel.GetRechargeList()
    this.super_list_:SetData(#this.recharge_list_)
end

function RechargePanel.ShowRechargeSub(t_recharge)
    --[[for i = 1, #PlayerData.player.recharge_ids do
        if PlayerData.player.recharge_ids[i] == t_recharge.id then
            return false
        end
    end]]--



    if t_recharge.type == 4 or t_recharge.type == 3 then
        local flag = false
        for i = 1, #PlayerData.player.recharge_ids do
            if PlayerData.player.recharge_ids[i] == t_recharge.id then
                flag = true
                break
            end
        end
        if not flag then
            return false
        end
    end
    --[[if t_recharge.type == 1 then
        if PlayerData.player.zhouka_time > tonumber(timerMgr.now_string()) then
            return false
        end
    end

    if t_recharge.type == 2 then
        if PlayerData.player.yueka_time > tonumber(timerMgr.now_string()) then
            return false
        end
    end]]--

    return true
end

function RechargePanel.GetRechargeList()
    this.recharge_list_ = {}
    for _, v in pairs(Config.t_recharge) do
        if RechargePanel.ShowRechargeSub(v) then
            table.insert(this.recharge_list_, v)
        end
    end
    if #this.recharge_list_ > 0 then
        table.sort(this.recharge_list_, function (a, b)
            return a.id < b.id
        end)
    end
end

function RechargePanel.InitSuperList()
    RechargePanel.GetRechargeList()
    this.super_list_ = this.recharge_group_content_:GetComponent("UIScrollGrid")
    this.super_list_.prefab = this.icon_res_.gameObject
    this.super_list_.SetDataHandle = function(go, index)
        local value = this.recharge_list_[index + 1]
        go.transform:Find("back_image/recharge_img"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas("RechargePanel"):GetSprite(value.icon)
        go.transform:Find("back_image/recharge_name"):GetComponent("LocalizationText").text = value.name
        go.transform:Find("back_image/recharge_price"):GetComponent("LocalizationText").text = value.crystal
        local click_obj = go.transform:Find("back_image/click_obj").transform:GetChild(0).gameObject
        if click_obj ~= nil then
            this.lua_script_:RemoveClick(click_obj)
        end
        click_obj.name = "recharge_id_"..tostring(value.id)
        GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", RechargePanel.RechargeItemClick, {value})
        go.gameObject:SetActive(true)
    end
    this.super_list_:Init()
    this.super_list_:SetData(#this.recharge_list_)
end

function RechargePanel.RechargeItemClick(obj, param)
    local t_recharge = param[1]
    RechargeManger.DoRecharge(t_recharge.id)
end

function RechargePanel.OnCloseBtnClick()
    GUIRoot.ClosePanel("RechargePanel")
end
