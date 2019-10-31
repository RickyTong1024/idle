
QuestManger = {}
local quest_lines_
local daily_data_
local t_server_id_
function QuestManger.Init()
    QuestManger.RegisterMessage()
    QuestManger.GetQuestLines()
    UnlockManger.Init()
end

function QuestManger.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_TASK_RECEIVE, QuestManger.SMSG_TASK_RECEIVE)
    Message.register_net_handle(opcodes.SMSG_TASK_END, QuestManger.SMSG_TASK_END)
end

function QuestManger.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_MISSION, QuestManger.SMSG_MISSION)
    Message.remove_net_handle(opcodes.SMSG_TASK_END, QuestManger.SMSG_TASK_END)
end

function QuestManger.GetQuestLines()
    quest_lines_, daily_data_ = QuestManger.GetQusetConfig()
end

--获取未领取需要提示
function QuestManger.GetQuestWLQ()
    local t_quest_wlq = {}
    for _, v in pairs(Config.t_quest) do
        if v.type == 1 then
            if v.required == 1 and PlayerData.player.level >= v.required_param1 and not QuestManger.QuestisEnd(v.id) then
                if QuestManger.IsInTask(v.id) and v.tip ~= "" then
                    table.insert(t_quest_wlq, v)
                end
            elseif v.required == 2 and not QuestManger.QuestisEnd(v.id) and QuestManger.QuestisEnd(v.required_param2)  then
                if QuestManger.IsInTask(v.id) and v.tip ~= "" then
                    table.insert(t_quest_wlq, v)
                end
            elseif v.required == 3 and not QuestManger.QuestisEnd(v.id) and QuestManger.NeedOverCondition(v.required_param2) then
                if QuestManger.IsInTask(v.id) and v.tip ~= "" then
                    table.insert(t_quest_wlq, v)
                end
            end
        end
    end
    local sort_fun = function(a,b)
        return a.id < b.id
    end
    if #t_quest_wlq > 1 then
        table.sort(t_quest_wlq, sort_fun)
    end
    return t_quest_wlq
end

function QuestManger.IsInTask(quest_id)
    for i = 1, #PlayerData.player.tasks do
        if PlayerData.player.tasks[i] == quest_id then
            return false
        end
    end
    return true
end

-- 获取可以进行或者进行中的任务线
function QuestManger.GetQusetConfig()
    local t_quest = {}
    local t_daily = {}
    for _, v in pairs(Config.t_quest) do
        if v.required == 1 and PlayerData.player.level >= v.required_param1 and not QuestManger.QuestisEnd(v.id) then
            if v.type ~= 3 then
                table.insert(t_quest, v)
            else
                if QuestManger.GradeCon() == v.grade then
                    table.insert(t_daily, v)
                end
            end
        elseif v.required == 2 and not QuestManger.QuestisEnd(v.id) and QuestManger.QuestisEnd(v.required_param2)  then
            if v.type ~= 3 then
                table.insert(t_quest, v)
            else
                if QuestManger.GradeCon() == v.grade then
                    table.insert(t_daily, v)
                end
            end
        elseif v.required == 3 and not QuestManger.QuestisEnd(v.id) and QuestManger.NeedOverCondition(v.required_param2) then
            if QuestManger.IsInTask(v.id) then
                if v.type ~= 3 then
                    table.insert(t_quest, v)
                else
                    if PlayerData.player.map == v.map and v.map ~= 0 then
                        table.insert(t_daily, v)
                    end
                end
            end
        end
    end
    local sort_fun = function(a,b)
        return a.id < b.id
    end
    if #t_quest > 1 then
        table.sort(t_quest, sort_fun)
    end
    return t_quest, t_daily
end

QuestManger.t_quest_sub = {}
function QuestManger.GetQuestSub(quest_id)
    for i = #QuestManger.t_quest_sub, 1, -1 do
        table.remove(QuestManger.t_quest_sub, i)
    end
    for _,v in pairs(Config.t_quest_sub) do
        if v.quest == quest_id then
            table.insert(QuestManger.t_quest_sub, v)
        end
    end
    return QuestManger.t_quest_sub
end

function QuestManger.GradeCon()
    return math.floor(PlayerData.player.level / 10)
end

function QuestManger.QuestisEnd(quest_id)
    for i = 1, #PlayerData.player.task_ends do
        if quest_id == PlayerData.player.task_ends[i] then
            return true
        end
    end
    return false
end

function QuestManger.QuestSubisWc(quest_sub_id)
    for i = 1, #PlayerData.player.task_ids do
        if quest_sub_id == PlayerData.player.task_ids[i] and PlayerData.player.task_reaches[i] ~= -1 then
            return false
        end
    end
    return false
end

function QuestManger.TriggerQuest(npc_data, quest_sub_ids)
    if npc_data ~= nil then
        if #quest_sub_ids == 1 then
            QuestManger.DirClick(quest_sub_ids[1])
        else
            GUIRoot.ShowPanel("TalkPanel", {npc_data.director, {nil, nil, quest_sub_ids}, QuestManger.DailyShow(npc_data.id) and {
                function ()
                    GUIRoot.ShowPanel("TalkPanel", {30100000, { function (talk_data)
                        local temp = talk_data
                        local dic_id = temp.id
                        local dic_index = temp.index
                        local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
                        if t_director_.options[dic_index].type == 1 then
                            QuestManger.LqDaily(npc_id)
                        end
                    end}})
                end, "每日任务"} or nil})
        end
    end
end

function QuestManger.DailyShow(npc)
    local npc_daily = QuestManger.IsNpcDailyQuest(npc)
    local t_daily_num = Config.get_config_value("t_const", "quest_num").value
    return (PlayerData.player.task_num < t_daily_num and not QuestManger.HasDailyTask() and  #npc_daily > 0)
end

function QuestManger.QuestEnd(quest_sub_id)
    t_server_id_ = quest_sub_id
    local msg = promotion_msg_pb.cmsg_task_end()
    msg.task_id = t_server_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_TASK_END, data, {opcodes.SMSG_TASK_END},"获取任务")
end

function QuestManger.QuestReceive(quest_sub_id)
    t_server_id_ = quest_sub_id
    local msg = promotion_msg_pb.cmsg_task_receive()
    msg.task_id = t_server_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_TASK_RECEIVE, data, {opcodes.SMSG_TASK_RECEIVE},"获取任务")
end

function QuestManger.IsNpcQuestSub(npc_id)
    local all_quest2npc = {}
    for i = 1, #PlayerData.player.task_ids do
        local quest_sub_d = Config.get_config_value("t_quest_sub", PlayerData.player.task_ids[i])
        if quest_sub_d ~= nil then
            if quest_sub_d.npcid == npc_id and PlayerData.player.task_reaches[i] ~= -1 then
                if not GameSys.hasInTable(all_quest2npc, quest_sub_d.quest) then
                    table.insert(all_quest2npc, quest_sub_d.quest)
                end
            end
            if quest_sub_d.npcid == npc_id and PlayerData.player.task_reaches[i] ~= -1 then
                if not GameSys.hasInTable(all_quest2npc, quest_sub_d.quest) then
                    table.insert(all_quest2npc, quest_sub_d.quest)
                end
            end
        end
    end
    
    for i = 1, #quest_lines_ do
        if quest_lines_[i].npc_id == npc_id then
            if not GameSys.hasInTable(all_quest2npc, quest_lines_[i].id) and not QuestManger.QuestLinesLq(quest_lines_[i].id) then
                table.insert(all_quest2npc, quest_lines_[i].id)
            end
        end
    end

    return all_quest2npc
end

function QuestManger.IsNpcDailyQuest(npc_id)
    local all_daily2npc = {}
    for i = 1, #daily_data_ do
        if daily_data_[i].npc_id == npc_id then
            if not GameSys.hasInTable(all_daily2npc, daily_data_[i].id) then
                table.insert(all_daily2npc, daily_data_[i].id)
            end
        end
    end
    return all_daily2npc
end

function QuestManger.HasDailyTask()
    for i = 1, #PlayerData.player.tasks do
        local t_quest = Config.get_config_value("t_quest", PlayerData.player.tasks[i])
        if t_quest ~= nil then
            if t_quest.type == 3 then
                return true
            end
        else
            return false
        end
    end
    return false
end

function QuestManger.QuestLinesLq(quest_id)
    local quset_sub = QuestManger.GetQuestSub(quest_id)
    for k = 1, #quset_sub do
        if QuestManger.QuestIsInTask_Ids(quset_sub[k].id) then
            return true
        end
    end
    return false
end

function QuestManger.GetQuestDesc(quest_sub)
    local reaches = QuestManger.GetQuestSubReche(quest_sub.id)
    local desc = ""
    if quest_sub.event_type == 2 or quest_sub.event_type == 5 or quest_sub.event_type == 13 then
        if reaches ~= -1 then
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param2), reaches ,quest_sub.event_param2)
        else
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param2), quest_sub.event_param2 ,quest_sub.event_param2)
        end
    elseif quest_sub.event_type == 4 then
        if reaches ~= -1 then
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param3), GameSys.GetAssetCount(quest_sub.event_param1, quest_sub.event_param2) ,quest_sub.event_param3)
        else
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param3), quest_sub.event_param3 ,quest_sub.event_param3)
        end
    elseif quest_sub.event_type == 9 then
        if reaches ~= -1 then
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param1), PlayerData.player.level, quest_sub.event_param1)
        else
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param1), quest_sub.event_param1, quest_sub.event_param1)
        end
    elseif quest_sub.event_type == 10 then
        if reaches ~= -1 then
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param1), toInt(PlayerData.get_fight_power()), quest_sub.event_param1)
        else
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, quest_sub.event_param1), quest_sub.event_param1, quest_sub.event_param1)
        end
    elseif quest_sub.event_type == 12 then
        local need = QuestManger.Type12Quest(quest_sub.map)
        if reaches ~= -1 then
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, need), reaches , need)
        else
            desc = string.format("%s(%s/%s)", GameSys.TextDealPlaceholder(quest_sub.desc, need), need, need)
        end
    else
        desc = quest_sub.desc
    end
    return desc
end

function QuestManger.DirClick(quest_id)
    local quest = Config.get_config_value("t_quest", quest_id)
    local quest_lines = PlayerData.get_task_line(quest_id)
    if QuestManger.QuestLinesLq(quest_id) then
        local _, jc = QuestManger.GetQuestJc(quest_id)
        if jc.event_type == 3 then
            QuestManger.QuestEnd(jc.id)
        elseif jc.event_type == 4 or jc.event_type == 9 or jc.event_type == 10 then
            GUIRoot.ShowPanel("TalkPanel", {jc.event_param4, {function (talk_data)
                local temp = talk_data
                local dic_id = temp.id
                local dic_index = temp.index
                local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
                if t_director_.options[dic_index].type == 1 then
                    local wc = false
                    if jc.event_type == 4 then
                        wc = GameSys.GetAssetCount(jc.event_param1, jc.event_param2) >= jc.event_param3
                    elseif jc.event_type == 9 then
                        wc = PlayerData.player.level >= jc.event_param1
                    elseif jc.event_type == 10 then
                        wc = PlayerData.get_fight_power() >= jc.event_param1
                    end
                    if wc then
                        QuestManger.QuestEnd(jc.id)
                        if t_director_.options[dic_index].param1 ~= 0 then
                            GUIRoot.ShowPanel("TalkPanel",{t_director_.options[dic_index].param1, {}})
                        end
                    else
                        GUIRoot.ShowPanel("MessagePanel",{"不满足条件"})
                    end
                end
            end, nil, nil}})
        else
            GUIRoot.ShowPanel("TalkPanel", {jc.event_param1, {function (talk_data)
                local temp = talk_data
                local dic_id = temp.id
                local dic_index = temp.index
                local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
                if t_director_.options[dic_index].type == 1 then
                    QuestManger.QuestEnd(jc.id)
                end
            end}})
        end

    else
        GUIRoot.ShowPanel("TalkPanel", {quest.event, {function (talk_data)
            local temp = talk_data
            local dic_id = temp.id
            local dic_index = temp.index
            local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
            if t_director_.options[dic_index].type == 1 then
                QuestManger.QuestReceive(quest_lines[0])
            end
        end}})
    end
end

function QuestManger.NpcOnClick(npc_id)
    local quest_s_d = QuestManger.IsNpcQuestSub(npc_id)
    local npc_data = Config.get_config_value("t_npc", npc_id)
    if npc_data ~= nil then
        if #quest_s_d > 0 then
            QuestManger.TriggerQuest(npc_data, quest_s_d)
        else
            if QuestManger.DailyShow(npc_id) then
                GUIRoot.ShowPanel("TalkPanel", {30100000, { function (talk_data)
                    local temp = talk_data
                    local dic_id = temp.id
                    local dic_index = temp.index
                    local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
                    if t_director_.options[dic_index].type == 1 then
                        QuestManger.LqDaily(npc_data.id)
                    end
                end}})
            else
                GUIRoot.ShowPanel("TalkPanel", {npc_data.director, {}})
            end
        end
    else
        GUIRoot.ShowPanel("MessagePanel",{"对方并不想理你"})
    end
end

function QuestManger.LqDaily(npc_id)
    local npc_daily = QuestManger.IsNpcDailyQuest(npc_id)
    local index = math.random(#npc_daily)
    local id = npc_daily[index]
    local daily_line = PlayerData.get_task_line(id)
    QuestManger.QuestReceive(daily_line[0])
end

function QuestManger.GetQuestSubReche(sub_id)
    for j = 1, #PlayerData.player.task_ids do
        if sub_id == PlayerData.player.task_ids[j] then
            return PlayerData.player.task_reaches[j]
        end
    end
    return 0
end

function QuestManger.NpcHasQuest(npc_id)
    local cast = QuestManger.IsNpcQuestSub(npc_id)
    local quest_type = 2
    if #cast > 0 then
        for i = 1, #cast do
            local quest = Config.get_config_value("t_quest", cast[i])
            if quest ~= nil then
                if quest.type == 1 then
                    quest_type = 1
                    break
                end
            end
        end
        return true, quest_type
    else
        if QuestManger.DailyShow(npc_id) then
            return true, quest_type
        end
        return false, quest_type
    end
end

function QuestManger.HasQuestXy(params)
    local map_id = params[1]
    local x = params[2]
    local y = params[3]
    for j = 1, #PlayerData.player.task_ids do
        local quest_sub = Config.get_config_value("t_quest_sub", PlayerData.player.task_ids[j])
        if quest_sub ~= nil then
            if quest_sub.event_type == 3 and quest_sub.event_param1 == map_id and PlayerData.player.task_reaches[j] ~= -1 then
                local dis = (Vector3(x, y, 0) - Vector3(quest_sub.event_param2, quest_sub.event_param3 , 0)).magnitude
                if dis < 2 then
                    return true , quest_sub.quest
                end
            end
        end
    end
    return false, nil
end

function QuestManger.GetQuestJc(quest_id)
    local quest_sub_d = QuestManger.GetQuestSub(quest_id)
    for i = 1, #quest_sub_d do
        if not QuestManger.QuestSubExEnd(quest_sub_d[i].id)  then
            return true, quest_sub_d[i]
        end
    end

    for i = 1, #quest_sub_d do
        local cur_r_sub = quest_sub_d[i].id
        local pre_r_sub = quest_sub_d[i].pre_sub
        if not QuestManger.QuestIsInTask_Ids(cur_r_sub) and pre_r_sub == 0 then
            return true , quest_sub_d[i]
        end
    end
    return false, nil
end

----任务线 sub 是否完成
function QuestManger.QuestSubExEnd(sub_id)
    for j = 1, #PlayerData.player.task_ids do
        if sub_id == PlayerData.player.task_ids[j] and PlayerData.player.task_reaches[j] ~= -1 then
            return false
        end
    end
    return true
end

function QuestManger.QuestIsInTask_Ids(sub_id)
    for j = 1, #PlayerData.player.task_ids do
        if sub_id == PlayerData.player.task_ids[j] then
            return true
        end
    end
    return false
end

function QuestManger.Radio()
    local common_msg = CommonMessage()
    common_msg.name = "need_check_quest"
    messMgr:AddCommonMessage(common_msg)
    QuestManger.GetQuestLines()
end

function QuestManger.RadioUnlockQsub(quset_sub_id)
    local common_msg = CommonMessage()
    common_msg.m_object:Add(quset_sub_id)
    common_msg.m_object:Add(2)
    common_msg.name = "check_unlock_quest"
    messMgr:AddCommonMessage(common_msg)
end

function QuestManger.RadioHasQuest(quest_sub_id)
    local common_msg = CommonMessage()
    common_msg.m_object:Add(quest_sub_id)
    common_msg.m_object:Add(3)
    common_msg.name = "check_unlock_quest_get"
    messMgr:AddCommonMessage(common_msg)
end

function QuestManger.DungeonCheck(dungeon_id)
    for i = 1, #PlayerData.player.task_ids do
        if PlayerData.player.task_reaches[i] ~= -1 then
            local t_quest_sub = Config.get_config_value('t_quest_sub', PlayerData.player.task_ids[i])
            if t_quest_sub.event_type == 11 or t_quest_sub.event_type == 16 and dungeon_id == t_quest_sub.event_param1 then
                QuestManger.QuestEnd(PlayerData.player.task_ids[i])
            end
        end
    end
end

function QuestManger.GetQuestPlace(quest_sub_id)
    local quest_sub = Config.get_config_value("t_quest_sub", quest_sub_id)
    local map = Config.get_config_value("t_map", quest_sub.map)
    if map ~= nil then
        return map.name
    else
        return "unknown"
    end
end

function QuestManger.Type12Quest(map_id)
    local quest_mission_num = 0
    for _, v in pairs(Config.t_mission) do
        if v.chapter == map_id and v.type ==2 then
            quest_mission_num = quest_mission_num + 1
        end
    end
    return quest_mission_num
end

function QuestManger.NeedOverCondition(t_quest_sub_id)
    local t_quest_sub = Config.get_config_value("t_quest_sub", t_quest_sub_id)
    if t_quest_sub ~= nil then
        for i = 1, #PlayerData.player.task_ends do
            if t_quest_sub.quest == PlayerData.player.task_ends[i] then
                return true
            end
        end
        for i = 1, #PlayerData.player.task_ids do
            if t_quest_sub.id == PlayerData.player.task_ids[i] and PlayerData.player.task_reaches[i] == -1 then
                return true
            end
        end
    end
    return false
end

function QuestManger.NeedHasCondition(t_quest_sub_id)
    local t_quest_sub = Config.get_config_value("t_quest_sub", t_quest_sub_id)
    if t_quest_sub ~= nil then
        for i = 1, #PlayerData.player.task_ends do
            if t_quest_sub.quest == PlayerData.player.task_ends[i] then
                return true
            end
        end
        for i = 1, #PlayerData.player.task_ids do
            if t_quest_sub.id == PlayerData.player.task_ids[i] and PlayerData.player.task_reaches[i] ~= nil then
                return true
            end
        end
    end
    return false
end

function QuestManger.SMSG_TASK_RECEIVE(message)
    ---为提交的id t_server_id_
    local mark = false
    local t_quest_sub = Config.get_config_value('t_quest_sub', t_server_id_)
    table.insert(PlayerData.player.tasks, t_quest_sub.quest)
    table.insert(PlayerData.player.task_ids, t_server_id_)
    table.insert(PlayerData.player.task_reaches, 0)
    QuestManger.Radio()
    --QuestManger.RadioHasQuest(t_server_id_)
    local t_quest_sub = Config.get_config_value("t_quest_sub", t_server_id_)
    local t_quest = Config.get_config_value("t_quest", t_quest_sub.quest)
    if t_quest.type == 3 then
        GUIRoot.ShowPanel("TalkPanel", {t_quest.event, {}})
    end
    soundMgr:play_sound("reward")
end

function QuestManger.SMSG_TASK_END(message)
    ---为提交的id t_server_id_
    local msg = promotion_msg_pb.smsg_task_end()
    msg:ParseFromString(message.luabuff)
    local t_quest_sub = Config.get_config_value('t_quest_sub', t_server_id_)
    local t_quest = Config.get_config_value('t_quest', t_quest_sub.quest)
    local task_line = PlayerData.get_task_line(t_quest_sub.quest)
    QuestManger.RadioUnlockQsub(t_server_id_)
    if t_quest_sub.event_type == 4 then
        local asset = {
            type = t_quest_sub.event_param1,
            value1 = t_quest_sub.event_param2,
            value2 = t_quest_sub.event_param3,
            value3 = 0
        }
        PlayerData.remove_asset(asset)
    end
    if task_line[t_server_id_] == nil then
        if t_quest.type == 3 then
            PlayerData.player.task_num = PlayerData.player.task_num + 1
        end
        for i = 1, #PlayerData.player.tasks do
            if PlayerData.player.tasks[i] == t_quest_sub.quest then
                table.remove(PlayerData.player.tasks, i)
                break
            end
        end
        if t_quest.type ~= 3 then
            table.insert(PlayerData.player.task_ends, t_quest_sub.quest)
        end
        for i = #PlayerData.player.task_ids, 1, -1 do
            local quest_sub = Config.get_config_value('t_quest_sub', PlayerData.player.task_ids[i])
            if quest_sub.quest == t_quest_sub.quest then
                table.remove(PlayerData.player.task_ids, i)
                table.remove(PlayerData.player.task_reaches, i)
            end
        end
    else
        for i = 1, #PlayerData.player.task_ids do
            if PlayerData.player.task_ids[i] == t_server_id_ then
                PlayerData.player.task_reaches[i] = -1
                break
            end
        end
        table.insert(PlayerData.player.task_ids, task_line[t_server_id_])
        table.insert(PlayerData.player.task_reaches, 0)
        QuestManger.RadioHasQuest(task_line[t_server_id_])
    end
    if msg.map_id ~= 0 then
        PlayerData.player.map = msg.map_id
    end
    soundMgr:play_sound("reward")
    PlayerData.add_assets(msg.assets)


    QuestManger.Radio()
end