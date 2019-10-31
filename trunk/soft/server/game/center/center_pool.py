from pgame.service import PGame
import center_message


class Server:
    def __init__(self, server_id, addr):
        self.server_id = server_id
        self.addr = addr
        self.un_response = 0


class CenterPool:

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.servers = dict()
        self.requests = dict()
        self.tid = None

    def init(self):
        debug = PGame.env.get_setting_value('debug')
        if debug == 0:
            self.tid = PGame.timer.schedule(self.update, 10000)
        self.requests = dict()
        return 0

    def fini(self):
        if self.tid is not None:
            PGame.timer.cancel(self.tid)
        return 0

    def add_server(self, server_id, addr):
        server = Server(server_id, addr)
        self.servers[server_id] = server

    def del_server(self, server_id):
        del self.servers[server_id]

    def server_response(self, server_id):
        if server_id in self.requests.keys():
            del self.requests[server_id]
        self.servers[server_id].un_response = 0

    def update(self):
        for server_id in self.requests.keys():
            if server_id in self.servers.keys():
                self.servers[server_id].un_response = self.servers[server_id].un_response + 1
                if self.servers[server_id].un_response >= 3:
                    self.del_server(server_id)

        self.requests = dict()

        for server_id in self.servers.keys():
            self.requests[server_id] = server_id
            center_message.send_cnmsg_heart_beat(self.servers[server_id].addr)
        return 0
