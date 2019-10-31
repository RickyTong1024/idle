from pgame.request import Request
from common.proto.player_db_pb2 import *
from common import guid_tool
from pgame.service import PGame
import player_data, gs_message, db_player, promotion_pool, mail_pool, config
import copy


class PlayerLoadMap:
    def __init__(self):
        self.need_smsg = False
        self.callbacks = []
        self.param = None


class PlayerPool:
    PLAYER_UPDATE_TIME = 60000
    NORMAL_OFF_TIME = 3600000
    BUSY_OFF_TIME = 300000

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance
    
    def __init__(self):
        self.load_maps = {}
        self.player_update_list = []
        self.player_offline_map = {}
        self.last_time = PGame.timer.now()
        
    def init(self):
        return 0
        
    def fini(self):
        self.save_all()
        return 0

    def load_player(self, guid, param=None):
        if guid in self.load_maps.keys():
            self.load_maps[guid].need_smsg = True
            self.load_maps[guid].param = param
            return

        plm = PlayerLoadMap()
        plm.need_smsg = True
        if param is not None:
            plm.param = param
        plm.query_num = 1
        self.load_maps[guid] = plm
        req = Request(Request.opc_query, [guid_tool.et['player'], guid])
        req.add_callback(self.load_player_callback)
        db_player.DbPlayer.instance().request(req)

    def load_player2(self, guid, callback, param):
        if guid in self.load_maps.keys():
            self.load_maps[guid].callbacks.append([callback, param])
            return

        plm = PlayerLoadMap()
        plm.need_smsg = False
        plm.query_num = 1
        plm.callbacks.append([callback, param])
        self.load_maps[guid] = plm
        req = Request(Request.opc_query, [guid_tool.et['player'], guid])
        req.add_callback(self.load_player_callback)
        db_player.DbPlayer.instance().request(req)

    def load_player_callback(self, req):
        guid = req.param[1]
        if guid not in self.load_maps.keys():
            return
        plm = self.load_maps[guid]
        if req.res >= 0 and len(req.datas) > 0:
            player = req.datas[0]
            self.load_children(player, player, plm)
            self.load_player_check_end(player)
        else:
            player = self.create_player(guid)
            if plm.need_smsg:
                player_data.client_login(player)
                gs_message.send_smsg_login_player(guid, player)
            del self.load_maps[guid]

    def load_children(self, player, obj, plm):
        for i in range(len(obj.children)):
            child = obj.children[i]
            tp = guid_tool.et[child[:len(child) - 1]]
            father = getattr(obj, child)
            plm.query_num += 1
            req = Request(Request.opc_query, [tp, player.guid])
            req.add_extra(player)
            req.add_extra(father)
            req.add_callback(self.load_msg_callback)
            db_player.DbPlayer.instance().request(req)                         

    def load_msg_callback(self, req):
        player = req.extra[0]
        father = req.extra[1]
        plm = self.load_maps[player.guid]
        if req.res >= 0 and len(req.datas) > 0:
            for i in range(len(req.datas)):
                data = req.datas[i]
                father[data.guid] = data
                self.load_children(player, data, plm)                                
        self.load_player_check_end(player)

    def load_player_check_end(self, player):
        plm = self.load_maps[player.guid]
        plm.query_num -= 1
        if plm.query_num <= 0:
            PGame.pool.add(guid_tool.et['player'], player.guid, player)
            self.player_update_list.append([player.guid, PGame.timer.now()])
            if not plm.need_smsg:
                self.add_player_time(player.guid)
            player_data.player_login(player)
            for i in range(len(plm.callbacks)):
                plm.callbacks[i][0](plm.callbacks[i][1])
            if plm.need_smsg:
                player_data.client_login(player)
                gs_message.send_smsg_login_player(player.guid, player)
            del self.load_maps[player.guid]

    def create_player(self, guid):
        now = PGame.timer.now()
        tp = guid_tool.et['player']
        player = player_t()
        player.guid = guid
        player.server_id = 1
        player.level = 1
        player.rush_level = 1
        player.role_id = 1
        player.mission_ex_time = now
        player.last_refresh_time = now
        player.last_refresh_week_time = now
        player.last_refresh_month_time = now

        t_recharge = config.Config.instance().t_recharge.get()
        for i in range(len(t_recharge)):
            if t_recharge[i].type == 3:
                player.recharge_ids.append(t_recharge[i].id)

        t_arena_reward = config.Config.instance().t_arena_reward.get()
        for i in range(len(t_arena_reward)):
            if t_arena_reward[i].priv == 0:
                player.arena_segment = t_arena_reward[i].id
                break

        player_data.create_player_spells(player)

        player.new(player)
        PGame.pool.add(tp, player.guid, player)
        self.player_update_list.append([player.guid, PGame.timer.now()])
        player_data.player_login(player)
        self.save(player, False)
        return player

    def save(self, player, release):
        tp = guid_tool.et['player']
        for i in range(len(player.remove_tops)):
            req = Request(Request.opc_remove, player.remove_tops[i])
            db_player.DbPlayer.instance().request(req)
        self.save_me(player, player)
        player.clear_top()
        if release:
            player_data.player_logout(player)
            PGame.pool.remove(tp, player.guid)

    def save_me(self, player, obj):
        for i in range(len(obj.children)):
            child = obj.children[i]
            children = getattr(obj, child)
            for guid in children:
                data = children[guid]
                self.save_me(player, data)
        self.save_sub(player, obj)

    def save_all(self):
        for i in range(len(self.player_update_list)):
            guid = self.player_update_list[i][0]
            player = PGame.pool.get(guid)
            self.save(player, True)
        self.player_update_list = []

    @staticmethod
    def save_sub(player, obj):
        if obj.is_changed():
            opt = Request.opc_update
            if obj.guid in player.new_tops:
                opt = Request.opc_insert
            obj1 = copy.deepcopy(obj)
            req = Request(opt, obj1)
            db_player.DbPlayer.instance().request(req)
            obj.clear_changed()

    def add_player_time(self, guid):
        self.player_offline_map[guid] = PGame.timer.now()

    def del_player_time(self, guid):
        if guid in self.player_offline_map.keys():
            del self.player_offline_map[guid]

    # 刷新奇遇
    @staticmethod
    def refresh_qiyu(player):
        qiyu_kill_num = config.Config.instance().const('qiyu_kill_num')
        qiyu_time = config.Config.instance().const('qiyu_time')
        if player.mission_ex == 1:
            return
        elif player.mission_ex == 0:
            if PGame.timer.now() < player.mission_ex_time + qiyu_time or player.mission_ex_count < qiyu_kill_num:
                return

        player.mission_ex = 1
        player.mission_ex_count = 0
        player.mission_ex_time = PGame.timer.now()
        gs_message.send_smsg_mission_ex_meet(player.guid, player.mission_ex_time)

    @staticmethod
    def refresh_mail(player):
        # 刷新邮件
        mails = mail_pool.MailPool.instance().get_mail(player)
        if len(mails) != 0:
            if player.has_mail == 0:
                player.has_mail = 1
                gs_message.send_smsg_mail_update(player.guid)

    def update(self):
        # 每日刷新
        if PGame.timer.trigger_time(self.last_time, 5, 0):
            player_list = PGame.pool.get_type(guid_tool.et['player'])
            for i in range(len(player_list)):
                player = player_list[i]
                refresh_assets, refresh_time = player_data.player_refresh(player)
                gs_message.send_smsg_refresh_player(player.guid, refresh_time, refresh_assets)

            if PGame.timer.trigger_week_time(self.last_time):
                player_list = PGame.pool.get_type(guid_tool.et['player'])
                for i in range(len(player_list)):
                    player = player_list[i]
                    player_data.player_refresh_week(player)

            if PGame.timer.trigger_month_time(self.last_time):
                player_list = PGame.pool.get_type(guid_tool.et['player'])
                for i in range(len(player_list)):
                    player = player_list[i]
                    player_data.player_refresh_month(player)
        
        now = PGame.timer.now()
        self.last_time = now
        busy_num = PGame.env.get_setting_value("busy")
        total_num = len(self.player_update_list)
        if int(now / 1000 % 30) == 0:
            PGame.log.debug("player_num : %d" % (total_num,))
        total_upnum = 20
        total_upnum1 = int((total_num - busy_num) / 10)
        if total_upnum1 > total_upnum:
            total_upnum = total_upnum1
        if total_upnum > total_num:
            total_upnum = total_num
        upnum = 0
        while upnum < total_upnum:
            player_update_num = len(self.player_update_list)
            if player_update_num == 0:
                break
            data = self.player_update_list[0]
            if now < data[1] + self.PLAYER_UPDATE_TIME:
                break
            self.player_update_list.pop(0)
            player = PGame.pool.get(data[0])
            if player is not None:
                upnum += 1
                can_offline = False
                if player.guid in self.player_offline_map.keys():
                    ptime = self.player_offline_map[player.guid]
                    if player_update_num < busy_num:
                        if now > ptime + self.NORMAL_OFF_TIME:
                            can_offline = True
                    else:
                        if now > ptime + self.BUSY_OFF_TIME:
                            can_offline = True
                if can_offline:
                    player_data.player_logout(player)
                    self.save(player, True)
                    del self.player_offline_map[player.guid]
                else:
                    self.save(player, False)
                    self.player_update_list.append([data[0], now])

                    # ##做人物刷新

                    # 刷新奇遇
                    self.refresh_qiyu(player)

                    # 刷新邮件
                    self.refresh_mail(player)

                    # 刷新排行榜
                    rank_join_level = config.Config.instance().const('rank_join_level')
                    if player.level >= rank_join_level:
                        sid = PGame.env.get_setting_value('qid')
                        for i in range(1, 4):
                            guid = guid_tool.make_guid(guid_tool.et['rank'], sid, i)
                            promotion_pool.PromotionPool.instance().update_rank(guid, player)
