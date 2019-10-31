Hall = {}

Hall.HallRoot = nil
Hall.HallUnitRoot = nil
Hall.Camera = nil
local unit_
local r_
local bias_ = -0.05
local mpos_ = {{0.61 + bias_* 2, 1.73}, {-0.31 + bias_, 1.73}, {-0.92 + bias_, 1.73},
				{0.91 + bias_, 1.12}, {0.3 + bias_, 1.12}, {-0.31 + bias_, 1.12}, {-0.92 + bias_, 1.12},
				{0.91 + bias_, 0.51}, {0.3 + bias_, 0.51}, {-0.31 + bias_, 0.51}, {-0.92 + bias_, 0.51},
				{0.91 + bias_, -0.1}, {0.3 + bias_, -0.1}, {-0.31 + bias_, -0.1}, {-0.92 + bias_, -0.1}}
local map_use_ = false
local map_units_ = {}

function Hall.Init()
    Hall.HallRoot = panelMgr.Root:Find("HallRoot")
	Hall.HallRoot.gameObject:SetActive(false)
    Hall.HallUnit = panelMgr.Root:Find("HallRoot/Unit")
	Hall.HallUnit.gameObject:SetActive(false)
    Hall.HallUnitRoot = panelMgr.Root:Find("HallRoot/Unit/UnitRoot")
    Hall.HallMap = panelMgr.Root:Find("HallRoot/Map")
	Hall.HallMap.gameObject:SetActive(false)
    Hall.HallMapRoot = panelMgr.Root:Find("HallRoot/Map/MapRoot")
	Hall.Camera = Hall.HallRoot:Find("HallCamera"):GetComponent("Camera")

    Message.register_handle("battle_start", Hall.BattleStart)
    Message.register_handle("battle_end", Hall.BattleEnd)
end

function Hall.Finish()
	Hall.Hide()
	Hall.HideMap()
	Hall.HallRoot = nil
	Hall.HallUnit = nil
	Hall.HallUnitRoot = nil
	Hall.HallMap = nil
	Hall.HallMapRoot = nil
	Hall.Camera = nil
    Message.remove_handle("battle_start", Hall.BattleStart)
    Message.remove_handle("battle_end", Hall.BattleEnd)
end

function Hall.Show(role_id)
    Hall.HallRoot.gameObject:SetActive(true)
    Hall.HallUnit.gameObject:SetActive(true)
    Hall.HallMap.gameObject:SetActive(false)
    if unit_ ~= nil then
        unit_:Destroy()
    end
    unit_ = nil
    r_ = 0
    unit_ = UnitIns.CreateUnitIns(role_id)
    unit_.ins.transform:SetParent(Hall.HallUnitRoot)
    unit_.ins.transform.localPosition = Vector3.zero
    unit_.ins.transform.localEulerAngles = Vector3.zero
    unit_.ins.transform.localScale = Vector3.one
end

function Hall.ChangePart(equips, role_id)
    unit_:SetFashion(equips, role_id)
end

function Hall.Hide()
    if unit_ ~= nil then
        unit_:Destroy()
        unit_ = nil
    end
    Hall.HallUnit.gameObject:SetActive(false)
    if map_use_ then
        Hall.HallMap.gameObject:SetActive(true)
    else
        Hall.HallRoot.gameObject:SetActive(false)
    end
end

function Hall.Roll(x)
    if unit_ == nil then
        return
    end
    r_ = r_ + x
    unit_.ins.transform.localEulerAngles = Vector3(0, r_, 0)
end

-------------------------------------------------------------------

function Hall.ShowMap(tp, param)
    Hall.HallRoot.gameObject:SetActive(true)
    Hall.HallMap.gameObject:SetActive(true)
    map_use_ = true
    
	local name = ""
	local scale = 1
	local t_role = nil
	if tp == 1 then
		t_role = Config.get_config_value("t_role", param)
		name = t_role.res
		scale = t_role.scale
	elseif tp == 2 then
		name = param
	else
		return nil
	end
	
	for i = 1, #map_units_ do
		if name == map_units_[i].name then
			return Hall.GetRect(i)
		end
	end
    
    local index = #map_units_ + 1
    local obj = UnityEngine.GameObject()
    obj.transform:SetParent(Hall.HallMapRoot)
    obj.transform.localPosition = Vector3(mpos_[index][1], mpos_[index][2], 0)
    obj.transform.localEulerAngles = Vector3(30, 0, 0)
    obj.transform.localScale = Vector3(0.225 * scale, 0.225 * scale, 0.225 * scale)

    local unit = nil
	if tp == 1 then
		if t_role.id < 1000 then
			local equips = GameSys.GetSlotEquipIds()
			local dress_ids = PlayerData.player.equip_shows
			local avatar_ids = GameSys.GetEquipAvatarIds(equips, dress_ids)
			unit = UnitIns.CreateUnitIns(t_role.id, avatar_ids)
		else
			unit = UnitIns.CreateUnitIns(t_role.id, nil)
		end
		unit.ins.transform:SetParent(obj.transform)
		unit.ins.transform.localPosition = Vector3.zero
		unit.ins.transform.localEulerAngles = Vector3(0, -30, 0)
		unit.ins.transform.localScale = Vector3.one
	elseif tp == 2 then
		local go = resMgr.LoadUIEffect(name)
		local unit = GameObject.Instantiate(go)
		unit.transform:SetParent(obj.transform)
		unit.transform.localPosition = Vector3.zero
		unit.transform.localEulerAngles = Vector3.zero
		unit.transform.localScale = Vector3.one
	end
    
	local mu = {}
	mu.tp = tp
	mu.name = name
	mu.obj = obj
	mu.ins = unit
    table.insert(map_units_, mu)
    return Hall.GetRect(index)
end

function Hall.MapChangePart(equips, role_id)
	if map_units_[1] ~= nil then
		map_units_[1].ins:SetFashion(equips, role_id)
	end
end

function Hall.GetRect(index)
	local r = nil
	if index == 1 then
		r = UnityEngine.Rect(0 + 0.015, 3 / 4, 2 / 4 - 0.06, 1 / 4 - 0.03)
	else
		local y = math.floor(index / 4)
		local x = index - y * 4
		r = UnityEngine.Rect(1 / 4 * x + 0.015, 3 / 4 - 1 / 4 * y, 1 / 4 - 0.03, 1 / 4 - 0.03)
	end
    return r
end

function Hall.GetMapUnit(index)
    return map_units_[index].ins
end

function Hall.HideMap()
    for i = 1, #map_units_ do
		local mu = map_units_[i]
		if mu.tp == 1 then
			mu.ins:Destroy()
		elseif mu.tp == 2 then
			resMgr.UnloadUIEffect(mu.name)
		end
        GameObject.Destroy(map_units_[i].obj)
    end
    map_units_ = {}
    map_use_ = false
    Hall.HallMap.gameObject:SetActive(false)
    Hall.HallRoot.gameObject:SetActive(false)
end

function Hall.BattleStart(message)
    if Hall.HallRoot.gameObject.activeSelf then
        Hall.HallRoot.gameObject:SetActive(false)
    end
end

function Hall.BattleEnd(message)
    if unit_ ~= nil or map_use_ then
        Hall.HallRoot.gameObject:SetActive(true)
    end
end
