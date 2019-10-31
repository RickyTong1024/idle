from common import guid_tool
from pgame.request import Request
from common.proto.mail_db_pb2 import *
from common.proto.mail_server_db_pb2 import *
from pgame.service import PGame
from common.db import db_gtool
import db_player
import copy


class MailPool:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.mail_all_list = dict()                 # 全局邮件列表
        self.mail_update_list = list()              # 轮训列表

    def init(self):
        self.load_mail_server()
        return 0
        
    def fini(self):
        self.save_all()
        return 0

    def load_mail_server(self):
        # 读玩家的邮件
        # 顺便清理玩家的过期全局邮件
        req = Request(Request.opc_query, [guid_tool.et["mail_server"], 0])
        req.add_callback(self.load_mail_server_callback)
        db_player.DbPlayer.instance().request(req)

    def load_mail_server_callback(self, req):
        if req.res >= 0:
            for i in range(len(req.datas)):
                self.mail_all_list[req.datas[i].guid] = req.datas[i]

    def get_mail(self, player):
        mails = list()
        for guid in player.mails.keys():
            if player.mails[guid] is not None:
                mails.append(player.mails[guid].obj)
        for guid in self.mail_all_list.keys():
            if player.guid not in self.mail_all_list[guid].delete_guids:
                mail = self.change_server_mail(player, self.mail_all_list[guid])
                mails.append(mail.obj)
        return mails

    @staticmethod
    def change_server_mail(player, mail_server):
        mail = mail_t
        mail.guid = mail_server.guid
        mail.receiver_guid = player.guid
        mail.sender_date = PGame.timer.now()
        mail.title = mail_server.title
        mail.text = mail_server.text
        mail.sender_name = mail_server.sender_name
        for i in range(len(mail_server.tp)):
            mail.type.append(mail_server.tp[i])
            mail.value1.append(mail_server.value1[i])
            mail.value2.append(mail_server.value2[i])
            mail.value3.append(mail_server.value3[i])
        mail.creat_time = mail_server.creat_time
        if player.guid in mail_server.receiver_guids:
            mail.used = 1
        else:
            mail.used = 0

        return mail

    def create_mail(self, player, title, text, sender_name, tp, value1, value2, value3):
        # 创建单个邮件
        guid = db_gtool.DbGtool.instance().assign(guid_tool.et['mail'])
        mail = mail_t()
        mail.guid = guid
        mail.receiver_guid = player.guid
        mail.sender_date = PGame.timer.now()
        mail.title = title
        mail.text = text
        mail.sender_name = sender_name
        for i in range(len(tp)):
            mail.type.append(tp[i])
            mail.value1.append(value1[i])
            mail.value2.append(value2[i])
            mail.value3.append(value3[i])
        mail.creat_time = PGame.timer.now()
        mail.used = 0
        player.new(mail, 'mails')
        return mail

    def create_mail_server(self, title, text, sender_name, tp, value1, value2, value3):
        # 创建全服邮件
        guid = db_gtool.DbGtool.instance().assign(guid_tool.et['mail_server'])
        mail = mail_server_t()
        mail.guid = guid
        mail.sender_date = PGame.timer.now()
        mail.title = title
        mail.text = text
        mail.sender_name = sender_name
        for i in range(len(tp)):
            mail.type.append(tp[i])
            mail.value1.append(value1[i])
            mail.value2.append(value2[i])
            mail.value3.append(value3[i])
        mail.creat_time = PGame.timer.now()
        mail.new(mail)
        return mail

    def send_mail(self, player_guid, title, text, sender_name, tp, value1, value2, value3):
        # 创建单个邮件
        guid = db_gtool.DbGtool.instance().assign(guid_tool.et['mail'])
        mail = mail_t()
        mail.guid = guid
        mail.receiver_guid = player_guid
        mail.sender_date = PGame.timer.now()
        mail.title = title
        mail.text = text
        mail.sender_name = sender_name
        for i in range(len(tp)):
            mail.type.append(tp[i])
            mail.value1.append(value1[i])
            mail.value2.append(value2[i])
            mail.value3.append(value3[i])
        mail.creat_time = PGame.timer.now()
        mail.used = 0
        req = Request(Request.opc_insert, mail_t)
        db_player.DbPlayer.instance().request(req)

    @staticmethod
    def remove_mail(player, mail_guid):
        # 删除单个邮件
        player.delete(mail_guid, 'mails')

    def remove_mail_server(self, mail_guid):
        # 删除全服邮件
        del self.mail_all_list[mail_guid]
        req = Request(Request.opc_remove, [guid_tool.et["mail_server"], mail_guid])
        db_player.DbPlayer.instance().request(req)

    def update_mail_server(self, mail, player_guid, delete):
        if delete:
            if player_guid not in mail.delete_guids:
                mail.delete_guids.append(player_guid)
                if mail.guid not in self.mail_update_list:
                    self.mail_update_list.append(mail.guid)
        else:
            if player_guid not in mail.receiver_guids:
                mail.receiver_guids.append(player_guid)
                if mail.guid not in self.mail_update_list:
                    self.mail_update_list.append(mail.guid)
                return True

        return False

    def save_all(self):
        for i in range(len(self.mail_update_list)):
            guid = self.mail_update_list[i]
            mail = self.mail_all_list[guid]
            self.save_mail(mail)
        self.mail_update_list = list()

    @staticmethod
    def save_mail(mail):
        if mail.is_changed():
            opt = Request.opc_update
            if mail.guid in mail.new_tops:
                opt = Request.opc_insert
            obj1 = copy.deepcopy(mail)
            req = Request(opt, obj1)
            db_player.DbPlayer.instance().request(req)
            mail.clear_changed()

    def update(self):
        # 清理过期邮件
        for guid in self.mail_all_list.keys():
            if PGame.timer.now - self.mail_all_list[guid].create_time > 604800000:
                self.remove_mail_server(guid)

        self.save_all()
