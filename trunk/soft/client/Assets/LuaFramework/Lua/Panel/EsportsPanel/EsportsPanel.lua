EsportsPanel = {}
EsportsPanel.Control = {}
local this = EsportsPanel.Control

function EsportsPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("bcakground/close_btn")
    this.challenge_panel_ = this.transform_:Find("bcakground/among_panel/challenge_panel")
    this.challenge_players_root_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/challenge_players_root")
    this.rank_slot_ = this.transform_:Find("bcakground/among_panel/rank_slot")
    this.player_name_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/info_root/player_name")
    this.player_jf_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/info_root/player_jf")
    this.player_rank_rate_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/info_root/player_rank_rate")
    this.player_power_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/info_root/player_power")
    this.player_icon_root_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/player_icon_root")
    this.reawrd_rank_num_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/reawrd_rank_num")
    this.reward_panel_btn_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/player_info/reward_panel_btn")
    this.challenge_pipe_emy_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/challenge_pipe_emy")
    this.rank_end_time_ = this.transform_:Find("bcakground/among_panel/challenge_panel/challenge_list/rank_end_time"):GetComponent("LocalizationText")
    this.rank_list_ = {}
    this.rank_scroll_grid_ = nil
    this.reward_states_ = {}
    this.open_player_panel_ = false
    this.rank_end_time = 0
    EsportsPanel.RegisterBtnListers()
    EsportsPanel.RegisterMessage()

    EsportsPanel.SetChangeList()
    timerMgr:AddRepeatTimer('rank_timerMar', EsportsPanel.RefreshTime, 0.1, 0.1)
    this.gameObject_:SetActive(false)
end

function EsportsPanel.OnDestroy(obj)
    EsportsPanel.RemoveMessage()
    timerMgr:RemoveRepeatTimer('rank_timerMar')
    this = {}
end

function EsportsPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", EsportsPanel.OnCloseBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.reward_panel_btn_.gameObject, "click", EsportsPanel.ShowRewarPanel, nil)
end

function EsportsPanel.RegisterMessage()
    Message.register_handle("battle_end", EsportsPanel.BattleEnd)
    Message.register_handle("PlayerPanelStateChange", EsportsPanel.OnPlayerPanelClose)
    Message.register_net_handle(opcodes.SMSG_ARENA_ROOM, EsportsPanel.SMSG_ARENA_ROOM)-- 获取挑战列表
    Message.register_net_handle(opcodes.SMSG_ARENA_LIST, EsportsPanel.SMSG_ARENA_LIST) -- 获取排行列表
    Message.register_net_handle(opcodes.SMSG_ARENA_FIGHT_INIT, EsportsPanel.SMSG_ARENA_FIGHT_INIT) -- 去挑战
    Message.register_net_handle(opcodes.SMSG_VIEW_PLAYER, EsportsPanel.SMSG_VIEW_PLAYER)
end

function EsportsPanel.RemoveMessage()
    Message.remove_handle("battle_end", EsportsPanel.BattleEnd)
    Message.remove_net_handle("PlayerPanelStateChange", EsportsPanel.OnPlayerPanelClose)
    Message.remove_net_handle(opcodes.SMSG_ARENA_ROOM, EsportsPanel.SMSG_ARENA_ROOM)
    Message.remove_net_handle(opcodes.SMSG_ARENA_FIGHT_INIT, EsportsPanel.SMSG_ARENA_FIGHT_INIT)
    Message.remove_net_handle(opcodes.SMSG_ARENA_LIST, EsportsPanel.SMSG_ARENA_LIST)
    Message.remove_net_handle(opcodes.SMSG_VIEW_PLAYER, EsportsPanel.SMSG_VIEW_PLAYER)
end

function EsportsPanel.OnCloseBtnClick()
    GUIRoot.ClosePanel("EsportsPanel")
end

function EsportsPanel.CloseAllPanel()
    this.challenge_panel_.gameObject:SetActive(false)
end

function EsportsPanel.BattleEnd(message)
    EsportsPanel.Refresh()
end

function EsportsPanel.Start(obj)
    EsportsPanel.Refresh()
end

function EsportsPanel.Refresh()

end

-------------------------------挑战界面-----------------------------------------
function EsportsPanel.RefreshChallengePanel()
    GameTcp.Send(opcodes.CMSG_ARENA_ROOM, nil, { opcodes.SMSG_ARENA_ROOM }, nil)
end

function EsportsPanel.SMSG_ARENA_ROOM(message)
    local msg = arena_msg_pb.smsg_arena_room()
    msg:ParseFromString(message.luabuff)
    -- 同步数据
    PlayerData.player.arena_room = msg.arena_room.guid
    PlayerData.player.arena_segment = msg.arena_room.segment
    for i = 1, #msg.arena_room.player_guids do
        if msg.arena_room.player_guids[i] == PlayerData.player.guid then
            PlayerData.player.arena_integral = msg.arena_room.player_integrals[i]
            PlayerData.player.arena_win = msg.arena_room.arena_wins[i]
            PlayerData.player.arena_num = msg.arena_room.arena_nums[i]
        end
    end

    this.rank_end_time = msg.arena_room.last_time
    this.challenge_list_ = {}
    EsportsPanel.RankSort(this.challenge_list_, msg, 1)
    this.challenge_panel_.gameObject:SetActive(true)
    if #this.challenge_list_ > 1 then
        this.challenge_pipe_emy_.gameObject:SetActive(false)
    else
        this.challenge_pipe_emy_.gameObject:SetActive(true)
    end
    this.challenge_scroll_grid_:SetData(#this.challenge_list_)
    this.player_name_:GetComponent("LocalizationText").text = PlayerData.player.name
    this.player_jf_:GetComponent("LocalizationText").text = string.format("积分 %s", PlayerData.player.arena_integral)
    this.player_rank_rate_:GetComponent("LocalizationText").text = string.format("胜率 %.1f%%", PlayerData.player.arena_num ~= 0 and  (PlayerData.player.arena_win / PlayerData.player.arena_num) * 100 or 0 )
    this.player_power_:GetComponent("LocalizationText").text = string.format("强度 %s", GameSys.unit_conversion(toInt(PlayerData.get_fight_power())))
    local player_icon_ins = nil
    local player_guid = PlayerData.player.guid
    local is_npc = 0
    player_icon_ins = CommonPanel.GetPlayerIcon(PlayerData.player.avatar, this.lua_script_, { "rank_player_btn_myself", EsportsPanel.OnRankPlayerClick, { is_npc, player_guid } })
    if player_icon_ins ~= nil then
        Util.SetRoot(player_icon_ins.transform, this.player_icon_root_)
    end
    local t_arena_reward = Config.get_config_value("t_arena_reward", msg.arena_room.segment)
    local next_reawr = Config.get_config_value("t_arena_reward", t_arena_reward.next)
    local reward_text = ""
    if next_reawr ~= nil then
        for i = 1, #next_reawr.reward do
            local asset = next_reawr.reward[i]
            local reward_sub_text = string.format("%s x%s ", GameSys.GetAssetName(asset), asset.value2)
            reward_text = reward_text..reward_sub_text
        end
        this.reawrd_rank_num_:GetComponent("LocalizationText").text = string.format("晋级奖励: %s", reward_text)
    else
        this.reawrd_rank_num_:GetComponent("LocalizationText").text = "最高奖励段位"
    end

    this.gameObject_:SetActive(true)
end

function EsportsPanel.RefreshTime()
    if this.rank_end_time ~= 0 then
        local time_show, end_time = EsportsPanel.TimerDua()
        if time_show then
            local time = tonumber(end_time) - tonumber(timerMgr:now_string())
            this.rank_end_time_.text = "下次结算时间："..count_time(time)
        else
            this.rank_end_time_.text = "系统正在结算"
        end
    end
end

function EsportsPanel.TimerDua()
    local now = tonumber(timerMgr:now_string() / 1000)
    local now_time = os.date("*t",tonumber(timerMgr:now_string() / 1000))
    local begin_time = os.time({day = now_time.day, month = now_time.month, year = now_time.year, hour = 5})
    local end_time = os.time({day = now_time.day, month = now_time.month, year = now_time.year, hour = 22})
    if now > begin_time and end_time > now then
        return true, end_time * 1000
    else
        return false, nil
    end
end

function EsportsPanel.SetChangeList()
    Util.ClearChild(this.challenge_players_root_)
    this.challenge_scroll_grid_ = this.challenge_players_root_:GetComponent("UIScrollGrid")
    this.challenge_scroll_grid_.prefab = this.rank_slot_.gameObject
    this.challenge_scroll_grid_.SetDataHandle = function(go, index)
        local challenge_info = this.challenge_list_[index + 1]
        EsportsPanel.SetRankSlot(go, challenge_info, index + 1)
        go.gameObject:SetActive(true)
    end
    this.challenge_scroll_grid_:Init()
    this.challenge_scroll_grid_:SetData(0)
    EsportsPanel.RefreshChallengePanel()
end

function EsportsPanel.RankSort(list, msg)
    for i = 1, #msg.arena_room.player_guids do
        local t = {
            ["guid"] = msg.arena_room.guid,
            ["player_guid"] = msg.arena_room.player_guids[i],
            ["name"] = msg.arena_room.player_names[i],
            ["level"] = msg.arena_room.player_levels[i],
            ["icon"] = msg.arena_room.player_icons[i],
            ["is_npc"] = msg.arena_room.is_npc[i],
            ["power"] = msg.arena_room.player_powers[i],
            ["integral"] = msg.arena_room.player_integrals[i],
            ["win"] = msg.arena_room.arena_wins[i],
            ["num"] = msg.arena_room.arena_nums[i],
            ["segment"] = msg.arena_room.segment
        }
        table.insert(list, t)
    end
    if #list > 1 then
        table.sort(list, function (a, b)
            return a.integral > b. integral
        end)
    end
end

function EsportsPanel.SetRankSlot(rank_slot_ins, info, sort)
    local rank_player_icon_root = rank_slot_ins.transform:Find("rank_player_icon_root")
    local name_text = rank_slot_ins.transform:Find("info_root/player_name")
    local player_sort = rank_slot_ins.transform:Find("info_root/player_sort")
    local player_power = rank_slot_ins.transform:Find("info_root/player_power")
    local challenge_btn = rank_slot_ins.transform:GetChild(3)
    local player_rank = rank_slot_ins.transform:Find("player_rank")
    local name = info.name
    local power = info.power
    local icon_id = info.icon
    if icon_id == 0 then
        icon_id = 1
    end
    local rank_sort = info.integral
    name_text:GetComponent("Text").text = name
    player_power:GetComponent("Text").text = "强度 "..GameSys.unit_conversion(power)
    player_sort.gameObject:SetActive(true)
    player_sort:GetComponent("Text").text = "积分 "..rank_sort
    Util.ClearChild(rank_player_icon_root)
    local rank_1 = player_rank:Find("num_1")
    local rank_2 = player_rank:Find("num_2")
    local rank_3 = player_rank:Find("num_3")
    local other = player_rank:Find("other")
    rank_1.gameObject:SetActive(false)
    rank_2.gameObject:SetActive(false)
    rank_3.gameObject:SetActive(false)
    rank_3.gameObject:SetActive(false)
    other.gameObject:SetActive(false)
    if sort > 3 then
        other.gameObject:SetActive(true)
        player_rank:Find("other/player_rank_num"):GetComponent("Text").text = sort
        player_rank.gameObject:SetActive(true)
    elseif sort == 1  then
        rank_1.gameObject:SetActive(true)
        player_rank.gameObject:SetActive(true)
    elseif sort == 2 then
        rank_2.gameObject:SetActive(true)
        player_rank.gameObject:SetActive(true)
    elseif sort == 3 then
        rank_3.gameObject:SetActive(true)
        player_rank.gameObject:SetActive(true)
    end
    if rank_player_icon_root.childCount > 0 then
        local icon = rank_player_icon_root:GetChild(0)
        this.lua_script_:RemoveButtonEvent(icon.gameObject, "click")
    end
    local player_icon_ins = nil
    local player_guid = info.player_guid
    local is_npc = info.is_npc
    player_icon_ins = CommonPanel.GetPlayerIcon(icon_id, this.lua_script_, { "rank_player_btn_" .. sort, EsportsPanel.OnRankPlayerClick, { is_npc, player_guid } })
    if player_icon_ins ~= nil then
        Util.SetRoot(player_icon_ins.transform, rank_player_icon_root)
    end

    local show_challenge = true
    for i = 1, #PlayerData.player.arena_fight do
        if PlayerData.player.arena_fight[i] == info.player_guid then
            show_challenge = false
            break
        end
    end
    if show_challenge and PlayerData.player.guid == info.player_guid then
        show_challenge = false
    end
    challenge_btn.gameObject:SetActive(show_challenge)
    this.lua_script_:RemoveButtonEvent(challenge_btn.gameObject, "click")
    challenge_btn.gameObject.name = "chanllenge_btn_"..sort
    GameSys.ButtonRegister(this.lua_script_, challenge_btn.gameObject, "click", EsportsPanel.OnChallengePlayerClick, { info })
end

function EsportsPanel.OnChallengePlayerClick(obj, params)
    if not EsportsPanel.TimerDua() then
        GUIRoot.ShowPanel("MessagePanel", {"现在是结算时间"})
        return
    end
    this.cur_chanllenge_rank_sort_ = params[1]
    local msg = arena_msg_pb.cmsg_arena_fight_init()
    msg.player_guid = this.cur_chanllenge_rank_sort_.player_guid
    msg.arena_room_guid = this.cur_chanllenge_rank_sort_.guid
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_ARENA_FIGHT_INIT, data, { opcodes.SMSG_ARENA_FIGHT_INIT }, nil)
end

function EsportsPanel.SMSG_ARENA_FIGHT_INIT(message)
    print("收到玩家消息")
    local msg = arena_msg_pb.smsg_arena_fight_init()
    msg:ParseFromString(message.luabuff)
    Battle.GoBattle(Battle.BATTLE_TYPE.esport, { this.cur_chanllenge_rank_sort_, msg }, State.state.ss_hall)
end

---------------------------------------排名界面---------------------------------------

function EsportsPanel.OnRankPlayerClick(obj, params)
    local is_npc = params[1]
    if is_npc == 1 then
        GUIRoot.ShowPanel("MessagePanel", {"我是npc,别点我"})
        return
    end
    local player_guid = params[2]
    if player_guid == PlayerData.player.guid then
        this.open_player_panel_ = true
        GUIRoot.ShowPanel("PlayerPanel", { true })
    else
        local msg = center_msg_pb.cmsg_view_player()
        msg.player_guid = player_guid
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_VIEW_PLAYER, data, { opcodes.SMSG_VIEW_PLAYER })
    end
end

function EsportsPanel.SMSG_VIEW_PLAYER(message)
    local msg = center_msg_pb.smsg_view_player()
    msg:ParseFromString(message.luabuff)
    GUIRoot.ClosePanel("EsportsPanel", false)
    this.open_player_panel_ = true
    GUIRoot.ShowPanel("PlayerPanel", { false, msg })
end

function EsportsPanel.OnPlayerPanelClose(message)
    local player_panel_show = message.m_object[0]
    if this.open_player_panel_ and not player_panel_show then
        this.open_player_panel_ = false
        GUIRoot.ShowPanel("EsportsPanel")
    end
end






