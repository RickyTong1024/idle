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
            self.deal_smsg_login_player(pck)
        elif pck.opcode == Opcodes.SMSG_ERROR:
            msg = smsg_error()
            msg.ParseFromString(pck.msg)
            print("error")
            print(msg.code, msg.text)

    def deal_smsg_login_player(self, pck):
        msg = smsg_login_player()
        msg.ParseFromString(pck.msg)
        print(msg.player.guid)


    def send_cmsg_login_player(self):
        msg = cmsg_login_player()
        msg.username = "txy"
        msg.password = ''
        msg.serverid = 1
        msg.platform = ""
        msg.lang = 0
        msg = msg.SerializeToString()
        pck = Packet(Opcodes.CMSG_LOGIN_PLAYER, 0, msg)
        self.send(pck)


class MyThread(MsgThread):
    def run(self):
        while(1):
            t = Tcp()
            t.send_cmsg_login_player()
            while not t.stop:
                t.read()
                time.sleep(0.05)


if __name__ == '__main__':
    ts = []
    for i in range(1):
        th = MyThread()
        th.start()
        ts.append(th)

    ts[0].join()
