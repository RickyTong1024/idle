from common.db.db_normal import DbNormal
from common import guid_tool
from common.dbo import player_dbo, acc_dbo, equip_dbo, mail_dbo, pet_dbo, rank_dbo, arena_list_dbo, mail_server_dbo


class DbPlayer(DbNormal):
    def make_dispatcher(self):
        self.dispatch[guid_tool.et['player']] = player_dbo
        self.dispatch[guid_tool.et['acc']] = acc_dbo
        self.dispatch[guid_tool.et['equip']] = equip_dbo
        self.dispatch[guid_tool.et['mail']] = mail_dbo
        self.dispatch[guid_tool.et['mail_server']] = mail_server_dbo
        self.dispatch[guid_tool.et['pet']] = pet_dbo

        self.dispatch[guid_tool.et['rank']] = rank_dbo
        self.dispatch[guid_tool.et['arena_list']] = arena_list_dbo
