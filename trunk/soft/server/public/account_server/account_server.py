#!/usr/bin/env python3
# coding=utf-8
from typing import Optional, Awaitable

import tornado.httpserver
import tornado.ioloop
import tornado.web
import pymysql
import json
import config
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
import re
import json
import random


class BaseHandler(tornado.web.RequestHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    _argl = []
    _args = {}

    def dbug(self):
        print(self.__class__.__name__, self.request.body)

    def check_args(self):
        for i in range(len(self._argl)):
            name = self._argl[i]
            arg = self.get_body_argument(name)
            self._args[name] = arg

            if name == 'mail':
                if arg[0:4] != 'tour':
                    if re.match(r'^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$', arg) is None:
                        # 邮箱格式问题
                        print("email error")
                        self.response(-3)
                        return False

            if name == "password":
                l = len(arg)
                if l < 8 or l > 16:
                    # 长度问题
                    print("len error -3")
                    self.response(-6)
                    return False

        return True

    @staticmethod
    def create_tourist():
        mail = ''
        password = ''
        for _ in range(18):
            mail += str(random.randint(0, 9))
            password += str(random.randint(0, 9))
        return 'tour' + mail[0:14], password[0:15]

    def get_db(self):
        self.application.ping()
        return self.application.db

    @staticmethod
    def make_token(pid):
        token = str(pid)
        while len(token) < 11:
            token = "0" + token
        token = "rpg" + token
        return token

    def response(self, res, param=None):
        self.application.db.commit()
        data = {"res": res}
        if param:
            data.update(param)
        data = json.dumps(data)
        self.write(data)
        self.finish()


class RegHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["mail", "password"]
        if not self.check_args():
            return

        cur = self.get_db().cursor()
        sql = "select pid, password from account where mail = %s"
        param = (self._args["mail"],)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            # 未知问题
            print("unknown error -7")
            self.response(-2)
            return
        elif len(res) == 0:
            sql = "select pid, password from account where mail = %s"
            param = (self._args["mail"],)
            cur.execute(sql, param)
            res1 = cur.fetchall()
            if len(res1) > 1:
                print("unknown error -7")
                self.response(-2)
                return
            elif len(res1) == 0:
                sql = "insert into account (mail, password) values (%s, %s)"
                param = (self._args["mail"], self._args["password"],)
                cur.execute(sql, param)
                pid = cur.lastrowid
                token = self.make_token(pid)
                # 注册成功
                print("register suc 1")
                self.response(1, {"token": token})
                return
            else:
                print("mail registered -1")
                # 邮箱已注册
                self.response(-1)
                return
        else:
            # 已存在账号
            print("has account error -1")
            self.response(-1)
            return


class LoginHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["mail", "password"]
        if not self.check_args():
            return

        cur = self.get_db().cursor()
        sql = "select pid, password from account where mail = %s"
        param = (self._args["mail"],)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            # 未知问题
            print("unknown error -7")
            self.response(-7)
            return
        elif len(res) == 0:
            # 未注册用户
            print("register error -2")
            self.response(-2)
            return
        else:
            if res[0][1] != self._args["password"]:
                # 密码错误
                print("password error -4")
                self.response(-4)
                return

        # 登陆成功
        print("login suc 0")
        token = self.make_token(res[0][0])
        self.response(0, {"token": token})


class ChpwdHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["mail", "old_password", "password"]
        if not self.check_args():
            return

        cur = self.get_db().cursor()
        sql = "select password from account where mail = %s"
        param = (self._args["mail"],)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            # 未知问题
            print("unknown error -7")
            self.response(-7)
            return
        elif len(res) == 0:
            # 未注册用户
            print("register error -2")
            self.response(-2)
            return
        else:
            if res[0][0] != self._args["old_password"]:
                # 密码错误
                print("password error -4")
                self.response(-4)
                return
            sql = "update account set password = %s where mail = %s"
            param = (self._args["password"], self._args["mail"], )
            cur.execute(sql, param)
        # 成功
        print("chpwd suc 0")
        self.response(0)


class BindHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["mail", "password", "old_mail", "old_password"]
        if not self.check_args():
            return

        cur = self.get_db().cursor()
        sql = "select password from account where mail = %s"
        param = (self._args["mail"],)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 0:
            # 账号已注册
            print("account register -1")
            self.response(-1)
            return

        if self._args["old_mail"] == "":
            sql = "insert into account (mail, password) values(%s, %s)"
            param = (self._args["mail"], self._args["password"],)
            cur.execute(sql, param)
            pid = cur.lastrowid
            token = self.make_token(pid)
            # 注册成功
            print("register suc 1")
            self.response(1, {"token": token})
            return
        else:
            sql = "select password, pid from account where mail = %s"
            param = (self._args["old_mail"],)
            cur.execute(sql, param)
            res = cur.fetchall()
            if len(res) > 1:
                # 未知问题
                print("unknown error -7")
                self.response(-7)
                return
            elif len(res) == 0:
                sql = "insert into account (mail, password) values(%s, %s)"
                param = (self._args["mail"], self._args["password"],)
                cur.execute(sql, param)
                pid = cur.lastrowid
                token = self.make_token(pid)
                # 注册成功
                print("register suc 1")
                self.response(1, {"token": token})
                return
            else:
                if res[0][0] != self._args["old_password"]:
                    # 密码错误
                    print("password error -4")
                    self.response(-4)
                    return
                else:
                    sql = "update account set mail = %s, password = %s where mail = %s"
                    param = (self._args["mail"], self._args["password"], self._args["old_mail"],)
                    cur.execute(sql, param)
                    print("bind suc 0")
                    token = self.make_token(res[0][1])
                    self.response(0, {'token': token})
                    return


class RecoveryHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["mail", "lang"]
        if not self.check_args():
            return

        cur = self.get_db().cursor()
        sql = "select password from account where mail = %s"
        param = (self._args["mail"],)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            # 未知问题
            print("unknown error -7")
            self.response(-7)
            return
        elif len(res) == 0:
            # 邮箱未注册
            print("email not register -1")
            self.response(-1)
            return
        else:
            mail = (self._args["mail"])
            passwd = res[0][0]
            lang = int(self._args["lang"])
            try:
                text = config.mail_text[lang] % (mail, passwd)
                msg = MIMEText(text, 'plain', 'utf-8')
                msg['from'] = formataddr(["yymoon", config.mail_sender])
                msg['To'] = formataddr(["FK", self._args["mail"]])
                msg['Subject'] = config.mail_title[lang]
                server = smtplib.SMTP_SSL("smtp.163.com", 465, timeout=2)
                server.login(config.mail_sender, config.mail_pass)
                server.sendmail(config.mail_sender, [self._args["mail"], ], msg.as_string())
                server.quit()
                print("email send success")
                self.response(0)
                return
            except Exception as e:
                print(e)
                print("email send error")
                self.response(-5)
                return


class TourHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["tour"]

        cur = self.get_db().cursor()
        while True:
            mail, password = self.create_tourist()
            sql = "select pid, password from account where mail = %s"
            param = (mail,)
            cur.execute(sql, param)
            res = cur.fetchall()
            if len(res) > 0:
                pass
            else:
                sql = "insert into account (mail, password) values (%s, %s)"
                param = (mail, password,)
                cur.execute(sql, param)
                pid = cur.lastrowid
                token = self.make_token(pid)
                self.response(1, {'mail': mail, 'password': password, 'token': token})
                return


class CheckHandler(BaseHandler):
    def data_received(self, chunk: bytes) -> Optional[Awaitable[None]]:
        pass

    def post(self):
        self.dbug()
        self._argl = ["token", "password"]
        if not self.check_args():
            return

        token = self._args["token"]
        token = token[3:]
        token = int(token)
        cur = self.get_db().cursor()
        sql = "select password from account where pid = %s"
        param = (token,)
        cur.execute(sql, param)
        res = cur.fetchall()
        if len(res) > 1:
            # 未知问题
            print("unknown error -7")
            self.response(-7)
            return
        elif len(res) == 0:
            print("unknown accountname -2")
            self.response(-2)
            return
        else:
            if res[0][0] != self._args["password"]:
                print("password error -4")
                self.response(-4)
                return
            else:
                print("check success")
                self.response(0)
                return


class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/reg", RegHandler),
            (r"/login", LoginHandler),
            (r"/chpwd", ChpwdHandler),
            (r"/bind", BindHandler),
            (r"/recovery", RecoveryHandler),
            (r"/check", CheckHandler),
            (r"/tourist", TourHandler),
        ]
        tornado.web.Application.__init__(self, handlers)
        self.db = None

    def create_db(self):
        self.db = pymysql.connect(user='root', passwd='root', db='account', host='127.0.0.1')

    # noinspection PyBroadException
    def ping(self):
        try:
            self.db.ping()
        except Exception:
            self.create_db()


def main():
    http_server = tornado.httpserver.HTTPServer(Application(), no_keep_alive=True)
    http_server.listen(10001)
    print('Welcome to the machine...')
    tornado.ioloop.IOLoop.current().start()


if __name__ == '__main__':
    main()
