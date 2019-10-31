from common import guid_tool
from common.db import db_gtool, db_log
import player_pool, config, promotion_pool
from common.proto.equip_db_pb2 import *
from common.proto.common_msg_pb2 import *
from pgame.service import PGame
import random, math
import mail_pool, pet_data, gs_message
from common.opcodes import Opcodes, Errors, LogMode, LogOp, LogWay
import re
import tools


def player_login(player):
    # 数据修复
    while len(player.equip_slots) < 8:
        player.equip_slots.append(0)
    while len(player.equip_shows) < 8:
        player.equip_shows.append(0)
    while len(player.equip_enhances) < 8:
        player.equip_enhances.append(0)
    while len(player.rune_slot1s) < 8:
        player.rune_slot1s.append(0)
    while len(player.rune_slot2s) < 8:
        player.rune_slot2s.append(0)
    while len(player.rune_slot3s) < 8:
        player.rune_slot3s.append(0)
    while len(player.spell_passive_slots) < 3:
        player.spell_passive_slots.append(0)
    while len(player.pet_slots) < 4:
        player.pet_slots.append(0)
    while len(player.spell_passive_slots) > 3:
        del player.spell_passive_slots[len(player.spell_passive_slots) - 1]

    while len(player.artifact_unlocks) < len(player.artifact_ids):
        player.artifact_unlocks.append(0)
    while len(player.equip_dresses_unlock) < len(player.equip_dresses):
        player.equip_dresses_unlock.append(0)
    while len(player.pet_unlocks) < len(player.pet_ids):
        player.pet_unlocks.append(0)

    while len(player.item_nums) < len(player.item_ids):
        player.item_nums.append(0)

    equip_repair(player)
    player_repair(player)

    if PGame.timer.trigger_time(player.last_refresh_time, 5, 0):
        player_refresh(player)
        if PGame.timer.trigger_week_time(player.last_refresh_week_time):
            player_refresh_week(player)
        if PGame.timer.trigger_month_time(player.last_refresh_month_time):
            player_refresh_month(player)

    player.seed = random.randint(1000000, 9999999)

    upgrade_operating(player, player.level)


# 角色数据修复
def player_repair(player):

    for i in range(len(player.tasks) - 1, -1, -1):
        t_quest = config.Config.instance().t_quest.get(player.tasks[i])
        if t_quest is None:
            del player.tasks[i]

    for i in range(len(player.task_ends) - 1, -1, -1):
        t_quest = config.Config.instance().t_quest.get(player.task_ends[i])
        if t_quest is None:
            del player.task_ends[i]

    for i in range(len(player.task_ids) - 1, -1, -1):
        t_quest_sub = config.Config.instance().t_quest_sub.get(player.task_ids[i])
        if t_quest_sub is None:
            del player.task_ids[i]
            del player.task_reaches[i]

    num = len(player.monsters)
    while len(player.monster_tasks) < num:
        player.monster_tasks.append(0)

    for i in range(len(player.dungeons)):
        assets = msg_assets()
        if not proto_utils.parse(assets, player.dungeon_assets[i]):
            player.dungeon_assets[i] = b''
            assets = msg_assets()
        player.dungeon_tags[i] = 1
        add_assets_set(player, assets)

    if player.aside - 1 > player.map:
        t_map = config.Config.instance().t_map.get(player.aside - 1)
        if t_map:
            if t_map.map_param != 0 and if_quest_end(player, t_map.map_param):
                player.map = t_map.id


# 装备数据修复
def equip_repair(player):
    equip_attr_min = config.Config.instance().const('equip_attr_min')
    for equip in player.equips.values():
        if equip.color == 5 and equip.template_id not in player.equip_dresses:
            player.equip_dresses.append(equip.template_id)
        if equip.color < 5 and equip.template_id in player.equip_dresses:
            for i in range(len(player.equip_dresses)):
                if player.equip_dresses[i] == equip.template_id:
                    del player.equip_dresses[i]
                    break

        if equip.percent < equip_attr_min:
            equip.percent = equip_attr_min


def player_logout(player):
    if player.guid in tools.LRandom.instance().fight_duration.keys():
        del tools.LRandom.instance().fight_duration[player.guid]
    if player.guid in tools.LRandom.instance().player_codes.keys():
        del tools.LRandom.instance().player_codes[player.guid]
    if player.guid in tools.LRandom.instance().player_username.keys():
        del tools.LRandom.instance().player_username[player.guid]


def client_login(player):
    player_pool.PlayerPool.instance().del_player_time(player.guid)


def client_logout(player):
    player_pool.PlayerPool.instance().add_player_time(player.guid)


def client_check():
    # 双端数据校验

    debug = PGame.env.get_setting_value('debug')
    if debug == 0:
        return

    for player_guid in PGame.pool.guid_obj.keys():
        if guid_tool.type_guid(player_guid) == guid_tool.et['player']:
            player = PGame.pool.guid_obj[player_guid]
            if player is None:
                continue
        else:
            continue

        check_data = player.SerializeToString()
        guids = list()
        for guid in player.equips.keys():
            guids.append(guid)
        guids = sorted(guids)
        for i in range(len(guids)):
            check_data += player.equips[guids[i]].SerializeToString()
        guids.clear()
        for guid in player.pets.keys():
            guids.append(guid)
        guids = sorted(guids)
        for i in range(len(guids)):
            check_data += player.pets[guids[i]].SerializeToString()
        gs_message.send_smsg_check_data(player.guid, check_data)


def player_refresh(player):
    """每日刷新"""

    assets = msg_assets()
    player.last_refresh_time = PGame.timer.now()
    refresh_time = player.last_refresh_time
    player.is_checked = 0
    player.task_num = 0
    for i in range(len(player.daily_ids)-1, -1, -1):
        del player.daily_ids[i]
        del player.daily_nums[i]
        del player.daily_reaches[i]
    for i in range(len(player.daily_rewards)-1, -1, -1):
        del player.daily_rewards[i]

    for i in range(len(player.shop_ids)-1, -1, -1):
        del player.shop_ids[i]
        del player.shop_nums[i]

    # 刷新竞技场
    t_arena_reward = config.Config.instance().t_arena_reward.get(player.arena_segment)
    if player.arena_integral > t_arena_reward.score:
        arena_refresh(player, t_arena_reward.next)
    else:
        arena_refresh(player, player.arena_segment)

    return assets, refresh_time


def player_refresh_week(player):
    """每周刷新"""

    player.last_refresh_week_time = PGame.timer.now()

    # 刷新竞技场
    t_arena_reward = config.Config.instance().t_arena_reward.get(player.arena_segment)
    arena_refresh(player, t_arena_reward.season_end_segment)


def player_refresh_month(player):
    player.last_refresh_month_time = PGame.timer.now()


def add_assets(player, tp, value1, value2, value3, assets=None, merge=True, log_way=None):
    if assets is None:
        assets = msg_assets()
    if tp == 1:                 # t_resource
        assets = add_resource(player, value1, value2, assets, merge, log_way)
    elif tp == 2:               # t_item
        assets = add_item(player, value1, value2, assets, merge)
    elif tp == 3:               # t_equip
        max_equip_bag = config.Config().instance().const('max_equip_bag')
        equip_num = len(player.equips)
        for i in range(len(player.equip_slots)):
            if player.equip_slots[i] > 0:
                equip_num -= 1
        if equip_num >= max_equip_bag:
            return assets
        equip = add_equip(player, value1, value2, value3)
        if equip is not None:
            assets.equips.add().CopyFrom(equip.obj)
        if equip.color == 5 and equip.template_id not in player.equip_dresses:
            player.equip_dresses.append(equip.template_id)
            player.equip_dresses_unlock.append(0)
    elif tp == 4:               # t_artifact
        assets = add_artifact(player, value1, value2, assets)
    elif tp == 5:               # t_rune
        assets = add_rune(player, value1, value2, assets, merge)
    elif tp == 6:               # t_pet
        pet = pet_data.create_pet(player, value1)
        if pet is not None:
            assets.pets.add().CopyFrom(pet.obj)
    elif tp == 7:
        assets = pet_data.pet_assets(player, value1, value2, value3)
    return assets


def remove_assets(player, tp, value1, value2):
    if tp == 1:
        add_resource(player, value1, -value2)
    elif tp == 2:
        remove_item(player, value1, value2)
    elif tp == 3:
        remove_equip(player, value1)
    elif tp == 4:
        remove_artifact(player, value1, value2)
    elif tp == 5:
        remove_rune(player, value1, value2)


def get_assets_num(player, tp, value):
    if tp == 1:
        return get_resource_num(player, value)
    elif tp == 2:
        return get_item_num(player, value)
    elif tp == 4:
        return get_artifact_num(player, value)
    elif tp == 5:
        return get_rune_num(player, value)


def add_resource(player, resource_id, num, assets=None, merge=True, log_way=None):
    asset = msg_asset()
    asset.type = 1
    asset.value1 = resource_id
    asset.value2 = num
    if assets is None:
        assets = msg_assets()

    assets = if_merge_assets(merge, assets, asset)

    if resource_id == 1:
        player.gold += num
    elif resource_id == 2:
        player.jewel += num
    elif resource_id == 3:
        player.exp += num
        upgrade(player)
    elif resource_id == 4:
        player.honor += num
    elif resource_id == 5:
        player.reputation += num

    username = tools.LRandom.instance().player_username[player.guid]
    if log_way is not None:
        if num > 0:
            db_log.DbLog.instance().info(username, player.guid, LogMode.LOG_RESOURCE, asset.type, asset.value1, asset.value2,
                                         asset.value3, log_way, LogOp.LOG_ADD)
        else:
            db_log.DbLog.instance().info(username, player.guid, LogMode.LOG_RESOURCE, asset.type, asset.value1, asset.value2,
                                         asset.value3, log_way, LogOp.LOG_DEC)

    return assets


def if_merge_assets(merge, assets, asset):
    if merge:
        mark = False
        for i in range(len(assets.assets)):
            if asset.type == assets.assets[i].type and asset.value1 == assets.assets[i].value1:
                assets.assets[i].value2 += asset.value2
                mark = True
        if not mark:
            assets.assets.add().CopyFrom(asset)
    else:
        assets.assets.add().CopyFrom(asset)

    return assets


def get_resource_num(player, resource_id):
    if resource_id == 1:
        return player.gold
    elif resource_id == 2:
        return player.jewel
    elif resource_id == 3:
        return player.exp
    elif resource_id == 4:
        return player.honor
    elif resource_id == 5:
        return player.reputation


def get_item_num(player, item_id):
    for i in range(len(player.item_ids)):
        if player.item_ids[i] == item_id:
            return player.item_nums[i]
    return 0


def add_item(player, item_id, num, assets=None, merge=True):
    if assets is None:
        assets = msg_assets()

    t_item = config.Config.instance().t_item.get(item_id)
    if t_item is None:
        PGame.log.error('t_item ' + str(item_id) + ' is None')
        return assets

    asset = msg_asset()
    asset.type = 2
    asset.value1 = item_id
    asset.value2 = num

    assets = if_merge_assets(merge, assets, asset)

    for i in range(len(player.item_ids)):
        if player.item_ids[i] == item_id:
            player.item_nums[i] += num
            return assets
    player.item_ids.append(item_id)
    player.item_nums.append(num)
    return assets


def remove_item(player, item_id, num):
    for i in range(len(player.item_ids)):
        if player.item_ids[i] == item_id:
            if player.item_nums[i] == num:
                del player.item_ids[i]
                del player.item_nums[i]
            else:
                player.item_nums[i] -= num
            return


def get_artifact_num(player, artifact_id):
    for i in range(len(player.artifact_ids)):
        if player.artifact_ids[i] == artifact_id:
            return player.artifact_nums[i]
    return 0


def add_artifact(player, artifact_id, num, assets=None):
    if assets is None:
        assets = msg_assets()

    t_artifact = config.Config.instance().t_artifact.get(artifact_id)
    if t_artifact is None:
        PGame.log.error('t_artifact ' + str(artifact_id) + ' is None')
        return assets

    asset = msg_asset()
    asset.type = 4
    asset.value1 = artifact_id
    asset.value2 = num

    if num == 0:
        if artifact_id not in player.artifact_ids:
            player.artifact_ids.append(artifact_id)
            player.artifact_nums.append(0)
            player.artifact_unlocks.append(0)
            assets.assets.add().CopyFrom(asset)
    elif num == 1:
        for i in range(len(player.artifact_ids)):
            if player.artifact_ids[i] == artifact_id:
                if player.artifact_nums[i] == 0:
                    player.artifact_nums[i] = 1
                    assets.assets.add().CopyFrom(asset)
                return assets

    return assets


def remove_artifact(player, artifact_id, num):
    for i in range(len(player.artifact_ids)):
        if player.artifact_ids[i] == artifact_id:
            if player.artifact_nums[i] == num:
                player.artifact_ids[i] = player.artifact_ids[len(player.artifact_ids) - 1]
                player.artifact_ids.pop()
                player.artifact_nums[i] = player.artifact_nums[len(player.artifact_nums) - 1]
                player.artifact_nums.pop()
            else:
                player.artifact_nums[i] -= num
            return


def get_rune_num(player, rune_id):
    for i in range(len(player.rune_ids)):
        if player.rune_ids[i] == rune_id:
            return player.rune_nums[i]
    return 0


def add_rune(player, rune_id, rune_num, assets=None, merge=True):
    if assets is None:
        assets = msg_assets()

    t_rune = config.Config.instance().t_rune.get(rune_id)
    if t_rune is None:
        PGame.log.error('t_artifact ' + str(rune_id) + ' is None')
        return assets

    asset = msg_asset()
    asset.type = 5
    asset.value1 = rune_id
    asset.value2 = rune_num

    assets = if_merge_assets(merge, assets, asset)

    for i in range(len(player.rune_ids)):
        if player.rune_ids[i] == rune_id:
            player.rune_nums[i] += rune_num
            return assets
    player.rune_ids.append(rune_id)
    player.rune_nums.append(rune_num)
    return assets


def remove_rune(player, rune_id, rune_num):
    for i in range(len(player.rune_ids)):
        if player.rune_ids[i] == rune_id:
            if player.rune_nums[i] == rune_num:
                player.rune_ids[i] = player.rune_ids[len(player.rune_ids) - 1]
                player.rune_ids.pop()
                player.rune_nums[i] = player.rune_nums[len(player.rune_nums) - 1]
                player.rune_nums.pop()
            else:
                player.rune_nums[i] -= rune_num
            return


def add_equip(player, template_id, level=0, color=0, new=True):
    t_equip = config.Config().instance().t_equip.get(template_id)
    if t_equip is None:
        PGame.log.debug("t_equip is None")
        return None
    guid = db_gtool.DbGtool.instance().assign(guid_tool.et['equip'])
    equip = equip_t()
    equip.guid = guid
    equip.player_guid = player.guid
    equip.template_id = template_id

    if 0 < level <= 10:
        equip.level = t_equip.min_level - 1 + level
    else:
        equip.level = random.randint(t_equip.min_level, t_equip.max_level)

    if 0 < color <= 5:
        equip.color = color

    generate_equip(equip)
    if new:
        player.new(equip, 'equips')

    return equip


# 装备随机品质
def generate_equip(equip):
    t_equip = config.Config().instance().t_equip.get(equip.template_id)
    if t_equip is None:
        PGame.log.debug("t_equip is None")
        return

    t_equip_random_rate = config.Config.instance().t_equip_random_rate.get()
    if t_equip_random_rate is None:
        PGame.log.debug("t_equip_reforges is None")
        return

    # 随机出装备的品质
    if equip.color == 0:
        seq = list()
        for i in range(len(t_equip_random_rate)):
            seq.append([t_equip_random_rate[i].color, t_equip_random_rate[i].weight])
        equip.color = tools.randseq(seq)

    # 主属性百分比
    per = get_per()
    equip_attr_min = config.Config.instance().const('equip_attr_min')
    equip.attr = t_equip.attr
    t_attr = config.Config().instance().t_attr.get(t_equip.attr)
    t_level = config.Config().instance().t_level.get(equip.level)
    value = t_level.std_attr * t_equip.value / 100 * t_attr.value
    value = math.ceil(value * ((100 - equip_attr_min) + per) / 100)
    value = get_equip_color_value(value, equip.color)
    equip.value = value
    equip.percent = per

    t_equip_random_num = config.Config.instance().t_equip_random_num.get()
    if t_equip_random_num is None:
        PGame.log.debug("t_equip_reforges is None")
        return

    # 随机出属性条数
    color_ids = list()

    for i in range(2, equip.color+1):
        seq = list()
        for j in range(t_equip.max_q):
            seq.append([t_equip_random_num[j].num, t_equip_random_num[j].weight])
        color_id = tools.randseq(seq)
        color_ids.append([color_id if color_id <= t_equip.max_q else t_equip.max_q, i])

    t_equip_randoms = config.Config().instance().t_equip_random.get()
    if t_equip_randoms is None:
        PGame.log.debug("t_equip_reforges is None")
        return

    # 随机出每个属性
    sids = list()
    for i in range(len(color_ids)):
        for j in range(color_ids[i][0]):
            seq = list()
            for k in range(len(t_equip_randoms)):
                if t_equip_randoms[k].color == color_ids[i][1]:
                    seq.append([t_equip_randoms[k].value, 100])
            ids = tools.randseq(seq)
            if [ids, color_ids[i][1]] not in sids:
                sids.append([ids, color_ids[i][1]])
            else:
                j -= 1

    # 清除装备属性
    equip.ClearField("attr_ids")
    equip.ClearField("attr_values")
    equip.ClearField("attr_colors")
    equip.ClearField("attr_pers")

    t_level = config.Config.instance().t_level.get(equip.level)

    # 把随机出的属性做数值化并写入装备中
    for i in range(len(sids)):
        for j in range(len(t_equip_randoms)):
            if t_equip_randoms[j].color == sids[i][1] and t_equip_randoms[j].value == sids[i][0]:
                attr_id = t_equip_randoms[j].value
                percent = get_per()
                if percent is None:
                    PGame.log.debug('percent is None')
                    return

                power_per = (t_equip_randoms[j].max - t_equip_randoms[j].min) * percent / 100 + t_equip_randoms[j].min
                if t_equip_randoms[j].type == 1:
                    t_attr = config.Config().instance().t_attr.get(attr_id)
                    if t_attr.value != 0:
                        attr_value = math.ceil(power_per * t_level.std_attr * t_attr.value / 10000)
                    else:
                        attr_value = math.ceil(power_per * t_level.std_per / 100)
                else:
                    attr_value = math.ceil(power_per * t_level.std_spell / 100)
                attr_value = get_equip_color_value(attr_value, equip.color)
                equip.attr_types.append(t_equip_randoms[j].type)
                equip.attr_ids.append(attr_id)
                equip.attr_values.append(attr_value)
                equip.attr_colors.append(t_equip_randoms[j].color)
                equip.attr_pers.append(percent)


# 装备重铸
def reforge_equip(equip, color):
    t_equip = config.Config.instance().t_equip.get(equip.template_id)
    if t_equip is None:
        PGame.log.debug('t_equip is None')
        return

    t_equip_randoms = config.Config.instance().t_equip_random.get()
    if t_equip_randoms is None:
        PGame.log.error('t_equip_randoms is None')
        return

    t_level = config.Config.instance().t_level.get(equip.level)

    for i in range(len(equip.attr_colors)):
        for j in range(len(t_equip_randoms)):
            if equip.attr_colors[i] == color and t_equip_randoms[j].value == equip.attr_ids[i] and t_equip_randoms[j].color == equip.attr_colors[i]:
                attr_id = t_equip_randoms[j].value
                percent = get_per()
                power_per = (t_equip_randoms[j].max - t_equip_randoms[j].min) * percent / 100 + t_equip_randoms[j].min
                if t_equip_randoms[j].type == 1:
                    t_attr = config.Config().instance().t_attr.get(attr_id)
                    if t_attr.value != 0:
                        attr_value = math.ceil(power_per * t_level.std_attr * t_attr.value / 10000)
                    else:
                        attr_value = math.ceil(power_per * t_level.std_per / 100)
                else:
                    attr_value = math.ceil(power_per * t_level.std_spell / 100)
                attr_value = get_equip_color_value(attr_value, equip.color)
                equip.attr_values[i] = attr_value
                equip.attr_pers[i] = percent
    equip.reforge_count += 1


def get_per():
    t_equip_random_values = config.Config.instance().t_equip_random_value.get()
    if t_equip_random_values is None:
        PGame.log.debug('t_equip_random_values is None')
        return None
    seq = list()
    for i in range(len(t_equip_random_values)):
        seq.append([t_equip_random_values[i].color, t_equip_random_values[i].weight])
    color = tools.randseq(seq)
    t_equip_random_value = config.Config.instance().t_equip_random_value.get(color)
    if t_equip_random_value is None:
        PGame.log.debug('t_equip_random_value is None')
        return None

    return random.randint(t_equip_random_value.min, t_equip_random_value.max)


def get_equip_color_value(value, color):
    t_equip_color = config.Config.instance().t_equip_color.get(color)
    return math.ceil(value * t_equip_color.rate / 100)


def remove_equip(player, equip_guid):
    player.delete(equip_guid, 'equips')


# 玩家升级
def upgrade(player):
    while True:
        t_level = config.Config.instance().t_level.get(player.level + 1)
        if t_level is None:
            return
        if player.exp >= t_level.exp:
            player.level += 1
            player.exp -= t_level.exp
            # 玩家升级
            upgrade_operating(player, player.level)
        else:
            return


def reduce_exp(player):
    die_reduce_exp = config.Config.instance().const('die_reduce_exp')
    t_level = config.Config.instance().t_level.get(player.level + 1)
    if t_level is not None:
        exp = tools.to_int(t_level.exp * die_reduce_exp / 100)
        if exp > player.exp:
            exp = player.exp
        add_resource(player, 3, -exp)


def upgrade_operating(player, level):

    # 刷新排行榜
    rank_join_level = config.Config.instance().const('rank_join_level')
    if player.level >= rank_join_level:
        sid = PGame.env.get_setting_value('qid')
        for i in range(1, 4):
            guid = guid_tool.make_guid(guid_tool.et['rank'], sid, i)
            promotion_pool.PromotionPool.instance().update_rank(guid, player)


def get_attr(player):
    attr = dict()
    t_attr = config.Config.instance().t_attr.get()
    for i in range(len(t_attr)):
        attr[t_attr[i].id] = 0
    for i in range(4):
        attr[i + 1] = get_level_value(player.level, i + 1) * 5

    for i in range(10, 16):
        attr[i + 1] = get_level_value(player.level, i + 1)

    for i in range(len(player.equip_slots)):
        if player.equip_slots[i] != 0:
            equip = player.equips[player.equip_slots[i]]
            enhance = player.equip_enhances[i]
            if equip is None:
                player.equip_slots[i] = 0
                continue
            t_equip = config.Config.instance().t_equip.get(equip.template_id)
            if enhance > t_equip.enhance_limit:
                enhance = t_equip.enhance_limit
            # t_attr = config.Config.instance().t_attr.get(equip.attr)
            base_value = get_equip_enhance_value(equip.value, enhance)
            attr[t_equip.attr] = attr[t_equip.attr] + base_value

            # 附魔属性
            t_equip_enchant = config.Config.instance().t_equip_enchant.get(equip.enchant_id)
            if t_equip_enchant:
                t_attr = config.Config.instance().t_attr.get(t_equip_enchant.attr)
                if t_attr:
                    attr[t_equip_enchant.attr] = attr[t_equip_enchant.attr] + equip.enchant_value

            # 重铸属性
            for j in range(len(equip.attr_ids)):
                if equip.attr_types[j] == 1:
                    attr[equip.attr_ids[j]] += get_equip_enhance_value(equip.attr_values[j], enhance)

            # 宝石
            if player.rune_slot1s[i] != 0:
                t_rune = config.Config.instance().t_rune.get(player.rune_slot1s[i])
                if t_rune:
                    attr[t_rune.attr_id] += t_rune.attr_value
            if player.rune_slot2s[i] != 0:
                t_rune = config.Config.instance().t_rune.get(player.rune_slot2s[i])
                if t_rune:
                    attr[t_rune.attr_id] += t_rune.attr_value
            if player.rune_slot3s[i] != 0:
                t_rune = config.Config.instance().t_rune.get(player.rune_slot3s[i])
                if t_rune:
                    attr[t_rune.attr_id] += t_rune.attr_value

    '''
    for i in range(len(player.artifact_ids)):
        if player.artifact_nums[i] > 0:
            t_artifact = config.Config.instance().t_artifact.get(player.artifact_ids[i])
            if t_artifact is not None:
                for j in range(len(t_artifact.attrs)):
                    attr[t_artifact.attrs[j].id] += t_artifact.attrs[j].value
    '''

    return attr


def get_base_attr(attr):
    battr = dict()
    battr[1] = tools.to_int(attr[1] * (1000 + attr[21]) / 1000)
    battr[2] = tools.to_int(attr[2] * (1000 + attr[22]) / 1000)
    battr[3] = tools.to_int((attr[3] + attr[17]) * (1000 + attr[23]) / 1000)
    battr[4] = tools.to_int((attr[4] + attr[17]) * (1000 + attr[24]) / 1000)
    return battr


def get_equip_enhance_value(attr_value, enhance):
    t_equip_enhance = config.Config.instance().t_equip_enhance.get(enhance)
    if t_equip_enhance is not None:
        total_value = t_equip_enhance.total_value
        if total_value != 0:
            return attr_value + attr_value * total_value / 100
        else:
            return attr_value
    else:
        return attr_value


# 获取战斗力
def get_fight_power(player):
    attr = get_attr(player)
    battr = get_base_attr(attr)
    fp = 0

    for i in range(1, 6):
        t_attr = config.Config.instance().t_attr.get(i)
        if t_attr:
            fp = fp + t_attr.power * battr[i]
    for i in range(11, 18):
        t_attr = config.Config.instance().t_attr.get(i)
        if t_attr:
            fp = fp + t_attr.power * attr[i]

    return tools.to_int(fp)


# 根据战斗力获取属性值
def get_power_value(power, attr_id):
    t_attr = config.Config.instance().t_attr.get(attr_id)
    if t_attr is None:
        return 0
    return power / 100 * t_attr.value


# 根据等级获取属性值
def get_level_value(level, attr_id):
    t_level = config.Config.instance().t_level.get(level)
    if t_level is None:
        return 0

    return get_power_value(t_level.std_attr, attr_id)


def get_assets(tp, value1, value2, value3, assets=None):
    if assets is None:
        assets = msg_assets()
    asset = msg_asset()
    asset.type = tp
    asset.value1 = value1
    asset.value2 = value2
    asset.value3 = value3
    assets.assets.add().CopyFrom(asset)

    return assets


def get_map_die_time(player, mission_id):
    for i in range(len(player.map_die_ids)):
        if mission_id == player.map_die_ids[i]:
            return player.map_die_times[i]
    return 0


# 获取任务线
def get_task_line(quest_id):
    t_quest_sub = config.Config.instance().t_quest_sub.get()
    if t_quest_sub is None:
        PGame.log.error('t_quest_sub is None')
        return None

    task_line = dict()
    for i in range(len(t_quest_sub)):
        if t_quest_sub[i].quest == quest_id:
            task_line[t_quest_sub[i].id] = None

    for i in range(len(t_quest_sub)):
        if t_quest_sub[i].quest == quest_id:
            task_line[t_quest_sub[i].pre_sub] = t_quest_sub[i].id

    return task_line


def if_quest_end(player, quest_sub_id):
    t_quest_sub = config.Config.instance().t_quest_sub.get(quest_sub_id)
    if t_quest_sub is None:
        PGame.log.error('t_quest_sub is None')
        return False

    if t_quest_sub.quest in player.task_ends:
        return True

    if t_quest_sub.quest in player.tasks:
        for i in range(len(player.task_ids)):
            if player.task_ids[i] == quest_sub_id:
                if player.task_reaches[i] == -1:
                    return True
                break

    return False


def daily_unlock(player, daily_id):
    t_daily = config.Config.instance().t_daily.get(daily_id)
    if t_daily.unlock_type == 1:
        if t_daily.unlock_param > player.level:
            return False
    elif t_daily.unlock_type == 2:
        return if_quest_end(player, t_daily.unlock_param)

    return True


# 日常任务
def daily_schedule(player, daily_id, num):
    if daily_unlock(player, daily_id):
        for i in range(len(player.daily_ids)):
            if player.daily_ids[i] == daily_id:
                player.daily_nums[i] += num
                return
        player.daily_ids.append(daily_id)
        player.daily_nums.append(num)
        player.daily_reaches.append(0)

    return


# 完成任务
def daily_reached(player, daily_id):
    for i in range(len(player.daily_ids)):
        if player.daily_ids[i] == daily_id:
            player.daily_reaches[i] += 1
            return


# 完成任务进度 mission相关
def task_reached(player, t_mission):
    count = list()
    for i in range(len(player.task_ids)):
        if player.task_reaches[i] != -1:
            t_quest_sub = config.Config.instance().t_quest_sub.get(player.task_ids[i])
            if t_quest_sub.event_type == 2:
                if t_quest_sub.event_param1 == t_mission.monsterid or t_quest_sub.event_param1 == 0:
                    player.task_reaches[i] = player.task_reaches[i] + 1
            elif t_quest_sub.event_type == 5:
                if t_quest_sub.event_param1 == t_mission.monsterid or t_quest_sub.event_param1 == 0:
                    if random.randint(0, 99) <= t_quest_sub.event_param3:
                        count.append(player.task_ids[i])
                        player.task_reaches[i] = player.task_reaches[i] + 1
            elif t_quest_sub.event_type == 12 and t_mission.type == 2:
                if t_quest_sub.map == t_mission.chapter:
                    t_monster = config.Config.instance().t_monster.get(t_mission.monsterid)
                    index = get_index(player.monsters, t_monster.role_id)
                    if player.monster_tasks[index] == 0:
                        player.monster_tasks[index] = 1
                        player.task_reaches[i] = player.task_reaches[i] + 1
            elif t_quest_sub.event_type == 13 and t_mission.type == 2:
                if t_quest_sub.event_param1 == t_mission.id:
                    player.task_reaches[i] = player.task_reaches[i] + 1

    return count


# 完成任务进度 mission无关
def task_reached_other(player, tp, param=None):
    for i in range(len(player.task_ids)):
        if player.task_reaches[i] != -1:
            t_quest_sub = config.Config.instance().t_quest_sub.get(player.task_ids[i])
            if t_quest_sub.event_type == 11 and tp == 11:
                if param == t_quest_sub.event_param1:
                    player.task_reaches[i] = 1
            elif t_quest_sub.event_type == 14 and tp == 14:
                player.task_reaches[i] = 1
            elif t_quest_sub.event_type == 15 and tp == 15:
                player.task_reaches[i] = 1
            elif t_quest_sub.event_type == 16 and tp == 16:
                if param == t_quest_sub.event_param1:
                    player.task_reaches[i] = 1


def get_task_reaches(player, task_id):
    for i in range(len(player.task_ids)):
        if player.task_ids[i] == task_id:
            return player.task_reaches[i]


def make_monsters_set(player, mission_id):
    for i in range(len(player.monsters)):
        if player.monsters[i] == mission_id:
            player.monster_nums[i] += 1
            return

    player.monsters.append(mission_id)
    player.monster_tasks.append(0)
    player.monster_nums.append(1)
    player.monster_unlocks.append(0)


# 副本事件线
def get_dungeon_line(event_id):
    t_dungeon_event = config.Config.instance().t_dungeon_event.get()
    if t_dungeon_event is None:
        PGame.log.error('t_quest_sub is None')
        return None

    dungeon_line = dict()
    for i in range(len(t_dungeon_event)):
        if t_dungeon_event[i].event_id == event_id:
            dungeon_line[t_dungeon_event[i].id] = None

    for i in range(len(t_dungeon_event)):
        if t_dungeon_event[i].event_id == event_id:
            dungeon_line[t_dungeon_event[i].pre_dungeon] = t_dungeon_event[i].id

    return dungeon_line


def make_dungeon_assets(player, tp, value1, value2, value3, assets, bonus=1, merge=False):
    if tp == 3:
        for i in range(bonus):
            equip = add_equip(player, value1, value2, value3, False)
            assets.equips.add().CopyFrom(equip.obj)
    else:
        asset = msg_asset()
        asset.type = tp
        asset.value1 = value1
        asset.value2 = value2 * bonus
        asset.value3 = value3
        mark = False
        if merge:
            for i in range(len(assets.assets)):
                if asset.type == assets.assets[i].type and asset.value1 == assets.assets[i].value1:
                    assets.assets[i].value2 += asset.value2
                    mark = True
            if not mark:
                assets.assets.add().CopyFrom(asset)
        else:
            assets.assets.add().CopyFrom(asset)

    return assets


def merge_assets(assets, dungeon_assets):
    for i in range(len(dungeon_assets.equips)):
        assets.equips.add().CopyFrom(dungeon_assets.equips[i])
    for i in range(len(dungeon_assets.pets)):
        assets.pets.add().CopyFrom(dungeon_assets.pets[i])
    for i in range(len(dungeon_assets.assets)):
        assets.assets.add().CopyFrom(dungeon_assets.assets[i])
    return assets


def add_assets_set(player, assets):
    for i in range(len(assets.assets)):
        add_assets(player, assets.assets[i].type, assets.assets[i].value1,
                   assets.assets[i].value2, assets.assets[i].value3)

    max_equip_bag = config.Config().instance().const('max_equip_bag')
    equip_num = len(player.equips)
    for j in range(len(player.equip_slots)):
        if player.equip_slots[j] > 0:
            equip_num -= 1
    index = -1

    for i in range(len(assets.equips)):
        if equip_num >= max_equip_bag:
            index = i
            break
        equip_num += 1
        equip = equip_t()
        equip.obj = assets.equips[i]
        if equip.color == 5 and equip.template_id not in player.equip_dresses:
            player.equip_dresses.append(equip.template_id)
            player.equip_dresses_unlock.append(0)
        player.new(equip, 'equips')
    if index != -1:
        for i in range(len(assets.equips) - 1, index, -1):
            del assets.equips[i]


def get_index(arr, v):
    for i in range(len(arr)):
        if v == arr[i]:
            return i
    return None


def quest_over(player, t_quest_sub_id):
    t_quest_sub = config.Config.instance().t_quest_sub.get(t_quest_sub_id)
    if t_quest_sub is not None:
        for i in range(len(player.task_ends)):
            if t_quest_sub.quest == player.task_ends[i]:
                return True
        for i in range(len(player.task_ids)):
            if t_quest_sub.id == player.task_ids[i] and player.task_reaches[i] == -1:
                return True

    return False


# 用户昵称是否符合规范
# 规则：中英文数字 其他不合理
def check_name(name):
    if len(name.encode('gbk')) > 16:
        return False
    if re.search(r'([^\u4e00-\u9fa5\u0030-\u0039\u0041-\u005a\u0061-\u007a])', name) is None:
        return True
    else:
        return False


# 掉落计算
def assets_calc(player, t_config, t_monster, assets, color=False):
    if color:
        t_mission_random = config.Config.instance().t_mission_random.get(t_config.diff)
        bonus = (100 + t_mission_random.bonus) / 100
    else:
        bonus = 1
    if t_monster.level == -1:
        level_punish = 0
        t_level = config.Config.instance().t_level.get(player.level)
    else:
        level_punish = int((player.level - 1) / 10) - int((t_monster.level - 1) / 10)
        t_level = config.Config.instance().t_level.get(t_monster.level)

    t_level_punishes = config.Config.instance().t_level_punish.get()
    if level_punish < t_level_punishes[0].level:
        t_level_punish = t_level_punishes[0]
    elif level_punish > t_level_punishes[len(t_level_punishes) - 1].level:
        t_level_punish = t_level_punishes[len(t_level_punishes) - 1]
    else:
        t_level_punish = config.Config.instance().t_level_punish.get(level_punish)

    for i in range(len(t_config.drops)):
        for _ in range(t_config.drops[i].num):
            index = random.randint(0, 999999)
            if index < math.ceil(t_config.drops[i].rate * bonus * t_level_punish.drop / 100):
                tp = t_config.drops[i].type
                value1 = t_config.drops[i].value1
                value2 = t_config.drops[i].value2
                value3 = t_config.drops[i].value3
                assets = make_dungeon_assets(player, tp, value1, value2, value3, assets, 1, False)

    for i in range(len(t_config.dropgroup)):
        for _ in range(t_config.dropgroup[i].num):
            index = random.randint(0, 999999)
            if index < math.ceil(t_config.dropgroup[i].rate * bonus * t_level_punish.drop / 100):
                t_drop = config.Config.instance().t_drop.get(t_config.dropgroup[i].id)
                seq = list()
                for j in range(len(t_drop.assets)):
                    seq.append([j, t_drop.assets[j].weight])
                k = tools.randseq(seq)
                assets = make_dungeon_assets(player, t_drop.assets[k].type, t_drop.assets[k].value1,  t_drop.assets[k].value2, t_drop.assets[k].value3, assets, 1, False)

    gold_bonus = math.ceil(t_config.gold_bonus / 100)
    bonus = list()
    for _ in range(math.floor(gold_bonus / 2)):
        percent = random.randint(10, 190) / 100
        bonus.append(1 - percent)
        gold = math.ceil(t_level.std_gold * random.randint(90, 110) / 100 * percent * t_level_punish.gold / 100)
        assets = make_dungeon_assets(player, 1, 1, gold, 0, assets, merge=False)
    for _ in range(gold_bonus - math.floor(gold_bonus / 2)):
        percent = 1
        if len(bonus) != 0:
            percent = percent + bonus[0]
            bonus.pop(0)
        gold = math.ceil(t_level.std_gold * random.randint(90, 110) / 100 * percent * t_level_punish.gold / 100)
        assets = make_dungeon_assets(player, 1, 1, gold, 0, assets, merge=False)

    assets = make_dungeon_assets(player, 1, 3, math.ceil(t_level.std_exp * t_level_punish.exp / 100), 0, assets, math.ceil(t_config.exp_bonus / 100))

    return assets


def create_player_spells(player):
    t_spell = config.Config.instance().t_spell.get()
    for i in range(len(t_spell)):
        if t_spell[i].type == 1 and t_spell[i].unlock_level == 0:
            player.spell_ids.append(t_spell[i].id)
            player.spell_levels.append(1)


def arena_refresh(player, arena_segment):
    player.arena_room = 0
    player.arena_segment = arena_segment
    player.arena_integral = 0
    player.arena_win = 0
    player.arena_num = 0
