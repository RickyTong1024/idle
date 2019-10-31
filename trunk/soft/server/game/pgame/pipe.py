from pgame.service_base import ServiceBase
from pgame.utils.msg_thread import MsgThread
from pgame.utils.packet import RpcPacket
import zmq
import time


class PipeThread(MsgThread):
    def __init__(self, addr, pgame):
        MsgThread.__init__(self, 2)
        self.PGame = pgame
        self.context = zmq.Context(1)
        self.pull_socket = self.context.socket(zmq.PULL)
        self.pull_socket.setsockopt(zmq.LINGER, 500)
        self.pull_socket.bind(addr)
        
        self.poller = zmq.Poller()
        self.poller.register(self.pull_socket, zmq.POLLIN)

        self.push_sockets = {}

    def run(self):
        while not self.isstop:
            
            tins = self.get_queue(1)
            l = len(tins) // 2
            for i in range(l):
                addr = tins[i * 2]
                msg = tins[i * 2 + 1]
                try:
                    if addr not in self.push_sockets.keys():
                        push_socket = self.context.socket(zmq.PUSH)
                        push_socket.setsockopt(zmq.LINGER, 500)
                        push_socket.connect(addr)
                        self.push_sockets[addr] = push_socket
                    push_socket = self.push_sockets[addr]
                    push_socket.send(msg)
                except:
                    continue
            flag = True
            while flag:
                flag = False
                socks = dict(self.poller.poll(50))
                if self.pull_socket in socks.keys():
                    flag = True
                    msg = self.pull_socket.recv()
                    self.add_queue(0, msg)
        self.pull_socket.close()
        for addr in self.push_sockets:
            push_socket = self.push_sockets[addr]
            push_socket.close()


class Pipe(ServiceBase):
    RCB_EXPIRE_TIME = 30

    def init(self, name):
        self.active = False
        self.addr = self.make_addr(name)
        if self.addr is None:
            return
        self.active = True        
        self.thread = PipeThread(self.addr, self.PGame)
        self.thread.start()
        self.rcb = {}
        self.pid = 0
        self.tid = self.PGame.timer.schedule(self.update, 30)
        self.tid1 = self.PGame.timer.schedule(self.update1, 10000)
        return 0

    def fini(self):
        if not self.active:
            return 0
        self.PGame.timer.cancel(self.tid1)
        self.PGame.timer.cancel(self.tid)
        self.thread.stop()
        self.thread.join()
        return 0

    def make_addr(self, name):
        env = self.PGame.env
        host = env.get_server_value(name, "host")
        port = env.get_server_value(name, "port")
        if host is None or port is None:
            self.PGame.log.error("make_addr error name = " + name)
            return None
        return "tcp://" + host + ":" + str(port)

    def request(self, pck, sname=None, addr=None, callback=None):
        pck.tp = RpcPacket.RP_REQUEST
        pck.pid = self.pid
        pck.set_addr(self.addr)
        self.pid += 1
        self.rcb[pck.pid] = [callback, time.time()]
        self.send(pck, sname=sname, addr=addr)

    def push(self, pck, sname=None, addr=None):
        pck.tp = RpcPacket.RP_PUSH
        pck.set_addr(self.addr)
        self.send(pck, sname=sname, addr=addr)

    def response(self, pck, sname=None, addr=None):
        pck.tp = RpcPacket.RP_RESPONSE
        pck.set_addr(self.addr)
        self.send(pck, sname=sname, addr=addr)

    def send(self, pck, sname=None, addr=None):
        if addr is None:
            addr = self.make_addr(sname)
            if addr is None:
                return
        self.thread.add_queue(1, addr)
        self.thread.add_queue(1, pck.to_bytes())

    def close(self, sname=None, addr=None):
        if addr is None:
            addr = self.make_addr(sname)
            if addr is None:
                return
        self.thread.add_queue(2, addr)
        self.thread.add_queue(2, -1)

    def update(self):
        tins = self.thread.get_queue(0)
        for i in range(len(tins)):
            tin = tins[i]
            pck = RpcPacket()
            pck.from_bytes(tin)
            if pck.tp == RpcPacket.RP_RESPONSE:
                if pck.pid in self.rcb.keys():
                    self.rcb[pck.pid][0](pck)
                    del self.rcb[pck.pid]
            else:
                self.PGame.game.add_msg(pck)

    def update1(self):
        delrcb = []
        tt = time.time()
        for pid in self.rcb:
            rcb = self.rcb[pid][0]
            t = self.rcb[pid][1]
            if t + self.RCB_EXPIRE_TIME < tt:
                delrcb.append(pid)

        for i in range(len(delrcb)):
            del self.rcb[delrcb[i]]
