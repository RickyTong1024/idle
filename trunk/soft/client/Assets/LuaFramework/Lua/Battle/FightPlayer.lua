FightPlayer = Object:subclass("FightPlayer")

FightPlayer.prototype.fighter_type = 1
FightPlayer.prototype.ai = nil
FightPlayer.prototype.site = 0
FightPlayer.prototype.t_role = 0
FightPlayer.prototype.hp = 0
FightPlayer.prototype.sp = 0
FightPlayer.prototype.sp_time = 0
FightPlayer.prototype.sp_state = 0
FightPlayer.prototype.level = 0
FightPlayer.prototype.attrs = nil
FightPlayer.prototype.buffs = nil
FightPlayer.prototype.spells = nil
FightPlayer.prototype.spell_levels = nil
FightPlayer.prototype.spell_passives = nil
FightPlayer.prototype.spell_id = 0
FightPlayer.prototype.spell_state = 0
FightPlayer.prototype.spell_release_time = 0
FightPlayer.prototype.spell_cd = nil
FightPlayer.prototype.pre_spell_id = 0
FightPlayer.prototype.pre_spell_start_time = 0
FightPlayer.prototype.pre_spell_time = 0
FightPlayer.prototype.pre_spell_end_time = 0
FightPlayer.prototype.gd_press = false
FightPlayer.prototype.gd = false
FightPlayer.prototype.gd_time = 0
FightPlayer.prototype.injury_time = 0
FightPlayer.prototype.target = nil
FightPlayer.prototype.blood_lock = 0            -- 战神触发
FightPlayer.prototype.sp_change = 0             -- 怒气减少量
FightPlayer.prototype.sp_attr = 0               -- 怒气属性标记
FightPlayer.prototype.add_hurt = 0              -- 被动属性标记 生命低于一定值


FightPlayer.prototype.unit = nil


-- 创建战斗角色 进攻方
function FightPlayer.CreatePlayer(player, camp)
    local fp = FightPlayer()
    -- 初始化工作--
    fp.fighter_type = 1
    fp.site = 0 + camp * 10
    fp.level = player.level
    fp.t_role = Config.get_config_value("t_role", player.role_id)
    fp:Init()
    fp.attrs = PlayerData.get_attr()

    for _, v in pairs(Config.t_spell) do
        if v.type == 1 then
            local spell_id = v.id
            if spell_id > 0 then
                local spell_level = GameSys.GetSpellLevel(spell_id)
                if spell_level > 0 then
                    table.insert(fp.spells, spell_id)
                    table.insert(fp.spell_levels, spell_level)
                end
            end
        end
    end
    --[[for _, v in pairs(Config.t_spell) do
        if v.type == 1 then
            table.insert(fp.spells, v.id)
            table.insert(fp.spell_levels, 1)
        end
    end]]--
    for i = 1, #player.spell_passive_slots do
        local spell_passive_id = player.spell_passive_slots[i]
        if spell_passive_id > 0 then
            table.insert(fp.spell_passives, spell_passive_id)
        end
    end
    ----------初始化表现对象----------
    local pet_ids = {}
    for i = 1, #player.pet_slots do
        if player.pet_slots[i] ~= "0" then
            pet_ids[i] = PlayerData.pets[player.pet_slots[i]].template_id
        else
            pet_ids[i] = 0
        end
    end

    fp.ai = FightAIPlayer()
    fp.ai:Start(fp)

    fp:PostInit()

    local equip_ids = GameSys.GetSlotEquipIds()
    local dress_ids = PlayerData.player.equip_shows
    local avatar_ids = GameSys.GetEquipAvatarIds(equip_ids, dress_ids)
    fp.unit = Unit.CreateUnit(fp.site, player.name, player.level, fp.hp, player.role_id, pet_ids, avatar_ids, nil)
    return fp
end


-- 创建战斗角色 防守方 怪
function FightPlayer.CreateMonster(t_monster, camp, color, passive)
    local fp = FightPlayer()
    -- 初始化工作
    fp.fighter_type = 2
    fp.site = 0 + camp * 10
    fp.t_role = Config.get_config_value("t_role", t_monster.role_id)
    fp:Init()
    if t_monster.level == -1 then
        fp.level = PlayerData.player.level
    else
        fp.level = t_monster.level
    end
    -- 怪物属性
    for attrid in pairs(Config.t_attr) do
        fp.attrs[attrid] = 0
    end
    fp.attrs[1] = t_monster.attrs[1].value * PlayerData.get_level_value(fp.level, 1)
    fp.attrs[2] = t_monster.attrs[2].value * PlayerData.get_level_value(fp.level, 2)
    fp.attrs[3] = t_monster.attrs[3].value * PlayerData.get_level_value(fp.level, 3)
    fp.attrs[4] = t_monster.attrs[3].value * PlayerData.get_level_value(fp.level, 4)

    for i = 11, 16 do
        fp.attrs[i] = PlayerData.get_level_value(fp.level, i)
    end

    local t_mission_random = Config.get_config_value('t_mission_random', color)
    local bonus = t_mission_random.bonus
    bonus = bonus / 100
    fp.attrs[1] = fp.attrs[1] * (1 + bonus * 5)
    fp.attrs[2] = fp.attrs[2] * (1 + bonus)


    table.insert(fp.spells, fp.t_role.attack_id)
    table.insert(fp.spell_levels, t_monster.spell_level)

    for i = 1, #t_monster.spell_release do
        local spell_id = t_monster.spell_release[i].id
        if spell_id ~= 1 then
            local flag = false
            for j = 1, #fp.spells do
                if fp.spells[j] == spell_id then
                    flag = true
                    break
                end
            end
            if not flag then
                table.insert(fp.spells, spell_id)
                table.insert(fp.spell_levels, t_monster.spell_level)
            end
        end
    end

    if passive ~= 0 then
        local t_dungeon_passive = Config.get_config_value('t_dungeon_passive', passive)
        local index = LRandom.Random(1, #t_dungeon_passive.passive)
        table.insert(fp.spell_passives, t_dungeon_passive.passive[index].id)
    else
        if t_monster.passive > 0 then
            table.insert(fp.spell_passives, t_monster.passive)
        end
    end

    fp.ai = FightAIMonster()
    fp.ai:Start(fp, t_monster)

    ----------初始化表现对象----------
    fp:PostInit()
    fp.unit = Unit.CreateUnit(fp.site, fp.t_role.name, fp.level, fp.hp, t_monster.role_id, nil, nil, color)
    return fp
end


-- 创建竞技场战斗对象
function FightPlayer.CreateArenaPlayer(player, camp)
    local fp = FightPlayer()
    -- 初始化工作--
    fp.fighter_type = 1
    fp.site = 0 + camp * 10
    fp.level = player.level
    fp.t_role = Config.get_config_value("t_role", player.role_id)
    fp:Init()
    fp.attrs = player.attrs

    for _, v in pairs(Config.t_spell) do
        if v.type == 1 then
            local spell_id = v.id
            if spell_id > 0 then
                local index = GameSys.getIndex(player.spell_ids, spell_id)
                if index ~= nil then
                    table.insert(fp.spells, spell_id)
                    table.insert(fp.spell_levels, player.spell_levels[index])
                end
            end
        end
    end

    for i = 1, #player.spell_passive_slots do
        local spell_passive_id = player.spell_passive_slots[i]
        if spell_passive_id > 0 then
            table.insert(fp.spell_passives, spell_passive_id)
        end
    end
    ----------初始化表现对象----------
    local pet_ids = {}
    for i = 1, #player.pet_slots do
        local pet_info = player.pet_slots[i]
        if pet_info ~= nil then
            pet_ids[i] = pet_info.template_id
        else
            pet_ids[i] = 0
        end
    end
    local equip_ids = {}
    for i = 1, #player.equip_slots do
        if player.equip_slots[i] ~= "0" then
            equip_ids[i] = PlayerData.equips[player.equip_slots[i]].template_id
        else
            equip_ids[i] = 0
        end
    end

    fp.ai = FightAIPlayer()
    fp.ai:Start(fp)

    fp:PostInit()

    local dress_ids = player.equip_shows
    local avatar_ids = GameSys.GetEquipAvatarIds(equip_ids, dress_ids)
    fp.unit = Unit.CreateUnit(fp.site, player.name, player.level, fp.hp, player.role_id, pet_ids, avatar_ids, nil)
    return fp
end

-- 物理/魔法
function FightPlayer.get_attack_attrid(attack_type)
    if attack_type == 1 then
        return { 3, 39 }
    else
        return { 4, 40 }
    end
end


-- 形态
function FightPlayer.get_race_attrid(race)
    if race == 1 then
        return { 57, 60 }
    elseif race == 2 then
        return { 58, 61 }
    else
        return { 59, 62 }
    end
end


-- 转化为百分比
function FightPlayer.convert_value_to_per(value, level, attrid)
    if level < 10 then
        level = 10
    end
    local factor = PlayerData.get_level_value(level, attrid)
    return value / factor
end


-- 冷却
function FightPlayer.convert_per_to_realper(value)
    if value > 0 then
        return 1000 / (1000 + value)
    else
        return (1000 - value) / 1000
    end
end


-------------------------------------------------------------

-- 战斗角色初始化
function FightPlayer.prototype:Init()
    self.attrs = {}
    self.buffs = {}
    self.spells = {}
    self.spell_levels = {}
    self.spell_passives = {}
    self.target = nil
end


-- 战斗角色初始化
function FightPlayer.prototype:PostInit()
    local battr_self = PlayerData.get_base_attr(self.attrs)
    self.hp = battr_self[1]
    self.spell_cd = {}
    self:SpellPassiveInit()
end

function FightPlayer.prototype:Destroy()
    self.unit = nil
end


-- 敌方
function FightPlayer.prototype:SetTarget(fp)
    self.target = fp
end


-- 被动 sp相关属性变化
function FightPlayer.prototype:SpellPassiveAddHp()
    local battr= PlayerData.get_base_attr(self.attrs)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 1, #t_spell_passive.effect do
            if t_spell_passive.effect[j].type == 2 then
                if self.sp_change >= t_spell_passive.effect[j].param1 then
                    self.sp_change = self.sp_change - t_spell_passive.effect[j].param1
                    self.hp = self.hp + t_spell_passive.effect[j].param2
                end
            elseif t_spell_passive.effect[j].type == 3 then
                if self.hp <= 0 and self.blood_lock == 0 then
                    self.hp = toInt(battr[1] * t_spell_passive.effect[j].param1 / 100)
                    self.blood_lock = 1
                end
            elseif t_spell_passive.effect[j].type == 6 then
                if self.sp_state == 1 and self.sp_attr == 0 then
                    self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] + t_spell_passive.effect[j].param2
                    self.sp_attr = 1
                elseif self.state == 0 and self.sp_attr == 1 then
                    self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] - t_spell_passive.effect[j].param2
                    self.sp_attr = 0
                end
            end
        end
    end
end


-- 被动 对于生命少于一定的目标改变属性
function FightPlayer.prototype:SpellPassiveAddHurt()
    local battr = PlayerData.get_base_attr(self.attrs)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, 1 do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 5 then
                    if self.hp * 100 / battr[1] >= t_spell_passive.effect[j].param3 then
                        self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] + t_spell_passive.effect[j].param2
                    end
                end
            end
        end
    end
end


-- 被动 附加伤害
function FightPlayer.prototype:SpellPassiveHurt(dmg, nowtime)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, 1 do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 4 then
                    self.attrs[t_spell_passive.effect[j].param1] = 1
                    local dmg_median = self.target.hp * t_spell_passive.effect[j].param1 / 100
                    if dmg_median > dmg * t_spell_passive.effect[j].param2 then
                        dmg_median = dmg * t_spell_passive.effect[j].param2
                        dmg = dmg_median
                    end
                elseif t_spell_passive.effect[j].type == 12 then
                    if nowtime > t_spell_passive.effect[j].param2 then
                        dmg = dmg * (100 + t_spell_passive.effect[j].param1) / 100
                    end
                end
            end
        end
    end
    return dmg
end


-- 被动 初始化修改属性
function FightPlayer.prototype:SpellPassiveInit()
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, #t_spell_passive.effect do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 1 then
                    self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] + t_spell_passive.effect[j].param2
                elseif t_spell_passive.effect[j].type == 11 then
                    self.hp = self.hp + t_spell_passive.effect[j].param1
                    if self.hp > 100 then
                        self.hp = 100
                    end
                end
            end
        end
    end
end


-- 怪物被动 散失
function FightPlayer.prototype:SpellPassiveChange(spell_type)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, #t_spell_passive.effect do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 7 then
                    if spell_type == 1 then
                        self.target.sp = self.target.sp - t_spell_passive.effect[j].param1
                        if self.target.sp < 0 then
                            self.target.sp = 0
                        end
                    end
                end
            end
        end
    end
end


-- 怪物被动 霸体
function FightPlayer.prototype:SpellPassiveTyrants(hurt, nowtime)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, #t_spell_passive.effect do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 8 then
                    if t_spell_passive.effect[j].param1 >= nowtime then
                        hurt = 0
                        return toInt(hurt)
                    end
                end
            end
        end
    end
    return toInt(hurt)
end

-- 怪物被动 修正 9 10
function FightPlayer.prototype:SpellPassiveHp(hurt)
    local battr_self = PlayerData.get_base_attr(self.attrs)
    for i = 1, #self.spell_passives do
        local t_spell_passive = Config.get_config_value('t_spell_passive', self.spell_passives[i])
        for j = 0, #t_spell_passive.effect do
            if t_spell_passive.effect[j] ~= nil then
                if t_spell_passive.effect[j].type == 9 then
                    local ar = t_spell_passive.effect[j].param1 * battr_self[1] / 100
                    if hurt >  ar then
                        hurt = ar
                    end
                elseif t_spell_passive.effect[j].type == 10 then
                    if hurt > t_spell_passive.effect[j].param1 * battr_self[1] / 100 then
                        hurt = 0
                    end
                end
            end
        end
    end

    return toInt(hurt)
end

-- 打断技能
function FightPlayer.prototype:DoBreak()
    local nowtime = FightManger.nowtime()
    if self.spell_state == 2 and nowtime < self.spell_release_time then
        self.unit:SingBroken()
    end

    self.spell_id = 0
    self.pre_spell_id = 0
    self.spell_release_time = 0
    if self.gd then
        self.gd = false
        self.unit:UnGedang()
    end
    self.spell_state = 0
end

-- 释放技能
function FightPlayer.prototype:DoSpell(nowtime)
    local t_spell = Config.get_config_value("t_spell", self.spell_id)
    if self.spell_id == 9999 then
        FightManger.RunAwaySuccess()
        --表现逃跑
        self.unit:RunAway()
        return
    end
    self:SpellPassiveAddHp()
    local speed = FightPlayer.convert_per_to_realper(self.attrs[82])
    self.spell_cd[self.spell_id] = nowtime + t_spell.cold_time * speed
end

function FightPlayer.prototype:GetContinueReleaseSpell(spell_id)
    local nowtime = FightManger.nowtime()
    local xj = false
    local per = 0
    if spell_id <= 3 then
        if self.pre_spell_id > 0 then
            local sid = 0
            for i = 1, #self.spells do
                local t_spell = Config.get_config_value('t_spell', self.spells[i])
                if t_spell.release_type >= 2 and t_spell.release_button == spell_id then
                    local params = GameSys.split(t_spell.release_param, "|")
                    for j = 1, #params do
                        if tonumber(params[j]) == self.pre_spell_id then
                            sid = t_spell.id
                        end
                    end
                end
                if sid > 0 then
                    spell_id = sid
                    xj = true
                    local tt = self.pre_spell_end_time - self.pre_spell_start_time - 50
                    local dt = nowtime - self.pre_spell_start_time
                    per = 300 - 200 * dt / tt
                    break
                end
            end
        end
    end
    return xj, spell_id, per
end

function FightPlayer.prototype:GetNormalReleaseSpell(spell_id)
    for i = 1, #self.spells do
        local t_spell = Config.get_config_value('t_spell', self.spells[i])
        if t_spell.release_type == 1 and t_spell.release_button == spell_id then
            return t_spell.id
        end
    end
    return nil
end

-- 技能是否可以释放
function FightPlayer.prototype:ReleaseSpell(spell_id, auto)
    local nowtime = FightManger.nowtime()

    -- 晕眩
    if self.attrs[1001] > 0 then
        self.unit:Tip("晕眩状态")
        return false
    end

    -- 击退
    if self.injury_time > nowtime then
        self.unit:Tip("受击状态")
        return false
    end

    -- 格挡中
    if self.gd then
        self.unit:Tip("格挡状态")
        return false
    end

    local xj = false
    local per = 0
    xj, spell_id, per = self:GetContinueReleaseSpell(spell_id)

    if spell_id < 3 then
        spell_id = self:GetNormalReleaseSpell(spell_id)
    end
    if spell_id == nil then
        return false
    end
    local t_spell = Config.get_config_value("t_spell", spell_id)
    if t_spell == nil then
        return false
    end

    if not auto then
        self.pre_spell_id = 0
    end

    -- cd中
    if self.spell_cd[spell_id] ~= nil then
        if self.spell_cd[spell_id] > nowtime then
            return false
        end
    end

    -- 非爆气状态
    if t_spell.release_type == 3 and self.sp_state ~= 1 then
        return false
    end

    -- 别的在公共cd
    if not xj and self.spell_release_time > nowtime then
        return false
    end

    -- 别的在放
    if self.spell_state ~= 0 then
        return false
    end

    -- 没到衔接时间
    if xj then
        if nowtime < self.pre_spell_time or nowtime >= self.pre_spell_end_time then
            return false
        end
    end

    self:SetSpell(nowtime, spell_id)
    return true
end

function FightPlayer.prototype:Gedang()
    self.gd_press = true
end

function FightPlayer.prototype:UnGedang()
    self.gd_press = false
end

function FightPlayer.prototype:SetSpell(nowtime, spell_id)
    self.spell_id = spell_id
    self.pre_spell_id = spell_id
    local t_spell = Config.get_config_value("t_spell", spell_id)
    self.pre_spell_start_time = nowtime
    self.pre_spell_time = nowtime + t_spell.sing_time + t_spell.pre_time + t_spell.release_time - 200
    self.pre_spell_end_time = nowtime + t_spell.sing_time + t_spell.pre_time + t_spell.release_time + 200
    self.spell_state = 1
end


function FightPlayer.prototype:CalcHit()
    local hit = FightPlayer.convert_value_to_per(self.attrs[11], self.target.level, 11)
    local dodge = FightPlayer.convert_value_to_per(self.target.attrs[12], self.level, 12)
    hit = 1000 + hit - dodge + self.attrs[31] - self.target.attrs[32]
    hit = toInt(hit)
    if hit < 700 then
        hit = 700
    end
    return hit
end

function FightPlayer.prototype:CalcDamageIncrease()
    -- 伤害修正 伤害和抵抗 增伤和减伤
    local damage_increase = FightPlayer.convert_value_to_per(self.attrs[15], self.target.level, 15)
    local damage_decrease = FightPlayer.convert_value_to_per(self.target.attrs[16], self.level, 16)
    damage_increase = 1000 + damage_increase - damage_decrease
    local attack_attrids = FightPlayer.get_attack_attrid(self.t_role.attack_type)
    damage_increase = damage_increase + self.attrs[38] + self.attrs[35] - self.target.attrs[attack_attrids[2]] - self.target.attrs[36]
    if damage_increase < 0 then
        damage_increase = 0
    end
    return damage_increase
end

function FightPlayer.prototype:CalcCritDamage(isfj)
    -- 暴击修正
    local is_crit = false
    local crit = FightPlayer.convert_value_to_per(self.attrs[13], self.target.level, 13)
    local crit_immune = FightPlayer.convert_value_to_per(self.target.attrs[14], self.level, 14)
    crit = crit - crit_immune + self.attrs[33] - self.target.attrs[34]
    local crit_damage = 1000
    crit = toInt(crit)
    if crit > LRandom.Random(0, 1000) or isfj then
        is_crit = true
        crit_damage = 1500 + self.attrs[51] - self.target.attrs[52]
        if crit_damage < 0 then
            crit_damage = 0
        end
    end
    return is_crit, crit_damage
end

function FightPlayer.prototype:CalcRaceDamage()
    -- 种族修正
    local race_attrids = FightPlayer.get_race_attrid(self.target.t_role.race)
    local race_damage = 1000 + self.attrs[race_attrids[1]] - self.target.attrs[race_attrids[2]]
    if race_damage < 0 then
        race_damage = 0
    end
    return race_damage
end

function FightPlayer.prototype:CalcASDamage(spell_type)
    -- 技能普攻修正
    local as_damdage = 1000
    if spell_type == 1 then
        as_damdage = as_damdage + self.attrs[55] - self.target.attrs[56]
    else
        as_damdage = as_damdage + self.attrs[53] - self.target.attrs[54]
    end
    return as_damdage
end


-- buff改变属性
function FightPlayer.prototype:BuffEffect(t_buff, buff_time, spell_level, nowtime, mark)
    for i = 1, #t_buff.buff do
        self.attrs[t_buff.buff[i].attr] = self.attrs[t_buff.buff[i].attr] + (t_buff.buff[i].value + t_buff.buff[i].add * (spell_level - 1)) * mark
        if t_buff.buff[i].attr == 1001 and mark > 0 then
            self:DoBreak()
            self.unit:DizzyStart()
        elseif t_buff.buff[i].attr == 1001 and mark < 0 then
            self.unit:DizzyEnd()
        end
    end
    if mark == 1 then
        self:AddBuff(nowtime, t_buff.id, buff_time, spell_level)
    else
        self:RemoveBuff(t_buff.id)
    end
end


-- buff
function FightPlayer.prototype:BuffCheck(t_spell, nowtime, mark)
    local spell_level = self.spell_levels[GameSys.GetSpellLevel(t_spell.id)]
    if spell_level == nil then
        spell_level = 1
    end
    for i = 1, #t_spell.buff do
        local t_buff = Config.get_config_value('t_spell_buff', t_spell.buff[i].id)
        if t_spell.buff[i].target == 1 then
            self.target:BuffEffect(t_buff, t_spell.buff[i].time, spell_level, nowtime, mark)
        else
            self:BuffEffect(t_buff, t_spell.buff[i].time, spell_level, nowtime, mark)
        end
    end
end


-- 造成伤害
function FightPlayer.prototype:Hurt(nowtime)
    local t_spell = Config.get_config_value("t_spell", self.spell_id)
    self:SpellPassiveChange(t_spell.spell_type)
    -- 对敌人释放
    local ar = 0
    local fs = 0
    local hf = 0
    local hx = 0
    local is_hit = true
    local is_crit = false
    local battr_self = PlayerData.get_base_attr(self.attrs)
    local battr_target = PlayerData.get_base_attr(self.target.attrs)

    if t_spell.target == 1 then
        local hit = self:CalcHit()
        if hit > LRandom.Random(0, 1000) then
            if t_spell.dmg_type > 0 then
                local attack_attrids = FightPlayer.get_attack_attrid(self.t_role.attack_type)
                local target_attrids = FightPlayer.get_attack_attrid(self.target.t_role.attack_type)
                local damage = battr_self[2]
                ar = damage - battr_target[attack_attrids[1]]

                if ar < 0 then
                    ar = 0
                end
                -- 技能修正
                self:SpellPassiveAddHurt()
                local index = GameSys.getIndex(self.spells, self.spell_id)
                local spell_damage
                if index ~= nil then
                    spell_damage = t_spell.dmg_param1 + t_spell.dmg_param1_add * (self.spell_levels[index] - 1)
                else
                    spell_damage = t_spell.dmg_param1
                end
                if t_spell.dmg_type == 3 then
                    spell_damage = spell_damage + (t_spell.dmg_param2 + t_spell.dmg_param2_add * (self.spell_levels[index] - 1) - spell_damage) * self.sp / 100
                end
                local damage_increase = self:CalcDamageIncrease()
                local crit_damage = 0
                is_crit, crit_damage = self:CalcCritDamage(t_spell.dmg_type == 2)
                local race_damage = self:CalcRaceDamage()
                local as_damage = self:CalcASDamage(t_spell.spell_type)

                ar = ar * spell_damage / 1000 * damage_increase / 1000 * crit_damage / 1000 * race_damage / 1000 * as_damage / 1000
                local attack_dmg = LRandom.Random(900, 1100)
                ar = ar * attack_dmg / 1000
                if ar < damage * 0.2 then
                    ar = damage * 0.2
                end
                ar = self:SpellPassiveHurt(ar, nowtime)
                fs = fs + self.target.attrs[73]
                fs = fs + battr_target[target_attrids[1]] * self.target.attrs[74] / 1000
                fs = fs + ar * self.target.attrs[75] / 1000
                hf = hf + self.target.attrs[76]
                hf = hf + battr_self[1] * self.target.attrs[77] / 1000

                local hxs = 0
                if t_spell.dmg_type == 4 then
                    hxs = t_spell.dmg_param2 + t_spell.dmg_param2_add * (self.spell_levels[index] - 1)
                end
                hx = hx + self.attrs[78]
                hx = hx + damage * self.attrs[79] / 1000
                hx = hx + ar * (self.attrs[80] + hxs) / 1000

                if self.site > 0 or t_spell.spell_type == 2 then
                    Scene.Shake(0.1)
                end
            end
            ar = toInt(ar)
            fs = toInt(fs)
            hf = toInt(hf)
            hx = toInt(hx)

            -- 计算格挡受伤
            if self.target.gd then
                self.target:DoBreak()
                if nowtime - self.target.gd_time <= 400 then
                    ar = ar * 0.2
                    if t_spell.jt == 2 then
                        self.target:SetSpell(nowtime, 9904)
                    else
                        self.target:SetSpell(nowtime, 9902)
                    end
                else
                    ar = ar * 0.5
                    if t_spell.jt == 2 then
                        self.target:SetSpell(nowtime, 9903)
                    else
                        self.target:SetSpell(nowtime, 9901)
                    end
                end
            elseif self.target.sp_state == 0 then
                if t_spell.jt == 1 then
                    self.target:DoBreak()
                    self.target.injury_time = nowtime + 1000
                    self.target.unit:Injury()
                elseif t_spell.jt == 2 then
                    self.target:DoBreak()
                    self.target.injury_time = nowtime + 3000
                    self.target.unit:InjuryBig()
                end
            end

            ar = self.target:SpellPassiveTyrants(ar, nowtime)
            ar = self.target:SpellPassiveHp(ar)
            if ar < 1 then
                ar = 1
            end
            if ar > 0 then
                self.target.hp = self.target.hp - ar
            end
            if fs > 0 then
                fs = self:SpellPassiveTyrants(fs, nowtime)
                self.hp = self.hp - fs
            end
            if hf > 0 then
                self.target.hp = self.target.hp + hf
                if self.target.hp > battr_target[1] then
                    self.hp = battr_target[1]
                end
            end
            if hx > 0 then
                self.hp = self.hp + hx
                if self.hp > battr_self[1] then
                    self.hp = battr_self[1]
                end
            end

            -- 被动战神判断
            self.target:SpellPassiveAddHp()
            -- 算buff
            self:BuffCheck(t_spell, nowtime, 1)
        else
            is_hit = false
            --未命中
        end
    else
        -- 算buff
        self:BuffCheck(t_spell, nowtime, 1)
    end

    -- sp变化
    self.sp = self.sp + t_spell.sp
    if self.sp > 100 then
        self.sp = 100
    elseif self.sp < 0 then
        self.sp = 0
    end
    if self.sp == 100 and self.sp_state == 0 then
        self.sp_state = 1
        self.sp_time = nowtime + 5000
    end
    return { t_spell.id, is_hit, is_crit, ar, fs, hx, hf}
end

function FightPlayer.prototype:Gd(nowtime)
    -- 晕眩
    if self.attrs[1001] > 0 then
        return
    end

    -- 击退
    if self.injury_time > nowtime then
        return
    end

    if self.spell_release_time > nowtime then
        return
    end

    -- 别的在放
    if self.spell_state ~= 0 then
        return
    end

    if self.gd_press then
        if not self.gd then
            self.gd = true
            self.pre_spell_id = 0
            self.gd_time = nowtime
            self.unit:Gedang()
        end
    else
        if self.gd then
            self.gd = false
            self.unit:UnGedang()
        end
    end
end

-- 技能
function FightPlayer.prototype:Spell(nowtime)
    if self.spell_state == 1 then
        --读条
        local t_spell = Config.get_config_value('t_spell', self.spell_id)
        if t_spell.sing_time > 0 then
            self.spell_state = 2
            self.spell_release_time = nowtime + t_spell.sing_time
            --表现吟唱
            self.unit:SingStart(self.spell_id, t_spell.sing_time)
        else
            self.spell_release_time = nowtime + t_spell.pre_time
            self.spell_state = 3
            --表现攻击动作
            self.unit:Attack(t_spell.id, 1)
        end
    elseif self.spell_state == 2 then
        if self.spell_release_time <= nowtime then
            local t_spell = Config.get_config_value('t_spell', self.spell_id)
            self.spell_release_time = nowtime + t_spell.pre_time
            self.spell_state = 3
            --表现吟唱结束
            self.unit:SingFinish()
            --表现攻击动作
            self.unit:Attack(t_spell.id, 1)
        end
    elseif self.spell_state == 3 then
        if self.spell_release_time <= nowtime then
            local param = self:Hurt(nowtime)
            local t_spell = Config.get_config_value('t_spell', self.spell_id)
            self.spell_release_time = nowtime + t_spell.release_time
            self:DoSpell(nowtime + t_spell.release_time)
            --技能特效
            if not (self.target.spell_id >= 9901 and self.target.spell_id <= 9904) then
                self.unit:ShowSpellEffect(self.spell_id)
            end
            --表现击打
            self.unit:ShowHurt(param[1], not param[2], param[3], param[4], param[5], param[6], param[7], t_spell.section_num)
            self.spell_state = 0
            self.spell_id = 0
        end
    end
end


-- 添加buff
function FightPlayer.prototype:AddBuff(nowtime, buffid, t, spell_level)
    if self.buffs[buffid] == nil then
        if t ~= -1 then
            self.buffs[buffid] = {t + nowtime, spell_level}
        else
            self.buffs[buffid] = {t, spell_level}
        end
    else
        if t ~= -1 then
            if self.buffs[buffid][1] < t + nowtime then
                self.buffs[buffid] = {t + nowtime, spell_level}
            end
        else
            self.buffs[buffid] = {t, spell_level}
        end
    end
    --表现加buff
    self.unit:AddBuff(buffid, t, spell_level)
end


-- 移除buff
function FightPlayer.prototype:RemoveBuff(buffid)
    self.buffs[buffid] = nil

    --表现 移除buff
    self.unit:RemoveBuff(buffid)
end


-- buff清除判断
function FightPlayer.prototype:Buff(nowtime)
    for k, v in pairs(self.buffs) do
        local buff = v[1]
        if buff <= nowtime and buff ~= -1 then
            -- 清除buff属性
            local t_buff = Config.get_config_value('t_spell_buff', k)
            self:BuffEffect(t_buff, 0, v[2], nowtime, -1)
        end
    end
end

-- 是否死亡
function FightPlayer.prototype:IsDie()
    if self.hp <= 0 then
        return true
    end
    return false
end

-- 刷新
function FightPlayer.prototype:Update()
    local nowtime = FightManger.nowtime()
    if self:IsDie() then
        return
    end
    self:Buff(nowtime)
    -----------------------------------------------------
    if self.attrs[1001] > 0 then
        return
    end
    if self.injury_time > nowtime then
        return
    end

    if self.spell_id > 0 then
        self:Spell(nowtime)
    end
    self:Gd(nowtime)
    if self.sp_state == 1 and self.sp_time <= nowtime then
        self.sp_state = 0
        self.sp = 0
    end
    if self.pre_spell_id > 0 and nowtime >= self.pre_spell_end_time then
        self.pre_spell_id = 0
    end
end

function FightPlayer.prototype:Sp()
    local nowtime = FightManger.nowtime()
    if self.sp_state == 0 then
        return self.sp_state, math.floor(self.sp)
    else
        local sp = (self.sp_time - nowtime) / 5000 * 100
        if sp < 0 then
            sp = 0
        elseif sp > 100 then
            sp = 100
        end
        return self.sp_state, math.floor(sp)
    end
end

-- 竞技场备用
function FightPlayer.Change(msg)
    local arena_player = {}
    arena_player.name = msg.name
    arena_player.level = msg.level
    arena_player.role_id = msg.role_id
    arena_player.attrs = {}
    for i = 1, #msg.attr_ids do
        arena_player.attrs[msg.attr_ids[i]] = msg.attr_values[i]
    end
    arena_player.spell_ids = {}
    arena_player.spell_levels = {}
    for i = 1, #msg.spell_levels do
        table.insert(arena_player.spell_levels, msg.spell_levels[i])
    end
    arena_player.spell_passive_slots = {}
    for i = 1, #msg.spell_passive_slots do
        table.insert(arena_player.spell_passive_slots, msg.spell_passive_slots[i])
    end
    arena_player.pet_slots = {}
    for i = 1, #msg.pets do
        table.insert(arena_player.pet_slots, msg.pets[i])
    end
    arena_player.equip_slots = {}
    for i = 1, #msg.equips do
        table.insert(arena_player.equip_slots, msg.equips[i])
    end
    arena_player.equip_shows = {}
    for i = 1, #msg.equip_shows do
        table.insert(arena_player.equip_shows, msg.equip_shows[i])
    end
    return arena_player
end
