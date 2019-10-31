from pgame.service_base import ServiceBase
import pymysql
from pgame.request import Request
from pgame.utils.msg_thread import MsgThread
import time
from warnings import filterwarnings
filterwarnings("ignore", category=pymysql.Warning)


class DbThread(MsgThread):
    def __init__(self, db):
        MsgThread.__init__(self, 2)
        self.db = db
        
    def run(self):
        while not self.isstop:
            self.deal()
            time.sleep(0.05)
        self.deal()
            
    def deal(self):
        tins = self.get_queue(0)
        for i in range(len(tins)):
            req = tins[i]
            self.db.do_request(req)
            if req.callback is not None:
                self.add_queue(1, req)


class Db(ServiceBase):
    def init(self, db, db_operation, is_async=True):
        self.db_operation = db_operation
        self.is_async = is_async
        env = self.PGame.env
        host = env.get_db_value(db, "host")
        user = env.get_db_value(db, "username")
        passwd = env.get_db_value(db, "password")
        db = env.get_db_value(db, "db")
        if host is None or user is None or passwd is None or db is None:
            self.PGame.log.error('env cant find')
            return -1
        try:
            self.db = pymysql.connect(host=host,
                                      user=user,
                                      passwd=passwd,
                                      db=db,
                                      charset="utf8mb4")
        except:
            self.PGame.log.error('db cant connect')
            return -1
        self.timer = self.PGame.timer
        if self.is_async:
            self.tid = self.timer.schedule(self.update, 30)

            self.thread = DbThread(self)
            self.thread.start()

        self.tid1 = self.timer.schedule(self.update1, 1000)
        self.req_num = 0
        self.speed = 0
        return 0

    def fini(self):
        if self.is_async:
            self.thread.stop()
            self.thread.join()
            self.timer.cancel(self.tid)
        self.timer.cancel(self.tid1)
        self.db.close()
        return 0

    def request(self, req):
        self.req_num += 1
        if self.is_async:
            self.thread.add_queue(0, req)
        else:
            self.do_request(req)
            if req.callback is not None:
                req.callback(req)

    def do_request(self, req):
        self.db.ping()
        res = -1
        if req.op == Request.opc_insert:
            res = self.db_operation.do_insert(self.db, req)
        elif req.op == Request.opc_query:
            res = self.db_operation.do_query(self.db, req)
            for i in range(len(req.datas)):
                req.datas[i].clear_changed()
        elif req.op == Request.opc_update:
            res = self.db_operation.do_update(self.db, req)
        elif req.op == Request.opc_remove:
            res = self.db_operation.do_remove(self.db, req)
        elif req.op == Request.opc_query_all:
            res = self.db_operation.do_query_all(self.db, req)
        elif req.op == Request.opc_remove_all:
            res = self.db_operation.do_remove_all(self.db, req)
        req.res = res
        return res

    def update(self):
        tins = self.thread.get_queue(1)
        for i in range(len(tins)):
            req = tins[i]
            req.callback(req)

    def update1(self):
        self.speed = self.req_num
        self.req_num = 0
