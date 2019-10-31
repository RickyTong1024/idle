import os, sys

AbsolutePath = os.path.abspath(__file__)
SuperiorCatalogue = os.path.dirname(AbsolutePath)
BaseDir = os.path.dirname(SuperiorCatalogue)
sys.path.insert(0, BaseDir)

from pgame.utils.packet import Packet
import time
import select, socket
from common.opcodes import Opcodes
from common.proto.player_msg_pb2 import *
from common.proto.mission_msg_pb2 import *
import random
from pgame.utils.msg_thread import MsgThread

class Tcp:
    def __init__(self):
        self.stream = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ADDR = ('127.0.0.1', 9001)
        self.stream.connect(ADDR)
        self.chunk = bytes()
        self.stop = False

    def read(self):
        readable, writable, exceptional = select.select([self.stream], [], [self.stream])
        if len(readable) > 0:
            data = self.stream.recv(1024)
            if len(data) > 0:
                self.on_message(data)
            else:
                print("kicked")
                self.close()

    def send(self, pck):
        self.stream.send(pck.to_bytes())

    def on_message(self, data):
        self.chunk = self.chunk + data
        pck = Packet(0)
        res = pck.from_bytes(self.chunk, False)
        if res == -1:
            print("pck too large")
            self.close()
            return
        if res > 0:
            self.chunk = self.chunk[res:]
            self.deal(pck)

    def close(self):
        self.stream.close()
        self.stop = True

    def deal(self, pck):
        if pck.opcode == Opcodes.SMSG_LOGIN_PLAYER:
            self.d_smsg_login_player(pck)

    def d_smsg_login_player(self, pck):
        msg = smsg_login_player()
        msg.ParseFromString(pck.msg)

        print(msg.player.guid)
    ##    print(msg.player.serverid)
    ##    print(msg.player.name)
    ##
    ##    for i in range(len(msg.equip_slots)):
    ##        equip_slot = msg.equip_slots[i]
    ##        print(equip_slot.guid, equip_slot.equip_guid)
    ##    for i in range(len(msg.spell_slots)):
    ##        spell_slot = msg.spell_slots[i]
    ##        print(spell_slot.guid, spell_slot.spell_id)

        self.close()

    def send_cmsg_login_player(self):
        msg = cmsg_login_player()
        msg.username = str(random.randint(1, 5000000))
        #msg.username = "111"
        msg.password = '111'
        msg.serverid = 0
        msg.platform = ""
        msg.lang = 0
        msg = msg.SerializeToString()
        pck = Packet(Opcodes.CMSG_LOGIN_PLAYER, 0, msg)
        self.send(pck)

    def second(self):
        print('asdasd')
        msg = cmsg_view_player()
        msg.player_guid = 72057594038077938
        msg = msg.SerializeToString()
        pck = Packet(Opcodes.CMSG_VIEW_PLAYER, 0, msg)
        self.send(pck)

    def third(self):
        msg = cmsg_item_sell()
        msg.item_guids.append(456789)
        msg.item_nums.append(1)
        msg = msg.SerializeToString()
        pck = Packet(Opcodes.CMSG_ITEM_SELL, 0, msg)
        self.send(pck)

class MyThread(MsgThread):
    def run(self):
        t = Tcp()
        t.send_cmsg_login_player()
        t.second()
        while not t.stop:
            t.read()
            # t.second()
            time.sleep(1)
            

if __name__ == '__main__':
    ts = []
    print(time.time())
    for i in range(1):
        th = MyThread()
        th.start()
        ts.append(th)
    ts[0].join()
