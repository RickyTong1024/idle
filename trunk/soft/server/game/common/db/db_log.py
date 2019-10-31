from pgame.service import PGame
from pgame.db import Db
from common.dbo import log_dbo
from pgame.request import Request


class DbLog:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.db = None

    def init(self, name):
        self.db = Db(PGame)
        self.db.init(name, self)

    def fini(self):
        self.db.fini()

    def info(self, username, player_guid, log_tp, tp, value1, value2, value3, log_way, log_op):
        serverid = int(PGame.env.get_setting_value('qid'))
        param = [username, serverid, player_guid, log_tp, tp, value1, value2, value3, log_way, log_op]
        req = Request(Request.opc_insert, param)
        self.request(req)

    def do_insert(self, db, req):
        return log_dbo.insert(db, req)

    def request(self, req):
        self.db.request(req)
