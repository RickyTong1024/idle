from pgame.service import PGame
from pgame.dispatcher import reg_handle
from common.opcodes import Opcodes, Errors
from common.proto.arena_msg_pb2 import *
from common.proto.mission_msg_pb2 import *
from common.proto.common_msg_pb2 import *
import config, gs_message, channel, player_data, mail_pool, player_pool, mission_pool
from pgame.utils import proto_utils
import random
import tools


# 地图切换
@reg_handle(Opcodes.CMSG_MAP_GO)
def deal_cmsg_map_go(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_map_go()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    map_id = msg.map_id
    t_map = config.Config.instance().t_map.get(map_id)
    if t_map is None:
        gs_message.global_error(player.guid)
        return

    if t_map.map_param != 0:
        if not player_data.if_quest_end(player, t_map.map_param):
            gs_message.send_smsg_error(player.guid, Errors.ERROR_MAP_UNLOCK)
            return

    if map_id == player.aside:
        player.aside += 1

    player.in_map = map_id

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_MAP_GO)


def fight_duration(player):
    # 最小连续战斗时间校验
    debug = PGame.env.get_setting_value('debug')
    if debug == 0:
        if player.guid in tools.LRandom.instance().fight_duration.keys():
            min_fight_duration = config.Config.instance().const('min_fight_duration')
            if tools.LRandom.instance().fight_duration[player.guid] + min_fight_duration > PGame.timer.now():
                gs_message.send_smsg_error(player.guid, Errors.ERROR_CHECK_TIME)
                gs_message.send_sys_kick(player.guid)
                return False
    return True


@reg_handle(Opcodes.CMSG_MISSION)
def deal_cmsg_mission(pck):
    # 关卡

    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_mission()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    mission_id = msg.mission_id
    t_mission = config.Config.instance().t_mission.get(mission_id)
    if t_mission is None:
        gs_message.global_error(cif.guid)
        return

    t_monster = config.Config.instance().t_monster.get(t_mission.monsterid)
    if t_monster is None:
        gs_message.global_error(cif.guid)
        return

    if not fight_duration(player):
        return

    tools.LRandom.instance().fight_duration[player.guid] = PGame.timer.now()

    tools.LRandom.instance().make_seed(player.seed)
    count = list()
    time = 12
    assets = msg_assets()

    if msg.fight_check != 2:
        # 战斗校验
        # if msg.fight_check == 2:
        #     if not mission_fight.mission(player, t_monster, msg.check_param):
        #         gs_message.global_error(cif.guid)
        #         return

        # 奖励计算
        player_data.assets_calc(player, t_mission, t_monster, assets, True)
        player_data.add_assets_set(player, assets)

        count = player_data.task_reached(player, t_mission)
        tools.LRandom.instance().make_seed(player.seed)
        if t_mission.type == 2:
            time = PGame.timer.now() + t_mission.cd
            mark = False
            for i in range(len(player.mission)):
                if player.mission[i] == t_mission.id:
                    player.mission_time[i] = time
                    mark = True
                    break
            if not mark:
                player.mission.append(t_mission.id)
                player.mission_time.append(time)

            player_data.make_monsters_set(player, t_mission.id)

        # 每日任务
        if t_mission.diff == 1:
            player_data.daily_schedule(player, 1009, 1)
        elif t_mission.diff == 4:
            player_data.daily_schedule(player, 1010, 1)
        elif t_mission.diff == 5:
            player_data.daily_schedule(player, 1011, 1)
        if player.mission_ex == 0:
            player.mission_ex_count += 1
    else:
        player_data.reduce_exp(player)
    player.seed = random.randint(1000000, 9999999)

    gs_message.send_smsg_mission(player.guid, time, player.seed, count, assets)


# 副本
@reg_handle(Opcodes.CMSG_DUNGEON)
def deal_cmsg_dungeon(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_dungeon()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    dungeon_id = msg.dungeon_id
    t_dungeon = config.Config.instance().t_dungeon.get(dungeon_id)
    if t_dungeon is None:
        gs_message.global_error(player.guid)
        return

    if len(t_dungeon.ceng) <= 0:
        gs_message.global_error(player.guid)
        return

    if t_dungeon.type == 1:
        dungeon_item = config.Config.instance().const('dungeon_item')
    else:
        dungeon_item = config.Config.instance().const('dungeon_artifact')

    if player_data.get_item_num(player, dungeon_item) < 1:
        gs_message.global_error(player.guid)
        return

    index = -1
    for i in range(len(player.dungeons)):
        if player.dungeons[i] == dungeon_id:
            index = i
            break

    if index != -1:
        if player.dungeon_tags[index] == 0:
            gs_message.global_error(player.guid)
            return

    player_data.remove_item(player, dungeon_item, 1)

    t_dungeon_random = config.Config.instance().t_dungeon_random.get(t_dungeon.ceng[0].id)
    seq = list()
    for i in range(len(t_dungeon_random.event)):
        if t_dungeon_random.event[i].id != 0:
            seq.append([t_dungeon_random.event[i].id, t_dungeon_random.event[i].weight])
    event = tools.randseq(seq)

    assets = msg_assets()
    assets = assets.SerializeToString()
    if index != -1:
        player.dungeon_tags[index] = 0
        player.dungeon_cengs[index] = 1
        player.dungeon_events[index] = event
        player.dungeon_assets[index] = assets
    else:
        player.dungeons.append(dungeon_id)
        player.dungeon_tags.append(0)
        player.dungeon_cengs.append(1)
        player.dungeon_events.append(event)
        player.dungeon_assets.append(assets)

    gs_message.send_smsg_dungeon(player.guid, event)


# 副本事件
@reg_handle(Opcodes.CMSG_DUNGEON_EVENT)
def deal_cmsg_dungeon_event(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_dungeon_event()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    dungeon_id = msg.dungeon_id
    t_dungeon = config.Config.instance().t_dungeon.get(dungeon_id)
    if t_dungeon is None:
        gs_message.global_error(player.guid)
        return

    if not fight_duration(player):
        return

    index = -1
    for i in range(len(player.dungeons)):
        if player.dungeons[i] == msg.dungeon_id:
            index = i
            break

    if index == -1:
        gs_message.global_error(player.guid)
        return

    if player.dungeon_tags[index] == 1:
        gs_message.global_error(player.guid)
        return

    t_dungeon_event = config.Config.instance().t_dungeon_event.get(player.dungeon_events[index])
    if t_dungeon_event is None:
        gs_message.global_error(player.guid)
        return

    dungeon_assets = msg_assets()

    # 打怪掉落
    t_monster = config.Config.instance().t_monster.get(t_dungeon_event.monster)

    dungeon_assets = player_data.assets_calc(player, t_dungeon_event, t_monster, dungeon_assets)

    player.seed = random.randint(1000000, 9999999)
    assets = msg_assets()
    if not proto_utils.parse(assets, player.dungeon_assets[index]):
        player.dungeon_assets[index] = b''
        assets = msg_assets()

    assets = player_data.merge_assets(assets, dungeon_assets)
    dungeon_assets = dungeon_assets.SerializeToString()

    event = 0
    if player.dungeon_cengs[index] == len(t_dungeon.ceng):
        player.dungeon_tags[index] = 1
        for i in range(len(t_dungeon.drops)):
            assets = player_data.make_dungeon_assets(player, t_dungeon.drops[i].type, t_dungeon.drops[i].value1,
                                                     t_dungeon.drops[i].value2, t_dungeon.drops[i].value3, assets)
        player_data.add_assets_set(player, assets)
        assets = assets.SerializeToString()
        if t_dungeon.type == 1:
            player_data.task_reached_other(player, 11, player.dungeons[index])
        elif t_dungeon.type == 2:
            player_data.task_reached_other(player, 16, player.dungeons[index])
    else:
        assets = assets.SerializeToString()
        player.dungeon_assets[index] = assets

        t_dungeon_random = config.Config.instance().t_dungeon_random.get(t_dungeon.ceng[player.dungeon_cengs[index]].id)
        seq = list()
        for i in range(len(t_dungeon_random.event)):
            if t_dungeon_random.event[i].id != 0:
                seq.append([t_dungeon_random.event[i].id, t_dungeon_random.event[i].weight])
        event = tools.randseq(seq)
        player.dungeon_events[index] = event

        player.dungeon_cengs[index] += 1

    gs_message.send_smsg_dungeon_event(player.guid, player.seed, event, assets, dungeon_assets)


# 主动关闭副本
@reg_handle(Opcodes.CMSG_DUNGEON_CLOSE)
def deal_cmsg_dungeon_close(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_dungeon_close()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    dungeon_id = msg.dungeon_id
    t_dungeon = config.Config.instance().t_dungeon.get(dungeon_id)
    if t_dungeon is None:
        gs_message.send_smsg_error(player.guid, Errors.ERROR_DUNGEON)
        return

    index = -1
    for i in range(len(player.dungeons)):
        if player.dungeons[i] == msg.dungeon_id:
            index = i
            break

    if index == -1:
        gs_message.send_smsg_error(player.guid, Errors.ERROR_DUNGEON)
        return

    assets = msg_assets()
    if not proto_utils.parse(assets, player.dungeon_assets[index]):
        player.dungeon_assets[index] = b''
        assets = msg_assets()

    player_data.add_assets_set(player, assets)
    player.dungeon_tags[index] = 1

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_DUNGEON_CLOSE)


# 无限塔挑战
@reg_handle(Opcodes.CMSG_TOWER)
def deal_cmsg_tower(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_tower()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    if not fight_duration(player):
        return

    tower_stair = msg.tower_stair
    t_tower = config.Config.instance().t_tower.get(tower_stair)
    if t_tower is None:
        gs_message.global_error(cif.guid)
        return

    if player.tower + 1 != tower_stair:
        gs_message.global_error(cif.guid)
        return

    t_monster = config.Config.instance().t_monster.get(t_tower.monster)
    if t_monster is None:
        gs_message.global_error(cif.guid)
        return

    assets = msg_assets()

    for i in range(len(t_tower.freward)):
        index = random.randint(0, 99)
        if index < t_tower.freward[i].prob:
            types = t_tower.freward[i].type
            value1 = t_tower.freward[i].value1
            value2 = t_tower.freward[i].value2
            value3 = t_tower.freward[i].value3
            player_data.add_assets(player, types, value1, value2, value3, assets)
    player.tower = tower_stair
    player.seed = random.randint(1000000, 9999999)
    player_data.task_reached_other(player, 14)
    gs_message.send_smsg_tower(player.guid, player.seed, assets)


# 无限塔扫荡
@reg_handle(Opcodes.CMSG_TOWER_SWEEP)
def deal_cmsg_tower_sweep(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_tower_sweep()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    tower_stair = msg.tower_stair
    sweep_num = msg.sweep_num

    free_tower_num = config.Config.instance().const('free_tower_num')
    if free_tower_num == 0:
        gs_message.global_error(cif.guid)
        return

    t_tower = config.Config.instance().t_tower.get(tower_stair)
    if t_tower is None:
        gs_message.global_error(cif.guid)
        return

    t_price = config.Config.instance().t_price.get()
    if t_price is None:
        gs_message.global_error(cif.guid)
        return

    # if len(t_price) < player.tower_sweep_num + player.tower_sweep_free + sweep_num:
    #     gs_message.global_error(cif.guid)
    #     return

    if player.tower < tower_stair:
        gs_message.global_error(cif.guid)
        return

    if sweep_num < 0:
        gs_message.global_error(cif.guid)
        return

    if player.tower_sweep_free != free_tower_num:
        if free_tower_num >= player.tower_sweep_free + sweep_num:
            player.tower_sweep_free += sweep_num
            lnum = 0
            rnum = 0
        else:
            lnum = player.tower_sweep_num
            rnum = player.tower_sweep_num + sweep_num - (free_tower_num - player.tower_sweep_free)

            player.tower_sweep_num = player.tower_sweep_free + sweep_num - free_tower_num
            player.tower_sweep_free = free_tower_num
    else:
        lnum = player.tower_sweep_num
        rnum = player.tower_sweep_num + sweep_num
        player.tower_sweep_num += sweep_num

    sum_jewel = 0
    for i in range(lnum, rnum):
        if i >= len(t_price):
            sum_jewel += t_price[len(t_price) - 1].tower_sweep
        else:
            sum_jewel += t_price[i].tower_sweep
    if sum_jewel > player.jewel:
        gs_message.global_error(cif.guid)
        return
    player_data.add_resource(player, 2, -sum_jewel)

    cnt = list()
    while len(cnt) < len(t_tower.reward):
        cnt.append(0)

    for i in range(sweep_num):
        for j in range(len(t_tower.reward)):
            index = random.randint(0, 99)
            if index < t_tower.reward[j].prob:
                cnt[j] += 1

    assets = msg_assets()
    for i in range(len(t_tower.reward)):
        assets = player_data.add_assets(player, t_tower.reward[i].type, t_tower.reward[i].value1,
                                        t_tower.reward[i].value2 * cnt[i], t_tower.reward[i].value3, assets)
    gs_message.send_smsg_tower_sweep(player.guid, assets)


# 奇遇
@reg_handle(Opcodes.CMSG_MISSION_EX)
def deal_cmsg_mission_ex(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_mission_ex()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    if not fight_duration(player):
        return

    mission_id = msg.mission_id
    t_mission = config.Config.instance().t_mission.get(mission_id)
    if t_mission is None:
        gs_message.global_error(cif.guid)
        return

    t_monster = config.Config.instance().t_monster.get(t_mission.monsterid)
    if t_monster is None:
        gs_message.global_error(cif.guid)
        return

    assets = msg_assets()
    if msg.fight_check != 2:
        # 奖励计算
        player_data.assets_calc(player, t_mission, t_monster, assets, True)
        player_data.add_assets_set(player, assets)
    else:
        player_data.reduce_exp(player)

    player.mission_ex = 0
    player.mission_ex_time = PGame.timer.now()
    player.seed = random.randint(1000000, 9999999)

    gs_message.send_smsg_mission_ex(player.guid, player.mission_ex_time, player.seed, assets)


@reg_handle(Opcodes.CMSG_ARENA_ROOM)
def deal_cmsg_arena_room(pck):
    """查看竞技场"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    # 加载玩家
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    gs_message.send_smsg_arena_room_inquire(player, pck.hid)


@reg_handle(Opcodes.AMSG_ARENA_ROOM_INQUIRE)
def deal_amsg_arena_room_inquire(pck):
    """查看竞技场房间返回"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = smsg_arena_room()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    # 加载玩家
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    player.arena_room = msg.arena_room.guid
    player.arena_segment = msg.arena_room.segment

    for i in range(len(msg.arena_room.player_guids)):
        if msg.arena_room.player_guids[i] == player.guid:
            player.arena_integral = msg.arena_room.player_integrals[i]
            player.arena_win = msg.arena_room.arena_wins[i]
            player.arena_num = msg.arena_room.arena_nums[i]

    gs_message.send_smsg_arena_room(player.guid, pck.msg)


@reg_handle(Opcodes.CMSG_ARENA_FIGHT_INIT)
def deal_cmsg_arena_fight_init(pck):
    """获取竞技场战斗对手数据"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    # 处理数据
    msg = cmsg_arena_fight_init()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    # 加载玩家
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    arena_unlock_level = config.Config.instance().const("rank_join_level")
    if arena_unlock_level is None:
        gs_message.global_error(cif.guid)
        return

    if player.level < arena_unlock_level:
        gs_message.send_smsg_error(cif.guid, Errors.ERROR_ARENA_LEVEL)
        return

    arena_room_player_num = config.Config.instance().const('arena_room_player_num')
    if player.arena_num >= arena_room_player_num - 1:
        gs_message.send_smsg_error(cif.guid, Errors.ERROR_ARENA_COST)
        return

    gag_player_guid = msg.gag_player_guid
    gs_message.send_smsg_arena_fight_init_ask(pck.hid, pck.msg)


@reg_handle(Opcodes.AMSG_ARENA_FIGHT_INIT_INQUIRE)
def deal_amsg_arena_fight_init_inquire(pck):
    """竞技场战斗对手数据查询"""
    msg = cmsg_arena_fight_init()
    if not proto_utils.parse(msg, pck.msg):
        return

    gag_player_guid = msg.gag_player_guid
    gag_player = PGame.pool.get(gag_player_guid)
    if gag_player is None:
        player_pool.PlayerPool.instance().load_player2(gag_player_guid, get_gag_player,
                                                       [gag_player_guid, pck.hid, pck.get_addr()])
        return
    get_gag_player([gag_player_guid, pck.hid, pck.get_addr()])


def get_gag_player(param):
    """竞技场战斗回调函数"""
    gag_player_guid = param[0]
    hid = param[1]
    addr = param[2]

    gag_player = PGame.pool.get(gag_player_guid)
    if gag_player is None:
        PGame.log.error("if gag_player is None")
        return

    msg = smsg_arena_fight_init()
    msg.guid = gag_player_guid
    msg.name = gag_player.name
    msg.level = gag_player.level
    msg.role_id = gag_player.role_id
    attr = player_data.get_attr(gag_player)
    for i in attr.keys():
        msg.attr_ids.append(i)
        msg.attr_values.append(attr[i])

    for i in range(len(gag_player.spell_ids)):
        msg.spell_ids.append(gag_player.spell_ids[i])
        msg.spell_levels.append(gag_player.spell_levels[i])

    for i in range(len(gag_player.spell_passive_slots)):
        msg.spell_passive_slots.append(gag_player.spell_passive_slots[i])

    for i in range(len(gag_player.equip_shows)):
        msg.equip_shows.append(gag_player.equip_shows[i])

    for i in range(len(gag_player.equip_slots)):
        if gag_player.equip_slots[i] > 0:
            equip = gag_player.equips[gag_player.equip_slots[i]]
            if equip is not None:
                msg.equips.add().CopyFrom(equip.obj)

    for i in range(len(gag_player.pet_slots)):
        if gag_player.pet_slots[i] > 0:
            pet = gag_player.pets[gag_player.pet_slots[i]]
            if pet is not None:
                msg.pets.add().CopyFrom(pet.obj)

    gs_message.send_smsg_arena_fight_init_inquire(hid, addr, msg)


@reg_handle(Opcodes.AMSG_ARENA_FIGHT_INIT)
def deal_amsg_arena_fight_init(pck):
    """竞技场战斗玩家数据返回"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = smsg_arena_fight_init()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 保存玩家数据
    mission_pool.MissionPool.instance().add_arena_gag_player(player.guid, msg)
    gs_message.send_smsg_arena_fight_init(player.guid, pck.msg)


# 竞技场战斗
@reg_handle(Opcodes.CMSG_ARENA_FIGHT)
def deal_cmsg_arena_fight(pck):
    """竞技场战斗处理"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    # 处理数据
    msg = cmsg_arena_fight()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    # 加载玩家
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    win = msg.win
    gag_player = mission_pool.MissionPool.instance().arena_gag_players[player.guid]
    if gag_player is None:
        gs_message.global_error(cif.guid)
        return

    gag_player = gag_player[0]
    if gag_player is None:
        gs_message.global_error(cif.guid)
        return

    if win:
        # mission_fight.check()
        pass

    player.arena_fight.append(gag_player.guid)

    gs_message.send_smsg_arena_fight_report(pck.hid, win, player, gag_player.guid)


@reg_handle(Opcodes.AMSG_ARENA_FIGHT_REPORT)
def deal_amsg_arena_fight_report(pck):
    """竞技场战斗返回"""
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    # 处理数据
    msg = amsg_arena_fight_report()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    # 加载玩家
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    arena_integral = msg.arena_integral
    arena_win = msg.arena_win
    arena_num = msg.arena_num
    player.arena_integral = arena_integral
    player.arena_win = arena_win
    player.arena_num = arena_num

    player.seed = random.randint(1000000, 9999999)
    player_data.task_reached_other(player, 15)

    gs_message.send_smsg_arena_fight(player.guid, player.seed, arena_integral, arena_win, arena_num)


@reg_handle(Opcodes.AMSG_ARENA_LIST_REGISTERED)
def deal_amsg_arena_list_registered(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = amsg_arena_list_registered()
    if not proto_utils.parse(msg, pck.msg):
        PGame.log.error("msg amsg_arena_list_registered is error")
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        PGame.log.error("player is None")
        return

    arena_list_index = msg.index
    if arena_list_index < 0:
        PGame.log.error("arena_list_index is error")
        return

    player.arena_list_index = arena_list_index


@reg_handle(Opcodes.AMSG_ARENA_REFRESH)
def deal_amsg_arena_refresh(pck):
    msg = amsg_arena_refresh()
    if not proto_utils.parse(msg, pck.msg):
        PGame.log.error("msg amsg_arena_refresh is error")
        return

    player_guid = msg.player_guid
    arena_segment = msg.arena_segment
    t_arena_reward = config.Config.instance().t_arena_reward.get(arena_segment)
    title = '竞技场晋级奖励'
    text = '恭喜您在近日的竞技场中表现优异 成功晋级 以下是您的奖励'
    sender_name = 'loot_hero'
    tp = list()
    value1 = list()
    value2 = list()
    value3 = list()
    for i in range(len(t_arena_reward.reward)):
        tp.append(t_arena_reward.reward[i].tp)
        value1.append(t_arena_reward.reward[i].value1)
        value2.append(t_arena_reward.reward[i].value2)
        value3.append(t_arena_reward.reward[i].value3)
    player = PGame.pool.get(player_guid)
    if player is None:
        mail_pool.MailPool.instance().send_mail(player_guid, title, text, sender_name, tp, value1, value2, value3)
    else:
        mail_pool.MailPool.instance().create_mail(player, title, text, sender_name, tp, value1, value2, value3)


@reg_handle(Opcodes.AMSG_ARENA_REFRESH_SEASON)
def deal_amsg_arena_refresh_season(pck):
    msg = amsg_arena_refresh_season()
    if not proto_utils.parse(msg, pck.msg):
        PGame.log.error("msg amsg_arena_refresh_season is error")
        return

    player_guid = msg.player_guid
    arena_segment = msg.arena_segment
    t_arena_reward = config.Config.instance().t_arena_reward.get(arena_segment)
    title = '竞技场赛季奖励'
    text = '恭喜您在本赛季的竞技场中表现优异 成功晋级 以下是您的奖励'
    sender_name = 'loot_hero'
    tp = list()
    value1 = list()
    value2 = list()
    value3 = list()
    for i in range(len(t_arena_reward.season_reward)):
        tp.append(t_arena_reward.season_reward[i].tp)
        value1.append(t_arena_reward.season_reward[i].value1)
        value2.append(t_arena_reward.season_reward[i].value2)
        value3.append(t_arena_reward.season_reward[i].value3)
    player = PGame.pool.get(player_guid)
    if player is None:
        mail_pool.MailPool.instance().send_mail(player_guid, title, text, sender_name, tp, value1, value2, value3)
    else:
        mail_pool.MailPool.instance().create_mail(player, title, text, sender_name, tp, value1, value2, value3)
