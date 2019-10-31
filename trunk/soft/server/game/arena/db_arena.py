from common.db.db_normal import DbNormal
from common import guid_tool
from common.dbo import arena_room_dbo, arena_list_dbo


class DbArena(DbNormal):
    def make_dispatcher(self):
        self.dispatch[guid_tool.et['arena_list']] = arena_list_dbo
        self.dispatch[guid_tool.et['arena_room']] = arena_room_dbo
