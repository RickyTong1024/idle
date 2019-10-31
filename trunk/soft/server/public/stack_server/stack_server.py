# !/usr/bin/env python3
# coding=utf-8
from typing import Optional, Awaitable
import tornado.httpserver
import tornado.ioloop
import tornado.web
import pymysql


class SetHandler(tornado.web.RequestHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def response(self):
        self.application.db.commit()
        self.finish()

    def post(self):
        # 收到包，取出地址信息
        username = self.get_body_argument("username")
        msg = self.get_body_argument("msg")
        stack = self.get_body_argument("stack")

        print(msg)

        self.application.ping()
        db = self.application.db
        cur = db.cursor()
        sql = 'insert into stack (id, username, log_msg, stack, datetime) values (0, %s, %s, %s, NOW())'
        param = (username, msg, stack, )
        cur.execute(sql, param)

        self.response()


class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/set", SetHandler),
        ]
        tornado.web.Application.__init__(self, handlers)
        self.db = None

    def create_db(self):
        self.db = pymysql.connect(user='root', passwd='root', db='stack', host='127.0.0.1')

    def ping(self):
        try:
            self.db.ping()
        except Exception as e:
            self.create_db()


def main():
    http_server = tornado.httpserver.HTTPServer(Application(), no_keep_alive=True)
    http_server.listen(10005)
    print('Welcome to the stack_server machine...')
    tornado.ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    main()
