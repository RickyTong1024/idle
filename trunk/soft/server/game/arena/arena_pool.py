from pgame.service import PGame
from pgame.request import Request
from common.proto.arena_list_db_pb2 import *
from common.proto.arena_room_db_pb2 import *
from common import guid_tool
from common.db import db_gtool
import db_arena
import arena_message, arena_data, config
import copy


class Server:
    def __init__(self, serverid, addr):
        self.serverid = serverid
        self.addr = addr
        self.un_response = 0


class ArenaPool:
    UPDATE_TIME = 6000000

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.arena_list = None
        self.arena_rooms = dict()  # 用guid做key
        self.arena_room_type = dict()  # 用段位做key 存guid的list
        self.room_update_list = list()
        self.last_time = PGame.timer.now()
        self.servers = dict()
        self.requests = dict()
        self.room_player_num = 0                    # 竞技场房间最大人数
        self.room_add_npc_time = 0                  # 房间每隔多久未进新人增加npc
        self.update_npc_rooms = list()

    def init(self):
        arena_room_type = config.Config.instance().const('arena_room_type')
        for i in range(1, arena_room_type + 1):
            self.arena_room_type[i] = list()
        self.requests = dict()
        self.room_player_num = config.Config.instance().const('arena_room_player_num')
        self.room_add_npc_time = config.Config.instance().const('arena_room_add_npc_time')
        self.arena_server_query()

        return 0

    def fini(self):
        self.arena_rooms = dict()
        self.arena_room_type = dict()
        self.room_update_list = list()
        self.save_all()
        return 0

    def create_arena_list(self, guid):
        arena_list = arena_list_t()
        arena_list.guid = guid
        arena_list.last_time = PGame.timer.now()
        return arena_list

    def create_room(self, segment):
        arena_room = arena_room_t()
        t_arena_reward = config.Config.instance().t_arena_reward.get(segment)
        arena_room.guid = db_gtool.DbGtool.instance().assign(guid_tool.et['arena_room'])
        arena_room.segment = segment
        arena_room.last_time = PGame.timer.now()
        arena_room.new(arena_room)
        self.room_update_list.append(arena_room.guid)
        self.save(arena_room)
        self.arena_rooms[arena_room.guid] = arena_room
        self.arena_room_type[t_arena_reward.type].append(arena_room.guid)
        self.update_npc_rooms.append(arena_room.guid)
        return arena_room

    def switch_room(self, segment, player_guid,
                    player_name, player_level, player_avatar, player_power):
        """选择房间加入"""

        mark = False
        t_arena_reward = config.Config.instance().t_arena_reward.get(segment)

        arena_room = arena_room_t()
        rooms = self.arena_room_type[t_arena_reward.type]
        arena_room_player_num = config.Config.instance().const('arena_room_player_num')
        for i in range(len(rooms)):
            if rooms[i] in self.room_update_list:
                arena_room = self.arena_rooms[rooms[i]]
                mark = True
                break
        if not mark:
            arena_room = self.create_room(segment)

        arena_room.player_guids.append(player_guid)
        arena_room.player_names.append(player_name)
        arena_room.player_levels.append(player_level)
        arena_room.player_icons.append(player_avatar)
        arena_room.player_integrals.append(0)
        arena_room.is_npc.append(0)
        # ## 战斗力计算
        arena_room.player_powers.append(player_power)
        arena_room.arena_wins.append(0)
        arena_room.arena_nums.append(0)
        arena_room.last_time = PGame.timer.now()
        if len(arena_room.player_guids) >= self.room_player_num:
            index = arena_data.get_index(arena_room.guid, self.room_update_list)
            del self.room_update_list[index]
        return arena_room

    def add_npc(self, arena_room):
        """竞技场房间添加npc"""
        arena_room.player_guids.append(len(arena_room.player_guids) + 1)
        arena_room.player_names.append(arena_data.random_name())
        average_level = arena_data.average_num(arena_room.player_levels)
        arena_room.player_levels.append(arena_data.random_level(average_level))
        arena_room.player_icons.append(arena_data.random_icon())
        arena_room.player_integrals.append(0)
        arena_room.is_npc.append(1)
        average_power = arena_data.average_num(arena_room.player_powers)
        arena_room.player_powers.append(arena_data.random_power(average_power))
        arena_room.arena_wins.append(0)
        arena_room.arena_nums.append(0)

    def save(self, obj):
        for i in range(len(obj.remove_tops)):
            req = Request(Request.opc_remove, obj.remove_tops[i])
            db_arena.DbArena.instance().request(req)
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
            db_arena.DbArena.instance().request(req)
            obj.clear_changed()

    def save_all(self):
        for i in range(len(self.room_update_list)):
            guid = self.room_update_list[i]
            arena_room = self.arena_rooms[guid]
            self.save(arena_room)
        self.room_update_list = list()
        self.save(self.arena_list)

    def arena_server_query(self):
        req = Request(Request.opc_query_all, [guid_tool.et["arena_room"]])
        req.add_callback(self.load_room_callback)
        db_arena.DbArena.instance().request(req)

        sid = PGame.env.get_setting_value('qid')
        guid = guid_tool.make_guid(guid_tool.et["arena_list"], sid, 1)  # arena_list
        # self.update_list.append([guid, PGame.timer.now()])
        req = Request(Request.opc_query, [guid_tool.et["arena_list"], guid])
        req.add_callback(self.load_list_callback)
        db_arena.DbArena.instance().request(req)

    def remove_server(self):
        req = Request(Request.opc_remove_all, [guid_tool.et["arena_room"]])
        db_arena.DbArena.instance().request(req)

    def load_room_callback(self, req):
        if req.res >= 0 and len(req.datas) > 0:
            for i in range(len(req.datas)):
                t_arena_reward = config.Config.instance().t_arena_reward.get(req.datas[i].segment)
                self.arena_rooms[req.datas[i].guid] = req.datas[i]
                self.arena_room_type[t_arena_reward.type].append(req.datas[i].guid)
                if len(req.datas[i].player_guids) < self.room_player_num:
                    self.update_npc_rooms.append(req.datas[i].guid)

    def load_list_callback(self, req):
        guid = req.param[1]
        if req.res >= 0 and len(req.datas) > 0:
            self.arena_list = req.datas[0]
        else:
            self.arena_list = self.create_arena_list(guid)
            self.arena_list.new(self.arena_list)

    def add_server(self, serverid, addr):
        server = Server(serverid, addr)
        self.servers[serverid] = server

    def del_server(self, serverid):
        del self.servers[serverid]

    def server_response(self, serverid):
        if serverid in self.requests.keys():
            del self.requests[serverid]
        self.servers[serverid].un_response = 0

    def update(self):

        # 每日刷新
        if PGame.timer.trigger_time(self.last_time, 5, 0):
            # 清空表
            for _, arena_room in self.arena_rooms:
                t_arena_reward = config.Config.instance().t_arena_reward.get(arena_room.segment)
                for i in range(arena_room.player_guids):
                    if arena_room.player_integrals[i] >= t_arena_reward.score:
                        self.arena_list.player_segments[arena_room.player_indexes[i]] = t_arena_reward.next
                        serverid = guid_tool.sid_guid(arena_room.player_guids[i])
                        addr = self.servers[serverid].addr
                        arena_message.send_amsg_arena_refresh(addr, arena_room.player_guids[i], t_arena_reward.next)
            self.arena_rooms = dict()
            self.arena_room_type = dict()
            self.room_update_list = list()
            self.remove_server()
            self.last_time = PGame.timer.now()

            # 周刷新
            if PGame.timer.trigger_week_time(self.last_time):
                for i in range(len(self.arena_list.player_segments)):
                    t_arena_reward = config.Config.instance().t_arena_reward.get(self.arena_list.player_segments[i])
                    self.arena_list.player_segments[i] = t_arena_reward.season_end_segment
                    serverid = guid_tool.sid_guid(self.arena_list.player_guids[i])
                    addr = self.servers[serverid].addr
                    arena_message.send_amsg_arena_refresh_season(addr, self.arena_list.player_guids[i], t_arena_reward.id)

        now = PGame.timer.now()
        self.last_time = now

        # 竞技场房间每隔一段时间未进入新人增加npc
        for i in range(len(self.update_npc_rooms) - 1, -1, -1):
            guid = self.update_npc_rooms[i]
            arena_room = self.arena_rooms[guid]
            if now - arena_room.last_time >= self.room_add_npc_time:
                arena_room.last_time = now
                self.add_npc(arena_room)
                if arena_room.guid not in self.room_update_list:
                    self.room_update_list.append(arena_room.guid)
                if len(arena_room.player_guids) >= self.room_player_num:
                    del self.update_npc_rooms[i]

        # 保存数据
        total_num = len(self.room_update_list)
        if now // 1000 % 60 == 0:
            PGame.log.debug("update_arena_rooms")

        total_upnum = 20
        if total_upnum > total_num:
            total_upnum = total_num
        upnum = 0
        while upnum < total_upnum:
            arena_update_num = len(self.room_update_list)
            if arena_update_num == 0:
                break

            data = self.room_update_list[0]
            arena_room = self.arena_rooms[data]
            if arena_room is not None:
                del self.room_update_list[0]
                self.save(arena_room)
                self.room_update_list.append(arena_room.guid)

            self.save(self.arena_list)

            upnum += 1

        # 逻辑服务器心跳处理
        for serverid in self.requests.keys():
            if serverid in self.servers.keys():
                self.servers[serverid].un_response = self.servers[serverid].un_response + 1
                if self.servers[serverid].un_response >= 3:
                    self.del_server(serverid)

        self.requests = dict()

        for serverid in self.servers.keys():
            self.requests[serverid] = serverid
            arena_message.send_amsg_heart_beat(self.servers[serverid].addr)
        return 0
