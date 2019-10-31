from pgame.service_base import ServiceBase
from tornado.tcpserver import TCPServer
from pgame.utils.packet import Packet
from tornado.ioloop import IOLoop
from tornado.iostream import StreamClosedError


class Tcp(ServiceBase):
    def init(self, name):
        self.env = self.PGame.env
        port = self.env.get_server_value(name, 'tcp_port')
        self.active = False
        if port is None:
            return 0
        self.active = True
        self.tcp_server = TcpServer(self)
        self.tcp_server.listen(port)
        return 0

    def fini(self):
        if not self.active:
            return 0
        self.tcp_server.stop()
        return 0

    def send_msg(self, pck):
        self.tcp_server.send_msg(pck)

    def kick(self, hid):
        self.tcp_server.kick(hid)


class TcpServer(TCPServer):
    def __init__(self, tcp):
        TCPServer.__init__(self)
        self.tcp = tcp
        self.hid = 0
        self.handles = {}

    async def handle_stream(self, stream, address):
        th = TcpHandle(self, stream, address, self.hid)
        self.handles[self.hid] = th
        self.hid = self.hid + 1
        await th.run()

    def remove_handle(self, hid):
        del self.handles[hid]

    def send_msg(self, pck):
        if pck.hid in self.handles.keys():
            IOLoop.current().spawn_callback(self.handles[pck.hid].write, pck)

    def kick(self, hid):
        if hid in self.handles.keys():
            IOLoop.current().spawn_callback(self.handles[hid].close)


class TcpHandle:
    SYS_ENTER_WORLD = 0
    SYS_LEAVE_WORLD = 1

    def __init__(self, tcp_server, stream, address, hid):
        self.tcp_server = tcp_server
        self.stream = stream
        self.address = address
        self.hid = hid
        self.chunk = bytes()
        self.is_close = False

        self.tcp_server.tcp.PGame.log.debug("client connect address = " + str(self.address))

        self.stream.set_close_callback(self.on_close)

        pck = Packet(self.SYS_ENTER_WORLD, self.hid)
        self.tcp_server.tcp.PGame.game.add_msg(pck)

    async def run(self):
        try:
            while True:
                data = await self.stream.read_bytes(65535, partial=True)
                await self.on_message(data)
        except StreamClosedError:
            pass

    async def on_message(self, data):
        self.chunk = self.chunk + data
        pck = Packet(hid=self.hid)
        res = pck.from_bytes(self.chunk)
        if res == -1:
            self.tcp_server.tcp.PGame.log.debug("pck too large")
            await self.close()
            return
        if res > 0:
            self.chunk = self.chunk[res:]
            self.tcp_server.tcp.PGame.game.add_msg(pck)

    def on_close(self):
        self.tcp_server.tcp.PGame.log.debug("client disconnect address = " + str(self.address))
        self.tcp_server.remove_handle(self.hid)

        pck = Packet(self.SYS_LEAVE_WORLD, self.hid)
        self.tcp_server.tcp.PGame.game.add_msg(pck)
        self.is_close = True

    async def close(self):
        if self.is_close:
            return
        self.tcp_server.tcp.PGame.log.debug("kick out address = " + str(self.address))
        self.stream.close()

    async def write(self, pck):
        try:
            await self.stream.write(pck.to_bytes())
        except Exception as e:
            self.tcp_server.tcp.PGame.log.error("tcp error:" + str(e))
