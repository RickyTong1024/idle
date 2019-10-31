from pgame.service import PGame
from pgame.db import Db
from common import guid_tool
from pgame.request import Request


class DbGtool:
    ONE_ADD = 50000

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.cur_guid = 0
        self.next_guid = 0
        self.db = None
        self.qid = 0
        self.start_time = 0
        
    def do_query(self, db, req):
        if req.param == 0:
            sql = 'select num from gtool_t where guid = 0'
            cur = db.cursor()
            cur.execute(sql)
            ret = cur.fetchall()
            if len(ret) == 1:
                self.cur_guid = ret[0][0]
                self.next_guid = self.cur_guid + self.ONE_ADD
                sql = 'update gtool_t set num = %s where guid = 0'
                param = (self.next_guid,)
                cur.execute(sql, param)
            else:
                sql = 'insert into gtool_t set guid = 0, num = %s'
                param = (self.ONE_ADD,)
                cur.execute(sql, param)
                self.cur_guid = 0
                self.next_guid = self.cur_guid + self.ONE_ADD
            db.commit()
            cur.close()
        else:
            sql = 'select num from gtool_t where guid = 1'
            cur = db.cursor()
            cur.execute(sql)
            ret = cur.fetchall()
            if len(ret) == 1:
                self.start_time = ret[0][0]
            else:
                sql = 'insert into gtool_t set guid = 1, num = %s'
                param = (PGame.timer.now(),)
                cur.execute(sql, param)
            db.commit()
            cur.close()

    def init(self, name):
        self.db = Db(PGame)
        self.db.init(name, self, False)
        self.qid = PGame.env.get_setting_value("qid")
        if self.qid is None:
            return -1
        self.get_guid()
        self.get_start_time()
        return 0

    def fini(self):
        self.db.fini()
        return 0

    def assign(self, tp):
        guid = guid_tool.make_guid(tp, self.qid, self.cur_guid)
        self.cur_guid += 1
        if self.cur_guid >= self.next_guid:
            self.get_guid()
        return guid

    def start_time(self):
        return self.start_time

    def get_guid(self):
        req = Request(Request.opc_query, 0)
        self.db.request(req)

    def get_start_time(self):
        req = Request(Request.opc_query, 1)
        self.db.request(req)
