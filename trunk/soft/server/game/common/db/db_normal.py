from pgame.service import PGame
from pgame.db import Db
from common import guid_tool

class DbNormal:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.dispatch = dict()
        self.make_dispatcher()

    def make_dispatcher(self):
        pass

    def get_dispatcher(self, guid):
        tp = guid_tool.type_guid(guid)
        return self.dispatch[tp]

    def do_insert(self, db, req):
        return self.get_dispatcher(req.param.guid).insert(db, req)

    def do_query(self, db, req):
        return self.dispatch[req.param[0]].query(db, req)

    def do_update(self, db, req):
        return self.get_dispatcher(req.param.guid).update(db, req)

    def do_remove(self, db, req):
        return self.get_dispatcher(req.param).remove(db, req)

    def do_query_all(self, db, req):
        return self.dispatch[req.param[0]].query_all(db, req)

    def init(self, name):
        self.db = Db(PGame)
        if -1 == self.db.init(name, self):
            return -1

    def fini(self):
        if -1 == self.db.fini():
            return -1

    def request(self, req):
        self.db.request(req)
