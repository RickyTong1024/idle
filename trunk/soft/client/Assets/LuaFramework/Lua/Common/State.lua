State = {}

State.state = {
    ss_null = 1,
    ss_login = 2,
    ss_hall = 3,
    ss_map = 4,
    ss_battle = 5
}

State.cur_state = State.state.ss_null

function State.ChangeState(state, param)
    if state == State.state.ss_battle then
        GUIRoot.ShowPanel("LoadingPixelPanel", { State.Change, { state, param } })
    else
        GUIRoot.ShowPanel("LoadingPanel", { State.Change, { state, param } })
    end
end

function State.Change(params)
    local next_state = params[1]
    local param = params[2]
    State.LeaveState(State.cur_state, next_state)
    State.cur_state = next_state
    State.EnterState(State.cur_state, param)
end

--退出当前状态
function State.LeaveState(curState, nextState)
    if curState == State.state.ss_null then
        return
    elseif curState == State.state.ss_login then
        GUIRoot.ClosePanel("StartPanel")
    elseif curState == State.state.ss_hall then
        GUIRoot.ClosePanel("TopResPanel", false)
        GUIRoot.ClosePanel("HallPanel", nextState ~= State.state.ss_battle)
    elseif curState == State.state.ss_map then
        GUIRoot.ClosePanel("TopResPanel", false)
        GUIRoot.ClosePanel("MapPanel", nextState ~= State.state.ss_battle)
    elseif curState == State.state.ss_battle then
        Scene.Hide()
        GUIRoot.ClosePanel("BattlePanel")
        GUIRoot.ShowPanels("GameUIRoot")
    end
end

--进入指定状态,回调参数param
function State.EnterState(enterState, params)
    local music_name = ""
    if enterState == State.state.ss_null then
        return
    elseif enterState == State.state.ss_login then
        music_name = "start"
        GUIRoot.ShowPanel("StartPanel", params)
    elseif enterState == State.state.ss_hall then
        music_name = "0"
        GUIRoot.ShowPanel("BasicUIPanel")
        BasicUIPanel.ChangeState()
        GUIRoot.ShowPanel("TopResPanel")
        if next(GUIRoot.map_guis) ~= nil then
            GUIRoot.ClosePanel("MapPanel")
        end
        GUIRoot.ShowPanel("HallPanel", params)
    elseif enterState == State.state.ss_map then
        music_name = tostring(params.cur_map_id)
        GUIRoot.ShowPanel("BasicUIPanel")
        BasicUIPanel.ChangeState()
        GUIRoot.ShowPanel("TopResPanel")
        if next(GUIRoot.hall_guis) ~= nil then
            GUIRoot.ClosePanel("HallPanel")
        end
        GUIRoot.ShowPanel("MapPanel", params)
    elseif enterState == State.state.ss_battle then
        GUIRoot.ClosePanels("GameUIRoot", false)
        GUIRoot.ShowPanel("BattlePanel", nil)
        BasicUIPanel.ChangeState()
        GUIRoot.ShowPanel("BasicUIPanel")
        local back = ""
        if Battle.cur_type == Battle.BATTLE_TYPE.mission or Battle.cur_type == Battle.BATTLE_TYPE.mission_ex then
            local mission_id = 0
            if Battle.cur_type == Battle.BATTLE_TYPE.mission then
                mission_id = Battle.mission_params.mission_id
                FightManger.Mission(mission_id)
            elseif Battle.cur_type == Battle.BATTLE_TYPE.mission_ex then
                mission_id = Battle.mission_ex_params.mission_id
                FightManger.MissionEX()
            end
            local mission = Config.get_config_value("t_mission", mission_id)
            local map_id = mission.chapter
            if map_id == 0 then
                map_id = PlayerData.player.in_map
            end
            local t_map = Config.get_config_value("t_map", map_id)
            back = t_map.back[math.random(#t_map.back)].value
            music_name = "battle"
        elseif Battle.cur_type == Battle.BATTLE_TYPE.tower then
            music_name = "battle_boss"
            FightManger.Tower()
        elseif Battle.cur_type == Battle.BATTLE_TYPE.esport then
            local rank = Battle.tower_params.target_rank
            local target_msg = Battle.esport_params.target_msg
            music_name = "battle_boss"
            FightManger.Arena(rank, target_msg)
        elseif Battle.cur_type == Battle.BATTLE_TYPE.dungeon then
            local send_id = Battle.dungeon_params.dungeon_id
            local dungeon_event_id = Battle.dungeon_params.dungeon_event_id
            local dungeon_id = send_id
            local t_dungeon = Config.get_config_value("t_dungeon", dungeon_id)
            back = t_dungeon.back
            music_name = "battle_boss"

            FightManger.Dungeon(send_id, dungeon_event_id, true)
        end
        if back == "" or back == nil then
            back = "zdbj_001"
        end
        Scene.Show(back)
    end
    if music_name ~= "" then
        soundMgr:play_mus(music_name)
    end
    if enterState ~= State.state.ss_null and enterState ~= State.state.ss_login and (not GameTcp.Isconnect()) then
        GameTcp.ConnectProblem()
    end
end

function State.Reset()
    SceneManager.LoadScene("start")
end