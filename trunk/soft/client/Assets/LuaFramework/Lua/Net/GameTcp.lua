GameTcp = {}

GameTcp.is_kicked = false
GameTcp.re_connect_fail = false

function GameTcp.Init()
    GameTcp.is_kicked = false
    GameTcp.re_connect_fail = false
    Message.register_net_handle(opcodes.SMSG_LOGIN_PLAYER, GameTcp.OnLoginGameServer)
    Message.register_net_handle(opcodes.SMSG_RECONNECTION, GameTcp.OnLoginGameServer)
end

function GameTcp.Finish()
    GameTcp.is_kicked = false
    GameTcp.re_connect_fail = false
    Message.remove_net_handle(opcodes.SMSG_LOGIN_PLAYER, GameTcp.OnLoginGameServer)
    Message.remove_net_handle(opcodes.SMSG_RECONNECTION, GameTcp.OnLoginGameServer)
end

function GameTcp.Connect(ip, port)
    GUIRoot.ShowPanel("MaskPanel")
    networkMgr:Connect("GameTcp", ip, port)
end

function GameTcp.Disconnect()
    networkMgr:Disconnect("GameTcp")
end

function GameTcp.Isconnect()
    return networkMgr:Isconnect("GameTcp")
end

function GameTcp.Send(opcode, data, smsgs, text, time)
    if not GameTcp.Isconnect() then
        return
    end
    if text == nil then
        text = ""
    end
    if time == nil then
        time = 10
    end
    if smsgs ~= nil and #smsgs > 0 then
        Message.OnMask(smsgs, text, time)
    end
    if data then
        networkMgr:SendMessage("GameTcp", opcode, data)
    else
        networkMgr:SendMessageNull("GameTcp", opcode)
    end
end

function GameTcp.OnConnect()
    GUIRoot.ClosePanel("MaskPanel")
    if PlayerData.re_connect_code == nil then
        local msg = player_msg_pb.cmsg_login_player()
        msg.username = PlayerData.login_info.token
        msg.password = PlayerData.login_info.pass_word
        msg.serverid = PlayerData.login_info.server_id
        msg.platform = PlayerData.login_info.platform
        msg.lang = PlayerData.login_info.lang
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_LOGIN_PLAYER, data, { opcodes.SMSG_LOGIN_PLAYER })
    else
        local msg = player_msg_pb.cmsg_reconnection()
        msg.player_guid = PlayerData.player.guid
        msg.code = PlayerData.re_connect_code
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_RECONNECTION, data, { opcodes.SMSG_RECONNECTION })
    end
end

function GameTcp.OnLoginGameServer(message)
    PlayerData.Init(message)
    if State.cur_state == State.state.ss_login then
        if PlayerData.player.in_map == 0 then
            State.ChangeState(State.state.ss_hall)
        else
            local map_data = {}
            map_data.cur_map_id = PlayerData.player.in_map
            map_data.pre_map_id = nil
            State.ChangeState(State.state.ss_map, map_data)
        end
    elseif State.cur_state == State.state.ss_hall then
        HallPanel.RefreshPanel()
        BasicUIPanel.RefreshPanel()
        TopResPanel.RefreshPanel()
        GUIRoot.ShowPanel("MessagePanel", { "连接成功" })
    elseif State.cur_state == State.state.ss_map then
        --地图客户端自己算
        BasicUIPanel.RefreshPanel()
        TopResPanel.RefreshPanel()
        GUIRoot.ShowPanel("MessagePanel", { "连接成功" })
    elseif State.cur_state == State.state.ss_battle then
        Battle.LevelBattleByReConnect()
    end
end

function GameTcp.OnConnectFail()
    GameTcp.ConnectProblem()
end

function GameTcp.OnDisconnect()
    GameTcp.ConnectProblem()
end

function GameTcp.ConnectProblem()
    Message.OnDisConnect()
    local del_panels = {}
    for panel_name in pairs(GUIRoot.game_guis) do
        if panel_name ~= "TopResPanel" and panel_name ~= "BasicUIPanel" then
            table.insert(del_panels, panel_name)
        end
    end
    for i = 1, #del_panels do
        GUIRoot.ClosePanel(del_panels[i])
    end
    if State.cur_state == State.state.ss_map then
        MapPanel.OnDisconnect()
    elseif State.cur_state == State.state.ss_battle then
        FightManger.GameDisConnect()
    end
    if GameTcp.is_kicked then
        GUIRoot.ShowPanel("SelectPanel", { "与服务器断开连接", State.Reset })
        GameTcp.is_kicked = false
    elseif GameTcp.re_connect_fail then
        GUIRoot.ShowPanel("SelectPanel", { "重连失败,请重新登陆", State.Reset })
        GameTcp.re_connect_fail = false
    else
        GUIRoot.ShowPanel("SelectPanel", { "与服务器断开连接,是否重新连接", function ()
            GameTcp.Connect(PlayerData.login_info.game_server, PlayerData.login_info.game_server_port)
        end, State.Reset })
    end
end