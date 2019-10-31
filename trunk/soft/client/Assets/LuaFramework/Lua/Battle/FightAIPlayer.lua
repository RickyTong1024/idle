FightAIPlayer = Object:subclass("FightAIPlayer")

FightAIPlayer.prototype.fighter = nil

function FightAIPlayer.prototype:Start(fighter)
    self.fighter = fighter
end

function FightAIPlayer.prototype:AutoFight()
	self.fighter:ReleaseSpell(1, true)
end
