from pgame.service import PGame
from pgame.dispatcher import reg_handle
from common.proto.arena_msg_pb2 import *
from common.opcodes import Opcodes, Errors
from pgame.utils import proto_utils
from common import guid_tool
from common.db import db_gtool
import db_arena, arena_pool, arena_message, arena_data
import config


# functions
@reg_handle(Opcodes.SMSG_ARENA_ENTER_SERVER)
def deal_smsg_arena_enter_server(pck):
    msg = smsg_arena_enter_server()
    if not proto_utils.parse(msg, pck.msg):
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    server_id = msg.server_id
    addr = pck.get_addr()
    arena_pool.ArenaPool.instance().add_server(server_id, addr)


@reg_handle(Opcodes.SMSG_ARENA_HEART_BEAT)
def deal_smsg_arena_heart_beat(pck):
    msg = smsg_arena_heart_beat()
    if not proto_utils.parse(msg, pck.msg):
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    server_id = msg.server_id
    if server_id not in arena_pool.ArenaPool.instance().servers.keys():
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    arena_pool.ArenaPool.instance().server_response(server_id)


@reg_handle(Opcodes.SMSG_ARENA_ROOM_INQUIRE)
def deal_smsg_arena_room_inquire(pck):
    """获取玩家竞技场所在房间信息"""
    msg = smsg_arena_room_inquire()
    if not proto_utils.parse(msg, pck.msg):
        # arena_message.global_error(pck.hid)
        PGame.log.error('smsg_arena_room_inquire is error')
        return

    room_guid = msg.arena_room_guid
    if room_guid not in arena_pool.ArenaPool.instance().arena_rooms.keys():
        # 分配相同段位房间
        print(msg.arena_segment)
        t_arena_reward = config.Config.instance().t_arena_reward.get(msg.arena_segment)
        if t_arena_reward is None:
            PGame.log.error('t_arena_reward is None')
            return
        arena_room = arena_pool.ArenaPool.instance().switch_room(msg.arena_segment, msg.player_guid, msg.player_name,
                                                                 msg.player_level, msg.player_avatar, msg.player_power)
    else:
        # 获取房间
        arena_room = arena_pool.ArenaPool.instance().arena_rooms[room_guid]

    msg = smsg_arena_room()
    msg.arena_room.CopyFrom(arena_room.obj)
    print(1)

    # 返回房间信息
    arena_message.send_amsg_arena_room_inquire(pck.get_addr(), pck.hid, msg)


@reg_handle(Opcodes.SMSG_ARENA_FIGHT_INIT_ASK)
def deal_smsg_arena_fight_init_ask(pck):
    """询问竞技场战斗玩家数据"""
    msg = cmsg_arena_fight_init()
    if not proto_utils.parse(msg, pck.msg):
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    gag_player_guid = msg.player_guid
    if guid_tool.type_guid(gag_player_guid) == guid_tool.et['player']:
        server_id = guid_tool.sid_guid(gag_player_guid)
        if server_id not in arena_pool.ArenaPool.instance().servers.keys():
            arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
            return

        server = arena_pool.ArenaPool.instance().servers[server_id]
        if server is None:
            arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
            return

        arena_message.send_amsg_arena_fight_init_inquire(pck.get_addr(), pck.hid, server, pck.msg)
    else:
        # 查找npc
        arena_room_guid = msg.arena_room_guid
        if arena_room_guid not in arena_pool.ArenaPool.instance().arena_rooms.keys():
            arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
            return

        arena_room = arena_pool.ArenaPool.instance().arena_rooms[arena_room_guid]
        index = arena_data.get_index(gag_player_guid, arena_room)
        if index is None:
            arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
            return

        # 初始化npc信息
        msg = smsg_arena_fight_init()
        msg.guid = arena_room.player_guids[index]
        msg.name = arena_room.player_names[index]
        msg.level = arena_room.player_levels[index]
        msg.role_id = 1

        attr = arena_data.get_npc_attr(arena_room.player_levels[index])

        for i in attr.keys():
            msg.attr_ids.append(i)
            msg.attr_values.append(attr[i])

        for i in range(8):
            msg.equip_shows.append(0)

        msg = msg.SerializeToString()
        arena_message.send_amsg_arena_fight_init(pck.get_addr(), pck.hid, msg)


@reg_handle(Opcodes.SMSG_ARENA_FIGHT_INIT_INQUIRE)
def deal_smsg_arena_fight_init_inquire(pck):
    arena_message.send_amsg_arena_fight_init(pck.get_addr(), pck.hid, pck.msg)


@reg_handle(Opcodes.SMSG_ARENA_FIGHT_REPORT)
def deal_smsg_arena_fight_report(pck):
    msg = smsg_arena_fight_report()
    if not proto_utils.parse(msg, pck.msg):
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    arena_room_guid = msg.arena_room_guid
    player_guid = msg.player_guid
    gag_player_guid = msg.gag_player_guid
    player_name = msg.player_name
    player_level = msg.player_level
    player_icon = msg.player_icon
    player_power = msg.player_power
    win = msg.win

    arena_room = arena_pool.ArenaPool.instance().arena_rooms[arena_room_guid]
    if arena_room is None:
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_ARENA_ROOM)
        return

    if player_guid not in arena_room.player_guids or gag_player_guid not in arena_room.player_guids:
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_ARENA_ROOM_PLAYER)
        return

    player_index = None
    for i in range(len(arena_room.player_guids)):
        if player_guid == arena_room.player_guids[i]:
            player_index = i
            break

    if win:
        arena_room.player_integrals[player_index] += 1
        arena_room.arena_wins[player_index] += 1
    arena_room.player_names[player_index] = player_name
    arena_room.player_levels[player_index] = player_level
    arena_room.player_icons[player_index] = player_icon
    arena_room.player_powers[player_index] = player_power
    arena_room.arena_nums[player_index] += 1

    arena_message.send_amsg_arena_fight_report(pck.hid, pck.get_addr(),
                                               arena_room.player_integrals[player_index],
                                               arena_room.arena_wins[player_index],
                                               arena_room.arena_nums[player_index])


@reg_handle(Opcodes.SMSG_ARENA_LIST_REGISTERED)
def deal_smsg_arena_list_registered(pck):
    msg = smsg_arena_fight_report()
    if not proto_utils.parse(msg, pck.msg):
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    player_guid = msg.player_guid
    arena_list = arena_pool.ArenaPool.instance().arena_list
    if player_guid in arena_list:
        arena_message.send_amsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    arena_list.player_guids.append(player_guid)
    arena_list.player_names.append(msg.player_name)
    arena_list.player_levels.append(msg.player_level)
    arena_list.player_icons.append(msg.player_icon)
    arena_list.player_segments.append(msg.player_segment)
    arena_list.player_powers.append(msg.player_power)
    index = len(arena_list.player_guids) - 1
    arena_message.send_amsg_arena_list_registered(pck.hid, pck.get_addr(), index)


# classes

class ArenaManager:
    def __init__(self):
        self.tid = None

    def init(self):
        if -1 == config.Config.instance().init('t_lang'):
            return -1
        if -1 == db_arena.DbArena.instance().init('arena'):
            return -1
        if -1 == db_gtool.DbGtool.instance().init('arena'):
            return -1
        if -1 == arena_pool.ArenaPool.instance().init():
            return -1
        self.tid = PGame.timer.schedule(self.update, 1000)
        return 0

    def fini(self):
        PGame.timer.cancel(self.tid)
        if -1 == arena_pool.ArenaPool.instance().fini():
            return -1
        if -1 == config.Config.instance().fini():
            return -1
        if -1 == db_gtool.DbGtool.instance().fini():
            return -1
        if -1 == db_arena.DbArena.instance().fini():
            return -1
        return 0

    @staticmethod
    def update():
        arena_pool.ArenaPool.instance().update()
