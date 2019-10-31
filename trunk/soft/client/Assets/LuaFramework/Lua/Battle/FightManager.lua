FightManger = {}

FightManger.fighter1 = nil
FightManger.fighter2 = nil

FightManger.fixed_time = 20
FightManger.auto = false
FightManger.mission_many_times = false

local fight_check_
local start_ = false
local time_ = 0
local prepare_time_ = 0
local end_time_ = 0
local max_fight_time_ = 0
local is_win_ = false
local is_runaway_ = false
local param_ = {}

function FightManger.Init()
    max_fight_time_ = Config.get_config_value('t_const', 'max_fight_time').value
    FixedUpdateBeat:Add(FightManger.FixedUpdateBeat, FightManger)
    FightManger.RegisterMessage()

    is_win_ = false
    is_runaway_ = false
end

function FightManger.Destroy()
    FightManger.mission_many_times = false
    FixedUpdateBeat:Remove(FightManger.FixedUpdateBeat, FightManger)
    FightManger.RemoveMessage()
end

function FightManger.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_MISSION, FightManger.SMSG_MISSION)
    Message.register_net_handle(opcodes.SMSG_MISSION_EX, FightManger.SMSG_MISSION_EX)
    Message.register_net_handle(opcodes.SMSG_TOWER, FightManger.SMSG_TOWER)
    Message.register_net_handle(opcodes.SMSG_ARENA_FIGHT, FightManger.SMSG_ARENA_FIGHT)
    Message.register_net_handle(opcodes.SMSG_DUNGEON_EVENT, FightManger.SMSG_DUNGEON_EVENT)
    Message.register_net_handle(opcodes.SMSG_DUNGEON_CLOSE, FightManger.SMSG_DUNGEON_CLOSE)
end

function FightManger.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_MISSION, FightManger.SMSG_MISSION)
    Message.remove_net_handle(opcodes.SMSG_MISSION_EX, FightManger.SMSG_MISSION_EX)
    Message.remove_net_handle(opcodes.SMSG_TOWER, FightManger.SMSG_TOWER)
    Message.remove_net_handle(opcodes.SMSG_ARENA_FIGHT, FightManger.SMSG_ARENA_FIGHT)
    Message.remove_net_handle(opcodes.SMSG_DUNGEON_EVENT, FightManger.SMSG_DUNGEON_EVENT)
    Message.remove_net_handle(opcodes.SMSG_DUNGEON_CLOSE, FightManger.SMSG_DUNGEON_CLOSE)
end

function FightManger.Mission(mission_id, need_init)
    if need_init == nil then
        FightManger.Init()
    end
	FightManger.Clear()
    if FightManger.auto then
        table.insert(param_, { time_, 1, 1 })
    else
        table.insert(param_, { time_, 1, 0 })
    end
    local t_mission = Config.get_config_value("t_mission", mission_id)
    local t_monster = Config.get_config_value("t_monster", t_mission.monsterid)
    local t_role = Config.get_config_value("t_role", t_monster.role_id)
    FightManger.fighter1 = FightPlayer.CreatePlayer(PlayerData.player, 0)
    FightManger.fighter2 = FightPlayer.CreateMonster(t_monster, 1, t_mission.diff, 0)
    Battle.InitShow()
    if t_mission.dialog > 99999 and not FightManger.mission_many_times then
        GUIRoot.ShowPanel("TalkPanel", { t_mission.dialog, {function(talk_data)
            local temp = talk_data
            local dic_id = temp.id
            local dic_index = temp.index
            local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
            if t_director_.options[dic_index].type == 1 then
                FightManger.Start()
            else
                FightManger.Destroy()
                Battle.LeaveBattleByGiveUp()
            end
        end, nil, nil, t_role.id}, t_mission.diff < 4 and {
            function ()
                FightManger.mission_many_times = true
                FightManger.Start()
        end, "连续挑战"} or nil
        })
    else
        FightManger.Start()
    end
end

function FightManger.MissionEX(need_init)
    if need_init == nil then
        FightManger.Init()
    end
	FightManger.Clear()
    local t_mission = Config.get_config_value("t_mission", Battle.mission_ex_params.mission_id)
    local t_monster = Config.get_config_value("t_monster", t_mission.monsterid)
    FightManger.fighter1 = FightPlayer.CreatePlayer(PlayerData.player, 0)
    FightManger.fighter2 = FightPlayer.CreateMonster(t_monster, 1, 1, 0)
    Battle.InitShow()
    FightManger.Start()
end

function FightManger.Tower()
    FightManger.Init()
	FightManger.Clear()
    local t_tower = Config.get_config_value("t_tower", Battle.tower_params.stair)
    local t_monster = Config.get_config_value("t_monster", t_tower.monster)
    FightManger.fighter1 = FightPlayer.CreatePlayer(PlayerData.player, 0)
    FightManger.fighter2 = FightPlayer.CreateMonster(t_monster, 1, 1, 0)
    Battle.InitShow()
    FightManger.Start()
end

function FightManger.Arena(rank, target_msg)
    FightManger.Init()
    FightManger.Clear()
    FightManger.fighter1 = FightPlayer.CreatePlayer(PlayerData.player, 0)
    local arena_player = FightPlayer.Change(target_msg)
    FightManger.fighter2 = FightPlayer.CreateArenaPlayer(arena_player, 1)
    Battle.InitShow()
    FightManger.Start()
end

function FightManger.Dungeon(dungeon_id, dungeon_event, init)
    if init then
        FightManger.Init()
    end
    local t_dungeon_event = Config.get_config_value("t_dungeon_event", dungeon_event)
    local index = -1
    for i = 1, #PlayerData.player.dungeons do
        if PlayerData.player.dungeons[i] == dungeon_id then
            index = i
        end
    end
    FightManger.fighter1 = FightPlayer.CreatePlayer(PlayerData.player, 0)
    local role_id = -1
    local t_monster = Config.get_config_value("t_monster", t_dungeon_event.monster)
    role_id = Config.get_config_value("t_role", t_monster.role_id).id
    FightManger.fighter2 = FightPlayer.CreateMonster(t_monster, 1,1, t_dungeon_event.passive)
    Battle.InitShow()
    BattlePanel.ShowTipTitle(string.format("第%s层", PlayerData.player.dungeon_cengs[index]))
    FightManger.DungeonTrigger(dungeon_id, dungeon_event, role_id)
end

function FightManger.DungeonTrigger(dungeon_id, dungeon_event_id, role_id)
	FightManger.Clear()
    local dungeon_event_data = Config.get_config_value("t_dungeon_event", dungeon_event_id)
    local dungeon_dialog = Config.get_config_value("t_dungeon_dialog", dungeon_event_data.dialog)
    local index = math.random(#dungeon_dialog.dialog)
    local dir = dungeon_dialog.dialog[index].id
    GUIRoot.ShowPanel("TalkPanel", { dir, {function(talk_data)
        local temp = talk_data
        local dic_id = temp.id
        local dic_index = temp.index
        local t_director_ = Config.get_config_value("t_director", tonumber(dic_id))
        if t_director_.options[dic_index].type == 1 then
            FightManger.Start()
        elseif t_director_.options[dic_index].type == 2 then
            FightManger.Destroy()
            Battle.LeaveBattleByGiveUp()
        elseif t_director_.options[dic_index].type == 3 then
            FightManger.ShowDungeonReward()
        elseif t_director_.options[dic_index].type == 4 then
            GUIRoot.ShowPanel("SelectPanel", { "关闭副本将获取当前奖励,并且清空进度,是否关闭", function()
                is_win_ = true
                local msg = mission_msg_pb.cmsg_dungeon_close()
                msg.dungeon_id = dungeon_id
                local data = msg:SerializeToString()
                GameTcp.Send(opcodes.CMSG_DUNGEON_CLOSE, data, { opcodes.SMSG_DUNGEON_CLOSE })
            end, nil, "" })
        end
    end, nil, nil, role_id }})
end

function FightManger.Clear()
    prepare_time_ = 500
    time_ = 0
    end_time_ = 0
end

function FightManger.Start()
    FightManger.fighter1:SetTarget(FightManger.fighter2)
    FightManger.fighter1.unit:ShowBehaviour("ready")
    FightManger.fighter2:SetTarget(FightManger.fighter1)
    start_ = true
end

function FightManger.End(win)
    start_ = false
    is_win_ = win
    end_time_ = 1400
    Battle.TimerEnd()
end

function FightManger.RunAwaySuccess()
    start_ = false
    end_time_ = 1400
    is_runaway_ = true
end

--断线处理
function FightManger.GameDisConnect()
    if FightManger.fighter1 ~= nil then
        FightManger.fighter1:Destroy()
        FightManger.fighter1 = nil
    end
    if FightManger.fighter2 ~= nil then
        FightManger.fighter2:Destroy()
        FightManger.fighter2 = nil
    end
    FightManger.Destroy()
    start_ = false
    prepare_time_ = 500
    time_ = 0
    end_time_ = 0
end

function FightManger.SendEnd()
    if is_runaway_ then
        FightManger.Destroy()
        Battle.LeaveBattleByRunAway()
        return
    end
    if Battle.cur_type == Battle.BATTLE_TYPE.mission then
        local t_mission = Config.get_config_value('t_mission', Battle.mission_params.mission_id)
        local t_monster = Config.get_config_value('t_monster', t_mission.monsterid)
        local msg = mission_msg_pb.cmsg_mission()
        msg.mission_id = Battle.mission_params.mission_id
        for i = 1, #param_ do
            local fight_msg = mission_msg_pb.fight_param()
            fight_msg.time = param_[i][1]
            fight_msg.type = param_[i][2]
            fight_msg.param = param_[i][3]
            table.insert(msg.check_param, fight_msg)
        end
        param_ = {}
        if is_win_ then
            if not GameSys.hasInTable(PlayerData.player.monsters, t_monster.role_id) then
                fight_check_ = 1
            else
                fight_check_ = 0
            end
        else
            fight_check_ = 2
        end
        msg.fight_check = fight_check_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_MISSION, data, { opcodes.SMSG_MISSION })
    elseif Battle.cur_type == Battle.BATTLE_TYPE.mission_ex then
        if is_win_ then
            fight_check_ = 1
            local msg = mission_msg_pb.cmsg_mission_ex()
            msg.mission_id = Battle.mission_ex_params.mission_id
            msg.fight_check = fight_check_
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_MISSION_EX, data, { opcodes.SMSG_MISSION_EX })
        else
            fight_check_ = 2
            FightManger.ShowResult(nil, false)
        end
    elseif Battle.cur_type == Battle.BATTLE_TYPE.tower then
        if is_win_ then
            local msg = mission_msg_pb.cmsg_tower()
            msg.tower_stair = Battle.tower_params.stair
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_TOWER, data, { opcodes.SMSG_TOWER })
        else
            FightManger.ShowResult(nil, false)
        end
    elseif Battle.cur_type == Battle.BATTLE_TYPE.esport then
        local msg = arena_msg_pb.cmsg_arena_fight()
        msg.arena_rank = Battle.esport_params.target_rank
        msg.win = is_win_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_ARENA_FIGHT, data, { opcodes.SMSG_ARENA_FIGHT })
    elseif Battle.cur_type == Battle.BATTLE_TYPE.dungeon then
        if is_win_ then
            local msg = mission_msg_pb.cmsg_dungeon_event()
            msg.dungeon_id = Battle.dungeon_params.dungeon_id
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_DUNGEON_EVENT, data, { opcodes.SMSG_DUNGEON_EVENT })
        else
            FightManger.ShowResult(nil, false)
        end
    end
end

function FightManger.SMSG_MISSION(message)
    local msg = mission_msg_pb.smsg_mission()
    msg:ParseFromString(message.luabuff)
    ---在这里  同步数据
    if fight_check_ ~= 2 then
        local assets = msg.assets
        local t_mission = Config.get_config_value('t_mission', Battle.mission_params.mission_id)
        PlayerData.add_assets(assets)
        PlayerData.task_reached(t_mission, msg.count)
        Battle.SetTaskBattle(next(msg.count) ~= nil, msg.count) --是不是 任务战斗
        LRandom.Seed(PlayerData.player.seed)

        if t_mission.type == 2 then
            local mark = false
            for i = 1, #PlayerData.player.mission do
                if PlayerData.player.mission[i] == t_mission.id then
                    PlayerData.player.mission_time[i] = msg.time
                    mark = true
                    break
                end
            end
            if not mark then
                table.insert(PlayerData.player.mission, t_mission.id)
                table.insert(PlayerData.player.mission_time, msg.time)
            end
            PlayerData.make_monsters_set(t_mission.id)
        end
        if PlayerData.player.mission_ex == 0 then
            PlayerData.player.mission_ex_count = PlayerData.player.mission_ex_count + 1
        end
        if FightManger.mission_many_times then
            Battle.MissionRoundEnd(assets, { Battle.mission_params.mission_id, false })
        else
            FightManger.ShowResult(assets, true)
        end

        -- 每日任务
        if t_mission.diff == 1 then
            PlayerData.daily_schedule(1009, 1)
            AssetsChangeControl.OnDailyChanged()
        elseif t_mission.diff == 4 then
            PlayerData.daily_schedule(1010, 1)
            AssetsChangeControl.OnDailyChanged()
        elseif t_mission.diff == 5 then
            PlayerData.daily_schedule(1011, 1)
            AssetsChangeControl.OnDailyChanged()
        end
            
    else
        local exp = PlayerData.ReduceExp()
        FightManger.ShowResult(nil, false, exp)
    end
    PlayerData.player.seed = msg.seed
end

function FightManger.ShowDungeonReward()
    for i = 1, #PlayerData.player.dungeons do
        if PlayerData.player.dungeons[i] == Battle.dungeon_params.dungeon_id then
            local assets = common_msg_pb.msg_assets()
            assets:ParseFromString(PlayerData.player.dungeon_assets[i])
            GUIRoot.ShowPanel("ShowAssetPanel", { assets })
            break
        end
    end
end

function FightManger.SMSG_MISSION_EX(message)
    local msg = mission_msg_pb.smsg_mission_ex()
    msg:ParseFromString(message.luabuff)

    local assets = msg.assets
    local t_mission = Config.get_config_value('t_mission', Battle.mission_ex_params.mission_id)
    local t_level = Config.get_config_value('t_level', PlayerData.player.level)
    if fight_check_ ~= 2 then
        PlayerData.add_assets(assets)
    else
        local exp = PlayerData.ReduceExp()
        FightManger.ShowResult(nil, false, exp)
    end
    PlayerData.player.mission_ex = 0
    PlayerData.player.mission_ex_time = msg.time
    PlayerData.player.seed = msg.seed
    LRandom.Seed(PlayerData.player.seed)
    if FightManger.mission_many_times then
        Battle.ChangeBattleType(Battle.BATTLE_TYPE.mission, {Battle.mission_params.mission_id})
        Battle.MissionRoundEnd(assets, { Battle.mission_params.mission_id, false })
    else
        FightManger.ShowResult(assets, true)
    end
end

function FightManger.SMSG_TOWER(message)
    local msg = mission_msg_pb.smsg_tower()
    msg:ParseFromString(message.luabuff)
    local t_tower = Config.get_config_value("t_tower", Battle.tower_params.stair)
    if t_tower ~= nil then
        PlayerData.player.tower = Battle.tower_params.stair
    end
    -- local t_monster = Config.get_config_value('t_monster', t_tower.monster)
    local assets = msg.assets
    PlayerData.add_assets(assets)
    PlayerData.player.seed = msg.seed
    LRandom.Seed(PlayerData.player.seed)
    -- PlayerData.task_operation(14) --龙之塔任务
    PlayerData.task_reached_other(14)
    FightManger.ShowResult(assets, false)
end

function FightManger.SMSG_ARENA_FIGHT(message)
    local msg = arena_msg_pb.smsg_arena_fight()
    msg:ParseFromString(message.luabuff)
    if is_win_ then
        PlayerData.player.arena_win = PlayerData.player.arena_win + 1
        if target_arena_rank_ < PlayerData.player.arena_highest then
            PlayerData.player.arena_highest = Battle.esport_params.target_rank
        end
        PlayerData.add_assets(msg.assets)
    end
    PlayerData.player.arena_num = PlayerData.player.arena_num + 1
    PlayerData.player.arena_rank = PlayerData.player.arena_rank - 1
    PlayerData.player.seed = msg.seed
    LRandom.Seed(PlayerData.player.seed)
    -- PlayerData.task_operation(15) --竞技场任务
    PlayerData.task_reached_other(15)
    FightManger.ShowResult(msg.assets, false)
end

function FightManger.SMSG_DUNGEON_EVENT(message)
    local msg = mission_msg_pb.smsg_dungeon_event()
    msg:ParseFromString(message.luabuff)
    local event_assets = msg.dungeon_assets
    local index = -1
    for i = 1, #PlayerData.player.dungeons do
        if PlayerData.player.dungeons[i] == Battle.dungeon_params.dungeon_id then
            index = i
            break
        end
    end
    local t_dungeon = Config.get_config_value('t_dungeon', Battle.dungeon_params.dungeon_id)

    PlayerData.player.seed = msg.seed

    if PlayerData.player.dungeon_cengs[index] == #t_dungeon.ceng then
        PlayerData.player.dungeon_tags[index] = 1
        QuestManger.DungeonCheck(Battle.dungeon_params.dungeon_id)
        local assets = common_msg_pb.msg_assets()
        assets:ParseFromString(msg.assets)
        PlayerData.add_assets(assets)
        if t_dungeon.type == 1 then
            PlayerData.task_reached_other(11, PlayerData.player.dungeons[index])
        elseif t_dungeon.type == 2 then
            PlayerData.task_reached_other(16, PlayerData.player.dungeons[index])
        end
        Battle.DungeonRoundEnd(assets, {true, index})
        FightManger.Destroy()
    else
        PlayerData.player.dungeon_assets[index] = msg.assets
        PlayerData.player.dungeon_cengs[index] = PlayerData.player.dungeon_cengs[index] + 1
        PlayerData.player.dungeon_events[index] = msg.event
        local assets = common_msg_pb.msg_assets()
        assets:ParseFromString(event_assets)
        Battle.DungeonRoundEnd(assets, { false, Battle.dungeon_params.dungeon_id, msg.event, false })
    end
end

function FightManger.SMSG_DUNGEON_CLOSE(message)
    local index = -1
    for i = 1, #PlayerData.player.dungeons do
        if PlayerData.player.dungeons[i] == Battle.dungeon_params.dungeon_id then
            index = i
            break
        end
    end

    local assets = common_msg_pb.msg_assets()
    assets:ParseFromString(PlayerData.player.dungeon_assets[index])
    PlayerData.add_assets(assets)
    PlayerData.player.dungeon_tags[index] = 1
    FightManger.ShowResult(assets, false)
    local common_msg = CommonMessage()
    common_msg.name = "close_dungeon"
    messMgr:AddCommonMessage(common_msg)
end

function FightManger.ShowResult(assets, need_drop, reduce_exp)
    FightManger.Destroy()
    if is_win_ then
        Battle.ShowWinResult(assets, need_drop)
    else
        if reduce_exp == nil then
            reduce_exp = 0
        end
        Battle.ShowLoseResult(reduce_exp)
    end
end

-- 逃跑
function FightManger.RunAway()
    if prepare_time_ > 0 then
        return
    end
    FightManger.fighter1:ReleaseSpell(9999)
    table.insert(param_, { time_, 3, 0 })
end

function FightManger.GetContinueReleaseSpell(spell_id)
    if FightManger.fighter1 ~= nil then
        return FightManger.fighter1:GetContinueReleaseSpell(spell_id)
    end
end

function FightManger.GetSpellCd(spell_id)
    if FightManger.fighter1 ~= nil then
        local spell_cd = FightManger.fighter1.spell_cd[spell_id]
        if spell_cd == nil then
            return 0
        else
            spell_cd = spell_cd - time_
            return spell_cd / 1000
        end
    end
end

function FightManger.GetPlayerSp()
    if FightManger.fighter1 ~= nil then
        return FightManger.fighter1.sp
    end
end

-- 开/关 自动战斗
function FightManger.SwitchAutoFight(auto)
    FightManger.auto = auto
    local save = FightManger.auto and 1 or 0
    PlayerPrefs.SetInt("auto_battle", save)
    PlayerPrefs.Save()
    if auto then
        table.insert(param_, { time_, 1, 1 })
    else
        table.insert(param_, { time_, 1, 0 })
    end
end

function FightManger.nowtime()
    return time_
end

function FightManger.ReleaseSpell(spell_id)
    if prepare_time_ > 0 then
        return false
    end
    if FightManger.fighter1 ~= nil then
        local result = FightManger.fighter1:ReleaseSpell(spell_id)
        table.insert(param_, { time_, 2, spell_id })
        return result
    end
end

function FightManger.FixedUpdateBeat()
    if not start_ then
        if end_time_ > 0 then
            end_time_ = end_time_ - FightManger.fixed_time
            if end_time_ <= 0 then
                FightManger.fighter1:Destroy()
                FightManger.fighter1 = nil
                FightManger.fighter2:Destroy()
                FightManger.fighter2 = nil
                FightManger.SendEnd()
            end
        end
        return
    end
    if prepare_time_ > 0 then
        prepare_time_ = prepare_time_ - FightManger.fixed_time
        return
    end

    Battle.Timer(max_fight_time_)

    if FightManger.auto then
        FightManger.fighter1.ai:AutoFight()
    end
    FightManger.fighter2.ai:AutoFight()

    FightManger.fighter1:Update()
    FightManger.fighter2:Update()

    --如果结束
    if FightManger.fighter1:IsDie() then
        -- 表现死亡
        FightManger.fighter1.unit:Die()
        FightManger.End(false)
    elseif FightManger.fighter2:IsDie() then
        -- 表现死亡
        FightManger.fighter2.unit:Die()
        FightManger.End(true)
    elseif time_ > max_fight_time_ then
        FightManger.fighter1.unit:OverTime()
        FightManger.fighter2.unit:OverTime()
        FightManger.End(false)
    end
    time_ = time_ + FightManger.fixed_time
end

