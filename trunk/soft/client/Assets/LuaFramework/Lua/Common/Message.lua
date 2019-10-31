Message = {}

local net_handles_ = {}
local handles_ = {}
local cur_reopcode_ = {}

local send_time_ = 0
local gm_command_text_
function Message.Init()
    send_time_ = 0
    timerMgr:AddRepeatTimer("Message", Message.Update, 1, 1)
    Message.register_handle("edit_gm_command", Message.edit_gm_command)
    Message.register_net_handle(opcodes.SMSG_ERROR, Message.SMSG_ERROR)
    Message.register_net_handle(opcodes.SMSG_HEART_BEAT, Message.SMSG_HEART_BEAT)
    Message.register_net_handle(opcodes.SMSG_GM_COMMAND, Message.SMSG_GM_COMMAND)
    Message.register_net_handle(opcodes.SMSG_MISSION_EX_MEET, Message.SMSG_MISSION_EX_MEET)
    Message.register_net_handle(opcodes.SMSG_CHECK_DATA, Message.SMSG_CHECK_DATA)
    Message.register_net_handle(opcodes.SMSG_REFRESH_PLAYER, Message.SMSG_REFRESH_PLAYER)
    Message.register_net_handle(opcodes.SMSG_MAIL_UPDATE, Message.SMSG_MAIL_UPDATE)
    Message.register_handle("check_power", Message.CheckPower)
end

function Message.Finish()
    timerMgr:RemoveRepeatTimer("Message")
    Message.remove_handle("edit_gm_command", Message.edit_gm_command)
    Message.remove_net_handle(opcodes.SMSG_ERROR, Message.SMSG_ERROR)
    Message.remove_net_handle(opcodes.SMSG_HEART_BEAT, Message.SMSG_HEART_BEAT)
    Message.remove_net_handle(opcodes.SMSG_GM_COMMAND, Message.SMSG_GM_COMMAND)
    Message.remove_net_handle(opcodes.SMSG_MISSION_EX_MEET, Message.SMSG_MISSION_EX_MEET)
    Message.remove_net_handle(opcodes.SMSG_CHECK_DATA, Message.SMSG_CHECK_DATA)
    Message.remove_net_handle(opcodes.SMSG_REFRESH_PLAYER, Message.SMSG_REFRESH_PLAYER)
    Message.remove_net_handle(opcodes.SMSG_MAIL_UPDATE, Message.SMSG_MAIL_UPDATE)
    Message.remove_handle("check_power", Message.CheckPower)
end

function Message.Update()
    if send_time_ > 0 then
        send_time_ = send_time_ - 1
        if send_time_ <= 0 then
            GameTcp.Disconnect()
        end
    end
end

function Message.CheckPower()
    local pw1 = PlayerData.cur_power
    local pw2 = PlayerData.get_fight_power()
    PlayerData.cur_power = PlayerData.get_fight_power()
    GUIRoot.ShowPanel("PowerChangePanel", {pw2 - pw1})
end

function Message.SMSG_ERROR(message)
    send_time_ = 0
    GUIRoot.ClosePanel("MaskPanel")
    cur_reopcode_ = {}

    local msg = player_msg_pb.smsg_error()
    msg:ParseFromString(message.luabuff)
    log("server error info:"..msg.text)
    local t_error = Config.get_config_value("t_error", tonumber(msg.code))
    if tonumber(msg.code) == errors.ERROR_CHECK_TIME then
        --踢人
        GameTcp.is_kicked = true
        return
    elseif tonumber(msg.code) == errors.ERROR_RECONNECTION then
        --重连有问题, 重新登陆
        GameTcp.re_connect_fail = true
        GameTcp.Disconnect()
        return
    end
    if t_error == nil then
        GUIRoot.ShowPanel("MessagePanel",  {'未知错误'})
    else
        GUIRoot.ShowPanel("MessagePanel", {t_error.code})
    end
end

function Message.register_net_handle(opcode, func)
    local name = tostring(opcode)
    if net_handles_[name] == nil then
        net_handles_[name] = { func }
    else
        table.insert(net_handles_[name], func)
    end
end

function Message.remove_net_handle(opcode, func)
    local name = tostring(opcode)
    if net_handles_[name] ~= nil then
        for i = 1, #net_handles_[name] do
            if (net_handles_[name][i] == func) then
                table.remove(net_handles_[name], i)
                break
            end
        end
    end
end

function Message.register_handle(name, func)
    if handles_[name] == nil then
        handles_[name] = { func }
    else
        table.insert(handles_[name], func)
    end
end

function Message.remove_handle(name, func)
    if handles_[name] ~= nil then
        for i = 1, #handles_[name] do
            if (handles_[name][i] == func) then
                table.remove(handles_[name], i)
                break
            end
        end
    end
end

function Message.OnMessage(message)
    local name = message.name
    if handles_[name] ~= nil then
        for i = 1, #handles_[name] do
            handles_[name][i](message)
        end
    end 
end

function Message.OnNetMessage(message)
    local opcode = message.opcode
    local name = tostring(opcode)
    for i = 1, #cur_reopcode_ do
        if cur_reopcode_[i] == opcode then
            GUIRoot.ClosePanel("MaskPanel")
            send_time_ = 0
            cur_reopcode_ = {}
            break
        end
    end
    if net_handles_[name] ~= nil then
        for i = 1, #net_handles_[name] do
            net_handles_[name][i](message)
        end
    end
end

function Message.edit_gm_command(message)
    local s = tostring(message.m_object[0])
    gm_command_text_ = s
    local msg = player_msg_pb.cmsg_gm_command()
    msg.text = s
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_GM_COMMAND, data)
end

function Message.OnMask(smsgs, text, time)
    cur_reopcode_ = smsgs
    send_time_ = time
    GUIRoot.ShowPanel("MaskPanel")
end

function Message.OnDisConnect()
    cur_reopcode_ = {}
    send_time_ = 0
    if GUIRoot.util_guis["MaskPanel"] ~= nil then
        GUIRoot.ClosePanel("MaskPanel")
    end
end

-----gm
function Message.SMSG_GM_COMMAND(message)
    local msg = player_msg_pb.smsg_gm_command()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets)
end

function Message.SMSG_MISSION_EX_MEET(message)
    local msg = mission_msg_pb.smsg_mission_ex_meet()
    msg:ParseFromString(message.luabuff)
    PlayerData.player.mission_ex_time = msg.mission_ex_time
    PlayerData.player.mission_ex = 1
    PlayerData.player.mission_ex_count = 0
end

function  Message.SMSG_CHECK_DATA(message)
    local msg = player_msg_pb.smsg_check_data()
    msg:ParseFromString(message.luabuff)
    if msg.check_data ~= GameSys.GetCheckData() then
        GUIRoot.ShowPanel("MessagePanel", {'数据不同步'})
    end
end

function  Message.SMSG_REFRESH_PLAYER(message)
    local msg = player_msg_pb.smsg_refresh_player()
    msg:ParseFromString(message.luabuff)
    if msg ~= nil then
        PlayerData.player_refresh(msg)
        AssetsChangeControl.OnSignChanged()
    end
end

function Message.SMSG_HEART_BEAT(message)
    local msg = common_msg_pb.cmsg_heart_beat()
    msg.time = timerMgr:now_string()
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_HEART_BEAT, data)
end

function Message.SMSG_MAIL_UPDATE(message)
    PlayerData.player.has_mail = 1
    AssetsChangeControl.OnMailChanged()
end
