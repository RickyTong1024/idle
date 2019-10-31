from pgame.service import PGame
from common.proto.player_msg_pb2 import *
from pgame.utils.packet import RpcPacket
from common.opcodes import Opcodes


def send_cnmsg_error(hid, addr, code):
    msg = smsg_error()
    msg.code = code
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.CNMSG_ERROR, hid, msg)
    PGame.pipe.push(pck, addr=addr)


def send_cnmsg_view_player_inquire(hid, addr, server, msg):
    pck = RpcPacket(Opcodes.CNMSG_VIEW_PLAYER_INQUIRE, hid, msg)
    pck.set_addr(addr)
    PGame.pipe.push(pck, addr=server.addr)


def send_cnmsg_view_player(hid, addr, msg):
    pck = RpcPacket(Opcodes.CNMSG_VIEW_PLAYER, hid, msg)
    pck.set_addr(addr)
    PGame.pipe.push(pck, addr=addr)


def send_cnmsg_heart_beat(addr):
    pck = RpcPacket(Opcodes.CNMSG_HEART_BEAT)
    pck.set_addr(addr)
    PGame.pipe.push(pck, addr=addr)
