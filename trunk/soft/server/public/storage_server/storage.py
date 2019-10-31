#!/usr/bin/env python3
# coding=utf-8
from typing import Optional, Awaitable
import tornado.httpserver
import tornado.ioloop
import tornado.web
import pymysql
import json


class GetHandler(tornado.web.RequestHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def response(self, res, param=None):
        self.application.db.commit()
        data = {"res": res}
        if param:
            data.update(param)
        data = json.dumps(data)
        self.write(data)
        self.finish()

    def post(self):
        # 收到包，取出地址信息
        token = self.get_body_argument("token")

        print("token:%s" % token)

        length = len(token)
        if length < 6 or length > 64:
            print('token错误')
            self.response(-1)
            return

        self.application.ping()
        db = self.application.db
        cur = db.cursor()
        sql = 'select serverid, server, port from storage where token = %s'
        param = (token,)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            print('未知错误')
            self.response(-2)
            return

        elif len(res) < 1:
            self.application.backstage_ping()
            backstage_db = self.application.backstage_db
            backstage_cur = backstage_db.cursor()
            sql = 'select serverid, server, port from server order by id desc limit 1'
            backstage_cur.execute(sql, )
            backstage_res = backstage_cur.fetchall()
            self.application.backstage_db.commit()
            if len(backstage_res) != 1:
                print('没有服务器')
                self.response(-3)
                return

            sql = 'insert into storage (token, serverid, server, port) values (%s, %s, %s, %s)'
            param = (token, backstage_res[0][0], backstage_res[0][1], backstage_res[0][2], )
            cur.execute(sql, param)
            data = {"serverid": backstage_res[0][0], 'server': backstage_res[0][1], 'port': backstage_res[0][2]}
        else:
            data = {"serverid": res[0][0], 'server': res[0][1], 'port': res[0][2]}

        self.response(0, data)


class Application(tornado.web.Application):  
    def __init__(self):
        handlers = [
            (r"/get", GetHandler),
        ]
        tornado.web.Application.__init__(self, handlers)
        self.db = None
        self.backstage_db = None

    def create_db(self):
        self.db = pymysql.connect(user='root', passwd='root', db='storage', host='127.0.0.1')

    def create_backstage_db(self):
        self.backstage_db = pymysql.connect(user='root', passwd='root', db='backend', host='127.0.0.1')

    def ping(self):
        try:
            self.db.ping()
        except Exception as e:
            self.create_db()

    def backstage_ping(self):
        try:
            self.backstage_db.ping()
        except Exception as e:
            self.create_backstage_db()


def main():
    http_server = tornado.httpserver.HTTPServer(Application(), no_keep_alive=True)
    http_server.listen(10004)
    print('Welcome to the storage machine...')
    tornado.ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    main()
