from pgame.service import PGame


class MissionPool:
    REMOVE_TIME = 600000
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.arena_gag_players = dict()

    def init(self):
        return 0

    def fini(self):
        return 0

    def add_arena_gag_player(self, player_guid, gag_player):
        self.arena_gag_players[player_guid] = [gag_player, PGame.timer.now()]

    def remove_arena_gag_player(self, player_guid):
        del self.arena_gag_players[player_guid]

    def update(self):
        now = PGame.timer.now()
        for player_guid, gag_player in self.arena_gag_players:
            if gag_player[1] + self.REMOVE_TIME < now:
                self.remove_arena_gag_player(player_guid)
