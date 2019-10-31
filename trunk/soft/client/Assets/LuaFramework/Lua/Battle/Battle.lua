Battle = {}

Battle.BATTLE_TYPE = {
    mission = 1,
    mission_ex = 2,
    tower = 3,
    esport = 4,
    dungeon = 5
}

Battle.END_TYPE = {
    normal = 1,
    run_away = 2,
    give_up = 3,
    dis_connect = 4,

}

Battle.cur_type = 1
Battle.common_behaviour_list = nil
Battle.common_effect_points = nil
Battle.units = {}

Battle.mission_params = nil
Battle.mission_ex_params = nil
Battle.tower_params = nil
Battle.esport_params = nil
Battle.dungeon_params = nil

local had_task_
local task_ids_
local back_state_
local back_params_

---进入战斗状态 没有开打(由FighterManager控制战斗过程)
function Battle.GoBattle(battle_type, battle_params, back_state, back_params)
    back_state_ = back_state
    back_params_ = back_params
    Battle.common_behaviour_list = Battle.GetBehaviours("unit_common")
    Battle.common_effect_points = Battle.GetUnitEffectPoint("unit_common")
    if not PlayerPrefs.HasKey("auto_battle") then
        FightManger.auto = false
    else
        local save = PlayerPrefs.GetInt("auto_battle")
        FightManger.auto = (save == 1) and true or false
    end

    Battle.ChangeBattleType(battle_type, battle_params)
    State.ChangeState(State.state.ss_battle)

    Message.register_handle("level_up", Battle.UnitLevelUp)

    local msg = CommonMessage()
    msg.name = "battle_start"
    messMgr:AddCommonMessage(msg)
end

---切换战斗的类型
function Battle.ChangeBattleType(battle_type, battle_params)
    Battle.cur_type = battle_type
    if Battle.cur_type == Battle.BATTLE_TYPE.mission then
        if Battle.mission_params == nil then
            Battle.mission_params = {
                ["mission_id"] = 0
            }
        end
        Battle.mission_params.mission_id =  battle_params[1]
    elseif Battle.cur_type == Battle.BATTLE_TYPE.mission_ex then
        if Battle.mission_ex_params == nil then
            Battle.mission_ex_params = {
                ["mission_id"] = 0
            }
        end
        local t_qy_id = Config.get_config_value("t_const", "qiyu_mission")
        Battle.mission_ex_params.mission_id =  t_qy_id.value
    elseif Battle.cur_type == Battle.BATTLE_TYPE.tower then
        if Battle.tower_params == nil then
            Battle.tower_params = {
                ["stair"] = 0
            }
        end
        Battle.tower_params.stair = battle_params[1]
    elseif Battle.cur_type == Battle.BATTLE_TYPE.esport then
        if Battle.esport_params == nil then
            Battle.esport_params = {
                ["target_rank"] = 0,
                ["target_msg"] = nil
            }
        end
        Battle.esport_params.target_rank = battle_params[1]
        Battle.esport_params.target_msg = battle_params[2]
    elseif Battle.cur_type == Battle.BATTLE_TYPE.dungeon then
        if Battle.dungeon_params == nil then
            Battle.dungeon_params = {
                ["dungeon_id"] = 0,
                ["dungeon_event_id"] = nil
            }
        end
        Battle.dungeon_params.dungeon_id = battle_params[1][1]
        Battle.dungeon_params.dungeon_event_id = battle_params[1][2]
    end
end

---展示初始化
function Battle.InitShow()
    for _, unit in pairs(Battle.units) do
        unit:InitSiteShow()
    end
end

---设置这场战斗是否是任务战斗
function Battle.SetTaskBattle(is_task, ids)
    had_task_ = is_task
    task_ids_ = ids
end

---是否是任务战斗
function Battle.IsTaskBattle()
    return (Battle.cur_type == Battle.BATTLE_TYPE.mission and had_task_) , task_ids_
end

---是否是副本战斗
function Battle.IsDungeonBattel()
    return (Battle.cur_type == Battle.BATTLE_TYPE.dungeon)
end

---展示副本一关的结果
function Battle.DungeonRoundEnd(assets, next_param)
    BattlePanel.ShowRoundDrop(assets)
    Battle.next_dungeon_param = next_param
end

---进入下一轮副本
function Battle.GoDungeonNextRound()
    if Battle.next_dungeon_param == nil then
        return
    end
    local is_last = Battle.next_dungeon_param[1]
    if not is_last then
        GUIRoot.ShowPanel("LoadingPixelPanel", { function(param)
            FightManger.Dungeon(param[2], param[3], param[4])
        end, Battle.next_dungeon_param })
    else
        local index = Battle.next_dungeon_param[2]
        local assets = common_msg_pb.msg_assets()
        assets:ParseFromString(PlayerData.player.dungeon_assets[index])
        Battle.ShowWinResult(assets, false)
    end
end

---连续战斗中一轮结束
function Battle.MissionRoundEnd(assets, next_param)
    BattlePanel.ShowMissionDrop(assets)
    Battle.next_mission_param = next_param
end

---连续战斗 进入下一轮
function Battle.GoMissionNextRound()
    if Battle.next_mission_param == nil then
        return
    end
    GUIRoot.ShowPanel("LoadingPixelPanel", { function(param)
        FightManger.Mission(param[1], param[2])
    end, Battle.next_mission_param })
end

---整场战斗结束 展示胜利
function Battle.ShowWinResult(assets, need_drop)
    if need_drop then
        BattlePanel.ShowBattleDrop(assets)
    else
        BattlePanel.ShowWinPanel(assets)
    end
end

---整场战斗结束 展示失败
function Battle.ShowLoseResult(reduce_exp)
    local content = "Exp -"..GameSys.unit_conversion(reduce_exp)
    content = GameSys.SetTextColor("#FF0026", content)
    BattlePanel.FlowText("flow_text", 0, content)
    timerMgr:AddTimer("ShowLosePanel", BattlePanel.ShowLosePanel, 1)
end

---正常离开 离开战斗状态
function Battle.LeaveBattle(win)
    Battle.Clear()
    if win then
        State.ChangeState(back_state_, back_params_)
    end
    Battle.SendEndMessage(Battle.END_TYPE.normal, win)
end

---逃跑离开 离开战斗状态
function Battle.LeaveBattleByRunAway()
    Battle.Clear()
    State.ChangeState(back_state_, back_params_)
    Battle.SendEndMessage(Battle.END_TYPE.run_away, false)
end

---放弃离开 离开战斗状态
function Battle.LeaveBattleByGiveUp()
    Battle.Clear()
    State.ChangeState(back_state_, back_params_)
    Battle.SendEndMessage(Battle.END_TYPE.give_up, false)
end

---短线后重连离开 离开战斗状态
function Battle.LevelBattleByReConnect()
    Battle.Clear()
    State.ChangeState(back_state_, back_params_)
    Battle.SendEndMessage(Battle.END_TYPE.dis_connect, false)
end

---清理战斗数据
function Battle.Clear()
    for site in pairs(Battle.units) do
        Battle.units[site]:Destroy()
        Battle.units[site] = nil
    end
    Battle.units = {}
    Battle.common_behaviour_list = nil
    Battle.common_effect_points = nil
    Battle.mission_params = nil
    Battle.mission_ex_params = nil
    Battle.tower_params = nil
    Battle.esport_params = nil
    Battle.dungeon_params = nil

    Message.remove_handle("level_up", Battle.UnitLevelUp)
end

---发送战斗结束消息
function Battle.SendEndMessage(end_type, win)
    local msg = CommonMessage()
    msg.name = "battle_end"
    msg.m_object:Add(end_type)
    msg.m_object:Add(win)
    messMgr:AddCommonMessage(msg)
end

---接受玩家升级消息
function Battle.UnitLevelUp(messagee)
    Battle.units[0]:LevelUp()
end

---计时
function Battle.Timer(max_time)
    local sub_time = max_time - FightManger.nowtime()
    BattlePanel.Timer(sub_time / 1000)
end

---计时结束
function Battle.TimerEnd()
    BattlePanel.TimerEnd()
end

----------------------------------------------工具-------------------------------------------------------

---取得行为xml
function Battle.GetBehaviours(xml_name)
    local be_tables = {}
    local xml = resMgr.LoadUnitXml(xml_name)
    if xml == nil then
        return be_tables
    end
    local x_doc = Util.GetXDocument(xml)
    local root = Util.GetXElement(x_doc, "unit")
    local behaviours = Util.GetXElementList(root, "behaviour")
    local behaviour_count = behaviours.Count
    for i = 0, behaviour_count - 1 do
        local behaviour = behaviours[i]
        local behaviour_name = Util.GetXAttribute(behaviour, "name").Value
        be_tables[behaviour_name] = {
            ["name"] = behaviour_name,
            ["action_list"] = {}
        }
        local actions = Util.GetXElementList(behaviour, "action")
        local action_count = actions.Count
        local ac_tables = {}
        for j = 0, action_count - 1 do
            local action = actions[j]
            local ac_table = {
                ["time"] = 0,
                ["type"] = "",
                ["num_list"] = {},
                ["string_list"] = {}
            }
            local action_time = Util.GetXAttribute(action, "time")
            if action_time ~= nil then
                ac_table["time"] = tonumber(action_time.Value)
            end
            local action_type = Util.GetXAttribute(action, "type")
            if action_type ~= nil then
                ac_table["type"] = action_type.Value
            end
            if ac_table["type"] ~= nil then
                local type_name = ac_table["type"]
                if type_name == "effect" or type_name == "attack_effect" then
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "name").Value)
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "point").Value)
                    table.insert(ac_table["num_list"], Util.GetXAttribute(action, "x").Value)
                    table.insert(ac_table["num_list"], Util.GetXAttribute(action, "y").Value)
                    table.insert(ac_table["num_list"], Util.GetXAttribute(action, "z").Value)
                    table.insert(ac_table["num_list"], tonumber(Util.GetXAttribute(action, "remove_time").Value))
                elseif type_name == "remove_effect" or type_name == "remove_attach_name" then
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "name").Value)
                elseif type_name == "attack_anim" then
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "name").Value)
                elseif type_name == "anim" then
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "name").Value)
                elseif type_name == "set_active" then
                    table.insert(ac_table["num_list"], tonumber(Util.GetXAttribute(action, "active").Value))
                elseif type_name == "sound" then
                    table.insert(ac_table["string_list"], Util.GetXAttribute(action, "name").Value)
                elseif type_name == "rotate" then
                    table.insert(ac_table["num_list"], Util.GetXAttribute(action, "value").Value)
                elseif type_name == "move" then
                    table.insert(ac_table["num_list"], Util.GetXAttribute(action, "speed").Value)
				elseif type_name == "time_scale" then
					table.insert(ac_table["num_list"], Util.GetXAttribute(action, "scale").Value)
					table.insert(ac_table["num_list"], Util.GetXAttribute(action, "scale_time").Value)
                end
            end
            table.insert(ac_tables, ac_table)
        end
        be_tables[behaviour_name].action_list = ac_tables
    end
    return be_tables
end

---取得特效位置点xml
function Battle.GetUnitEffectPoint(xml_name)
    local points = {
        ["accept"] = nil,
        ["headtop"] = nil,
        ["foot"] = nil
    }
    local xml = resMgr.LoadUnitXml(xml_name)
    if xml == nil then
        return points
    end
    local x_doc = Util.GetXDocument(xml)
    local root = Util.GetXElement(x_doc, "unit")
    if root == nil then
        return points
    end
    local effect_points = Util.GetXElement(root, "effect_points")
    if effect_points == nil then
        return points
    end
    local accept_info = Util.GetXElement(effect_points, "accept")
    if accept_info ~= nil then
        local bone_name = Util.GetXAttribute(accept_info, "name").Value
        local offset_x = tonumber(Util.GetXAttribute(accept_info, "x").Value)
        local offset_y = tonumber(Util.GetXAttribute(accept_info, "y").Value)
        local offset_z = tonumber(Util.GetXAttribute(accept_info, "z").Value)
        points.accept = {
            ["name"] = bone_name,
            ["x"] = offset_x,
            ["y"] = offset_y,
            ["z"] = offset_z
        }
    end
    local headtop_info = Util.GetXElement(effect_points, "headtop")
    if headtop_info ~= nil then
        local bone_name = Util.GetXAttribute(headtop_info, "name").Value
        local offset_x = tonumber(Util.GetXAttribute(headtop_info, "x").Value)
        local offset_y = tonumber(Util.GetXAttribute(headtop_info, "y").Value)
        local offset_z = tonumber(Util.GetXAttribute(headtop_info, "z").Value)
        points.headtop = {
            ["name"] = bone_name,
            ["x"] = offset_x,
            ["y"] = offset_y,
            ["z"] = offset_z
        }
    end
    return points
end