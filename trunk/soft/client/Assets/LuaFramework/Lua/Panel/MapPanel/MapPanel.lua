MapPanel = {}
MapPanel.Control = {}
local this = MapPanel.Control

MapPanel.map_len = 85
MapPanel.map_x = 35

function MapPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.ins_ = this.gameObject_

    this.map_ = this.transform_:Find("map")
    this.backs_ = this.transform_:Find("map/backs")
	this.items_ = this.transform_:Find("map/items")
    this.paths_ = this.transform_:Find("map/paths")
    this.background_ = this.transform_:Find("map/background")
    this.hero_ = this.transform_:Find("hero")
    this.lx_ = this.transform_:Find("map/templates/lx")
    this.map_element_res_ = this.transform_:Find("map/templates/map_element_res")
    this.fx_ = this.transform_:Find("map/templates/fx")
    this.mask_ = this.transform_:Find("mask")
    this.go_back_btn_ = this.transform_:Find("UIBack/go_back_btn")
    this.silder_ = this.transform_:Find("UIBack/go_back_btn/silder")
    this.go_back_tip_text_ = this.transform_:Find("UIBack/go_back_btn/title_text")
    this.map_monster_res_ = this.transform_:Find("map/templates/map_monster_res")
    this.map_npc_res_ = this.transform_:Find("map/templates/map_npc_res")
    this.map_name_show_ = this.transform_:Find("UIBack/map_name_show_back")
    this.wb_effect_ = this.transform_:Find("UIBack/wb_cz/effect"):GetComponent("RawImage")
	this.wb_effect_.texture = UIEffect.Camera.targetTexture
	this.qd_an_dt_ = this.transform_:Find("UIBack/wb_cz/yq_back/qd_an_dt")
    this.cj_btn_ = this.transform_:Find("UIBack/wb_cz/qd_an_btn/cj_btn")
    this.wb_cz_ = this.transform_:Find("UIBack/wb_cz")
    this.is_move_ = false
    this.cur_pos_ = nil
    this.target_pos_ = nil
    this.const_near_ = {{{0, 1}, 1}, {{0, -1}, 1}, {{1, 0}, 1}, {{1, 1}, 1}, {{1, -1}, 1}, {{-1, 0}, 1}, {{-1, 1}, 1}, {{-1, -1}, 1}, {{0, 2}, 2}, {{0, -2}, 2}, {{1, 2}, 2}, {{1, -2}, 2}, {{-1, 2}, 2}, {{-1, -2}, 2}, {{2, 0}, 2}, {{2, 1}, 2}, {{2, -1}, 2}, {{2, 2}, 2}, {{2, -2}, 2}, {{-2, 0}, 2}, {{-2, 1}, 2}, {{-2, -1}, 2}, {{-2, 2}, 2}, {{-2, -2}, 2}, {{0, 3}, 3}, {{0, -3}, 3}, {{1, 3}, 3}, {{1, -3}, 3}, {{-1, 3}, 3}, {{-1, -3}, 3}, {{2, 3}, 3}, {{2, -3}, 3}, {{-2, 3}, 3}, {{-2, -3}, 3}, {{3, 0}, 3}, {{3, 1}, 3}, {{3, -1}, 3}, {{3, 2}, 3}, {{3, -2}, 3}, {{3, 3}, 3}, {{3, -3}, 3}, {{-3, 0}, 3}, {{-3, 1}, 3}, {{-3, -1}, 3}, {{-3, 2}, 3}, {{-3, -2}, 3}, {{-3, 3}, 3}, {{-3, -3}, 3}, {{0, 4}, 4}, {{0, -4}, 4}, {{1, 4}, 4}, {{1, -4}, 4}, {{-1, 4}, 4}, {{-1, -4}, 4}, {{2, 4}, 4}, {{2, -4}, 4}, {{-2, 4}, 4}, {{-2, -4}, 4}, {{3, 4}, 4}, {{3, -4}, 4}, {{-3, 4}, 4}, {{-3, -4}, 4}, {{4, 0}, 4}, {{4, 1}, 4}, {{4, -1}, 4}, {{4, 2}, 4}, {{4, -2}, 4}, {{4, 3}, 4}, {{4, -3}, 4}, {{4, 4}, 4}, {{4, -4}, 4}, {{-4, 0}, 4}, {{-4, 1}, 4}, {{-4, -1}, 4}, {{-4, 2}, 4}, {{-4, -2}, 4}, {{-4, 3}, 4}, {{-4, -3}, 4}, {{-4, 4}, 4}, {{-4, -4}, 4}, {{0, 5}, 5}, {{0, -5}, 5}, {{1, 5}, 5}, {{1, -5}, 5}, {{-1, 5}, 5}, {{-1, -5}, 5}, {{2, 5}, 5}, {{2, -5}, 5}, {{-2, 5}, 5}, {{-2, -5}, 5}, {{3, 5}, 5}, {{3, -5}, 5}, {{-3, 5}, 5}, {{-3, -5}, 5}, {{4, 5}, 5}, {{4, -5}, 5}, {{-4, 5}, 5}, {{-4, -5}, 5}, {{5, 0}, 5}, {{5, 1}, 5}, {{5, -1}, 5}, {{5, 2}, 5}, {{5, -2}, 5}, {{5, 3}, 5}, {{5, -3}, 5}, {{5, 4}, 5}, {{5, -4}, 5}, {{5, 5}, 5}, {{5, -5}, 5}, {{-5, 0}, 5}, {{-5, 1}, 5}, {{-5, -1}, 5}, {{-5, 2}, 5}, {{-5, -2}, 5}, {{-5, 3}, 5}, {{-5, -3}, 5}, {{-5, 4}, 5}, {{-5, -4}, 5}, {{-5, 5}, 5}, {{-5, -5}, 5}}
    this.const_orient_ = {{0, 2}, {-2, 0}, {0, -2}, {2, 0}, {-1, 1}, {-1, -1}, {1, -1}, {1, 1}}
    this.const_orient_name_ = {"zjdt_ui021", "zjdt_ui023", "zjdt_ui022", "zjdt_ui024", "zjdt_ui025", "zjdt_ui027", "zjdt_ui028", "zjdt_ui026"}
    this.move_orient_ = {{1, 1}, {-1, 1}, {-1, -1}, {1, -1}, {0, 1}, {-1, 0}, {0, -1}, {1, 0}}
    this.orient_retate_ = {180, 90, 0, 270, 135, 45, 315, 225}
    this.orient_ = 0
    this.move_time_ = 0
    this.const_move_time_ = 0.3
    this.bias_pos_ = Vector3.zero
    this.edge_ = 10
    this.go_back_silder = 100
    this.go_back_target_ = false
    this.obstacles_ = {}
    this.path_list_ = {}
    this.path_tb_ = {}
    this.event_data_ = nil
    this.event_target_ = nil
    this.cur_map_id_ = 0
    this.pass_map_ = {}
    this.wb_silder_ = 0
    this.wb_targert_ = false
    this.wb_cz_image = {"zjdt_ui042", "zjdt_ui043"} --[1] 挖宝 [2]采集
    this.quest_type_ = {"zjdt_ui045", "zjdt_ui044"}
    this.element_obj_ = {}
    this.random_post_ = {}
    this.map_saved_msg_ = nil
    this.map_image_show_ = true
    this.server_dungeon = 0
    MapPanel.PlayerShow()
    timerMgr:AddRepeatTimer('BossDieTime', MapPanel.Refresh, 0.1, 0.1)
    UpdateBeat:Add(MapPanel.Update, MapPanel)
    MapPanel.RegisterBtnListers()
    MapPanel.RegisterMessage()
end

function MapPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_DUNGEON, MapPanel.SMSG_DUNGEON)
    Message.register_net_handle(opcodes.SMSG_MAP_GO, MapPanel.SMSG_MAP_GO)
    Message.register_handle("battle_end", MapPanel.BattleEnd)
    Message.register_handle("need_check_quest", MapPanel.QuestRefresh)
    Message.register_handle("level_up", MapPanel.Check)
    Message.register_handle("NarratorEnd", MapPanel.MapNameShow)
    Message.register_handle("PlayerPanelStateChange", MapPanel.PlayerPanelState)
end

function MapPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_DUNGEON, MapPanel.SMSG_DUNGEON)
    Message.remove_net_handle(opcodes.SMSG_MAP_GO, MapPanel.SMSG_MAP_GO)
    Message.remove_handle("battle_end", MapPanel.BattleEnd)
    Message.remove_handle("need_check_quest", MapPanel.QuestRefresh)
    Message.remove_handle("level_up", MapPanel.Check)
    Message.remove_handle("NarratorEnd", MapPanel.MapNameShow)
    Message.remove_handle("PlayerPanelStateChange", MapPanel.PlayerPanelState)

end

function MapPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.go_back_btn_.gameObject, "click", MapPanel.GoBack)
end

function MapPanel.OnDestroy()
    local cur = Config.get_config_value("t_map", this.cur_map_id_)
    resMgr.UnloadMap(cur.res)
    MapPanel.RemoveMessage()
    UpdateBeat:Remove(MapPanel.Update, MapPanel)
    BasicUIPanel.OrientShow(0, {0,0})
    Hall.HideMap()
	UIEffect.Hide("ui_mine01")
    timerMgr:RemoveRepeatTimer('BossDieTime')
    this = {}
end

function MapPanel.OnParam(params)
	GameSys.ClearChild(this.backs_)
	GameSys.ClearChild(this.items_)

    this.element_obj_ = {}
	this.move_time_ = 0
    this.is_move_ = false
    this.path_list_ = {}
    this.path_tb_ = {}
    this.event_target_ = nil
    this.event_data_ = nil
    this.pass_map_ = {}
    this.wb_silder_ = 0
    this.server_dungeon = 0
    this.wb_targert_ = false
    this.map_image_show_ = true
    this.bias_pos_ = Vector3.zero

    local map_id = params.cur_map_id
    local pre_map_id = params.pre_map_id
    if pre_map_id ~= nil then
		local pre_map = Config.get_config_value("t_map", pre_map_id)
        resMgr.UnloadMap(pre_map.res)
    end
    local t_map = Config.get_config_value("t_map", map_id)
    local map_res = resMgr.LoadMap(t_map.res)
    local map_config = resMgr.LoadMapConfig(t_map.res)
    if map_config == nil then
        map_id = 1
        t_map = Config.get_config_value("t_map", map_id)
        map_res = resMgr.LoadMap(t_map.res)
        map_config = resMgr.LoadMapConfig(t_map.res)
    end
	this.cur_map_id_ = map_id
	this.map_name_show_.transform:Find("map_name_show"):GetComponent("LocalizationText").text = t_map.name
    MapPanel.MapNameShow()
	
    local c = map_config.text
    c = stringSplit(c, " ")
    this.obstacles_ = {}
    this.random_post_= {}
    local count = 1
    for i = 0, MapPanel.map_len - 1 do
		this.obstacles_[i] = {}
        this.random_post_[i] = {}
	end
    for y = 0, MapPanel.map_len - 1 do
        for x = 0, MapPanel.map_len - 1 do
            if tonumber(c[count]) > 0 then
				this.obstacles_[x][y] = false
                this.random_post_[x][y] = 1
                --[[local obj = GameObject.Instantiate(this.lx_.gameObject)
                obj.transform:SetParent(this.backs_, false)
                obj.transform.localPosition = MapPanel.GetVector(x, y)
                obj.transform.localScale = Vector3.one
                obj:SetActive(true)
                obj:GetComponent("Image").color = Color(1, 0, 0, 0.1)]]--
            else
				this.obstacles_[x][y] = true
                this.random_post_[x][y] = 0
            end
            count = count + 1
        end
    end
	
    this.background_:GetComponent("RawImage").texture = map_res
    this.background_:GetComponent("RectTransform").sizeDelta = Vector2(MapPanel.map_x * 64, (MapPanel.map_len - MapPanel.map_x) * 32 + 400)
	this.background_.localPosition = Vector3(-MapPanel.map_x * 32, (MapPanel.map_x - 1) * 16 - 200, 0)
	
	MapPanel.BuildInit(map_id)
	MapPanel.NpcInit(map_id)
	if pre_map_id == nil then
		MapPanel.Load()
		this.cur_pos_ = nil
        if this.map_saved_msg_ ~= nil then
			if this.map_saved_msg_.map_id ~= this.cur_map_id_ then
				this.map_saved_msg_ = nil
			else
				this.cur_pos_ = {this.map_saved_msg_.x, this.map_saved_msg_.y}
			end
        end
		if this.cur_pos_ == nil then
            local t_map_port = Config.get_config_value("t_map_port", 0, map_id)
            this.cur_pos_ = {t_map_port.x, t_map_port.y}
        end
	else
        Hall.HideMap()
        MapPanel.PlayerShow()
		local t_map_port = Config.get_config_value("t_map_port", pre_map_id, map_id)
		this.cur_pos_ = {t_map_port.x, t_map_port.y}
	end
    MapPanel.MissionInit(map_id)
    MapPanel.DungeonInit(map_id)
    MapPanel.Save()
    this.map_saved_msg_ = nil
	
    MapPanel.adjust_map()
end

function MapPanel.PlayerShow()
    local hero_r = Hall.ShowMap(1, 1)
    local hero_rimg = this.hero_:Find("image"):GetComponent("RawImage")
    hero_rimg.texture = Hall.Camera.targetTexture
    hero_rimg.uvRect = hero_r
end

function MapPanel.RandomPos()
    local pos = {0, 0}
	local num = 0
    while true do
		num = num + 1
        local x = math.random(0, MapPanel.map_len - 1)
        local y = math.random(0, MapPanel.map_len - 1)
        if this.random_post_[x][y] == 0 or num >= 100 then
			if num >= 100 then
				logError("随机位置错误")
			end
            MapPanel.RandomPosSetActive(x, y, 1)
            pos = {x, y}
            break
        end
    end
    return pos
end

function MapPanel.RandomPosMission(xx, yy, size)
    local pos = {0, 0}
	local num = 0
    while true do
		num = num + 1
        local x = xx + math.random(-size, size)
        local y = yy + math.random(-size, 0)
        if this.random_post_[x][y] == 0 or num >= 100 then
			if num >= 100 then
				logError("随机位置错误")
			end
            MapPanel.RandomPosSetActive(x, y, 1)
            pos = {x, y}
            break
        end
    end
    return pos
end

function MapPanel.RandomPosSetActive(x, y, bol)
    for i = -bol, bol do
		for j = -bol, bol do
			if x + i >= 0 and x + i < MapPanel.map_len and y + j >= 0 and y + j < MapPanel.map_len then
				this.random_post_[x + i][y + j] = this.random_post_[x + i][y + j] + 1
			end
        end
    end
end

function MapPanel.find_nearest(x, y, selfx, selfy)
	local f = false
	local index = -1
	local dis = -1
	local p = nil
	for i = 1, #this.const_near_ do
		if f then
			if this.const_near_[i][2] > this.const_near_[index][2] then
				return p
			end
		end
		local xx = this.const_near_[i][1][1] + x
		local yy = this.const_near_[i][1][2] + y
		if this.obstacles_[xx] ~= nil then
			if this.obstacles_[xx][yy] == true then
				local d = math.max(math.abs(selfx - xx), math.abs(selfy - yy))
				if f == false or d < dis then
					f = true
					index = i
					dis = d
					p = {xx, yy}
				end
			end
		end
    end
	return p
end

function MapPanel.adjust_map()
    local x = this.cur_pos_[1]
    local y = this.cur_pos_[2]
    local px = (x - y) * -32
    local py = (y + x) * -16
    local tm = 0
    local fx = x
    local fy = y
    if this.is_move_ then
        tm = (this.const_move_time_ - this.move_time_) / this.const_move_time_
        px = px + this.const_orient_[this.orient_][1] * 32 * tm
        py = py + this.const_orient_[this.orient_][2] * 16 * tm
        fx = x - this.move_orient_[this.orient_][1] * tm
        fy = y - this.move_orient_[this.orient_][2] * tm
    end
    local rx = 0
    local ry = 0
    local uw = GUIRoot.UIRoot:GetComponent("RectTransform").rect.width
    local uh = GUIRoot.UIRoot:GetComponent("RectTransform").rect.height
    local l = uw / 2 + this.background_.localPosition.x
    local r = l + this.background_:GetComponent("RawImage").rectTransform.rect.width - uw
    local b = uh / 2 + this.background_.localPosition.y
    local t = b + this.background_:GetComponent("RawImage").rectTransform.rect.height - uh
    if px + l > 0 then
        rx = -px - l
        px = -l
    elseif px + r < 0 then
        rx = -px - r
        px = -r
    end
    if py + b > 0 then
        ry = -py - b
        py = -b
    elseif py + t < 0 then
        ry = -py - t
        py = -t
    end
    this.bias_pos_ = Vector3(px, py, 0)
    this.map_.localPosition = Vector3(px, py, 0)
    this.hero_.localPosition = Vector3(rx, ry, 0)
end

function MapPanel.GetVector(x, y)
    return Vector3((x - y) * 32, (y + x) * 16, 0)
end

function MapPanel.get_xy(v)
    local x = math.modf(v.x)
    local y = math.modf(v.y)
    local fx = math.modf(x / 64)
    local fy = math.modf(y / 32)
    local xx = math.fmod(x, 64)
    local yy = math.fmod(y, 32)
    if xx < 0 then
        fx = fx - 1
        xx = xx + 64
    end
    if yy < 0 then
        fy = fy - 1
        yy = yy + 32
    end
    x = fx + fy + 1
    y = fy - fx
    if xx < 32 and yy < 16 and (16 - yy) * 2 > xx then
        x = x - 1
    elseif xx >= 32 and yy < 16 and yy * 2 < xx - 32 then
        y = y - 1
    elseif xx < 32 and yy >= 16 and (yy - 16) * 2 > xx then
        y = y + 1
    elseif xx >= 32 and yy >= 16 and (32 - yy) * 2 < xx - 32 then
        x = x + 1
    end
    return {x, y}
end

function MapPanel.get_orient(p1, p2)
    if p1[1] == p2[1] and p1[2] == p2[2] then
        return 0
    elseif p1[1] < p2[1] and p1[2] < p2[2] then
        return 1
    elseif p1[1] > p2[1] and p1[2] < p2[2] then
        return 2
    elseif p1[1] > p2[1] and p1[2] > p2[2] then
        return 3
    elseif p1[1] < p2[1] and p1[2] > p2[2] then
        return 4
    elseif p1[2] < p2[2] then
        return 5
    elseif p1[1] > p2[1] then
        return 6
    elseif p1[2] > p2[2] then
        return 7
    elseif p1[1] < p2[1] then
        return 8
    end
    return 0
end

function MapPanel.calc_move()
    if #this.path_list_ > 0 then
        this.target_pos_ = this.path_list_[1]
        table.remove(this.path_list_, 1)
        GameObject.Destroy(this.path_tb_[1])
        table.remove(this.path_tb_, 1)
        this.is_move_ = true
    end
    this.orient_ = MapPanel.get_orient(this.cur_pos_, this.target_pos_)
    if this.orient_ == 0 then
        this.is_move_ = false
        this.move_time_ = 0
    else
        this.cur_pos_[1] = this.cur_pos_[1] + this.move_orient_[this.orient_][1]
        this.cur_pos_[2] = this.cur_pos_[2] + this.move_orient_[this.orient_][2]
    end
end

function MapPanel.Update()
    if this.go_back_target_ then
        MapPanel.GoBackEffect()
    elseif this.wb_targert_ then
        MapPanel.wbEffect()
    else
        if this.is_move_ then
            this.move_time_ = this.move_time_ + Time.deltaTime
            while this.move_time_ >= this.const_move_time_ do
                this.move_time_ = this.move_time_ - this.const_move_time_

                if this.event_target_ ~= nil then
                    local dis = (Vector3(this.cur_pos_[1], this.cur_pos_[2], 0) - Vector3(this.event_data_.x, this.event_data_.y, 0)).magnitude
                    if dis < 3 then
                        this.event_target_()
                        MapPanel.ClearTarget()
                    end
                end

                if not this.is_move_ then
                    break
                end
                MapPanel.calc_move()
            end
        end
        MapPanel.adjust_map()
        local unit = Hall.GetMapUnit(1).ins
        local ani = unit:GetComponent("Animator")
        if this.orient_ > 0 then
            unit.transform.localEulerAngles = Vector3(0, this.orient_retate_[this.orient_], 0)
        end

        if this.is_move_ then
            if unit.activeInHierarchy then
                if not ani:GetCurrentAnimatorStateInfo(0):IsName("walk") then
                    ani:Play("walk")
                end
            end
        else
            if unit.activeInHierarchy then
                if not ani:GetCurrentAnimatorStateInfo(0):IsName("stand") then
                    ani:Play("stand")
                end
            end
        end

        MapPanel.MapXyQuest()
        BasicUIPanel.OrientShow(this.cur_map_id_, {this.cur_pos_[1], this.cur_pos_[2]})

        if Input.GetMouseButtonDown(0) then
            local obj = panelMgr:SelectedUIObject()
            if obj ~= nil and obj.name == "background" then
                MapPanel.ClearTarget()
                local v = Input.mousePosition
                local rect = this.ins_.transform:GetComponent("RectTransform")
                local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, v, GUIRoot.UICamera, nil)
                v.x = pos.x
                v.y = pos.y
                v.z = 0
                v = v - this.bias_pos_
                local v2 = MapPanel.get_xy(v)
                MapPanel.Goto(v2)
            end
        end
    end
    end

function MapPanel.Goto(tpos)
    local path_list = MapPanel.PathFinder(tpos)
    if #path_list > 0 then
        this.path_list_ = path_list
        MapPanel.ResetPath()
    else
        MapPanel.Stop()
        return
    end
    if not this.is_move_ then
        this.is_move_ = true
        this.move_time_ = this.const_move_time_
	end
end

function MapPanel.Stop()
    this.path_list_ = {}
    MapPanel.ResetPath()
    this.target_pos_ = this.cur_pos_
end

function MapPanel.PathFinder(tpos)
    if this.obstacles_[tpos[1]][tpos[2]] == false then
		local p = MapPanel.find_nearest(tpos[1], tpos[2], this.cur_pos_[1], this.cur_pos_[2])
        if p == nil then
            return {}
        else
            tpos = p
        end
    end
    if tpos[1] == this.cur_pos_[1] and tpos[2] == this.cur_pos_[2] then
        return {}
    end
    return MapPanel.RoutePlan(tpos)
end

function MapPanel.MakePIndex(x, y)
	return y * MapPanel.map_len + x
end

-- 寻路
function MapPanel.RoutePlan(tpos)
    local father_point = {}
    local open_list = {}
    local str = MapPanel.MakePIndex(this.cur_pos_[1], this.cur_pos_[2])
    father_point[str] = {{-1, -1}, 0}
    table.insert(open_list, this.cur_pos_)
    while #open_list ~= 0 do
        local cur_pos = open_list[1]
        if tpos[1] == cur_pos[1] and tpos[2] == cur_pos[2] then
            break
        end
        str = MapPanel.MakePIndex(cur_pos[1], cur_pos[2])
        local cnt = father_point[str][2] + 1
        table.remove(open_list, 1)
        for i = #this.move_orient_, 1, -1 do
            local point = {cur_pos[1] + this.move_orient_[i][1], cur_pos[2] + this.move_orient_[i][2]}
            if this.obstacles_[point[1]] ~= nil then
				if this.obstacles_[point[1]][point[2]] == true then
					str = MapPanel.MakePIndex(point[1], point[2])
					if father_point[str] == nil then
						father_point[str] = {cur_pos, cnt}
						table.insert(open_list, point)
					end
				end
            end
        end
    end
	
    local ans_list = {}
    str = MapPanel.MakePIndex(tpos[1], tpos[2])
    if father_point[str] ~= nil then
        local temp_list = {}
        local point = tpos
        while true do
            table.insert(temp_list, point)
            str = MapPanel.MakePIndex(point[1], point[2])
            if father_point[str] ~= nil then
                point = father_point[str][1]
				str = MapPanel.MakePIndex(point[1], point[2])
                if father_point[str] ~= nil then
                    if father_point[str][2] == 0 then
                        break
                    end
                end
            else
                break
            end
        end
        for i = #temp_list, 1, -1 do
            table.insert(ans_list, temp_list[i])
        end
    end
    return ans_list
end

------功能---------

function MapPanel.ResetPath()
    for i = 1, #this.path_tb_ do
        GameObject.Destroy(this.path_tb_[i])
    end
    this.path_tb_ = {}
    local pre = this.cur_pos_
    for i = 1, #this.path_list_ do
        local o = MapPanel.get_orient(pre, this.path_list_[i])
        local obj = GameObject.Instantiate(this.fx_.gameObject)
        obj.transform:SetParent(this.paths_, false)
        obj.transform.localPosition = MapPanel.GetVector(pre[1], pre[2])
        obj.transform.localScale = Vector3.one
        obj:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.const_orient_name_[o])
        obj:SetActive(true)
        table.insert(this.path_tb_, obj)
        pre = this.path_list_[i]
    end
end

function MapPanel.ClearTarget()
	this.event_target_ = nil
	this.event_data_ = nil
	MapPanel.Stop()
end

--------------------------------------------------------------------------------

function MapPanel.BuildInit(map_id)
    local map_build_datas = {}
    for _, v in pairs(Config.t_map_build) do
        if v.map == map_id then
            table.insert(map_build_datas, v)
        end
    end
    for i = 1, #map_build_datas do
		local t_map_build = map_build_datas[i]
        local obj = GameObject.Instantiate(this.map_element_res_.gameObject)
        if t_map_build.type == 2 then
            obj.transform:Find("map_portal").gameObject:SetActive(true)
        end
        obj.transform:Find("map_element/element_name"):GetComponent("LocalizationText").text = t_map_build.name
        obj.name = string.format("id%s_type%s", t_map_build.id, t_map_build.type)
        obj.transform:SetParent(this.items_, false)
        MapPanel.RandomPosSetActive(t_map_build.x, t_map_build.y, 2)
        obj.transform.localPosition = MapPanel.GetVector(t_map_build.x, t_map_build.y)
        obj.transform.localScale = Vector3.one
        MapPanel.SetElement("build", t_map_build, obj, t_map_build.x, t_map_build.y)
        GameSys.ButtonRegister(this.lua_script_, obj.gameObject, "click", MapPanel.BuildClick, t_map_build, false)
        obj:SetActive(true)
    end
end

function MapPanel.BuildClick(obj, params)
	MapPanel.ClearTarget()
    this.event_data_ = MapPanel.GetElement("build", params.id)
    this.event_target_ = MapPanel.BuildEvent
    MapPanel.Goto({this.event_data_.x, this.event_data_.y})
end


function MapPanel.BuildEvent()
    if this.event_data_ ~= nil then
        if this.event_data_.config.type == 1 then
            GUIRoot.ShowPanel("SelectPanel", {"是否回城",
                                              function ()
                                                  MapPanel.ReSetMap(this.cur_map_id_, 0)
                                              end,
                                              nil, ""})
        elseif this.event_data_.config.type == 2 then
            if this.event_data_.config.available == 0 then
                GUIRoot.ShowPanel("MessagePanel",{"该区域尚未开放"})
            elseif MapPanel.MapUnlock(this.event_data_.config.def1) then
                GUIRoot.ShowPanel("LoadingPanel", {function (params)
                    MapPanel.ReSetMap(params[1],params[2])
                end, {this.cur_map_id_, this.event_data_.config.def1}})
            else
                GUIRoot.ShowPanel("MessagePanel",{"前方危险"})
            end
        end
    end
end

--------------------------------------------------------------------------------

function MapPanel.NpcInit(map_id)
	local cur_npc_data = {}
    for _, v in pairs(Config.t_npc) do
        if v.map == map_id then
            table.insert(cur_npc_data, v)
        end
    end
    for i = 1, #cur_npc_data do
		local t_npc = cur_npc_data[i]
        local obj = GameObject.Instantiate(this.map_npc_res_.gameObject)
        obj.transform:SetParent(this.items_, false)
        obj.transform.localPosition = MapPanel.GetVector(t_npc.x, t_npc.y)
        obj.transform.localScale = Vector3.one
        MapPanel.RandomPosSetActive(t_npc.x, t_npc.y, 2)
        obj.transform:Find("monster_name"):GetComponent("LocalizationText").text = t_npc.name
        if t_npc.npc_type == 1 then
            obj.transform:Find("map_npc_head_back").gameObject:SetActive(true)
            obj.transform:Find("map_npc_head_back/map_npc_res/icon"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "npc"):GetSprite(t_npc.icon)
        else
            obj.transform:Find("npc_build").gameObject:SetActive(true)
            obj.transform:Find("npc_build"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "npc"):GetSprite(t_npc.icon)
            obj.transform:Find("npc_build"):GetComponent("Image"):SetNativeSize()

            local rect = obj.transform:Find("npc_build"):GetComponent("RectTransform").anchoredPosition
            obj.transform:Find("npc_build"):GetComponent("RectTransform").anchoredPosition = Vector3(rect.x + t_npc.offset_x, rect.y, rect.z)
        end
        local has, type = QuestManger.NpcHasQuest(t_npc.id)
        if has then
            obj.transform:Find("quest_bs").gameObject:SetActive(true)
            obj.transform:Find("quest_bs"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.quest_type_[type])
        end
        obj.name = string.format("npc_%s", t_npc.id)
        MapPanel.SetElement("npc", t_npc, obj, t_npc.x, t_npc.y)
        MapPanel.RandomPosSetActive(t_npc.x, t_npc.y, 2)
        GameSys.ButtonRegister(this.lua_script_, obj.gameObject, "click", MapPanel.NpcClick, t_npc, false)
        if GameSys.NpcShow(t_npc) then
            obj:SetActive(true)
        end
    end
end

function MapPanel.NpcClick(obj, params)
	MapPanel.ClearTarget()
    this.event_data_ = MapPanel.GetElement("npc", params.id)
    this.event_target_ = MapPanel.NpcEvent
	MapPanel.Goto({this.event_data_.x, this.event_data_.y})
end

function MapPanel.NpcEvent()
    QuestManger.NpcOnClick(this.event_data_.config.id)
end

--------------------------------------------------------------------------------

function MapPanel.MissionInit(map_id)
	local map_mission_datas = {}
    for _, v in pairsByKeys(Config.t_mission) do
        if v.chapter == map_id then
            table.insert(map_mission_datas, v)
        end
    end
    for i = 1, #map_mission_datas do
		local t_mission = map_mission_datas[i]
		local obj = GameObject.Instantiate(this.map_monster_res_.gameObject)
		obj.transform:SetParent(this.items_, false)
		local pos = nil
		local cur_monster = Config.get_config_value("t_monster", t_mission.monsterid)
		local cur_monster_role = Config.get_config_value("t_role", cur_monster.role_id)
		if cur_monster ~= nil then
			local r = Hall.ShowMap(1, cur_monster.role_id)
			local rimg = obj.transform:Find("image"):GetComponent("RawImage")
			rimg.texture = Hall.Camera.targetTexture
			rimg.uvRect = r
			local text = string.format("Lv %s %s", cur_monster.level, cur_monster_role.name)
			obj.transform:Find("monster_level"):GetComponent("LocalizationText").text = GameSys.set_color(t_mission.diff, text)
			if t_mission.diff == 1 then
				pos = MapPanel.RandomPosMission(t_mission.x, t_mission.y, 4)
				obj.transform:Find("image"):GetComponent("RectTransform").sizeDelta = Vector2(160, 160)
				obj.transform:Find("image").localPosition = Vector3(-15, -26, 0)
				obj.transform:GetComponent("Image").enabled = false
			elseif t_mission.diff == 4 then
				pos = MapPanel.RandomPosMission(t_mission.x, t_mission.y, 4)
				obj.transform:Find("image"):GetComponent("RectTransform").sizeDelta = Vector2(192, 192)
				obj.transform:Find("image").localPosition = Vector3(-18, -30, 0)
				obj.transform:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("zjdt_ui005b")
				obj.transform:Find("monster_level"):GetComponent("LocalizationText").fontSize = 20
			else
				pos = {t_mission.x, t_mission.y}
				MapPanel.RandomPosSetActive(pos[1], pos[2], 2)
				obj.transform:Find("image"):GetComponent("RectTransform").sizeDelta = Vector2(256, 256)
				obj.transform:Find("image").localPosition = Vector3(-26, -35, 0)
				obj.transform:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("zjdt_ui005a")
				obj.transform:GetComponent("RectTransform").sizeDelta = Vector2(160, 107)
				obj.transform:Find("monster_level"):GetComponent("LocalizationText").fontSize = 28
			end
		end
		local vis = 1
        if not MapPanel.MissionTime(t_mission.id) then
            vis = 0
            obj.transform:Find("image").gameObject:SetActive(false)
            obj.transform:Find("mb").gameObject:SetActive(true)
            obj.transform:Find("monster_level").gameObject:SetActive(false)
        end
		obj.transform.localPosition = MapPanel.GetVector(pos[1], pos[2])
		obj.transform.localScale = Vector3.one
		local click_obj = obj.transform:Find("monster_btn")
		click_obj.name = string.format("id%s_monster%s", t_mission.id, t_mission.monsterid)
		MapPanel.SetElement("mission", t_mission, obj, pos[1], pos[2], vis)
		GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", MapPanel.MissionClick, t_mission, false)
		obj:SetActive(true)
    end
end

function MapPanel.MissionClick(obj, params)
	MapPanel.ClearTarget()
    this.event_data_ = MapPanel.GetElement("mission", params.id)
    this.event_target_ = MapPanel.MissionEvent
    MapPanel.Goto({this.event_data_.x, this.event_data_.y})
end

function MapPanel.MissionEvent()
    if this.event_data_ ~= nil then
        if MapPanel.MissionTime(this.event_data_.config.id) then
            if QuestManger.NeedOverCondition(this.event_data_.config.task) or this.event_data_.config.task == 0 then
                if this.event_data_.config.diff == 4 and PlayerData.player.mission_ex == 1 and GameSys.QyRandom() then
                    soundMgr:play_sound("counter")
                    Battle.GoBattle(Battle.BATTLE_TYPE.mission_ex, {}, State.state.ss_map, MapPanel.ResetData())
                    timerMgr:RemoveRepeatTimer('BossDieTime')
                    UpdateBeat:Remove(MapPanel.Update, MapPanel)
                    return
                end
                soundMgr:play_sound("counter")
                Battle.GoBattle(Battle.BATTLE_TYPE.mission, {this.event_data_.config.id}, State.state.ss_map, MapPanel.ResetData())
                timerMgr:RemoveRepeatTimer('BossDieTime')
                UpdateBeat:Remove(MapPanel.Update, MapPanel)
            else
                GUIRoot.ShowPanel("MessagePanel", {"对方并不想搭理你"})
            end

        else
            GUIRoot.ShowPanel("MessagePanel", {"复活中"})
        end
    end
end

function MapPanel.SetElement(type, data, obj, x, y, vis)
    local element_data = {}
    element_data.id = data.id
    element_data.config = data
    if x ~= nil and y ~= nil then
        element_data.x = x
		element_data.y = y
    end
	if vis ~= nil then
		element_data.vis = vis
	else
		element_data.vis = 1
	end
    element_data.obj = obj
    if this.element_obj_[type] == nil then
        this.element_obj_[type] = {}
    end
    table.insert(this.element_obj_[type], element_data)
end

function MapPanel.GetElement(type, id)
    for i = 1, #this.element_obj_[type] do
        if this.element_obj_[type][i].id == id then
            return this.element_obj_[type][i]
        end
    end
    return nil
end

--------------------------------------------------------------------------------

function MapPanel.MapUnlock(map_id)
    local map = Config.get_config_value("t_map", map_id)
    if map ~= nil then
        if map.map_param == 0 or QuestManger.NeedOverCondition(map.map_param) then
            return true
        end
    end
    return false
end

function MapPanel.DungeonInit(map_id)
    local cur_dungeon_fixed = {}
    for _, v in pairs(Config.t_dungeon) do
        if v.map == map_id then
            table.insert(cur_dungeon_fixed, v)
        end
    end
    -----------------固定副本---------------------------
    for i = 1, #cur_dungeon_fixed do
        local fixed_dungeon = cur_dungeon_fixed[i]
        local obj = GameObject.Instantiate(this.map_element_res_.gameObject)
        if fixed_dungeon.type == 1 then
            obj.transform:Find("map_dungeon").gameObject:SetActive(true)
            local r = Hall.ShowMap(2, "csm_a01")
            local rimg = obj.transform:Find("map_dungeon"):GetComponent("RawImage")
            rimg.texture = Hall.Camera.targetTexture
            rimg.uvRect = r
        else
            obj.transform:Find("map_artifact_dungeon").gameObject:SetActive(true)
        end
        obj.transform:Find("map_element/element_name"):GetComponent("LocalizationText").text = fixed_dungeon.name
        obj.name = string.format("id%s_num%s", fixed_dungeon.id, i)
        obj.transform:SetParent(this.items_, false)
        obj.transform.localPosition = MapPanel.GetVector(fixed_dungeon.x, fixed_dungeon.y)
        MapPanel.RandomPosSetActive(fixed_dungeon.x, fixed_dungeon.y, 2)
        obj.transform.localScale = Vector3.one
        MapPanel.SetElement("dungeon", fixed_dungeon, obj, fixed_dungeon.x, fixed_dungeon.y)
        GameSys.ButtonRegister(this.lua_script_, obj.gameObject, "click", MapPanel.DungeonClick, fixed_dungeon, false)
        obj:SetActive(true)
    end
end

function MapPanel.DungeonClick(obj, params)
    MapPanel.ClearTarget()
    this.event_data_ = MapPanel.GetElement("dungeon", params.id)
    this.event_target_ = MapPanel.DungeonEvent
    MapPanel.Goto({this.event_data_.x, this.event_data_.y})
end

function MapPanel.DungeonEvent()
    if this.event_data_ ~= nil then
        MapPanel.DungeonConclude(this.event_data_)
    end
end

function MapPanel.GoDungeon(dungeon_id, dungeon_event_id)
    soundMgr:play_sound("counter")
    Battle.GoBattle(Battle.BATTLE_TYPE.dungeon,{{dungeon_id, dungeon_event_id}}, State.state.ss_map, MapPanel.ResetData())
    UpdateBeat:Remove(MapPanel.Update, MapPanel)
    timerMgr:RemoveRepeatTimer('BossDieTime')
end

function MapPanel.DungeonConclude(build_config)
    local name = build_config.config.name
    local has, dungeon_event_id = MapPanel.GetDungeonEvent(build_config.id)
    if has then
        MapPanel.GoDungeon(build_config.id, dungeon_event_id)
    else

        local t_item_id = nil
        if build_config.config.type == 1 then
            t_item_id = Config.get_config_value("t_const", "dungeon_item").value
        else
            t_item_id = Config.get_config_value("t_const", "dungeon_artifact").value
        end
        if t_item_id == 0 or t_item_id == nil then
            GUIRoot.ShowPanel("MessagePanel", {"dungeon_item错误"})
            return
        end
        local asset = {}
        asset.type = 2
        asset.value1 = t_item_id
        if GameSys.GetAssetCount(2, t_item_id) > 0 then
            local str = string.format("是否消耗一个%s挑战「%s」副本", GameSys.GetAssetName(asset),name)
            GUIRoot.ShowPanel("SelectPanel",{str, function ()
                    local msg = mission_msg_pb.cmsg_dungeon()
                    this.server_dungeon = build_config.id
                    msg.dungeon_id = build_config.id
                    local data = msg:SerializeToString()
                    GameTcp.Send(opcodes.CMSG_DUNGEON, data, { opcodes.SMSG_DUNGEON })
            end, nil, ""})
        else
            GUIRoot.ShowPanel("MessagePanel", {string.format("%s不足", GameSys.GetAssetName(asset))})
        end

    end
end

function MapPanel.GetDungeonEvent(dungeon_id)
    for i = 1, #PlayerData.player.dungeons do
        if dungeon_id == PlayerData.player.dungeons[i] and PlayerData.player.dungeon_tags[i] == 0 then
            return true , PlayerData.player.dungeon_events[i]
        end
    end
    return false , 0
end

function MapPanel.GoBack()
    MapPanel.Stop()
    GUIRoot.ShowPanel("SelectPanel", {"是否回城",
                                      function ()
                                          this.go_back_silder = 100
                                          this.go_back_tip_text_.gameObject:SetActive(true)
                                          this.mask_.gameObject:SetActive(true)
                                          this.go_back_target_ = true
                                      end,
                                      nil, ""})

end

function MapPanel.GoBackEffect()
    if this.go_back_silder > 0 then
        this.go_back_silder = this.go_back_silder - Time.deltaTime * 60
    end
    this.silder_:GetComponent("Image").fillAmount = this.go_back_silder / 100
    if this.go_back_silder <= 0 then
        this.go_back_target_ = false
        MapPanel.ReSetMap(this.cur_map_id_, 0)
    end
end

function MapPanel.GoPortal(obj, params)
    local go_map_ = params[1]
    GUIRoot.ShowPanel("LoadingPanel", {function (params)
        GUIRoot.ClosePanel("MapPanel")
        GUIRoot.ShowPanel("MapPanel", params)
    end, {this.cur_map_id_, tonumber(go_map_)}})
end

function MapPanel.MapXyQuest()
    local has, quest_id = QuestManger.HasQuestXy({this.cur_map_id_, this.cur_pos_[1], this.cur_pos_[2]})
    if has then
        MapPanel.OnPenWbBtn(2, quest_id)
    else
        if not this.wb_targert_ then
            this.wb_cz_.gameObject:SetActive(false)
			UIEffect.Hide("ui_mine01")
        end
    end
end

function MapPanel.ResetData()
    local data_map = {}
    data_map.battle_end = true
    data_map.cur_map_id = this.cur_map_id_
    data_map.pre_map_id = this.cur_map_id_
    data_map.x = this.cur_pos_[1]
    data_map.y = this.cur_pos_[2]
    return data_map
end

function MapPanel.OnPenWbBtn(btn_type, event_id)
    this.wb_silder_ = 0
    this.qd_an_dt_:GetComponent("Image").fillAmount = this.wb_silder_
    this.cj_btn_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.wb_cz_image[btn_type])
    GameSys.ButtonRegister(this.lua_script_, this.cj_btn_.gameObject, "click", MapPanel.BackWbEffect, {btn_type, event_id})
    this.wb_cz_.gameObject:SetActive(true)
	local r = UIEffect.Show("ui_mine01")
    this.wb_effect_.uvRect = r
end

function MapPanel.BackWbEffect(obj, params)
    this.mask_.gameObject:SetActive(true)
    MapPanel.Stop()
    this.wb_id_ = params
    this.wb_silder_ = 0
    this.wb_targert_ = true

end

function MapPanel.wbEffect()
    if this.wb_silder_ < 2 then
        this.wb_silder_ = this.wb_silder_ + Time.deltaTime
    end
    if this.wb_silder_ > 2 then
        this.wb_silder_ = 2
        this.wb_targert_ = false
        MapPanel.WB()
    end
    this.qd_an_dt_:GetComponent("Image").fillAmount = this.wb_silder_ / 2
end

function MapPanel.WB()
    ---执行挖宝的操作
    QuestManger.DirClick(this.wb_id_[2])
end

function MapPanel.QuestRefresh()
    if this.element_obj_["npc"] ~= nil then
        for _,v in pairs(this.element_obj_["npc"]) do
            local has, type = QuestManger.NpcHasQuest(v.config.id)
            if GameSys.NpcShow(v.config) then
                if has then
                    v.obj.transform:Find("quest_bs").gameObject:SetActive(true)
                else
                    v.obj.transform:Find("quest_bs").gameObject:SetActive(false)
                end
                v.obj.transform:Find("quest_bs"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.quest_type_[type])
                v.obj:SetActive(true)
            else
                v.obj:SetActive(false)
            end
        end
    end

    MapPanel.Check()
end

function MapPanel.Refresh()
    if this.element_obj_["mission"] ~= nil then
        for i = 1, #this.element_obj_["mission"] do
            local id = this.element_obj_["mission"][i].config.id
            local show, index = MapPanel.MissionTime(id)
            if this.element_obj_["mission"][i].vis == 0 then
                if index ~= nil then
                    local time = tonumber(PlayerData.player.mission_time[index]) - tonumber(timerMgr:now_string())
                    this.element_obj_["mission"][i].obj.transform:Find("image").gameObject:SetActive(false)
                    this.element_obj_["mission"][i].obj.transform:Find("mb").gameObject:SetActive(true)
                    this.element_obj_["mission"][i].obj.transform:Find("mb/time"):GetComponent("LocalizationText").text = count_time(time)
                    this.element_obj_["mission"][i].obj.transform:Find("monster_level").gameObject:SetActive(false)
                end
            end

            if this.element_obj_["mission"][i].vis == 0 and show and not this.map_image_show_ then
                this.element_obj_["mission"][i].vis = 1
                this.element_obj_["mission"][i].obj.transform:Find("image").gameObject:SetActive(true)
                this.element_obj_["mission"][i].obj.transform:Find("mb").gameObject:SetActive(false)
                this.element_obj_["mission"][i].obj.transform:Find("monster_level").gameObject:SetActive(true)
            end
        end
    end
end

function MapPanel.MissionTime(mission_id)
    for i = 1, #PlayerData.player.mission do
        if mission_id == PlayerData.player.mission[i] then
            local now_t = tonumber(timerMgr:now_string())
            local die_time = tonumber(PlayerData.player.mission_time[i])
            if now_t < die_time then
                return false, i
            end
        end
    end
    return true, nil
end

function MapPanel.Check()
    if this.element_obj_["mission"] ~= nil then
        for k, v in  pairs(this.element_obj_["mission"]) do
            if v.vis == 1 and not MapPanel.MissionTime(v.config.id) then
                v.vis = 0
            end
        end
    end
end

function MapPanel.PlayerPanelState()
   this.map_image_show_ = not this.map_image_show_
    for i = 1, #this.element_obj_["mission"] do
        local b_obj = this.element_obj_["mission"][i].obj
        if b_obj ~= nil then
            if this.element_obj_["mission"][i].vis == 1 then
                b_obj.transform:Find("image").gameObject:SetActive(this.map_image_show_)
            end
        end
    end
end

function MapPanel.BattleEnd(message)
    local type = message.m_object[0]
    local win = message.m_object[1]
    if type == Battle.END_TYPE.normal then
        if not win then
            MapPanel.ReSetMap(this.cur_map_id_, 0)
            return
        end
    end
    timerMgr:AddRepeatTimer('BossDieTime', MapPanel.Refresh, 0.1, 0.1)
    UpdateBeat:Add(MapPanel.Update, MapPanel)
    this.map_name_show_.gameObject:SetActive(false)
    MapPanel.Check()
	MapPanel.Save()
end

function MapPanel.ReSetMap(cur_map_id, go_map_id)
    this.map_portal_ = {cur_map_id, go_map_id}
    local msg = mission_msg_pb.cmsg_map_go()
    msg.map_id = go_map_id
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_MAP_GO, data, { opcodes.SMSG_MAP_GO })
end

function MapPanel.Save()
	local msg = {}
    msg.map_id = this.cur_map_id_
	msg.x = this.cur_pos_[1]
	msg.y = this.cur_pos_[2]
	local data = json.encode(msg)
    PlayerPrefs.SetString('save_map', data)
	PlayerPrefs.Save()
end

function MapPanel.Load()
    if PlayerPrefs.HasKey('save_map') then
		local data = PlayerPrefs.GetString('save_map')
		xpcall(MapPanel.LoadMsg, MapPanel.LoadFail, data)
    end
end

function MapPanel.LoadMsg(data)
	this.map_saved_msg_ = json.decode(data)
end

function MapPanel.LoadFail()
	this.map_saved_msg_ = nil
end

function MapPanel.OnDisconnect()
    MapPanel.ClearTarget()
end

---net message---

function MapPanel.SMSG_DUNGEON(message)
    local msg = mission_msg_pb.smsg_dungeon()
    msg:ParseFromString(message.luabuff)
    local index = -1
    local dungeon_id = this.server_dungeon
    local t_dungeon = Config.get_config_value('t_dungeon', dungeon_id)
    for i = 1, #PlayerData.player.dungeons do
        if PlayerData.player.dungeons[i] == dungeon_id then
            index = i
            break
        end
    end

    local dungeon_item
    if t_dungeon.type == 1 then
        dungeon_item = Config.get_config_value('t_const', 'dungeon_item').value
    else
        dungeon_item = Config.get_config_value('t_const', 'dungeon_artifact').value
    end

    PlayerData.remove_item(dungeon_item, 1)

    local assets = common_msg_pb.msg_assets()
    local data = assets:SerializeToString()
    if index ~= -1 then
        PlayerData.player.dungeon_tags[index] = 0
        PlayerData.player.dungeon_cengs[index] = 1
        PlayerData.player.dungeon_events[index] = msg.dungeon_event
        PlayerData.player.dungeon_assets[index] = data
    else
        table.insert(PlayerData.player.dungeons, this.server_dungeon)
        table.insert(PlayerData.player.dungeon_tags, 0)
        table.insert(PlayerData.player.dungeon_cengs, 1)
        table.insert(PlayerData.player.dungeon_events, msg.dungeon_event)
        table.insert(PlayerData.player.dungeon_assets, data)
    end
    MapPanel.GoDungeon(this.server_dungeon, msg.dungeon_event)
    MapPanel.Check()
end

function MapPanel.MapNameShow()
    this.map_name_show_.gameObject:SetActive(true)
    this.map_name_show_:GetComponent("Animator"):Play("map_name_show", 0, 0)
end

function MapPanel.SMSG_MAP_GO(message)
    if this.map_portal_ ~= nil then
        -- GUIRoot.ShowPanel("NarratorPanel", {this.map_portal_[2], nil})
        if this.map_portal_[2] == PlayerData.player.aside then
            PlayerData.player.aside = PlayerData.player.aside + 1
        end

        PlayerData.player.in_map = this.map_portal_[2]
        if PlayerData.player.in_map == 0 then
            State.ChangeState(State.state.ss_hall)
        else
            local map_data = {}
            map_data.cur_map_id = this.map_portal_[2]
            map_data.pre_map_id = this.map_portal_[1]
            MapPanel.OnParam(map_data)
        end
    end
    this.map_portal_ = nil
end
