ArtifactPanel = {}
ArtifactPanel.Control = {}
local this = ArtifactPanel.Control


local cur_select_

function ArtifactPanel.Awake(obj, lua_script)
    this = {}
    this.gameObject_ = obj
    this.lua_script_ = lua_script
    this.transform_ = obj.transform
    this.artifact_rect_ = obj.transform:Find("artifact_rect")
    this.artifact_icon_ = obj.transform:Find("artifact_icon")
    this.artifact_scroll_ = obj.transform:Find("artifact_scroll")
    this.content_ = obj.transform:Find("artifact_scroll/content")
    this.ui_scroll_grid_ = this.content_:GetComponent("UIScrollGrid")

    this.artifact_queues_ = {}
    this.cur_get_artifact_id_ = 0
    this.cur_get_reputation_index_ = 0

    ArtifactPanel.RegisterBtnListers()
    ArtifactPanel.RegisterMessage()
    ArtifactPanel.InitUIScroll()
end

function ArtifactPanel.OnDestroy(obj)
    ArtifactPanel.RemoveMessage()
    this = {}
end

function ArtifactPanel.RegisterBtnListers()

end

function ArtifactPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_DRAWS_UNLOCK, ArtifactPanel.OnGetReputation)
end

function ArtifactPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_DRAWS_UNLOCK, ArtifactPanel.OnGetReputation)
end

function ArtifactPanel.InitUIScroll()
    Util.ClearChild(this.content_)
    this.ui_scroll_grid_.prefab = this.artifact_rect_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function(go, index)
        ArtifactPanel.SetArtifactRect(go, index + 1)
        if not go.activeSelf then
            go:SetActive(true)
        end
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function ArtifactPanel.SetArtifactRect(go, sort)
    local artifact_states = this.artifact_queues_[sort]
    local title = go.transform:Find("line/title")
    local content = go.transform:Find("content")
    local map = Config.get_config_value("t_map", sort + 2)
    title:GetComponent("Text").text = map.name
    local child_count = content.childCount
    local state_count = #artifact_states
    local sub = state_count - child_count
    if sub > 0 then
        for i = 1, sub do
            local icon_ins = GameObject.Instantiate(this.artifact_icon_.gameObject)
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
    for i = 0, state_count - 1 do
        local index = i + 1
        local icon = content:GetChild(i)
        ArtifactPanel.SetIcon(icon.gameObject, sort, index)
    end
end

function ArtifactPanel.SetIcon(icon_ins, sort, index)
    local artifact_state = this.artifact_queues_[sort][index]
    local t_artifact = artifact_state.t_artifact
    local quality_back = icon_ins.transform:Find("quality_back")
    local equip_icon = icon_ins.transform:Find("artifact_icon")
    local mask = icon_ins.transform:Find("mask")
    local draw = icon_ins.transform:Find("draw")
    local red_point = icon_ins.transform:Find("red_point")
    local add_image = icon_ins.transform:Find("add_image")
    this.lua_script_:RemoveButtonEvent(icon_ins.transform.gameObject, "click")
    icon_ins.name = "this.artifact_icon_" .. sort .. "_" .. index
    GameSys.ButtonRegister(this.lua_script_, icon_ins, "click", ArtifactPanel.OnArtifactIconClick, { sort, index, icon_ins })
    local quality_icon_alias = GameSys.get_quality(t_artifact.color)
    local artifact_icon_alias = t_artifact.icon
    quality_back:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "quality"):GetSprite(quality_icon_alias)
    equip_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "artifact"):GetSprite(artifact_icon_alias)
    mask.gameObject:SetActive(artifact_state.state <= 0)
    draw.gameObject:SetActive(artifact_state.state == 0)
    add_image.gameObject:SetActive(artifact_state.can_get_1 or artifact_state.can_get_2)
    red_point.gameObject:SetActive(artifact_state.can_forge)
    icon_ins:SetActive(true)
end

function ArtifactPanel.RefreshPanel()
    ArtifactPanel.SetData()
    this.ui_scroll_grid_:SetData(#this.artifact_queues_)
end

function ArtifactPanel.SetData()
    this.artifact_queues_ = {}
    local t_artifact = Config.t_artifact
    for _, v in pairs(t_artifact) do
        if this.artifact_queues_[v.map - 2] == nil then
            this.artifact_queues_[v.map - 2] = {}
        end
        local reputataion_unlock, reputataion_has = GameSys.GetArtifactReputationState(v.id)
        local can_forge = GameSys.EnoughArtifactForge(v.id)
        table.insert(this.artifact_queues_[v.map - 2], {
            ["t_artifact"] = v,
            ["state"] = GameSys.GetArtifactState(v.id),
            ["can_get_1"] = reputataion_unlock.can_get,
            ["had_get_1"] = reputataion_unlock.had_get,
            ["can_get_2"] = reputataion_has.can_get,
            ["had_get_2"] = reputataion_has.had_get,
            ["can_forge"] = can_forge
        })
    end




    for k, v in pairs(this.artifact_queues_) do
        local artifact_states = this.artifact_queues_[k]
        table.sort(artifact_states, function(a, b)
            if a.t_artifact.color > b.t_artifact.color then
                return true
            elseif a.t_artifact.color < b.t_artifact.color then
                return false
            else
                if a.t_artifact.id < b.t_artifact.id then
                    return true
                else
                    return false
                end
            end
        end)
    end
end

function ArtifactPanel.OnArtifactIconClick(obj, params)
    local sort = params[1]
    local index = params[2]
    local icon = params[3]
    cur_select_ = { sort, index, icon }
    local artifact_state = this.artifact_queues_[sort][index]
    local state = tonumber(artifact_state.state)
    if state == 0 then
        if artifact_state.can_get_1 then
            ---领取解锁奖励声望
            this.cur_get_artifact_id_ = artifact_state.t_artifact.id
            this.cur_get_reputation_index_ = 1
            BookPanel.cur_unlock_type_ = 4
            local msg = item_msg_pb.cmsg_draws_unlock()
            msg.type = BookPanel.cur_unlock_type_
            msg.draw_id = this.cur_get_artifact_id_
            msg.param = this.cur_get_reputation_index_
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_DRAWS_UNLOCK, data, { opcodes.SMSG_DRAWS_UNLOCK })
        else
            ---打开锻造界面
            ArtifactPanel.ShowArtifactForgePanel({ artifact_state.t_artifact.id, cur_select_ })
        end
    else
        if artifact_state.can_get_2 then
            ---领取锻造奖励声望
            this.cur_get_artifact_id_ = artifact_state.t_artifact.id
            this.cur_get_reputation_index_ = 2
            BookPanel.cur_unlock_type_ = 4
            local msg = item_msg_pb.cmsg_draws_unlock()
            msg.type = BookPanel.cur_unlock_type_
            msg.draw_id = this.cur_get_artifact_id_
            msg.param = this.cur_get_reputation_index_
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_DRAWS_UNLOCK, data, { opcodes.SMSG_DRAWS_UNLOCK })
        else
            GUIRoot.ShowPanel("ArtifactDetailPanel", { artifact_state.t_artifact })
        end
    end
end

function ArtifactPanel.ShowArtifactForgePanel(params)
    local param = {}
    param[1] = ArtifactPanel.GetForgeId(params[1])
    param[2] = function ()
        local select = cur_select_
        ArtifactPanel.RefreshIcon(select)
    end
    GUIRoot.ShowPanel("ForgeSurePanel", param)
end

function ArtifactPanel.GetForgeId(artifact_id)
    for k, v in pairs(Config.t_forge) do
        if v.type == 4 and v.value1 == artifact_id then
            return k
        end
    end
end

function ArtifactPanel.OnGetReputation(message)
    if BookPanel.cur_unlock_type_ ~= 4 then
        return
    end
    local t_artifact = Config.get_config_value('t_artifact', this.cur_get_artifact_id_)
    local index = GameSys.getIndex(PlayerData.player.artifact_ids, this.cur_get_artifact_id_)
    if this.cur_get_reputation_index_ == 1 then
        PlayerData.player.artifact_unlocks[index] = 1
        PlayerData.add_resource(5, t_artifact.unlock_reputation)
    elseif this.cur_get_reputation_index_ == 2 then
        PlayerData.player.artifact_unlocks[index] = 2
        PlayerData.add_resource(5, t_artifact.has_reputation)
    end
    --刷新
    ArtifactPanel.RefreshIcon(cur_select_)

    local msg = CommonMessage()
    msg.name = "get_artifact_reputation_success"
    messMgr:AddCommonMessage(msg)
end

function ArtifactPanel.RefreshIcon(select)
    local sort = select[1]
    local index = select[2]
    local icon_ins = select[3]
    local artifact_state = this.artifact_queues_[sort][index]
    local reputataion_unlock, reputataion_has = GameSys.GetArtifactReputationState(this.cur_get_artifact_id_)
    local can_forge = GameSys.EnoughArtifactForge(this.cur_get_artifact_id_)
    artifact_state["state"]= GameSys.GetArtifactState(this.cur_get_artifact_id_)
    artifact_state["can_get_1"] = reputataion_unlock.can_get
    artifact_state["had_get_1"] = reputataion_unlock.had_get
    artifact_state["can_get_2"] = reputataion_has.can_get
    artifact_state["had_get_2"] = reputataion_has.had_get
    artifact_state["can_forge"] = can_forge
    if icon_ins ~= nil then
        ArtifactPanel.SetIcon(icon_ins, sort, index)
    end
end