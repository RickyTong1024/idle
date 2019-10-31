TopResPanel = {}
TopResPanel.Control = {}
local this = TopResPanel.Control

TopResPanel.no_active_panels = {
    "BasicUIPanel",
    "NarratorPanel",
    "PortalPanel",
    "NamePanel",
    "TalkPanel",
    "SelectPanel",
    "TopResPanel",
}

function TopResPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.common_top_ = this.transform_:Find("common_top")
    this.c_level_text_ = this.transform_:Find("common_top/c_level_text")
    this.c_add_gold_ = this.transform_:Find("common_top/c_gold_obj/c_add_gold")
    this.c_gold_num_ = this.transform_:Find("common_top/c_gold_obj/c_gold_num")
    this.c_add_jewel_ = this.transform_:Find("common_top/c_jewel_obj/c_add_jewel")
    this.c_jewel_num_ = this.transform_:Find("common_top/c_jewel_obj/c_jewel_num")
    this.c_set_btn_ = this.transform_:Find("common_top/c_set_btn")
    this.c_add_sw_ = this.transform_:Find("common_top/c_sw_obj/c_add_sw")
    this.c_sw_num_ = this.transform_:Find("common_top/c_sw_obj/c_sw_num")
    this.no_actives_ = {}
    for i = 1, #TopResPanel.no_active_panels do
        this.no_actives_[TopResPanel.no_active_panels[i]] = 1
    end
    TopResPanel.RegisterBtnListers()
    TopResPanel.RegisterMessage()
    TopResPanel.RegsterChangeMessage()
    this.transform_:SetSiblingIndex(1)
end

function TopResPanel.OnDestroy()
    TopResPanel.RemoveMessage()
    TopResPanel.RemoveChangeMessage()
    this = {}
end

function TopResPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.c_set_btn_.gameObject, "click", TopResPanel.OnSetingBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.c_add_jewel_.gameObject, "click", TopResPanel.OnVIPBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.c_add_gold_.gameObject, "click", TopResPanel.OnAddGoldBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.c_add_sw_.gameObject, "click", TopResPanel.OnAddSwBtnClick)
end

function TopResPanel.RegisterMessage()
    Message.register_handle("show_panel", TopResPanel.OnPanelShow)
    Message.register_handle("refresh_topRes", TopResPanel.RefreshPanel)
    Message.register_handle("need_check_quest", TopResPanel.RefreshPanel)
end

function TopResPanel.RemoveMessage()
    Message.remove_handle("show_panel", TopResPanel.OnPanelShow)
    Message.remove_handle("refresh_topRes", TopResPanel.RefreshPanel)
    Message.remove_handle("need_check_quest", TopResPanel.RefreshPanel)
end

function TopResPanel.RegsterChangeMessage()
    AssetsChangeControl.AddReputationChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.AddGoldChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.AddJewelChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.AddExpChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.AddLevelChanged(TopResPanel.RefreshPanel)
end

function TopResPanel.RemoveChangeMessage()
    AssetsChangeControl.RemoveReputationChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.RemoveGoldChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.RemoveJewelChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.RemoveExpChanged(TopResPanel.RefreshPanel)
    AssetsChangeControl.RemoveLevelChanged(TopResPanel.RefreshPanel)
end

function TopResPanel.Start(obj)
    TopResPanel.RefreshPanel()
end

function TopResPanel.OnPanelShow(message)
    TopResPanel.SetLastSibling(message)
end

function TopResPanel.SetLastSibling(message)
    local ui_root = tostring(message.m_object[0])
    local panel_name = tostring(message.m_object[1])
    if ui_root ~= "GameUIRoot" then
        return
    end
    local need_operate = TopResPanel.NeedOperate(panel_name)
    if need_operate then
        this.transform_:SetAsLastSibling()
    end
end

function TopResPanel.NeedOperate(panel_name)
    if this.no_actives_[panel_name] ~= nil then
        return false
    end
    return true
end

function TopResPanel.RefreshPanel()
    this.c_level_text_:GetComponent("Text").text = string.format("Lv.%s", PlayerData.player.level)
    this.c_gold_num_:GetComponent("Text").text = GameSys.unit_conversion(PlayerData.player.gold)
    this.c_jewel_num_:GetComponent("Text").text = GameSys.unit_conversion(PlayerData.player.jewel)
    this.c_sw_num_:GetComponent("Text").text = GameSys.unit_conversion(PlayerData.player.reputation)
    this.common_top_.gameObject:SetActive(GameSys.PlayerNameUnlock())
end

function TopResPanel.OnSetingBtnClick()
    TopResPanel.OpenTagPanel({"SetingPanel"}, 0)
end

function TopResPanel.OnVIPBtnClick()
    TopResPanel.OpenTagPanel({"RechargePanel"}, 0)
end

function TopResPanel.OnAddGoldBtnClick()
    if PlayerData.player.in_map > 0 then
        GUIRoot.ShowPanel("MessagePanel", {"请前往城堡商店"})
        return
    else
        TopResPanel.OpenTagPanel({"ShopPanel", 1}, 1002)
    end
end

function TopResPanel.OnAddSwBtnClick()
    if PlayerData.player.in_map > 0 then
        GUIRoot.ShowPanel("MessagePanel", {"请前往城堡商店"})
        return
    else
        TopResPanel.OpenTagPanel({"ShopPanel", 3}, 1002)
    end
end

function TopResPanel.OpenTagPanel(panel_param, unlock_id)
    if not GameSys.jump_info.can_jump then
        return
    end
    local is_unlock, desc = UnlockManger.CheckUnlock(unlock_id)
    if is_unlock then
        local open_tag = true
        for k in pairsByKeys(GUIRoot.game_guis) do
            if k == panel_param[1] then
                open_tag = false
            end
            if k ~= "TopResPanel" and k ~= "BasicUIPanel" and k ~= panel_param[1] then
                GUIRoot.ClosePanel(k)
            end
        end
        if open_tag then
            GUIRoot.ShowPanel(panel_param[1],{panel_param[2]})
        end
    else
        GUIRoot.ShowPanel("MessagePanel", {desc})
    end
end


