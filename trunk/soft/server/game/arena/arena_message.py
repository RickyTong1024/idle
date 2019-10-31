from pgame.service import PGame
from common.proto.arena_msg_pb2 import *
from common.proto.player_msg_pb2 import *
from pgame.utils.packet import RpcPacket
from common.opcodes import Opcodes


def send_amsg_error(hid, addr, code):
    msg = smsg_error()
    msg.code = code
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.AMSG_ERROR, hid, msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_heart_beat(addr):
    pck = RpcPacket(Opcodes.AMSG_HEART_BEAT)
    pck.set_addr(addr)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_room_inquire(addr, hid, msg):
    msg = msg.SerializeToString()

    pck = RpcPacket(opcode=Opcodes.AMSG_ARENA_ROOM_INQUIRE, hid=hid, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_fight_init_inquire(addr, hid, server, msg):
    pck = RpcPacket(Opcodes.AMSG_ARENA_FIGHT_INIT_INQUIRE, hid=hid, msg=msg)
    pck.set_addr(addr)
    PGame.pipe.push(pck, addr=server.addr)


def send_amsg_arena_fight_init(addr, hid, msg):
    pck = RpcPacket(Opcodes.AMSG_ARENA_FIGHT_INIT, hid=hid, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_fight_report(hid, addr, arena_integral, arena_win, arena_num):
    msg = amsg_arena_fight_report()

    msg.arena_integral = arena_integral
    msg.arena_win = arena_win
    msg.arena_num = arena_num
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.AMSG_ARENA_FIGHT_REPORT, hid=hid, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_list_registered(hid, addr, index):
    msg = amsg_arena_list_registered()
    msg.index = index
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.AMSG_ARENA_LIST_REGISTERED, hid=hid, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_refresh(addr, player_guid, segment):
    msg = amsg_arena_refresh()
    msg.player_guid = player_guid
    msg.arena_segment = segment
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.AMSG_ARENA_REFRESH, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_amsg_arena_refresh_season(addr, player_guid, segment):
    msg = amsg_arena_refresh_season()
    msg.player_guid = player_guid
    msg.arena_segment = segment
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.AMSG_ARENA_REFRESH_SEASON, msg=msg)
    PGame.pipe.push(pck, addr=addr)
