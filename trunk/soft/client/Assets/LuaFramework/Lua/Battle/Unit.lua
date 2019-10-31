Unit = Object:subclass("Unit")

Unit.prototype.site = 0
Unit.prototype.max_hp = 0
Unit.prototype.cur_hp = 0  --角色当前血量
Unit.prototype.name = ""
Unit.prototype.level = 0
Unit.prototype.rold_id = 0
Unit.prototype.res = ""
Unit.prototype.pets = nil
Unit.prototype.equips = nil
Unit.prototype.color = nil
Unit.prototype.unit_ins = nil
Unit.prototype.sing_info = nil
Unit.prototype.attack_info = nil
Unit.prototype.hurt_info = nil
Unit.prototype.add_hp_info = nil
Unit.prototype.attack_speed = 1
Unit.prototype.attack_action_index = 0
Unit.prototype.target_site = 0
Unit.prototype.attach_info = nil
Unit.prototype.dizzy = false
Unit.prototype.gedang = false
Unit.prototype.behaviour_states = nil
Unit.prototype.behaviour_id = 0
Unit.prototype.white_time = 0

--创建unit组件
function Unit.CreateUnit(site, name, level, max_hp, role_id, pets, equips, color)
    if Battle.units[site] ~= nil then
        if role_id == Battle.units[site].role_id and GameSys.TableEqual(equips, Battle.units[site].equips) then
            Battle.units[site]:InitData(site, name, level, max_hp, role_id, pets, equips, color)
            return Battle.units[site]
        else
            Battle.units[site]:Destroy()
            Battle.units[site] = nil
        end
    end
    local unit = Unit()
    unit:InitData(site, name, level, max_hp, role_id, pets, equips, color)
    local t_role = Config.get_config_value("t_role", role_id)
    unit.res = t_role.res
    unit.behaviour_list = Battle.GetBehaviours(unit.res)
    unit.unit_ins = UnitIns.CreateUnitIns(role_id, equips)
    unit.unit_ins:GetEffectPointsInfo(unit.res)
    unit.unit_ins:SetEffectPoints()
    UpdateBeat:Add(unit.Update, unit, unit)
    Battle.units[site] = unit
    return unit
end

--销毁unit组件
function Unit.prototype:Destroy()
    if self.unit_ins ~= nil then
        self.unit_ins:Destroy()
        self.unit_ins = nil
    end
    UpdateBeat:Remove(self.Update, self, self)
end

--初始化unit内容
function Unit.prototype:InitData(site, name, level, max_hp, role_id, pets, equips, color)
    self.site = site
    self.name = name
    self.level = level
    self.max_hp = max_hp
    self.cur_hp = max_hp
    self.role_id = role_id
    self.pets = pets
    self.equips = equips
    self.color = color
    self.sing_info = {}
    self.attack_info = {}
    self.hurt_info = {}
    self.add_hp_info = {}
    self.attach_info = {}
    self.dizzy = false
    self.gedang = false
    self.attack_speed = 1
    self.target_site = (10 - self.site)
    self.behaviour_states = {}
    self.behaviour_id = 0
end

--初始化界面和模型的展示
function Unit.prototype:InitSiteShow()
    self.unit_ins.ins.transform:SetParent(Scene.UnitRoot)
    if self.site == 0 then
        self.unit_ins.ins.transform.localPosition = Vector3.zero
        self.unit_ins.ins.transform.localEulerAngles = Vector3.zero
    elseif self.site == 10 then
        self.unit_ins.ins.transform.localPosition = Vector3(0, 0, 3)
        self.unit_ins.ins.transform.localEulerAngles = Vector3(0, 180, 0)
    end
    local t_role = Config.get_config_value("t_role", self.role_id)
    self.unit_ins.ins.transform.localScale = Vector3(t_role.bscale, t_role.bscale, t_role.bscale)
    if self.site == 10 and self.color ~= nil then
        self.unit_ins:ShowColorRingEffect(self.color)
    end
    local flow_pos = self.unit_ins:GetFlowPointWorldPos()
    local sing_point = self.unit_ins:GetFootWorldPos() + Vector3(0, 1.33, 0)
    self.unit_ins:InitShow()
    BattlePanel.InitSitePanel(self.site, self.name, self.level, self.max_hp, self.pets, self.color, flow_pos, sing_point)
end

--update行为
function Unit.prototype:Update()
    local del = {}
    for i = 1, #self.behaviour_states do
        local bs = self.behaviour_states[i]
        local coefficient = GameSys.StringStart(bs.name, "attack") and self.attack_speed or 1
        bs.timer = bs.timer + Time.deltaTime * coefficient
        local action_index = bs.cur_action_index
        if bs.timer >= bs.action_list[action_index].time then
            self:ShowAction(bs.id, bs.action_list[action_index])
            bs.cur_action_index = action_index + 1
        end
        if bs.cur_action_index > bs.actions_count then
            table.insert(del, i)
        end
    end
    table.sort(del, function(a, b)
        return a > b
    end)
    for i = 1, #del do
        table.remove(self.behaviour_states, del[i])
    end
    ---守击 变色
    if self.white_time > 0 then
        self.white_time = self.white_time - Time.deltaTime
        if self.white_time <= 0 then
            self:UnWhite()
        else
            self:DoWhite(self.white_time * 10)
        end
    end
end

--受击准备变白
function Unit.prototype:White()
    self.white_time = 0.1
    self:DoWhite(self.white_time * 10)
end

--受击变白
function Unit.prototype:DoWhite(n)
    local ss = self.unit_ins.ins:GetComponentsInChildren(typeof(UnityEngine.SkinnedMeshRenderer), true)
    for i = 0, ss.Length - 1 do
        local s = ss[i]
        for j = 0, s.materials.Length - 1 do
            local m = s.materials[j]
            if m.shader.name == "yh/Diffuse/Diffuse_metal" and self.role_id <= 1000 then
                m:SetFloat("_bright", n)
            end
            if m.shader.name == "Custom/unit_base" and self.role_id > 1000 then
                m:SetFloat("_while", n)
            end
        end
    end
    ss = self.unit_ins.ins:GetComponentsInChildren(typeof(UnityEngine.MeshRenderer), true)
    for i = 0, ss.Length - 1 do
        local s = ss[i]
        for j = 0, s.materials.Length - 1 do
            local m = s.materials[j]
            if m.shader.name == "yh/Diffuse/Diffuse_metal" and self.role_id <= 1000 then
                m:SetFloat("_bright", n)
            end
            if m.shader.name == "Custom/unit_base" and self.role_id > 1000 then
                m:SetFloat("_while", n)
            end
        end
    end
end

--守击变白结束
function Unit.prototype:UnWhite()
    self:DoWhite(0)
end

------------------------------------------------------------------------------------------------
function Unit.prototype:Ready()
    self:ShowBehaviour("ready")
end

--开始格挡
function Unit.prototype:Gedang()
    self.gedang = true
    self:ShowBehaviour("gedang")
end

--结束格挡
function Unit.prototype:UnGedang()
    self.gedang = false
    self:ShowBehaviour("ready")
end

--开始吟唱
function Unit.prototype:SingStart(spell_id, sing_time)
    sing_time = sing_time / 1000
    self.sing_info = {
        ["spell_id"] = spell_id,
        ["sing_time"] = sing_time,
        ["timer"] = 0
    }
    self:ShowBehaviour("start_sing")
    BattlePanel.StartSing(self.site, sing_time, spell_id)
end

--吟唱被打断
function Unit.prototype:SingBroken()
    self:ShowBehaviour("break_sing")
    BattlePanel.EndSing(self.site)
    self.sing_info = {}
end

--吟唱结束
function Unit.prototype:SingFinish()
    self:ShowBehaviour("end_sing")
    BattlePanel.EndSing(self.site)
    self.sing_info = {}
end

--展示进攻动作(普攻 / 技能)
function Unit.prototype:Attack(spell_id, attack_speed)
    local cur_t_spell = Config.get_config_value("t_spell", spell_id)
    local action_name = ""
    self.attack_speed = attack_speed
    action_name = cur_t_spell.action
    if action_name ~= "" then
        self:ShowBehaviour(action_name)
    end
end

--表现伤害
function Unit.prototype:ShowHurt(spell_id, is_miss, is_crit, hurt, rebound, recover, be_recovered, section_num)
    local site = 0
    local t_spell = Config.get_config_value("t_spell", spell_id)
    if t_spell.target == 1 then
        site = self.target_site
    else
        site = self.site
    end
    --无伤害 不展示
    if t_spell.dmg_type ~= 0 then
        self.hurt_info = {
            ["site"] = site,
            ["is_miss"] = is_miss,
            ["is_crit"] = is_crit,
            ["hurt"] = hurt,
            ["rebound"] = rebound,
            ["recover"] = recover,
            ["be_recovered"] = be_recovered,
            ["section_num"] = section_num
        }
        self:HurtAction(self.hurt_info)
    end
end

--伤害飘字 血条血量变化
function Unit.prototype:HurtAction(hurt_info)
    local is_miss = hurt_info.is_miss
    local is_crit = hurt_info.is_crit
    local hurt = hurt_info.hurt
    local rebound = hurt_info.rebound
    local recover = hurt_info.recover
    local be_recovered = hurt_info.be_recovered
    local section_num = hurt_info.section_num
    local target_unit = Battle.units[hurt_info.site]
    --设置飘字方向
    local self_flow = "flow_left"
    local target_flow = "flow_right"
    if self.site == 10 then
        self_flow = "flow_right"
        target_flow = "flow_left"
    end
    --miss
    if is_miss then
        local content = GameSys.SetTextColor("#FF83FA", "闪避")
        target_unit:FlowText(target_flow, content)
        return
    end
    local hurt_value = hurt
    local v = 0
    --伤害飘字分段
    for i = 1, section_num do
        local h = hurt_value / section_num
        if i == section_num then
            h = hurt_value - v
        else
            v = v + math.floor(hurt_value / section_num)
        end
        if is_crit then
            local content = ""
            content = string.format("%d暴击", h)
            content = GameSys.SetTextColor("#EE0000", content)
            target_unit:FlowText(target_flow, content, 60, (i - 1) * 0.25)
        else
            local content = ""
            content = string.format("%d", h)
            content = GameSys.SetTextColor("#EEEEEE", content)
            target_unit:FlowText(target_flow, content, 60, (i - 1) * 0.25)
        end
    end
    if recover ~= 0 then
        local suck_value = recover
        local content = ""
        content = string.format("%d吸血", suck_value)
        content = GameSys.SetTextColor("#7FFF00", content)
        self:FlowText("flow_text", content)
    end
    if rebound ~= 0 then
        local rebound_value = rebound
        local content = ""
        content = string.format("%d反伤", rebound_value)
        content = GameSys.SetTextColor("#EEC900", content)
        self:FlowText(self_flow, content)
    end
    if be_recovered ~= 0 then
        local be_recovered_value = be_recovered
        local content = ""
        content = string.format("%d回复", be_recovered_value)
        content = GameSys.SetTextColor("#7FFF00", content)
        target_unit:FlowText("flow_text", content)
    end
    --设置血量
    local fight1 = FightManger.fighter1
    local fight2 = FightManger.fighter2
    if self.site == 10 then
        fight1 = FightManger.fighter2
        fight2 = FightManger.fighter1
    end
    self:SetHp(fight1.hp)
    target_unit:SetHp(fight2.hp)
    --守击变白
    target_unit:White()
end

--设置界面的血条
function Unit.prototype:SetHp(cur_hp)
    if cur_hp <= 0 then
        cur_hp = 0
    elseif cur_hp >= self.max_hp then
        cur_hp = self.max_hp
    end
    self.cur_hp = cur_hp
    BattlePanel.SetHpSliser(self.site, cur_hp)
end

--加buff
function Unit.prototype:AddBuff(buff_id, buff_time, buff_level)
    buff_time = buff_time / 1000
    --加buff图标
    BattlePanel.AddBuff(self.site, buff_id, buff_time, buff_level)
    --buff飘字
    local t_buff = Config.get_config_value("t_spell_buff", buff_id)
    local add_color = "#7FFF00"
    local reduce_color = "#FF83FA"
    for i = 1, #t_buff.buff do
        local buff = t_buff.buff[i]
        local useful = buff.value >= 0
        local attr_name = GameSys.GetAttrNameText(buff.attr)
        local color = ""
        local state = ""
        local content = ""
        color = useful and add_color or reduce_color
        state = useful and "上升" or "下降"
        if buff.attr < 1000 then
            content = attr_name..state
        else
            content = attr_name
        end
        content = GameSys.SetTextColor(color, content)
        self:FlowText("flow_text", content, 60, (i - 1) * 0.25)
    end
end

--移除buff
function Unit.prototype:RemoveBuff(buff_id)
    BattlePanel.RemoveBuff(self.site, buff_id)
end

--buff消失
function Unit.prototype:BuffDisappear(buff_id)
    self:RemoveBuff(buff_id)
end

--眩晕开始
function Unit.prototype:DizzyStart()
    self.dizzy = true
    self:ShowBehaviour("start_dizzy")
end

--眩晕结束
function Unit.prototype:DizzyEnd()
    self.dizzy = false
    self:ShowBehaviour("end_dizzy")
end

--小受伤
function Unit.prototype:Injury()
    self:ShowBehaviour("injury")
end

--大受伤 倒地
function Unit.prototype:InjuryBig()
    self:ShowBehaviour("injury_big")
end

--逃跑
function Unit.prototype:RunAway()
    self:ShowBehaviour("runaway")
    for site, unit in pairs(Battle.units) do
        --如果在吟唱 晕眩 格挡 要结束这些表现
        unit:EndOtherAction()
        BattlePanel.Clears(site)
    end
end

--死亡
function Unit.prototype:Die()
    self:ShowBehaviour("die")
    for site, unit in pairs(Battle.units) do
        unit:EndOtherAction()
        BattlePanel.Clears(site)
    end
end

function Unit.prototype:EndOtherAction()
    if next(self.sing_info) ~= nil then
        self:SingFinish()
    end
    if self.dizzy then
        self:DizzyEnd()
    end
    if self.gedang then
        self:UnGedang()
    end
end

--超时
function Unit.prototype:OverTime()
    self:ShowBehaviour("ready")
    if next(self.sing_info) ~= nil then
        self:SingFinish()
    end
    if self.dizzy then
        self:DizzyEnd()
    end
    if self.gedang then
        self:UnGedang()
    end
    BattlePanel.Clears(self.site)
end

-----------------------------------------------------------------------------

--展示行为 将要执行的行为加入到列表
function Unit.prototype:ShowBehaviour(behaviour_name)
    local cur_behaviour = self:GetBehaviour(behaviour_name)
    local timer = 0
    local action_list = cur_behaviour.action_list
    local actions_count = #action_list
    if actions_count == 0 then
        return
    end
    self.behaviour_id = self.behaviour_id + 1
    table.insert(self.behaviour_states, {
        ["id"] = self.behaviour_id,
        ["name"] = cur_behaviour.name,
        ["timer"] = timer,
        ["action_list"] = action_list,
        ["cur_action_index"] = 1,
        ["actions_count"] = actions_count })
end

--获取行为
function Unit.prototype:GetBehaviour(behaviour_name)
    local cur_behaviour = nil
    if self.behaviour_list[behaviour_name] ~= nil then
        cur_behaviour = self.behaviour_list[behaviour_name]
        return cur_behaviour
    else
        cur_behaviour = Battle.common_behaviour_list[behaviour_name]
        return cur_behaviour
    end
    return cur_behaviour
end

--执行行为动作
function Unit.prototype:ShowAction(bsid, action)
    if bsid ~= self.behaviour_id then
        if action.type == "effect" or action.type == "attack_anim" or action.type == "anim" or action.type == "attack_effect" then
            return
        end
    end
    if action.type == "attack_anim" or action.type == "anim" then
        if action.type == "attack_anim" then
            self.unit_ins:SetAttackAnimSpeed(self.attack_speed)
        end
        local ani_name = action.string_list[1]
        self.unit_ins:PlayAnim(ani_name)
    elseif action.type == "effect" then
        local effect_name = action.string_list[1]
        local point = action.string_list[2]
        local x = action.num_list[1]
        local y = action.num_list[2]
        local z = action.num_list[3]
        local remove_time = action.num_list[4]
        if effect_name ~= "" then
            self:ShowEffectAction(effect_name, point, { x, y, z }, remove_time)
        end
    elseif action.type == "attack_effect" then
        local effect_name = action.string_list[1]
        local point = action.string_list[2]
        local x = action.num_list[1]
        local y = action.num_list[2]
        local z = action.num_list[3]
        local remove_time = action.num_list[4]
        if effect_name ~= "" then
            self:ShowAttackEffectAction(effect_name, point,{ x, y, z }, remove_time, self.attack_speed)
        end
    elseif action.type == "remove_effect" then
        local effect_name = action.string_list[1]
        self:RemoveEffectAction(effect_name)
    elseif action.type == "set_active" then
        local active = action.num_list[1]
        self.unit_ins:SetActive(active)
    elseif action.type == "sound" then
        local sound_name = action.string_list[1]
        self:SoundAction(sound_name)
    elseif action.type == "rotate" then
        local rotate_value = action.num_list[1]
        self:RotateIns(rotate_value)
    elseif action.type == "move" then
        local speed = action.num_list[1]
        self:Move(speed)
    elseif action.type == "time_scale" then
        local s = action.num_list[1]
        local t = action.num_list[2]
        timerMgr:ActionTimeScale(s, t)
    end
end

--技能特效(技能/普攻)
function Unit.prototype:ShowSpellEffect(spell_id)
    local site = 0
    local effect_name = ""
    local point = "foot"
    local t_spell = Config.get_config_value("t_spell", spell_id)
	effect_name = t_spell.effect
    if effect_name == "" then
        return
    end
	if t_spell.target == 1 then
		site = self.target_site
	else
		site = self.site
	end
	point = "accept"
    Battle.units[site]:ShowEffectAction(effect_name, point, nil, 2.5)
end

--展示技能特效
function Unit.prototype:ShowEffectAction(effect_name, point, vec, remove_time)
    self.unit_ins:ShowEffect(effect_name, point, vec, remove_time)
end

--展示普攻
function Unit.prototype:ShowAttackEffectAction(effect_name, point, vec, remove_time, attack_speed)
    self.unit_ins:ShowEffect(effect_name, point, vec, remove_time, attack_speed)
end

--移除特效
function Unit.prototype:RemoveEffectAction(effect_name)
    self.unit_ins:RemoveEffect(effect_name)
end

--播放声音
function Unit.prototype:SoundAction(sound_name)
    self.unit_ins:PlaySound(sound_name)
end

--旋转模型
function Unit.prototype:RotateIns(value)
    self.unit_ins:Rotate(value)
end

--移动模型
function Unit.prototype:Move(speed)
    self.unit_ins:Move(speed)
end

--界面飘字
function Unit.prototype:FlowText(tp, content, size, delay)
    BattlePanel.FlowText(tp, self.site, content, nil, size, delay)
end

--界面飘字(图标开头)
function Unit.prototype:FlowImageText(tp, content, icon_info, size, delay)
    BattlePanel.FlowText(tp, self.site, content, icon_info, size, delay)
end

--界面提示
function Unit.prototype:Tip(content)
    if FightManger.auto then
        return
    end
    BattlePanel.Tip(content)
end

--升级
function Unit.prototype:LevelUp()
    local content = "等级提升"
    content = GameSys.SetTextColor("#FFB600", content)
    self:FlowText("flow_text", content)
    self.unit_ins:LevelUp()
end