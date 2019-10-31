PortalPanel = {}
PortalPanel.Control = {}
local this = PortalPanel.Control

function PortalPanel.Awake(obj)
	this = {}
	this.gameObject_ = obj
	this.transform_ = obj.transform
	this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

    this.back_ = this.transform_:Find("back")
    this.portal_back_image_ = this.transform_:Find("back/portal_back_image")
    this.portal_res_ = this.transform_:Find("portal_res")
    this.close_portal_ = this.transform_:Find("close_portal")
    this.player_ent_ = this.transform_:Find("back/portal_back_image/player_ent")
    this.draw_line_root_ = this.transform_:Find("back/portal_back_image/draw_line_root")
    this.point_ = this.transform_:Find("point")
	this.mask_ = this.transform_:Find("mask")
	this.pass_map_ = nil
	this.anim_time_ = 0
	this.anim_index_ = -1
	this.anim_state_ = 0
	this.anim_obj_ = nil
    PortalPanel.RegisterBtnListers()
    UpdateBeat:Add(PortalPanel.Update, PortalPanel)
end

function PortalPanel.Start(obj)
    GameSys.ScreenSca(this.portal_back_image_)
    local player_icon_index = tonumber(PlayerData.player.avatar)
    if player_icon_index == 0 then
        player_icon_index = 1
    end
    local avatar = Config.get_config_value("t_avatar", player_icon_index)
    this.player_ent_.transform:Find("player/Image"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(avatar.res)

	this.anim_time_ = 0
	this.anim_index_ = -1
	this.anim_state_ = 0
	this.anim_obj_ = nil
    this.pass_map_ = PortalPanel.GetPassMap()
	if PlayerData.player.portal < PlayerData.player.map then
		local msg = promotion_msg_pb.cmsg_portal()
		msg.portal_id = PlayerData.player.map
		local data = msg:SerializeToString()
		GameTcp.Send(opcodes.CMSG_PORTAL, data, {opcodes.SMSG_PORTAL},"解锁传送门")
		this.mask_.gameObject:SetActive(true)
	else
		PortalPanel.PortalListInit(false)
	end

end

function PortalPanel.OnDestroy()
    PortalPanel.RemoveMessage()
    UpdateBeat:Remove(PortalPanel.Update, PortalPanel)
	this = {}
end

function PortalPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.close_portal_.gameObject, "click", PortalPanel.Close)
    Message.register_net_handle(opcodes.SMSG_MAP_GO, PortalPanel.SMSG_MAP_GO)
	Message.register_net_handle(opcodes.SMSG_PORTAL, PortalPanel.SMSG_PORTAL)
end

function PortalPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_MAP_GO, PortalPanel.SMSG_MAP_GO)
	Message.remove_net_handle(opcodes.SMSG_PORTAL, PortalPanel.SMSG_PORTAL)
end

function PortalPanel.PortalListInit(need_anim)
	local last = -1
	for i = 1, #this.pass_map_ do
		local state = this.pass_map_[i].state
		if state then
			last = i
		end
	end
	for i = 1, #this.pass_map_ do
		if i == last and need_anim then
			--什么都不做
		else
			PortalPanel.DrawMap(i, this.pass_map_[i].state)
			PortalPanel.DrawLine(i, false)
		end
	end
    this.player_ent_.transform:SetAsLastSibling()
    this.player_ent_.transform:Find("player"):GetComponent("RectTransform"):DOLocalMoveY(10, 0.5):SetRelative(true):SetLoops(-1, DG.Tweening.LoopType.Yoyo);
    this.back_.gameObject:SetActive(true)
	if need_anim then
		this.back_:GetComponent("ScrollRect").normalizedPosition = Vector2(this.pass_map_[last].t_map.x, this.pass_map_[last].t_map.y + 40)
		this.anim_index_ = last
	end
end

function PortalPanel.DrawMap(index, state)
	local slot_ins = GameObject.Instantiate(this.portal_res_.gameObject)
	slot_ins.transform:SetParent(this.portal_back_image_, false)
	slot_ins:GetComponent("RectTransform").anchoredPosition = Vector2(this.pass_map_[index].t_map.x , this.pass_map_[index].t_map.y)
	slot_ins:GetComponent("LocalizationText").text = this.pass_map_[index].t_map.name
	slot_ins.transform:Find("level_back_image/level"):GetComponent("LocalizationText").text = this.pass_map_[index].t_map.level_show
	slot_ins.gameObject:SetActive(true)
	local click_obj = slot_ins.transform:Find("unlock")
	if not state then
		click_obj:GetComponent("Button").interactable = false
		slot_ins:GetComponent("LocalizationText").text = ""
	else
		slot_ins.transform:Find("unlock_img").gameObject:SetActive(false)
		slot_ins:GetComponent("LocalizationText").text = this.pass_map_[index].t_map.name
	end
	if this.pass_map_[index].t_map.id == 0 then
		slot_ins.transform:Find("level_back_image").gameObject:SetActive(false)
		slot_ins.transform:Find("unlock_img").gameObject:SetActive(false)
	end
	if PlayerData.player.in_map == this.pass_map_[index].t_map.id then
		this.player_ent_.transform:SetParent(this.portal_back_image_, false)
		this.player_ent_:GetComponent("RectTransform").anchoredPosition = Vector2(this.pass_map_[index].t_map.x, this.pass_map_[index].t_map.y + 40)
		this.back_:GetComponent("ScrollRect").normalizedPosition = Vector2(this.pass_map_[index].t_map.x, this.pass_map_[index].t_map.y + 40)
		this.player_ent_.gameObject:SetActive(true)
	end
	click_obj.transform.name = string.format("%s_%s" , this.pass_map_[index].t_map.id, tostring(i))
	GameSys.ButtonRegister(this.lua_script, click_obj.gameObject, "click", PortalPanel.GoMap, {this.pass_map_[index].t_map.id})
	return slot_ins
end

function PortalPanel.DrawLine(index, anim)
	local all_line = {}
	if this.pass_map_[index].state then
		local dir = (Vector3(this.pass_map_[index].t_map.end_x, this.pass_map_[index].t_map.end_y, 0) - Vector3(this.pass_map_[index].t_map.start_x, this.pass_map_[index].t_map.start_y, 0)):Normalize()
		local dis = (Vector3(this.pass_map_[index].t_map.end_x, this.pass_map_[index].t_map.end_y, 0) - Vector3(this.pass_map_[index].t_map.start_x, this.pass_map_[index].t_map.start_y, 0)).magnitude
		local num = math.floor(dis / 12)
		for i = 1, (num - 1) do
            local pos_line = QuadBezierCurve(Vector3(this.pass_map_[index].t_map.start_x, this.pass_map_[index].t_map.start_y, 0), Vector3(this.pass_map_[index].t_map.middle_x, this.pass_map_[index].t_map.middle_y, 0), Vector3(this.pass_map_[index].t_map.end_x, this.pass_map_[index].t_map.end_y, 0), i / num)
			local line = GameObject.Instantiate(this.point_.gameObject)
			line.transform:SetParent(this.draw_line_root_, false)
			if i == 1 or i == (num - 1) then

			else
				line.transform.localScale = Vector3(0.8, 0.8 ,0)
			end
			line:GetComponent("RectTransform").anchoredPosition = Vector2(pos_line.x, pos_line.y)
			if anim then
				line.gameObject:SetActive(false)
			else
				line.gameObject:SetActive(true)
			end
			table.insert(all_line, {line, 0.4 * i + 1})
		end
	end
	return all_line
end


function PortalPanel.GetPassMap()
    local t_map_state = {}
    local t_map = Config.t_map
    for _,v in pairs(t_map) do
        table.insert(t_map_state, {
            ["t_map"] = v,
            ["state"] = PortalPanel.MapState(v),
        })

    end
    return t_map_state
end

function PortalPanel.MapState(map)
    if (map.map_param ~= 0 and QuestManger.NeedOverCondition(map.map_param)) or map.map_param == 0 then
        return true
    end
    return false
end

function PortalPanel.GoMap(obj, params)
    this.go_map_ = params[1]
    if this.go_map_ == PlayerData.player.in_map then
        return
    end
    local msg = mission_msg_pb.cmsg_map_go()
    msg.map_id = this.go_map_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_MAP_GO, data, { opcodes.SMSG_MAP_GO })
end

function PortalPanel.Close()
    GUIRoot.ShowPanel("LoadingPanel", {function (params)
        GUIRoot.ClosePanel("PortalPanel")
    end, nil})
end

function PortalPanel.SMSG_MAP_GO(message)
    local cur_map_ = PlayerData.player.in_map
    PlayerData.player.in_map = this.go_map_
    if PlayerData.player.in_map == 0 then
        UIRoot.ShowPanel("LoadingPanel", {function (params)
            State.ChangeState(State.state.ss_hall)
        end, nil})
    else
        local map_data = {}
        map_data.cur_map_id = this.go_map_
        map_data.pre_map_id = cur_map_
        if State.cur_state == State.state.ss_hall then
            local t_map = Config.get_config_value("t_map", this.go_map_)
            if QuestManger.NeedOverCondition(t_map.map_param) and PlayerData.player.aside == this.go_map_ then
                PlayerData.player.aside = PlayerData.player.aside + 1
                timerMgr:AddTimer("YcFun", function (param)
                    GUIRoot.ShowPanel("NarratorPanel", {this.go_map_, nil})
                end , {}, 0.6)
            end
            State.ChangeState(State.state.ss_map, map_data)
        elseif State.cur_state == State.state.ss_map then
            GUIRoot.ShowPanel("LoadingPanel", {function (params)
                GUIRoot.ShowPanel("MapPanel", params[1])
            end, {map_data}})
        end
    end
    PlayerPrefs.DeleteKey('map')
    timerMgr:AddTimer("yc_close", function (param)
        GUIRoot.ClosePanel("PortalPanel")
    end , {}, 0.6)
end

function PortalPanel.SMSG_PORTAL(message)
	PlayerData.player.portal = PlayerData.player.portal + 1
	PortalPanel.PortalListInit(true)
end

function PortalPanel.Update()
	if this.anim_index_ > 0 then
		this.anim_time_ = this.anim_time_ + Time.deltaTime
		if this.anim_state_ == 0 then
			this.anim_obj_ = PortalPanel.DrawMap(this.anim_index_, false).transform:Find("unlock_img")
			this.anim_state_ = 1
			this.anim_time_ = 0
		elseif this.anim_state_ == 1 then
			if this.anim_time_ >= 0.7 then
				this.anim_obj_:GetComponent("Animator").enabled = true
				this.anim_state_ = 2
				this.anim_time_ = 0
			end
		elseif this.anim_state_ == 2 then
			if this.anim_time_ >= 2.5 then
				GameObject.Destroy(this.anim_obj_.gameObject)
				PortalPanel.DrawMap(this.anim_index_, true)
				this.anim_state_ = 3
				this.anim_time_ = 0
				this.anim_obj_ = PortalPanel.DrawLine(this.anim_index_, true)
			end
		elseif this.anim_state_ == 3 then
			local dels = {}
			for i = 1, #this.anim_obj_ do
				if this.anim_time_ >= this.anim_obj_[i][2] then
					this.anim_obj_[i][1]:SetActive(true)
					table.insert(dels, i)
				end
			end
			for i = 1, #dels do
				table.remove(this.anim_obj_, dels[i])
			end
			if #this.anim_obj_ == 0 then
				this.anim_state_ = 4
				this.anim_time_ = 0
				this.anim_index_ = -1
				this.mask_.gameObject:SetActive(false)
			end
		end
	end
end