NamePanel = {}
NamePanel.Control = {}
local this = NamePanel.Control

function NamePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.player_name_panel_ = this.transform_:Find("back_ground/basic_panel_centent/player_name_panel")
    this.name_yes_but_ = this.transform_:Find("back_ground/basic_panel_centent/player_name_panel/player_name/rename_panel/name_yes_but")
    this.reicon_panel_back_ = this.transform_:Find("back_ground/basic_panel_centent/reicon_panel_back")
    this.close_btn_ = this.transform_:Find("back_ground/basic_panel_centent/reicon_panel_back/back_ground/close_btn")
    this.icon_ = this.transform_:Find("back_ground/basic_panel_centent/player_name_panel/player_name/rename_panel/Player_icon/icon")
    this.change_icon_btn_ = this.transform_:Find("back_ground/basic_panel_centent/player_name_panel/player_name/rename_panel/Player_icon/change_icon_btn")
    this.random_name_ = this.transform_:Find("back_ground/basic_panel_centent/player_name_panel/player_name/rename_panel/random_name")
    this.player_name_ = ""
    this.new_icon_ = 0
    this.name1_ = {}
    this.name2_ = {}
    NamePanel.RegisterBtnListers()
    NamePanel.RegisterMessage()
end

function NamePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.name_yes_but_.gameObject, "click", NamePanel.CallName)
    GameSys.ButtonRegister(this.lua_script_, this.change_icon_btn_.gameObject, "click", NamePanel.OpenReIconLayer)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", NamePanel.CloseIconPanel)
    GameSys.ButtonRegister(this.lua_script_, this.random_name_.gameObject, "click", NamePanel.RandomPlayerName)

end

function NamePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_NAMED, NamePanel.SMSG_NAMED)
end

function NamePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_NAMED, NamePanel.SMSG_NAMED)
end

function NamePanel.OnDestroy()
    NamePanel.RemoveMessage()
    this = {}
end

function NamePanel.Start(obj)
    NamePanel.InitNameData()
    NamePanel.InitPanel()
end

function NamePanel.InitNameData()
    for _, v in pairs(Config.t_name) do
        if v.lang[platform_config_common.lang].name1 ~= "" then
            table.insert(this.name1_, v.lang[platform_config_common.lang].name1)
        end
        if v.lang[platform_config_common.lang].name2 ~= "" then
            table.insert(this.name2_, v.lang[platform_config_common.lang].name2)
        end
    end
end

function NamePanel.InitPanel()
    this.player_name_panel_:Find("player_name/rename_panel/InputField"):GetComponent("InputField").onEndEdit:AddListener(NamePanel.InputFieldEditEnd)
    local random_index = math.random(#Config.t_avatar)
    if random_index ~= 0 then
        this.icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(Config.get_config_value("t_avatar",tonumber(random_index)).res)
        this.new_icon_ = random_index
    end
    NamePanel.RandomPlayerName()
    this.player_name_panel_.gameObject:SetActive(true)
end

function NamePanel.InputFieldEditEnd(text_str)
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

function NamePanel.RandomPlayerName()
    this.player_name_panel_:Find("player_name/rename_panel/InputField"):GetComponent("InputField").text = NamePanel.GetNameRandom()
end

function NamePanel.GetNameRandom()
    return this.name1_[math.random(#this.name1_)]..this.name2_[math.random(#this.name2_)]
end

function NamePanel.NewNameIcon()
    GameSys.ButtonRegister(this.lua_script_, this.name_yes_but_.gameObject, "click", NamePanel.CallName)
end

function NamePanel.OpenReIconLayer()
    this.player_name_panel_.gameObject:SetActive(false)
    local drawer_toggle = this.reicon_panel_back_:Find("back_ground/reicon_panel/select_icon/select_mask/drawer_toggle")
    local drawer_item = this.reicon_panel_back_:Find("back_ground/reicon_panel/toggle_item")
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
        GameSys.ButtonRegister(this.lua_script_, item_t, "toggle", NamePanel.ClickIcon)
        item_t:SetActive(true)
    end
    this.reicon_panel_back_.gameObject:SetActive(true)
end

function NamePanel.ClickIcon(obj, mag)
    if mag then
        this.new_icon_ = tonumber(obj.name)
        NamePanel.ChangePlayerIcon()
    end
end

function NamePanel.ChangePlayerIcon()
    NamePanel.CloseIconPanel()
    this.icon_:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(Config.get_config_value("t_avatar", this.new_icon_).res)
    NamePanel.ChangeRefresh()
end

function NamePanel.CallName()
    this.player_name_ = this.player_name_panel_:Find("player_name/rename_panel/InputField/Text"):GetComponent("LocalizationText").text
    local can_call = NamePanel.InputFieldEditEnd(this.player_name_)
    if can_call then
        local msg = player_msg_pb.cmsg_named()
        msg.name = this.player_name_
        msg.icon = this.new_icon_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_NAMED, data, {opcodes.SMSG_NAMED}, "起名", 60)
    end
end

function NamePanel.ClosePanel()
    GUIRoot.ClosePanel("NamePanel")
end

function NamePanel.CloseIconPanel()
    this.reicon_panel_back_.gameObject:SetActive(false)
    this.player_name_panel_.gameObject:SetActive(true)
end


function NamePanel.SMSG_NAMED(message)
    PlayerData.player.name = this.player_name_
    PlayerData.player.avatar = this.new_icon_
    NamePanel.ClosePanel()
    NamePanel.ChangeRefresh()
end

function NamePanel.ChangeRefresh()
    local common_msg = CommonMessage()
    common_msg.name = "refresh_topRes"
    messMgr:AddCommonMessage(common_msg)

    local common_msg2 = CommonMessage()
    common_msg2.name = "name_end"
    messMgr:AddCommonMessage(common_msg2)
end
