UnitIns = Object:subclass("UnitIns")

UnitIns.prototype.ins = nil -- 角色实体
UnitIns.prototype.animator = nil -- 角色动画控制器
UnitIns.prototype.effects = nil
UnitIns.prototype.resources = nil
UnitIns.prototype.parts = nil
UnitIns.prototype.effect_points_info = nil --特效点的配置
UnitIns.prototype.effect_points = nil --生成的特效位置点
UnitIns.prototype.move = false
UnitIns.prototype.move_speed = 1
UnitIns.prototype.color_ring_effect = ""
UnitIns.prototype.del_effects = nil

--创建unitIns组件
function UnitIns.CreateUnitIns(role_id, equips)
    local unit_ins = UnitIns()
    unit_ins.effects = {}
    unit_ins.effect_points_info = {}
    unit_ins.move = false
    unit_ins.move_speed = 1
    unit_ins.color_ring_effect = ""
    unit_ins.effect_points = {}
    unit_ins.resources = {}
    unit_ins.parts = {}
    unit_ins.del_effects = {}
    UpdateBeat:Add(unit_ins.Update, unit_ins, unit_ins)
    local res = Config.get_config_value("t_role", role_id).res
    local name = res
    local ins_prefab = resMgr.LoadUnit(name)
    unit_ins.resources[name] = { ins_prefab, 1000 }
    unit_ins.parts["weapon"] = name
    unit_ins.parts["body"] = name
    unit_ins.parts["helmet"] = name
    unit_ins.parts["shoulder"] = name
    unit_ins.parts["shoes"] = name
    unit_ins.parts["glove"] = name
    unit_ins.ins = GameObject.Instantiate(ins_prefab)
    unit_ins.animator = unit_ins.ins:GetComponent("Animator")
    unit_ins.animator:SetFloat("attack_speed", 1)
    ---根据equips换装  ChangePart(部位, 套装名字)  8个?
    unit_ins:SetFashion(equips, role_id)
    return unit_ins
end

--销毁unitIns组件
function UnitIns.prototype:Destroy()
    self:RemoveAllEffects()
    if self.ins ~= nil then
        GameObject.Destroy(self.ins)
        self.ins = nil
        self.animator = nil
    end
    for name in pairs(self.resources) do
        resMgr.UnloadUnit(name)
    end
    self.resources = nil
    self.parts = nil
    UpdateBeat:Remove(self.Update, self, self)
    self.effects = nil
    self.effect_points_info = nil
    self.effect_points = nil
end

--初始化展示
function UnitIns.prototype:InitShow()
    --重置  移除所有特效  恢复 待机状态
    if not self.ins.activeSelf then
        self.ins:SetActive(true)
    end
    self:RemoveAllEffects()
    self.animator:SetTrigger("stand")
end


--设置模型外观
function UnitIns.prototype:SetFashion(equips, role_id)
    local res = Config.get_config_value("t_role", role_id).res
    if equips ~= nil then
        for i = 1, #equips do
            local part = GameSys.GetEquipPart(i)
            if part ~= nil then
                if equips[i] ~= 0 then
                    local t_equip = Config.get_config_value("t_equip", equips[i])
                    self:ChangePart(part, t_equip.res)
                else
                    self:ChangePart(part, res)
                end
            end
        end
    end
end

--取得模型的节点及偏移
function UnitIns.prototype:GetEffectPointsInfo(res)
    local effect_points_info = Battle.GetUnitEffectPoint(res)
    for k, v in pairs(Battle.common_effect_points) do
        if effect_points_info[k] == nil then
            effect_points_info[k] = v
        end
    end
    self.effect_points_info = effect_points_info
end

--设置模型的特效节点
function UnitIns.prototype:SetEffectPoints()
    if next(self.effect_points_info) == nil then
        return
    end
    for k, v in pairs(self.effect_points_info) do
        local bone_tr = Util.FindSub(self.ins.transform, v.name)
        local sub_point = GameObject(k .. "_point")
        sub_point.transform:SetParent(self.ins.transform, false)
        sub_point.transform.position = bone_tr.position + Vector3(v.x, v.y, v.z)
        self.effect_points[k] = sub_point.transform
    end
end

--取得模型的部位
function UnitIns.GetPart(obj, part)
    if part == nil then
        return nil
    end
    local t = obj.transform
    if part == "weapon" then
        t = Util.FindSub(t, "Bip01 R Hand")
    end
    t = t:Find(part)
    if t ~= nil then
        return t.gameObject
    end
    return nil
end

--换装
function UnitIns.prototype:ChangePart(part, name)
    if self.parts[part] == nil then
        return
    end
    if self.parts[part] == name then
        return
    end
    local oldname = self.parts[part]
    local p = UnitIns.GetPart(self.ins, part)
    local pp = nil
    if p ~= nil then
        if part ~= "weapon" then
            local s = p:GetComponent("SkinnedMeshRenderer")
            if s ~= nil then
                GameObject.DestroyImmediate(s)
            end
        else
            pp = p.transform.parent
            GameObject.DestroyImmediate(p)

        end
        local ress = self.resources[oldname]
        ress[2] = ress[2] - 1
        if ress[2] <= 0 then
            resMgr.UnloadUnit(oldname)
            self.resources[oldname] = nil
        end
    end
    local obj = nil
    if self.resources[name] == nil then
        obj = resMgr.LoadUnit(name)
        self.resources[name] = { obj, 1 }
    else
        obj = self.resources[name][1]
        self.resources[name][2] = self.resources[name][2] + 1
    end
    self.parts[part] = name
    local newp = UnitIns.GetPart(obj, part)
    if newp ~= nil then
        if part ~= "weapon" then
            local news = newp:GetComponent("SkinnedMeshRenderer")
            if news ~= nil then
                local bone_root = self.ins.transform:Find("Bip01")
                Util.CopySkinnedMeshRenderer(news, p, bone_root)
            end
        else
            local neww = GameObject.Instantiate(newp)
            neww.name = "weapon"
            neww.transform:SetParent(pp, false)
            neww.transform.localPosition = newp.transform.localPosition
            neww.transform.localEulerAngles = newp.transform.localEulerAngles
            neww.transform.localScale = newp.transform.localScale
        end
    end
end

--受击点
function UnitIns.prototype:GetFlowPointWorldPos()
    return self.effect_points.accept.position
end

--头顶点
function UnitIns.prototype:GetHeadWorldPos()
    return self.effect_points.headtop.position
end

--脚下点
function UnitIns.prototype:GetFootWorldPos()
    return self.ins.transform.position
end

--update effects / move
function UnitIns.prototype:Update()
    if self.ins == nil then
        return
    end
    for i = #self.del_effects, 1, -1 do
        table.remove(self.del_effects, i)
    end
    for effect_name in pairs(self.effects) do
        for i = 1, #self.effects[effect_name] do
            self.effects[effect_name][i].remove_time = self.effects[effect_name][i].remove_time - Time.deltaTime
            if self.effects[effect_name][i].remove_time <= 0 then
                table.insert(self.del_effects, { effect_name, i })
            end
        end
    end
    for i = 1, #self.del_effects do
        self:RemoveEffect(self.del_effects[i][1], self.del_effects[i][2])
    end
    for effect_name in pairs(self.effects) do
        local effect = self.effects[effect_name]
        for i = #effect, 1, -1 do
            if effect[i].ins == nil then
                table.remove(effect, i)
            end
        end
        if next(effect) == nil then
            self.effects[effect_name] = nil
        end
    end
    if self.move then
        local pos = self.ins.transform.position
        local new_pos = Vector3(pos.x, pos.y, pos.z - self.move_speed * Time.deltaTime)
        self.ins.transform.position = new_pos
    end
end

--设置攻击动画的播放速度
function UnitIns.prototype:SetAttackAnimSpeed(speed)
    self.animator:SetFloat("attack_speed", speed)
end

--播放动画
function UnitIns.prototype:PlayAnim(name)
    self.animator:SetTrigger(name)
end

--展示品质光圈
function UnitIns.prototype:ShowColorRingEffect(color)
    local effect_name = Config.get_config_value("t_mission_random", color).effect
    if effect_name == "" then
        self:RemoveColorRingEffect()
    else
        if self.color_ring_effect ~= effect_name then
            self:RemoveColorRingEffect()
        end
        self:ShowEffect(effect_name, "foot", nil, -1 , nil)
        self.color_ring_effect = effect_name
    end
end

--移除品质光圈
function UnitIns.prototype:RemoveColorRingEffect()
    if self.color_ring_effect ~= ""  then
        self:RemoveEffect(self.color_ring_effect)
        self.color_ring_effect = ""
    end
end

--展示特效
function UnitIns.prototype:ShowEffect(effect_name, effect_point, vec ,remove_time, speed)
    if vec == nil then
        vec = { 0, 0 ,0 }
    end
    local go = resMgr.LoadEffect(effect_name)
    local ins = GameObject.Instantiate(go)
    if speed ~= nil then
        local particles = ins:GetComponentsInChildren(typeof(UnityEngine.ParticleSystem), true)
        local length = particles.Length
        for i = 0, length - 1 do
            local main = particles[i].main
            main.simulationSpeed = speed
        end
    end
    local effect_root = self.ins.transform
    local v = Vector3.zero
    if effect_point == "accept" then
        v = self.effect_points.accept.position
    elseif effect_point == "headtop" then
        v = self.effect_points.headtop.position
    elseif effect_point == "foot" then
        v = self.ins.transform.position
    elseif effect_point == "position" then
        effect_root = Scene.UnitRoot
        v = self.ins.transform.position
    else
        v = self.ins.transform.position
    end
    ins.transform:SetParent(effect_root, true)
    ins.transform.position = v
    ins.transform.position =  ins.transform.position + Vector3(vec[1], vec[2], vec[3])
    ins.transform.localEulerAngles = Vector3.zero
    if remove_time < 0 then
        remove_time = Config.get_config_value("t_const", "max_fight_time").value / 1000
    end
    local t = {
        ["remove_time"] = remove_time,
        ["ins"] = ins,
    }
    if self.effects[effect_name] == nil then
        self.effects[effect_name] = {}
    end
    table.insert(self.effects[effect_name], t)
    return ins
end

--移除特效
function UnitIns.prototype:RemoveEffect(effect_name, index)
    if index == nil then
        index = 1
    end
    if self.effects[effect_name] == nil then
        return
    end
    GameObject.Destroy(self.effects[effect_name][index].ins)
    resMgr.UnloadEffect(effect_name)
    self.effects[effect_name][index].ins = nil
end

--移除所有特效
function UnitIns.prototype:RemoveAllEffects()
    local del_effects = {}
    for effect_name in pairs(self.effects) do
        for i = 1, #self.effects[effect_name] do
            table.insert(del_effects, { effect_name, i })
        end
    end
    for i = 1, #del_effects do
        self:RemoveEffect(del_effects[i][1], del_effects[i][2])
    end
    self.effects = {}
end

--播放音效
function UnitIns.prototype:PlaySound(sound_name)

end

--模型旋转
function UnitIns.prototype:Rotate(value)
    local rotation = self.ins.transform.eulerAngles
    local new_rotation = Vector3(rotation.x, rotation.y + value, rotation.z)
    self.ins.transform.eulerAngles = new_rotation
end

--模型可以移动
function UnitIns.prototype:Move(speed)
    self.move = true
    self.move_speed = speed
end

--模型显隐
function UnitIns.prototype:SetActive(active)
    if active == 0 then
        if self.ins.activeSelf then
            self.ins:SetActive(false)
        end
    else
        if not self.ins.activeSelf then
            self.ins:SetActive(true)
        end
    end
end

--升级
function UnitIns.prototype:LevelUp(message)
    self:ShowEffect("levelup", "foot", nil, 2, 1)
end
