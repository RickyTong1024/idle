MonsterPanel = {}
MonsterPanel.Control = {}
local this = MonsterPanel.Control

function MonsterPanel.Awake(obj, lua_script)
    this = {}
    this.gameObject = obj
    this.lua_script_ = lua_script
    this.transform_ = obj.transform
    this.content_root_ = this.transform_:Find("monster_scroll/content")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.monster_rect_ = this.transform_:Find("monster_rect")
    this.monster_icon_ = this.transform_:Find("monster_icon")

    this.monster_queues_ = {}
    this.cur_get_mission_id_ = 0
    this.cur_get_role_id_ = 0
    this.cur_unlock_level_ = 0
    this.cur_click_chapter_index_ = 0
    this.cur_click_icon_index_ = 0
    this.cur_click_icon_ = 0

    MonsterPanel.RegisterBtnListers()
    MonsterPanel.RegisterMessage()
    MonsterPanel.InitUIScroll()
end

function MonsterPanel.OnDestroy(obj)
    MonsterPanel.RemoveMessage()
    this = {}
end

function MonsterPanel.RegisterBtnListers()

end

function MonsterPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_DRAWS_UNLOCK, MonsterPanel.OnGetReputation)
end

function MonsterPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_DRAWS_UNLOCK, MonsterPanel.OnGetReputation)
end

function MonsterPanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab = this.monster_rect_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function(go, index)
        MonsterPanel.SetMonsterRect(go, index + 1)
        if not go.activeSelf then
            go:SetActive(true)
        end
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function MonsterPanel.RefreshPanel()
    MonsterPanel.SetData()
    this.ui_scroll_grid_:SetData(#this.monster_queues_)
end

function MonsterPanel.SetData()
    this.monster_queues_ = {}
    local mission_config = Config.t_mission
    local mission_sort = {}
    for _, t_mission in pairs(mission_config) do
        if t_mission.type == 2  then
            table.insert(mission_sort, t_mission)
        end
    end
    table.sort(mission_sort, function(a, b)
        return a.id < b.id
    end)
    for i = 1, #mission_sort do
        local chapter = mission_sort[i].chapter
        if this.monster_queues_[chapter] == nil then
            this.monster_queues_[chapter] = {}
        end
        local t = {
            ["t_mission"] = mission_sort[i],
            ["t_monster"] = nil,
            ["t_role"] = nil,
            ["reputation_state"] = nil,
        }
        t.t_monster = Config.get_config_value("t_monster", t.t_mission.monsterid)
        t.t_role = Config.get_config_value("t_role", t.t_monster.role_id)
        t.reputation_state = GameSys.GetMonsterReputationState(t.t_mission.id, t.t_role.id)
        table.insert(this.monster_queues_[chapter], t)
    end
end

function MonsterPanel.SetMonsterRect(go, sort)
    local title = go.transform:Find("line/title")
    local content = go.transform:Find("content")
    local monster_states = this.monster_queues_[sort]
    local child_count = content.childCount
    local state_count = #monster_states
    local sub = state_count - child_count
    if sub > 0 then
        for i = 1, sub do
            local icon_ins = GameObject.Instantiate(this.monster_icon_.gameObject)
            icon_ins.transform:SetParent(content, false)
            icon_ins:SetActive(true)
        end
    else
        for i = state_count, math.abs(sub) do
            local icon = content:GetChild(i)
            if icon ~= nil then
                icon.gameObject:SetActive(false)
            end
        end
    end
    local t_map = Config.get_config_value("t_map", sort)
    title:GetComponent("Text").text = t_map.name
    for i = 1, #monster_states do
        local icon = content:GetChild(i - 1)
        MonsterPanel.SetIcon(icon.gameObject, sort, i)
    end
end

function MonsterPanel.SetIcon(icon_ins, chapter_index, index)
    local monster_state = this.monster_queues_[chapter_index][index]
    if not icon_ins.activeSelf then
        icon_ins:SetActive(true)
    end
    local quality_back = icon_ins.transform:Find("quality_back")
    local monster_icon = icon_ins.transform:Find("monster_icon")
    local add_image = icon_ins.transform:Find("add_image")
    local mask = icon_ins.transform:Find("mask")
    mask.gameObject:SetActive(not monster_state.reputation_state.had_unlock)
    add_image.gameObject:SetActive(monster_state.reputation_state.had_unlock and monster_state.reputation_state.can_get_reputation)
    local color = monster_state.t_mission.diff
    local quality_icon_alias = GameSys.get_quality(color)
    quality_back:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "quality"):GetSprite(quality_icon_alias)
    local monster_icon_alias = monster_state.t_role.icon
    monster_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "monster"):GetSprite(monster_icon_alias)
    this.lua_script_:RemoveButtonEvent(icon_ins, "click")
    icon_ins.name = "this.monster_icon_" .. chapter_index .. "_" .. index
    GameSys.ButtonRegister(this.lua_script_, icon_ins, "click", MonsterPanel.OnMonsterIconClick, { chapter_index, index, icon_ins})
end


function MonsterPanel.OnMonsterIconClick(obj, params)
    this.cur_click_chapter_index_ = params[1]
    this.cur_click_icon_index_ = params[2]
    this.cur_click_icon_ = params[3]
    local monster_state = this.monster_queues_[this.cur_click_chapter_index_][this.cur_click_icon_index_]
    if monster_state.reputation_state.can_get_reputation then
        local mission_id = monster_state.t_mission.id
        local role_id = monster_state.t_role.id
        this.cur_get_mission_id_ = mission_id
        this.cur_get_role_id_ = role_id
        this.cur_unlock_level_ = monster_state.reputation_state.cur_unlock_level
        BookPanel.cur_unlock_type_ = 2
        local msg = item_msg_pb.cmsg_draws_unlock()
        msg.type = BookPanel.cur_unlock_type_
        msg.draw_id = this.cur_get_mission_id_
        msg.param = this.cur_unlock_level_
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_DRAWS_UNLOCK ,data, {opcodes.SMSG_DRAWS_UNLOCK})
    else
        GUIRoot.ShowPanel("MonsterDetailPanel", {monster_state.t_mission ,monster_state.t_monster, monster_state.t_role})
    end
end

function MonsterPanel.OnGetReputation(message)
    if  BookPanel.cur_unlock_type_ ~= 2 then
        return
    end
    local t_role = Config.get_config_value('t_role', this.cur_get_role_id_)
    local t_role_reputation = Config.get_config_value('t_role_reputation', t_role.reputation)
    local index = GameSys.getIndex(PlayerData.player.monsters, this.cur_get_mission_id_)
    PlayerData.player.monster_unlocks[index] = PlayerData.player.monster_unlocks[index] + 1
    PlayerData.add_resource(5, t_role_reputation.kill[this.cur_unlock_level_ + 1].reputation)

    local reputation_state = GameSys.GetMonsterReputationState(this.cur_get_mission_id_, this.cur_get_role_id_)
    this.monster_queues_[this.cur_click_chapter_index_][this.cur_click_icon_index_].reputation_state = reputation_state
    if this.cur_click_icon_ ~= nil then
        MonsterPanel.SetIcon(this.cur_click_icon_, this.cur_click_chapter_index_, this.cur_click_icon_index_)
    end
    local msg = CommonMessage()
    msg.name = "get_monster_reputation_success"
    messMgr:AddCommonMessage(msg)
end