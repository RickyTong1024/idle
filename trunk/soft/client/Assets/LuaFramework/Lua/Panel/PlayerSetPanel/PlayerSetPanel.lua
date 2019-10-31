PlayerSetPanel = {}
-- 这是个设置的Lua脚本
PlayerSetPanel.Control = {}
local this = PlayerSetPanel.Control
function PlayerSetPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    
    this.icon_ = this.transform_:Find("back_ground/playerinfo_panel/Player_icon/icon")
    this.player_name_text_ = this.transform_:Find("back_ground/playerinfo_panel/player_name/background/player_name_text")
    this.player_power_text_ = this.transform_:Find("back_ground/playerinfo_panel/player_power/player_power_text")
    this.player_exp_slider_ = this.transform_:Find("back_ground/playerinfo_panel/player_exp/player_exp_slider")
    this.player_level_text_ = this.transform_:Find("back_ground/playerinfo_panel/player_exp/player_level/player_level_text")
    this.player_exp_text_ = this.transform_:Find("back_ground/playerinfo_panel/player_exp/player_exp_slider/player_exp_text")
    this.player_id_text_ = this.transform_:Find("back_ground/playerinfo_panel/player_id_text")
    this.change_icon_btn_ = this.transform_:Find("back_ground/playerinfo_panel/Player_icon/change_icon_btn")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.rename_ = this.transform_:Find("back_ground/playerinfo_panel/player_name/background/rename")
    this.target_btn_image_ = this.transform_:Find("back_ground/playerinfo_panel/playerinfo_botton/target_btn_image")
    this.playerinfo_panel_ = this.transform_:Find("back_ground/playerinfo_panel")
    this.rename_panel_ = this.transform_:Find("playerset_two_panel/two_back_ground/rename_panel")
    this.name_yes_but_ = this.transform_:Find("playerset_two_panel/two_back_ground/rename_panel/name_yes_but")
    this.two_close_btn_ = this.transform_:Find("playerset_two_panel/two_back_ground/two_close_btn")
    this.reicon_panel_ = this.transform_:Find("back_ground/reicon_panel")
    this.playerset_two_panel_ = this.transform_:Find("playerset_two_panel")
    this.title_text_ = this.transform_:Find("back_ground/panel_top/title_image/title_text"):GetComponent("LocalizationText")
    this.new_name_ = nil
    this.change_name_jewel_ = 0
    this.page_type_ = 1
    this.title_name_ = {"个人信息", "修改头像" }
    PlayerSetPanel.RegisterMessage()
    PlayerSetPanel.RegisterBtnListen()
end

function PlayerSetPanel.Start(obj)
    this.rename_panel_:Find("InputField"):GetComponent("InputField").onEndEdit:AddListener(PlayerSetPanel.InputFieldEditEnd)
    this.page_type_ = 1
    PlayerSetPanel.InitPanel()
end
function PlayerSetPanel.InputFieldEditEnd(text_str)
    local name_str_eng, name_str_cn = GameSys.Utf8Len(text_str)
    if name_str_eng + 2 * name_str_cn > 16 then
        local str = "名称太长"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return false
    end
    if text_str == "" then
        local str = "不能为空"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return false
    end
    return true
end

function PlayerSetPanel.OnDestroy()
    PlayerSetPanel.RemoveMessage()
    this = {}
end

function PlayerSetPanel.InitPanel()
    PlayerSetPanel.ShowSetingPanel()
end

function PlayerSetPanel.RegisterBtnListen()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PlayerSetPanel.OnBackClick)
    GameSys.ButtonRegister(this.lua_script_, this.rename_.gameObject, "click", PlayerSetPanel.OpenReNameLayer)
    GameSys.ButtonRegister(this.lua_script_, this.target_btn_image_.gameObject, "click", PlayerSetPanel.OpenLogOutLayer)
    GameSys.ButtonRegister(this.lua_script_, this.name_yes_but_.gameObject, "click", PlayerSetPanel.ChangePlayerName)
    GameSys.ButtonRegister(this.lua_script_, this.change_icon_btn_.gameObject, "click", PlayerSetPanel.OpenReIconLayer)
    GameSys.ButtonRegister(this.lua_script_, this.two_close_btn_.gameObject, "click", PlayerSetPanel.CloseTwoPanel)
end

function PlayerSetPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_PLAYER_CHANGE_NAME, PlayerSetPanel.change_player_name)
    Message.register_net_handle(opcodes.SMSG_PLAYER_CHANGE_ICON, PlayerSetPanel.change_player_icon)
end

function PlayerSetPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_PLAYER_CHANGE_NAME, PlayerSetPanel.change_player_name)
    Message.remove_net_handle(opcodes.SMSG_PLAYER_CHANGE_ICON, PlayerSetPanel.change_player_icon)
end

function PlayerSetPanel.OnBackClick(obj, param)
    if this.page_type_ == 1 then
        GUIRoot.ClosePanel("PlayerSetPanel")
        return
    elseif this.page_type_ == 2 then
        this.page_type_ = 1
        this.playerinfo_panel_.gameObject:SetActive(true)
        this.reicon_panel_.gameObject:SetActive(false)
    end
    this.title_text_.text = this.title_name_[this.page_type_]
end
---------------------------显示界面---------------------------

function PlayerSetPanel.ShowSetingPanel()
    local player_icon_index = tonumber(PlayerData.player.avatar)
    if player_icon_index == 0 then
        player_icon_index = 1
    end
    if player_icon_index ~= 0 then
        this.icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(Config.get_config_value("t_avatar",tonumber(player_icon_index)).res)
    end
    this.player_name_text_:GetComponent("LocalizationText").text = tostring(PlayerData.player.name)
    this.player_level_text_:GetComponent("LocalizationText").text = tostring(PlayerData.player.level)
    local PlayerLevelExp = GameSys.GetPlayerLevelExp(PlayerData.player.level + 1)
    this.player_exp_slider_:GetComponent("Slider").value = PlayerData.player.exp / PlayerLevelExp
    local exp = GameSys.unit_conversion(PlayerData.player.exp)
    PlayerLevelExp = GameSys.unit_conversion(PlayerLevelExp)
    this.player_exp_text_:GetComponent("LocalizationText").text = string.format("%s/%s", tostring(exp), tostring(PlayerLevelExp))
    this.player_power_text_:GetComponent("LocalizationText").text = string.format("强度 %s", tostring(GameSys.unit_conversion(toInt(PlayerData.get_fight_power()))))
    this.player_id_text_:GetComponent("LocalizationText").text = tostring(PlayerData.login_info.token)
    this.title_text_.text = this.title_name_[this.page_type_]
end

function PlayerSetPanel.OpenReIconLayer()
    this.page_type_ = 2
    this.playerinfo_panel_.gameObject:SetActive(false)
    local drawer_toggle = this.reicon_panel_:Find("select_icon/select_mask/drawer_toggle")
    local drawer_item = this.reicon_panel_:Find("toggle_item")
    GameSys.ClearChild(drawer_toggle)
    for k,v in ipairs(Config.t_avatar) do
        local item_t = GameObject.Instantiate(drawer_item.gameObject)
        item_t.transform:SetParent(drawer_toggle, false)
        item_t.transform.localScale = Vector3.one
        item_t.transform.name = tostring(k)
        item_t.transform:Find("Background"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(v.res)  --v.icon
        if v.id == tonumber(PlayerData.player.avatar) then
            item_t.transform:GetComponent("Toggle").isOn = true
        end
        GameSys.ButtonRegister(this.lua_script_, item_t, "toggle", PlayerSetPanel.ClickIcon)
        item_t:SetActive(true)
    end
    this.title_text_.text = this.title_name_[this.page_type_]
    this.reicon_panel_.gameObject:SetActive(true)
end

function PlayerSetPanel.OpenReNameLayer()
    this.change_name_jewel_ = tonumber(Config.get_config_value("t_const", "change_name_jewel").value)
    this.rename_panel_:Find("InputField"):GetComponent("InputField").text = ""
    this.rename_panel_:Find("cost/cost_text"):GetComponent("LocalizationText").text = this.change_name_jewel_
    this.playerset_two_panel_.gameObject:SetActive(true)
end

function PlayerSetPanel.OpenLogOutLayer()
    GUIRoot.ShowPanel("SelectPanel",{"将退回到登录界面，是否确定？", PlayerSetPanel.PlayerOutlogGame, PlayerSetPanel.PlayerOutlogGameB})
end

function PlayerSetPanel.CloseResetLayer()
    PlayerSetPanel.CloseTwoPanel()
    local str = "修改成功"
    GUIRoot.ShowPanel("MessagePanel", {str})
end

function PlayerSetPanel.CloseTwoPanel()
    this.playerset_two_panel_.gameObject:SetActive(false)
end

function PlayerSetPanel.ChangePlayerName(obj)
    if PlayerData.player.jewel < this.change_name_jewel_ then
        local str = "钻石不够"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return
    end
    this.new_name_ = this.rename_panel_:Find("InputField/Text"):GetComponent("LocalizationText").text
    if this.new_name_ == PlayerData.player.name then
        local str = "跟之前相同"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return
    end
    local can_call = PlayerSetPanel.InputFieldEditEnd(this.new_name_)
    if can_call then
        local msg = player_msg_pb.cmsg_change_player_name()
        msg.new_name = this.new_name_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_PLAYER_CHANGE_NAME, data, {opcodes.SMSG_PLAYER_CHANGE_NAME}, "更改昵称", 60)
    end
end

function PlayerSetPanel.ClickIcon(obj, mag)
    if mag then
        this.new_icon_ = tonumber(obj.name)
        PlayerSetPanel.ChangePlayerIcon()
    end
end

function PlayerSetPanel.ChangePlayerIcon(obj)
    if this.new_icon_ == PlayerData.player.avatar then
        local str = "不能和之前相同"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return
    end
    local msg = player_msg_pb.cmsg_change_player_icon()
    msg.new_icon = this.new_icon_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_PLAYER_CHANGE_ICON, data, {opcodes.SMSG_PLAYER_CHANGE_ICON}, "更改头像", 60)
end

function PlayerSetPanel.PlayerOutlogGame(obj)
    log("设置界面回调 确定")
end

function PlayerSetPanel.PlayerOutlogGameB(obj)
    log("设置界面回调 取消")
end

function PlayerSetPanel.change_player_name(message)
    local msg = player_msg_pb.smsg_change_player_name()
    msg:ParseFromString(message.luabuff)
    PlayerData.player.name = this.new_name_
    this.player_name_text_:GetComponent("LocalizationText").text = this.new_name_
    PlayerData.add_resource(2, -this.change_name_jewel_)
    PlayerSetPanel.CloseResetLayer()

end

function PlayerSetPanel.change_player_icon(message)
    local msg = player_msg_pb.smsg_change_player_name()
    msg:ParseFromString(message.luabuff)
    if msg.res == 0 then
        PlayerSetPanel.CloseResetLayer()
        PlayerData.player.avatar = this.new_icon_
        this.icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(Config.get_config_value("t_avatar", this.new_icon_).res)
        local msg = CommonMessage()
        msg.name = "change_avatar_success"
        messMgr:AddCommonMessage(msg)
    end
end
