import player_data, config
# from pgame.service import PGame
import tools


class FightManager:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.fixed_time_ = 20
        self.auto_ = False
        self.time_ = 0
        self.fighter1_ = FightPlayer()
        self.fighter2_ = FightPlayer()
        self.start_ = False
        self.prepare_time_ = 0
        self.end_time_ = 0
        self.max_fight_time_ = 0
        self.is_win_ = False
        self.is_runaway_ = False
        self.mission_id_ = 0
        self.tower_stair_ = 0
        self.target_arena_rank_ = 0
        self.param = list()

    def init(self, param):
        self.max_fight_time_ = config.Config.instance().const('max_fight_time')
        self.param = param

    @staticmethod
    def fini():
        return 0

    def start(self):
        self.fighter1_.set_target(self.fighter2_)
        self.fighter2_.set_target(self.fighter1_)
        self.start_ = True
        self.is_win_ = False
        self.is_runaway_ = False
        self.time_ = 0
        self.prepare_time_ = 500
        self.end_time_ = 0

    # 人物初始化
    @staticmethod
    def create_player(player, camp):
        fp = FightPlayer()
        fp.site = 0 + camp * 10
        fp.level = player.level
        fp.t_role = config.Config.instance().t_role.get(player.role_id)
        fp.attrs = player_data.get_attr(player)
        for i in range(len(player.spell_slots)):
            spell_id = player.spell_slots[i]
            if spell_id > 0:
                index = player_data.get_index(player.spells, spell_id)
                if index is None:
                    index = 1

                fp.spells.append(spell_id)
                fp.spell_levels.append(player.spell_levels[index])

        for i in range(len(player.spell_passive_slots)):
            spell_passive_id = player.spell_passive_slots[i]
            if spell_passive_id > 0:
                fp.spell_passives.append(spell_passive_id)

        fp.init()
        return fp

    # 怪物初始化
    def create_monster(self, player, t_monster, camp, bonus):
        fp = FightPlayer()
        fp.site = 0 + camp * 10
        fp.t_role = config.Config.instance().t_role.get(t_monster.role_id)
        if t_monster.level == -1:
            fp.level = player.level
        else:
            fp.level = t_monster.level

        t_attr = config.Config.instance().t_attr.get()
        for i in range(len(t_attr)):
            fp.attrs[t_attr[i].id] = 0

        fp.attrs[1] = t_monster.attrs[0].value * player_data.get_level_value(fp.level, 1)
        fp.attrs[2] = t_monster.attrs[1].value * player_data.get_level_value(fp.level, 2)
        fp.attrs[3] = t_monster.attrs[2].value * player_data.get_level_value(fp.level, 3)
        fp.attrs[4] = t_monster.attrs[2].value * player_data.get_level_value(fp.level, 4)
        for i in range(11, 17):
            fp.attrs[i] = player_data.get_level_value(fp.level, i)

        if bonus == -1:
            color = self.monster_bonus()
            t_mission_random = config.Config.instance().t_mission_random.get(color)
            bonus = t_mission_random.bonus
        bonus = bonus / 100
        fp.attrs[1] = fp.attrs[1] * bonus * bonus
        fp.attrs[2] = fp.attrs[2] * bonus

        for i in range(len(t_monster.spells)):
            spell_id = t_monster.spells[i].id
            if spell_id > 0:
                spell_level = t_monster.spells[i].level
                if spell_level > 0:
                    fp.spells.append(spell_id)
                    fp.spell_levels.append(spell_level)

        if t_monster.passive > 0:
            fp.spell_passives.append(t_monster.passive)

        fp.init()

        return fp

    # 竞技场玩家初始化
    @staticmethod
    def create_arena_player():
        pass

    # 怪物随机强度
    @staticmethod
    def monster_bonus():
        seq = list()
        t_mission_random = config.Config.instance().t_mission_random.get()
        for i in range(len(t_mission_random)):
            seq.append([t_mission_random[i].color, t_mission_random[i].weight])
        return tools.randseq(seq, tools.LRandom.instance().seed)

    @staticmethod
    def run_away_success():
        pass

    def end(self, win):
        self.start_ = False
        self.is_win_ = win
        self.end_time_ = 1500

    def now_time(self):
        return self.time_

    @staticmethod
    def auto_fight(fighter):
        if fighter.auto_spell_id == 0:
            if len(fighter.can_spells) > 0:
                spell_id = 0
                cold_time = 0
                for i in range(len(fighter.can_spells)):
                    t_spell = config.Config.instance().t_spell.get(fighter.can_spells[i])
                    if t_spell.cold_time > cold_time:
                        spell_id = i
                        cold_time = t_spell.cold_time

                fighter.auto_spell_id = fighter.can_spells[spell_id]
                del fighter.can_spells[spell_id]

    def fixed_update_beat(self):
        if len(self.param) != 0:
            if self.time_ > self.param[0].time:
                if self.param[0].type == 1:
                    if self.param[0].param == 1:
                        self.auto_ = True
                    else:
                        self.auto_ = False
                elif self.param[0].type == 2:
                    self.fighter1_.release_spell(self.param[0].param)
                elif self.param[0].type == 3:
                    self.fighter1_.run_away(self.time_)
                del self.param[0]

        if self.prepare_time_ > 0:
            self.prepare_time_ = self.prepare_time_ - self.fixed_time_
        if self.auto_:
            self.auto_fight(self.fighter1_)
        self.auto_fight(self.fighter2_)

        self.fighter1_.update(self.time_)
        self.fighter2_.update(self.time_)

        if self.fighter1_.is_die():
            print('fighter1_')
            print(self.fighter1_.hp)
            print(self.fighter2_.hp)
            self.end(False)
        elif self.fighter2_.is_die():
            print('fighter2_')
            print(self.fighter1_.hp)
            print(self.fighter2_.hp)
            self.end(True)
        elif self.time_ > self.max_fight_time_:
            self.end(False)
        self.time_ = self.time_ + self.fixed_time_


class FightPlayer:
    def __init__(self):
        self.fighter_type = 0
        self.site = 0
        self.t_role = None
        self.hp = 0
        self.sp = 0
        self.level = 0
        self.attrs = dict()
        self.buffs = dict()
        self.attack_state = 0
        self.attack_time = 0
        self.spells = list()
        self.spell_levels = list()
        self.can_spells = list()
        self.spell_passives = list()
        self.spell_id = 0
        self.auto_spell_id = 0
        self.spell_state = 0
        self.spell_sing_time = 0
        self.spell_release_time = 0
        self.spell_cd = dict()
        self.target = None
        self.ai = None
        self.blood_lock = 0  # 战神触发
        self.sp_change = 0  # 怒气减少量
        self.sp_attr = 0  # 怒气属性标记
        self.add_hurt = 0  # 被动属性标记 生命低于一定值

    # 魔法 / 物理
    @staticmethod
    def get_attack_attrid(attack_type):
        if attack_type == 1:
            return [3, 39]
        else:
            return [4, 40]

    # 形态
    @staticmethod
    def get_race_attrid(race):
        if race == 1:
            return [57, 60]
        elif race == 2:
            return [58, 61]
        else:
            return [59, 62]

    # 转换为百分比
    @staticmethod
    def convert_value_to_per(value, level, attrid):
        if level < 10:
            level = 10
        factor = player_data.get_level_value(level, attrid)
        return value / factor

    # 攻速 / 吟唱
    @staticmethod
    def convert_per_to_realper(value):
        if value > 0:
            return 1000 / (1000 + value)
        else:
            return (1000 - value) / 1000

    # 初始化
    def init(self):
        battr_self = player_data.get_base_attr(self.attrs)
        self.hp = battr_self[1]
        self.spell_id = self.t_role.attack_id
        self.ai = FightAi()
        self.ai.start(self)

    # 敌方
    def set_target(self, target):
        self.target = target

    def spell_passive_add_hp(self):
        battr = player_data.get_base_attr(self.attrs)
        for i in range(len(self.spell_passives)):
            t_spell_passive = config.Config.instance().t_spell_passive.get(self.spell_passives[i])
            for j in range(len(t_spell_passive.effect)):
                if t_spell_passive.effect[j].type == 2:
                    if self.sp_change >= t_spell_passive.effect[j].param1:
                        self.sp_change = self.sp_change - t_spell_passive.effect[j].param1
                        self.hp = self.hp + t_spell_passive.effect[j].param2
                elif t_spell_passive.effect[j].type == 3:
                    if self.hp <= 0 and self.blood_lock == 0:
                        self.hp = tools.to_int(battr[1] * t_spell_passive.effect[j].param1 / 100)
                        self.blood_lock = 1
                elif t_spell_passive.effect[j].type == 6:
                    if self.sp == 100 and self.sp_attr == 0:
                        self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] + \
                                                                       t_spell_passive.effect[j].param2
                        self.sp_attr = 1
                    elif self.sp != 100 and self.sp_attr == 1:
                        self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] - \
                                                                       t_spell_passive.effect[j].param2
                        self.sp_attr = 0

    def spell_passive_add_hurt(self):
        battr = player_data.get_base_attr(self.attrs)
        for i in range(len(self.spell_passives)):
            t_spell_passive = config.Config.instance().t_spell_passive.get(self.spell_passives[i])
            for j in range(len(t_spell_passive.effect)):
                if t_spell_passive.effect[j].type == 5:
                    if self.hp * 100 / battr[1] >= t_spell_passive.effect[j].param3:
                        self.attrs[t_spell_passive.effect[j].param1] = self.attrs[t_spell_passive.effect[j].param1] + \
                                                                       t_spell_passive.effect[j].param2

    # 被动 附加伤害
    def spell_passive_hurt(self, dmg):
        for i in range(len(self.spell_passives)):
            t_spell_passive = config.Config.instance().t_spell_passive.get(self.spell_passives[i])
            for j in range(len(t_spell_passive.effect)):
                if t_spell_passive.effect[j].type == 4:
                    self.attrs[t_spell_passive.effect[j].param1] = 1
                    dmg_median = self.target.hp * t_spell_passive.effect[j].param1 / 100
                    if dmg_median > dmg * t_spell_passive.effect[j].param2:
                        dmg_median = dmg * t_spell_passive.effect[j].param2
                        return dmg_median
        return dmg

    # 打断技能吟唱
    def do_break_sing(self):
        self.spell_id = self.t_role.attack_id
        self.spell_sing_time = 0
        self.spell_state = 0

    # 打断普攻
    def do_break(self):
        self.spell_id = self.t_role.attack_id
        self.attack_state = 0
        self.spell_state = 0

    def calc_hit(self):
        hit = self.convert_value_to_per(self.attrs[11], self.target.level, 11)
        dodge = self.convert_value_to_per(self.target.attrs[12], self.level, 12)
        hit = 1000 + hit - dodge + self.attrs[31] - self.target.attrs[32]
        hit = tools.to_int(hit)
        if hit < 700:
            hit = 700
        return hit

    def calc_damage_increase(self):
        damage_increase = self.convert_value_to_per(self.attrs[15], self.target.level, 15)
        damage_decrease = self.convert_value_to_per(self.target.attrs[16], self.level, 16)
        damage_increase = 1000 + damage_increase - damage_decrease
        attack_attrids = self.get_attack_attrid(self.t_role.attack_type)
        damage_increase = damage_increase + self.attrs[38] + self.attrs[35] - self.target.attrs[attack_attrids[1]] - self.target.attrs[36]
        if damage_increase < 0:
            damage_increase = 0
        return damage_increase

    # 暴击修正
    def calc_crit_damage(self):
        is_crit = False
        crit = self.convert_value_to_per(self.attrs[13], self.target.level, 13)
        crit_immune = self.convert_value_to_per(self.target.attrs[14], self.level, 14)
        crit = crit - crit_immune + self.attrs[33] - self.target.attrs[34]
        crit_damage = 1000
        crit = tools.to_int(crit)
        if crit > tools.LRandom.instance().random(0, 1000):
            is_crit = True
            crit_damage = 1500 + self.attrs[51] - self.target.attrs[52]
            if crit_damage < 0:
                crit_damage = 0
        return is_crit, crit_damage

    # 种族修正
    def calc_race_damage(self):
        race_attrids = self.get_race_attrid(self.target.t_role.race)
        race_damage = 1000 + self.attrs[race_attrids[0]] - self.target.attrs[race_attrids[1]]
        if race_damage < 0:
            race_damage = 0
        return race_damage

    # 技能普攻修正
    def calc_as_damage(self):
        as_damdage = 1000
        if self.spell_id < 100:
            as_damdage = as_damdage + self.attrs[55] - self.target.attrs[56]
        else:
            as_damdage = as_damdage + self.attrs[53] - self.target.attrs[54]
        return as_damdage

    # 释放技能
    def do_spell(self, nowtime):
        t_spell = config.Config.instance().t_spell.get(self.spell_id)
        if self.spell_id == 101:
            FightManager.run_away_success()

        # self.SpellPassiveAddHp()
        speed = self.convert_per_to_realper(self.attrs[82])
        self.spell_cd[self.spell_id] = nowtime + t_spell.cold_time * speed

    def run_away(self, nowtime):
        if self.spell_release_time > nowtime:
            return

        if self.spell_state != 0:
            return

        if self.attrs[1001] > 0:
            return

        if self.attrs[1002] > 0:
            return

        self.spell_id = 101
        self.spell(nowtime)

    # 按键释放技能
    def release_spell(self, spell_id):
        nowtime = FightManager.instance().now_time()
        t_spell = config.Config.instance().t_spell.get(spell_id)

        if self.spell_release_time > nowtime:
            return False

        if self.spell_state != 0:
            return False

        # 晕眩
        if self.attrs[1001] > 0:
            return False

        # 沉默
        if self.attrs[1002] > 0:
            return False

        # cd中
        if spell_id in self.spell_cd.keys():
            if self.spell_cd[spell_id] > nowtime:
                return False

        # 能量不够
        if t_spell.sp < 0:
            if self.sp < -t_spell.sp:
                return False

        self.spell_id = spell_id
        self.spell(nowtime)
        self.attack_state = 0
        return True

    def auto_spell(self, nowtime):
        t_spell = config.Config.instance().t_spell.get(self.auto_spell_id)
        if self.spell_release_time > nowtime:
            return

        if self.spell_state != 0:
            return

        if self.attrs[1001] > 0:
            return

        if self.attrs[1002] > 0:
            return

        for v in self.spell_cd.values():
            if v > nowtime:
                return

        if t_spell.sp < 0:
            if self.sp < -t_spell.sp:
                return

        self.spell_id = self.auto_spell_id
        self.auto_spell_id = 0
        self.spell(nowtime)
        self.attack_state = 0

    def spell(self, nowtime):
        if self.spell_state == 0:
            # 读条
            t_spell = config.Config.instance().t_spell.get(self.spell_id)
            if t_spell.sing_time > 0:
                self.spell_state = 1
                speed = FightPlayer.convert_per_to_realper(self.attrs[71])
                self.spell_sing_time = nowtime + t_spell.sing_time * speed
                self.attack_time = self.spell_sing_time

            else:
                self.spell_sing_time = nowtime + t_spell.pre_time
                self.spell_state = 2
                self.attack_time = nowtime
        elif self.spell_state == 1:
            if self.spell_sing_time <= nowtime:
                t_spell = config.Config.instance().t_spell.get(self.spell_id)
                self.spell_sing_time = nowtime + t_spell.pre_time
                self.spell_state = 2
        elif self.spell_state == 2:
            if self.spell_sing_time <= nowtime:
                self.hurt(nowtime)
                t_spell = config.Config.instance().t_spell.get(self.spell_id)
                self.spell_release_time = nowtime + t_spell.release_time
                self.spell_state = 0
                self.do_spell(nowtime + t_spell.release_time)
                self.spell_id = self.t_role.attack_id
                self.attack_time = nowtime + t_spell.release_time

    def attack(self, nowtime):
        t_spell = config.Config.instance().t_spell.get(self.spell_id)
        speed = self.convert_per_to_realper(self.attrs[72])
        if self.attack_state == 0:
            if self.attack_time <= nowtime:
                self.attack_state = 1
                self.attack_time = nowtime + t_spell.pre_time * speed
        if self.attack_state == 1:
            if self.attack_time <= nowtime:
                self.hurt(nowtime)
                self.attack_state = 0
                self.attack_time = nowtime + t_spell.release_time * speed

    def hurt(self, nowtime):
        t_spell = config.Config.instance().t_spell.get(self.spell_id)
        ar = 0
        fs = 0
        hf = 0
        hx = 0
        # is_hit = True
        # is_crit = False
        battr_self = player_data.get_base_attr(self.attrs)
        battr_target = player_data.get_base_attr(self.target.attrs)
        if t_spell.target == 1:
            hit = self.calc_hit()
            if hit > tools.LRandom.instance().random(0, 1000):
                if t_spell.dmg_type == 1 or t_spell.dmg_type == 2:
                    attack_attrids = self.get_attack_attrid(self.t_role.attack_type)
                    target_attrids = self.get_attack_attrid(self.target.t_role.attack_type)
                    damage = battr_self[2]
                    ar = damage - battr_target[attack_attrids[0]]

                    if ar < 0:
                        ar = 0

                    # 技能修正
                    self.spell_passive_add_hurt()
                    index = player_data.get_index(self.spells, self.spell_id)
                    if index is not None:
                        spell_damage = t_spell.dmg_param1 + t_spell.dmg_param1_add * (self.spell_levels[index] - 1)
                    else:
                        spell_damage = t_spell.dmg_param1

                    spell_value = 0
                    if t_spell.dmg_type == 2:
                        spell_value = (battr_target[1] - self.target.hp) * (
                                t_spell.dmg_param2 + t_spell.dmg_param1_add * (self.spell_levels[index] - 1)) / 1000

                    damage_increase = self.calc_damage_increase()
                    is_crit, crit_damage = self.calc_crit_damage()
                    race_damage = self.calc_race_damage()
                    as_damage = self.calc_as_damage()

                    ar = ar * spell_damage / 1000 * damage_increase / 1000 * crit_damage / 1000 * race_damage / 1000 * as_damage / 1000
                    ar = ar + spell_value
                    attack_dmg = tools.LRandom.instance().random(900, 1100)
                    ar = ar * attack_dmg / 1000
                    if ar < damage * 0.2:
                        ar = damage * 0.2
                    ar = tools.to_int(self.spell_passive_hurt(ar))
                    fs = fs + self.target.attrs[73]
                    fs = fs + battr_target[target_attrids[0]] * self.target.attrs[74] / 1000
                    fs = tools.to_int(fs + ar * self.target.attrs[75] / 1000)
                    hf = hf + self.target.attrs[76]
                    hf = tools.to_int(hf + battr_self[1] * self.target.attrs[77] / 1000)

                    hx = hx + self.attrs[78]
                    hx = hx + damage * self.attrs[79] / 1000
                    hx = tools.to_int(hx + ar * self.attrs[80] / 1000)

                if ar > 0:
                    self.target.hp = self.target.hp - ar
                if fs > 0:
                    self.hp = self.hp - fs
                if hf > 0:
                    self.target.hp = self.target.hp + hf
                    if self.target.hp > battr_target[1]:
                        self.hp = battr_target[1]
                if hx > 0:
                    self.hp = self.hp + hx
                    if self.hp > battr_self[1]:
                        self.hp = battr_self[1]

                # 被动战神判断
                self.target.spell_passive_add_hp()
                if self.spell_id > 100:
                    self.buff_check(t_spell, nowtime, 1)
            # else:
            #     is_hit = False
        else:
            if t_spell.dmg_type == 3:
                battr_self = player_data.get_base_attr(self.attrs)
                hx = battr_self[1] * t_spell.dmg_param1 / 100
            hx = tools.to_int(hx)
            if hx > 0:
                self.hp = self.hp + hx
                if self.hp > battr_self[1]:
                    self.hp = battr_self[1]

            if self.spell_id > 100:
                self.buff_check(t_spell, nowtime, 1)

        # sp 变化
        self.sp = self.sp + t_spell.sp
        if self.sp > 100:
            self.sp = 100
        elif self.sp < 0:
            self.sp = 0

    def buff_check(self, t_spell, nowtime, mark):
        spell_level = self.spell_levels[player_data.get_index(self.spells, t_spell.id)]
        if spell_level is None:
            spell_level = 1
        for i in range(len(t_spell.buff)):
            t_buff = config.Config.instance().t_spell_buff.get(t_spell.buff[i].id)
            if t_spell.buff[i].target == 1:
                self.target.buff_effect(t_buff, t_spell.buff[i].time, spell_level, nowtime, mark)
            else:
                self.buff_effect(t_buff, t_spell.buff[i].time, spell_level, nowtime, mark)

    def add_buff(self, nowtime, buff_id, t, spell_level):
        if buff_id not in self.buffs:
            if t != -1:
                self.buffs[buff_id] = [t + nowtime, spell_level]
            else:
                self.buffs[buff_id] = [t, spell_level]
        else:
            if t != -1:
                if self.buffs[buff_id][1] < t + nowtime:
                    self.buffs[buff_id] = [t + nowtime, spell_level]
                else:
                    self.buffs[buff_id] = [t, spell_level]

    def remove_buff(self, buff_id):
        del self.buffs[buff_id]

    def buff_effect(self, t_buff, buff_time, spell_level, nowtime, mark):
        for i in range(len(t_buff.buff)):
            self.attrs[t_buff.buff[i].attr] = self.attrs[t_buff.buff[i].attr] + (
                        t_buff.buff[i].value + t_buff.buff[i].add * (spell_level - 1)) * mark
            if t_buff.buff[i].attr == 1001 and mark > 0:
                if nowtime < self.spell_sing_time:
                    self.do_break_sing()
                else:
                    self.do_break()
            elif t_buff.buff[i].attr == 1002 and mark > 0:
                if nowtime < self.spell_sing_time:
                    self.do_break_sing()
        if mark > 0:
            self.add_buff(nowtime, t_buff.id, buff_time, spell_level)
        else:
            self.remove_buff(t_buff.id)

    def buff(self, nowtime):
        buff_copy = self.buffs.copy()
        for k in buff_copy.keys():
            if self.buffs[k][0] <= nowtime and self.buffs[k][0] != -1:
                t_buff = config.Config.instance().t_spell_buff.get(k)
                self.buff_effect(t_buff, 0, self.buffs[k][1], nowtime, -1)

    def is_die(self):
        if self.hp <= 0:
            return True
        return False

    def in_can_spells(self, spell_id):
        for i in range(len(self.can_spells)):
            if self.can_spells[i] == spell_id:
                return True

        return False

    def change_can_spells(self):
        for i in range(len(self.spells)):
            t_spell = config.Config.instance().t_spell.get(self.spells[i])
            if not self.in_can_spells(self.spells[i]):
                if t_spell.sp < 0:
                    if self.sp > -t_spell.sp and t_spell.id != self.spell_id and t_spell.id != self.auto_spell_id:
                        self.can_spells.append(self.spells[i])
                else:
                    if t_spell.id != self.spell_id and t_spell.id != self.auto_spell_id:
                        self.can_spells.append(self.spells[i])

    def update(self, nowtime):
        if self.is_die():
            return

        self.buff(nowtime)

        if self.attrs[1001] > 0:
            return

        if self.auto_spell_id != 0:
            self.auto_spell(nowtime)

        if self.spell_id < 100:
            self.attack(nowtime)
        else:
            self.spell(nowtime)

        self.change_can_spells()


class FightAi:
    def __init__(self):
        self.min_monster_spell_interval = config.Config.instance().const('min_monster_spell_interval')
        self.min_auto_spell_interval = config.Config.instance().const('min_auto_spell_interval')
        self.fighter = FightPlayer()
        self.spell_interval_time = 0
        self.spell_cold_sorts = list()
        self.spell_release_times = dict()

    def start(self, fighter):
        self.fighter = fighter
        self.spell_interval_time = self.min_auto_spell_interval
        t_spells = list()
        for i in range(len(fighter.spells)):
            t_spell = config.Config.instance().t_spell.get(fighter.spells[i])
            t_spells.append(t_spell)
        t_spells.sort(key=lambda spell: spell.cold_time)
        for i in range(len(t_spells)):
            self.spell_cold_sorts.append(t_spells[i].id)
            self.spell_release_times[t_spells[i].id] = 0

    def auto_fight(self):
        nowtime = FightManager.instance().now_time()
        if self.spell_interval_time > nowtime:
            return

        for i in range(len(self.spell_cold_sorts)):
            spell_id = self.spell_cold_sorts[i]
            flag = True
            if self.fighter.fighter_type == 2:
                if self.spell_release_times[spell_id] > nowtime:
                    continue
            if flag and self.fighter.release_spell(spell_id):
                self.spell_release_times[spell_id] = nowtime + self.min_monster_spell_interval
                self.spell_interval_time = nowtime + self.min_auto_spell_interval
                break


def mission(player, t_monster, param):
    fight = FightManager().instance()
    fight.fighter1_ = fight.create_player(player, 0)
    fight.fighter2_ = fight.create_monster(player, t_monster, 1, -1)
    fight.init(param)
    fight.start()
    while True:
        fight.fixed_update_beat()
        if not fight.start_:
            return fight.is_win_
