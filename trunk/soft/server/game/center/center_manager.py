from pgame.service import PGame
from pgame.dispatcher import reg_handle
from common.proto.center_msg_pb2 import *
from pgame.utils import proto_utils
from common.opcodes import Opcodes, Errors
import center_message, center_pool
from common import guid_tool


# functions

@reg_handle(Opcodes.SMSG_CENTER_ENTER_SERVER)
def deal_smsg_center_enter_server(pck):
    msg = smsg_center_enter_server()
    if not proto_utils.parse(msg, pck.msg):
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    server_id = msg.server_id
    addr = pck.get_addr()
    center_pool.CenterPool.instance().add_server(server_id, addr)


@reg_handle(Opcodes.SMSG_CENTER_HEART_BEAT)
def deal_smsg_center_heart_beat(pck):
    msg = smsg_center_heart_beat()
    if not proto_utils.parse(msg, pck.msg):
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    server_id = msg.server_id
    if server_id not in center_pool.CenterPool.instance().servers.keys():
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    center_pool.CenterPool.instance().server_response(server_id)


@reg_handle(Opcodes.SMSG_VIEW_PLAYER_ASK)
def deal_smsg_view_player_ask(pck):
    msg = cmsg_view_player()
    if not proto_utils.parse(msg, pck.msg):
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_MSG)
        return

    player_guid = msg.player_guid
    server_id = guid_tool.sid_guid(player_guid)
    if server_id not in center_pool.CenterPool.instance().servers.keys():
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
        return

    server = center_pool.CenterPool.instance().servers[server_id]
    if server is None:
        center_message.send_cnmsg_error(pck.hid, pck.get_addr(), Errors.ERROR_SERVER)
        return

    center_message.send_cnmsg_view_player_inquire(pck.hid, pck.get_addr(), server, pck.msg)


@reg_handle(Opcodes.SMSG_VIEW_PLAYER_INQUIRE)
def deal_smsg_view_player_inquire(pck):
    center_message.send_cnmsg_view_player(pck.hid, pck.get_addr(), pck.msg)


# classes

class CenterManager:
    def __init__(self):
        self.tid = None

    def init(self):
        if -1 == center_pool.CenterPool.instance().init():
            return -1
        self.tid = PGame.timer.schedule(self.update, 1000)
        return 0

    def fini(self):
        PGame.timer.cancel(self.tid)
        if -1 == center_pool.CenterPool.instance().fini():
            return -1
        return 0

    def update(self):
        center_pool.CenterPool.instance().update()
