RankPanel = {}

RankPanel.Control = {}
local this = RankPanel.Control
function RankPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.page_btn_res_ = this.transform_:Find("rank_back_panel/rank_pakege_botton/page_btn_res")
    this.page_btn_res_group_ = this.transform_:Find("rank_back_panel/rank_pakege_botton/page_btn_res_group")
    this.pakege_top_text_ = this.transform_:Find("rank_back_panel/rank_pakege_top/pakege_top_image/pakege_top_text")

    this.rank_back_panel_ = this.transform_:Find("rank_back_panel")
    this.rank_show_content_ = this.transform_:Find("rank_back_panel/rank_pakege_panel/rank_show/rank_main_panel/rank_show_content")
    this.rank_data_text_ = this.transform_:Find("rank_back_panel/rank_pakege_panel/rank_show/rank_main_panel/rank_tip/rank_data_text")
    this.rank_res_ = this.transform_:Find("rank_back_panel/rank_pakege_panel/rank_res")
    this.rank_me_ = this.transform_:Find("rank_back_panel/rank_pakege_panel/rank_me_panel/rank_pakege_view/rank_me")
    this.rank_close_ = this.transform_:Find("rank_back_panel/rank_close")
    this.btn_name_ = { "page_btn_level_nol", "page_btn_fight_nol", "page_btn_tower_nol" }
    this.page_text_ = {"等级榜单", "战力榜单", "龙之塔"}
    this.rank_type_data_ = { "等级", "战力", "层数" }
    this.page_botton_btn_ = {}
    this.cur_page_type = 1
    this.rank_sever_data_ = nil
    this.superlist_ = nil
    this.superlist_init_ = false
    this.open_player_panel_ = false
    RankPanel.RegButton()
    RankPanel.RegisterMessage()
    RankPanel.SetView()
end

function RankPanel.Start()
    this.gameObject_.gameObject:SetActive(false)
    RankPanel.GetRank2Server(this.cur_page_type)
end

function RankPanel.GetRank2Server(rank_type)
    local temp_rank_type = rank_type
    local msg = player_msg_pb.cmsg_rank_get()
    msg.type = temp_rank_type
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_RANK_GET, data, { opcodes.SMSG_RANK_GET }, "获取榜单中", 60)
end

function RankPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_RANK_GET, RankPanel.SMSG_RANK_GET)
    Message.register_net_handle(opcodes.SMSG_VIEW_PLAYER, RankPanel.SMSG_VIEW_PLAYER)

    Message.register_handle("PlayerPanelStateChange", RankPanel.OnPlayerPanelClose)
end

function RankPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_RANK_GET, RankPanel.SMSG_RANK_GET)
    Message.register_net_handle(opcodes.SMSG_VIEW_PLAYER, RankPanel.SMSG_VIEW_PLAYER)

    Message.remove_handle("PlayerPanelStateChange", RankPanel.OnPlayerPanelClose)
end

function RankPanel.InitSuperList()
    GameSys.ClearChild(this.rank_show_content_)
    this.superlist_ = this.rank_show_content_:GetComponent("UIScrollGrid")
    this.superlist_.prefab = this.rank_res_.gameObject
    this.superlist_.SetDataHandle = function(go, index)
        local temp_rank_num = index + 1
        go.transform:Find("rank_num"):GetComponent("LocalizationText").text = temp_rank_num
        go.transform:Find("rank_level"):GetComponent("LocalizationText").text = "战士"
        go.transform:Find("rank_player_icon/rank_name"):GetComponent("LocalizationText").text = this.rank_sever_data_.player_name[temp_rank_num]
        local click_obj = go.transform:Find("rank_player_icon")
        local btn = click_obj:GetChild(0)
        btn.gameObject.name = "player_icon_" .. index
        GameSys.ButtonRegister(this.lua_script_, btn.gameObject, "click", RankPanel.OnPlayerIconClick, { this.rank_sever_data_.player_guid[temp_rank_num] })
        local icon_index = this.rank_sever_data_.player_icon[temp_rank_num]
        if icon_index == 0 then
            icon_index = 1
        end
        local sprite_alias = Config.get_config_value("t_avatar", icon_index).res
        if sprite_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "avatar"):GetSprite(sprite_alias)
            if sprite ~= "" then
                btn:Find("icon"):GetComponent("Image").sprite = sprite
            end
        end

        local rank_num_image_groud = go.transform:Find("rank_num_image_groud")
        local num_show = true
        if (rank_num_image_groud.childCount > 0) then
            for i = 0, rank_num_image_groud.childCount - 1 do
                if tonumber(rank_num_image_groud:GetChild(i).name) == temp_rank_num then
                    rank_num_image_groud:GetChild(i).gameObject:SetActive(true)
                    num_show = false
                else
                    rank_num_image_groud:GetChild(i).gameObject:SetActive(false)
                end
            end
        end
        go.transform:Find("rank_num").gameObject:SetActive(num_show)

        go.transform:Find("rank_data"):GetComponent("LocalizationText").text = GameSys.unit_conversion(this.rank_sever_data_.player_data[temp_rank_num])

        go.gameObject:SetActive(true)
    end
    this.superlist_:Init()
    this.superlist_:SetData(#this.rank_sever_data_.player_guid)
end

function RankPanel.SetView()
    for i = 1, #this.btn_name_ do
        local btn_t = GameObject.Instantiate(this.page_btn_res_.gameObject)
        btn_t.transform:SetParent(this.page_btn_res_group_, false)
        btn_t.transform.localPosition = Vector3(-194 + (i - 1) * 195, 0, 0)
        btn_t.transform.localScale = Vector3.one
        btn_t.gameObject:GetComponent("Toggle").group = this.page_btn_res_group_:GetComponent("ToggleGroup")
        btn_t.gameObject:GetComponent("Toggle").isOn = false
        btn_t.name = this.btn_name_[i]
        btn_t.transform:Find("nol/Text"):GetComponent("LocalizationText").text = this.page_text_[i]
        btn_t.transform:Find("sel/Text"):GetComponent("LocalizationText").text = this.page_text_[i]
        btn_t:SetActive(true)
        table.insert(this.page_botton_btn_, btn_t.transform)
    end

    this.page_botton_btn_[1].gameObject:GetComponent("Toggle").isOn = true
    for i = 1, #this.page_botton_btn_ do
        GameSys.ButtonRegister(this.lua_script_, this.page_botton_btn_[i].gameObject, "toggle", RankPanel.ToggleClick)
    end
    this.pakege_top_text_:GetComponent("LocalizationText").text = this.page_text_[this.cur_page_type]
    this.rank_data_text_:GetComponent("LocalizationText").text = this.rank_type_data_[this.cur_page_type]
end

function RankPanel.OnDestroy()
    RankPanel.RemoveMessage()
    this.lua_script_:ClearClick()
    this = {}
end

function RankPanel.RegButton()
    GameSys.ButtonRegister(this.lua_script_, this.rank_close_.gameObject, "click", RankPanel.ClosePanel)
end

function RankPanel.ClosePanel()
    GUIRoot.ClosePanel("RankPanel")
end

function RankPanel.ToggleClick(obj, check)
    if check then
        if obj.name == "page_btn_level_nol" then
            this.cur_page_type = 1
        elseif obj.name == "page_btn_fight_nol" then
            this.cur_page_type = 2
        elseif obj.name == "page_btn_tower_nol" then
            this.cur_page_type = 3
        end
        RankPanel.GetRank2Server(this.cur_page_type)
    end
end

function RankPanel.SetRankMe()
    local me_ranking = RankPanel.GetMeRank()
    if me_ranking > 0 then
        this.rank_me_.transform:Find("rank_num"):GetComponent("LocalizationText").text = me_ranking
    else
        this.rank_me_.transform:Find("rank_num"):GetComponent("LocalizationText").text = "未上榜"
    end
    this.rank_me_.transform:Find("rank_level"):GetComponent("LocalizationText").text = "战士"
    this.rank_me_.transform:Find("rank_player_icon/rank_name"):GetComponent("LocalizationText").text = PlayerData.player.name
    local icon_btn = this.rank_me_.transform:Find("rank_player_icon"):GetChild(0)
    icon_btn.gameObject.name = "play_self_icon_btn"
    GameSys.ButtonRegister(this.lua_script_, icon_btn.gameObject, "click", RankPanel.OnPlayerIconClick, { PlayerData.player.guid })
    local icon_index = PlayerData.player.avatar
    if icon_index == 0 then
        icon_index = 1
    end
    local sprite_alias = Config.get_config_value("t_avatar", icon_index).res
    if sprite_alias ~= "" then
        local sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "avatar"):GetSprite(sprite_alias)
        if sprite ~= "" then
            icon_btn:Find("icon"):GetComponent("Image").sprite = sprite
        end
    end
    local rank_num_image_groud = this.rank_me_.transform:Find("rank_num_image_groud")
    local num_show = true
    if (rank_num_image_groud.childCount > 0) then
        for i = 0, rank_num_image_groud.childCount - 1 do
            if tonumber(rank_num_image_groud:GetChild(i).name) == me_ranking then
                rank_num_image_groud:GetChild(i).gameObject:SetActive(true)
                num_show = false
            else
                rank_num_image_groud:GetChild(i).gameObject:SetActive(false)
            end
        end
    end
    this.rank_me_.transform:Find("rank_num").gameObject:SetActive(num_show)
    local me_ranking_data = RankPanel.GetSelfRankData()

    this.rank_me_.transform:Find("rank_data"):GetComponent("LocalizationText").text = GameSys.unit_conversion(me_ranking_data)

end

function RankPanel.GetMeRank()
    local rank_num = 0
    if this.rank_sever_data_ ~= nil then
        for i = 1, #this.rank_sever_data_.player_guid do
            if this.rank_sever_data_.player_guid[i] == PlayerData.player.guid then
                rank_num = i
                break
            end
        end
    end
    return rank_num
end

function RankPanel.GetLastMission(pre_pid)
    for k, v in pairs(Config.t_mission) do
        if v.pre_pid == pre_pid then
            return v.id
        end
    end
    return 1
end

function RankPanel.GetSelfRankData()
    if this.cur_page_type == 1 then
        return PlayerData.player.level
    elseif this.cur_page_type == 2 then
        return PlayerData.get_fight_power()
    elseif this.cur_page_type == 3 then
        return PlayerData.player.tower
    else
        return 0
    end
end

function RankPanel.SMSG_RANK_GET(message)
    local msg = player_msg_pb.smsg_rank_get()
    msg:ParseFromString(message.luabuff)
    if not this.gameObject_.gameObject.activeSelf then
        this.gameObject_.gameObject:SetActive(true)
    end
    this.rank_sever_data_ = msg.rank
    if this.rank_sever_data_ ~= nil and not this.superlist_init_ then
        RankPanel.InitSuperList()
        this.rank_back_panel_:GetComponent("Animator"):Play("tanchu", 0, 0)
        this.superlist_init_ = true
    elseif this.rank_sever_data_ ~= nil then
        this.superlist_:SetData(#this.rank_sever_data_.player_guid)
    end
    if this.rank_sever_data_ ~= nil then
        RankPanel.SetRankMe()
    end
    this.pakege_top_text_:GetComponent("LocalizationText").text = this.page_text_[this.cur_page_type]
    this.rank_data_text_:GetComponent("LocalizationText").text = this.rank_type_data_[this.cur_page_type]
end

function RankPanel.OnPlayerIconClick(obj, param)
    local player_guid = param[1]
    if player_guid == PlayerData.player.guid then
        GUIRoot.ShowPanel("PlayerPanel", { true })
        this.open_player_panel_ = true
        GUIRoot.ClosePanel("RankPanel", false)
    else
        local msg = center_msg_pb.cmsg_view_player()
        msg.player_guid = player_guid
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_VIEW_PLAYER, data, { opcodes.SMSG_VIEW_PLAYER })
    end
end

function RankPanel.SMSG_VIEW_PLAYER(message)
    local msg = center_msg_pb.smsg_view_player()
    msg:ParseFromString(message.luabuff)
    GUIRoot.ClosePanel("RankPanel", false)
    this.open_player_panel_ = true
    GUIRoot.ShowPanel("PlayerPanel", { false, msg })
end

function RankPanel.OnPlayerPanelClose(message)
    local player_panel_show = message.m_object[0]
    if this.open_player_panel_ and not player_panel_show then
        this.open_player_panel_ = false
        GUIRoot.ShowPanel("RankPanel")
    end
end



