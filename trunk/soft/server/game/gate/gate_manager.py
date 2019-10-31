from pgame.service import PGame
from pgame.dispatcher import reg_handle_all, reg_handle
from pgame.utils.packet import Packet, RpcPacket
from pgame.utils import proto_utils
from common.opcodes import Opcodes
from common.proto.common_msg_pb2 import *


class HidInfo:
    def __init__(self, hid):
        self.hid = hid
        self.unresponse = 0


class GateManager:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def init(self):
        debug = PGame.env.get_setting_value('debug')
        if debug == 0:
            self.tid = PGame.timer.schedule(self.update, 10000)
        self.clients = {}
        self.requests = dict()
        return 0

    def fini(self):
        if self.tid is not None:
            PGame.timer.cancel(self.tid)
        return 0

    def update(self):
        for hid in self.requests:
            if hid in self.clients.keys():
                self.clients[hid].unresponse = self.clients[hid].unresponse + 1
                if self.clients[hid].unresponse >= 3:
                    PGame.tcp.kick(hid)

        self.requests = dict()

        for hid in self.clients.keys():
            pck = Packet(Opcodes.SMSG_HEART_BEAT, hid)
            PGame.tcp.send_msg(pck)
            self.requests[hid] = hid


@reg_handle(Opcodes.SYS_KICK)
def deal_sys_kick(pck):
    PGame.tcp.kick(pck.hid)


@reg_handle(Opcodes.CMSG_HEART_BEAT)
def deal_sys_heart_beat(pck):
    if pck.hid in GateManager.instance().requests.keys():
        del GateManager.instance().requests[pck.hid]

    if pck.hid in GateManager.instance().clients.keys():
        hi = GateManager.instance().clients[pck.hid]
        msg = cmsg_heart_beat()
        if not proto_utils.parse(msg, pck.msg):
            PGame.tcp.kick(pck.hid)
            return
        if abs(msg.time - PGame.timer.now()) >= 10000:
            PGame.tcp.kick(pck.hid)
            return

        hi.unresponse = 0


ignore_list = [Opcodes.SYS_KICK, Opcodes.CMSG_HEART_BEAT, Opcodes.SMSG_HEART_BEAT]


@reg_handle_all
def deal_all(pck):
    if pck.opcode in ignore_list:
        return

    if type(pck) == Packet:
        rpc_pck = RpcPacket(pck.opcode, pck.hid, pck.msg)
        PGame.pipe.push(rpc_pck, sname="gs")
    else:
        ppck = Packet(pck.opcode, pck.hid, pck.msg)
        PGame.tcp.send_msg(ppck)


@reg_handle(Opcodes.SYS_ENTER_WORLD)
def deal_sys_enter_world(pck):
    hi = HidInfo(pck.hid)
    GateManager.instance().clients[pck.hid] = hi


@reg_handle(Opcodes.SYS_LEAVE_WORLD)
def deal_sys_leave_world(pck):
    del GateManager.instance().clients[pck.hid]
    if pck.hid in GateManager.instance().requests.keys():
        del GateManager.instance().requests[pck.hid]
