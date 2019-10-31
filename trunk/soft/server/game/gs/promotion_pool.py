from pgame.request import Request
from common.proto.rank_db_pb2 import *
import db_player, player_data, gs_message
from common import guid_tool
from pgame.service import PGame
import copy


class PromotionPool:
    UPDATE_TIME = 600000

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.update_list = []       # 更新队列
        self.last_time = PGame.timer.now()
        self.rank = dict()

    def init(self):
        self.server_query()
        gs_message.send_smsg_center_enter_server()
        return 0
        
    def fini(self):
        self.save_all()
        return 0

    def server_query(self):
        sid = PGame.env.get_setting_value("qid")
        # rank
        for i in range(1, 4):
            guid = guid_tool.make_guid(guid_tool.et["rank"], sid, i)
            self.update_list.append([guid, PGame.timer.now()])
            req = Request(Request.opc_query, [guid_tool.et["rank"], guid])
            req.add_callback(self.load_server_callback)
            db_player.DbPlayer.instance().request(req)

    def load_server_callback(self, req):
        guid = req.param[1]
        tp = guid_tool.type_guid(guid)
        if req.res >= 0 and len(req.datas) > 0:
            obj = req.datas[0]
        else:
            if tp == guid_tool.et['rank']:
                obj = self.create_rank(guid)
                obj.new(obj)
            else:
                obj = None
        if tp == guid_tool.et['rank']:
            self.rank_init(guid, obj)
        PGame.pool.add(tp, guid, obj)

    @staticmethod
    def create_rank(guid):
        # 1 等级 2 战力 3 塔
        rank = rank_t()
        rank.guid = guid
        rank.last_time = PGame.timer.now()
        return rank

    # 排行榜初始化
    def rank_init(self, guid, obj):
        index = guid_tool.index_guid(guid)
        self.rank[index] = dict()
        for i in range(len(obj.player_guid)):
            self.rank[index][obj.player_guid[i]] = i

    def update_rank(self, guid, player):
        rank = PGame.pool.get(guid)
        if rank is None:
            PGame.log.error('rank is None')
            return

        if player is None:
            PGame.log.error('player is None')
            return

        # 如果排行榜中没有该玩家则插入该玩家
        index = guid_tool.index_guid(guid)
        if player.guid not in self.rank[index].keys():
            rank.player_guid.append(player.guid)
            rank.player_name.append(player.name)
            rank.player_icon.append(player.avatar)
            rank.player_level.append(player.level)
            # 1 等级 2 战力 3 塔
            if index == 1:
                rank.player_data.append(player.level)
            elif index == 2:
                rank.player_data.append(player_data.get_fight_power(player))
            elif index == 3:
                rank.player_data.append(player.tower)
            self.rank[index][player.guid] = len(rank.player_guid) - 1

        player_rank = self.rank[index][player.guid]
        if rank.player_name[player_rank] != player.name:
            rank.player_name[player_rank] = player.name
        if rank.player_icon != player.avatar:
            rank.player_icon[player_rank] = player.avatar
        if rank.player_level != player.level:
            rank.player_level[player_rank] = player.level

        if index == 1:
            if rank.player_data[player_rank] != player.level:
                rank.player_data[player_rank] = player.level
        elif index == 2:
            if rank.player_data[player_rank] != player_data.get_fight_power(player):
                rank.player_data[player_rank] = player_data.get_fight_power(player)
        elif index == 3:
            if rank.player_data[player_rank] != player.tower:
                rank.player_data[player_rank] = player.tower

        for i in range(self.rank[index][player.guid] - 1, -1, -1):
            player_rank = self.rank[index][player.guid]
            if rank.player_data[i] < rank.player_data[player_rank]:
                self.rank[index][player.guid], self.rank[index][rank.player_guid[i]] = self.rank[index][rank.player_guid[i]],\
                                                                                       self.rank[index][player.guid]
                rank.player_guid[i], rank.player_guid[player_rank] = rank.player_guid[player_rank], rank.player_guid[i]
                rank.player_name[i], rank.player_name[player_rank] = rank.player_name[player_rank], rank.player_name[i]
                rank.player_icon[i], rank.player_icon[player_rank] = rank.player_icon[player_rank], rank.player_icon[i]
                rank.player_level[i], rank.player_level[player_rank] = rank.player_level[player_rank], rank.player_level[i]
                rank.player_data[i], rank.player_data[player_rank] = rank.player_data[player_rank], rank.player_data[i]
            else:
                break

    def save(self, obj):
        for i in range(len(obj.remove_tops)):
            req = Request(Request.opc_remove, obj.remove_tops[i])
            db_player.DbPlayer.instance().request(req)
        self.save_sub(obj)
        obj.clear_top()

    @staticmethod
    def save_sub(obj):
        if obj.is_changed():
            opt = Request.opc_update
            if obj.guid in obj.new_tops:
                opt = Request.opc_insert
            obj1 = copy.deepcopy(obj)
            req = Request(opt, obj1)
            db_player.DbPlayer.instance().request(req)
            obj.clear_changed()

    def save_all(self):
        for i in range(len(self.update_list)):
            guid = self.update_list[i][0]
            obj = PGame.pool.get(guid)
            self.save(obj)
        self.update_list = []

    def update(self):
        # 系统表刷新
        now = PGame.timer.now()
        self.last_time = now
        if now // 1000 % 60 == 0:
            PGame.log.debug("update_sport")
        if len(self.update_list) > 0:
            data = self.update_list[0]
            if now < data[1] + self.UPDATE_TIME:
                return

            obj = PGame.pool.get(data[0])
            if obj is not None:
                self.update_list.pop(0)
                self.save(obj)
                self.update_list.append([obj.guid, now])
