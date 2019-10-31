FightAIMonster = Object:subclass("FightAIMonster")

FightAIMonster.prototype.fighter = nil
FightAIMonster.prototype.index = 0
FightAIMonster.prototype.spell_interval_time = 0
FightAIMonster.prototype.spell_release_time = 0
FightAIMonster.prototype.spell_state = 0

function FightAIMonster.prototype:Start(fighter, t_monster)
	local nowtime = FightManger.nowtime()
    self.fighter = fighter
	self.t_monster = t_monster
	self.index = 0
    self:Next(nowtime)
end

function FightAIMonster.prototype:AutoFight()
    local nowtime = FightManger.nowtime()
	if self.spell_release_time > nowtime then
		return
	end
	if self.spell_state == 1 then
		self:Next(nowtime)
	end
	if self.spell_interval_time > nowtime then
		return
	end
	if self.index > #self.t_monster.spell_release then
		self:Release(nowtime)
	else
		local spell_id = self:GetSpellId()
		if self.fighter:ReleaseSpell(spell_id, true) then
			self:Release(nowtime)
		end
	end
end

function FightAIMonster.prototype:Release(nowtime)
	local spell_id = self:GetSpellId()
	self.spell_release_time = 0
	self.spell_state = 1
	if spell_id ~= nil then
		local t_spell = Config.get_config_value("t_spell", spell_id)
		self.spell_release_time = nowtime + t_spell.sing_time + t_spell.pre_time + t_spell.release_time
	else
		self.spell_release_time = nowtime + self.t_monster.spell_round_interval
	end
end

function FightAIMonster.prototype:Next(nowtime)
	self.spell_state = 0
	self.index = self.index + 1
	if self.index == #self.t_monster.spell_release + 2 then
		self.index = 1
	end
	if self.index == #self.t_monster.spell_release + 1 then
		self.spell_interval_time = 0
		self.spell_interval_total_time = 0
	else
		self.spell_interval_time = nowtime + self.t_monster.spell_release[self.index].interval
		self.spell_interval_total_time = self.t_monster.spell_release[self.index].interval
	end
end

function FightAIMonster.prototype:GetSpellId()
	if self.t_monster.spell_release[self.index] == nil then
		return nil
	end
	local spell_id = self.t_monster.spell_release[self.index].id
	if spell_id == 1 then
		spell_id = self.fighter.t_role.attack_id
	end
	return spell_id
end

function FightAIMonster.prototype:GetPer()
	if self.spell_state == 1 then
		return 0, 0
	end
	local nowtime = FightManger.nowtime()
	local per = 1 - ((self.spell_interval_time - nowtime) / self.spell_interval_total_time)
	if per < 0 then
		per = 0
	elseif per > 1 then
		
		per = 1
	end
	local state = 0
	if self:GetSpellId() >1000 then
		state = 1
	end
	return state, per
end