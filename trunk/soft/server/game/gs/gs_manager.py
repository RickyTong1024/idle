from pgame.service import PGame
from common.db import db_gtool, db_log
import db_player, config, player_pool, promotion_pool, player_data, tools, mail_pool, mission_pool
import player_manager, mission_manager, item_manager, promotion_manager, mail_manager, pet_manager


class GsManager:
    def __init__(self):
        self.tid = None

    def init(self):
        if -1 == config.Config.instance().init('t_lang'):
            return -1
        if -1 == db_player.DbPlayer.instance().init('loot'):
            return -1
        if -1 == db_gtool.DbGtool.instance().init('loot'):
            return -1
        if -1 == db_log.DbLog.instance().init('loot'):
            return -1
        if -1 == player_pool.PlayerPool.instance().init():
            return -1
        if -1 == promotion_pool.PromotionPool.instance().init():
            return -1
        if -1 == mail_pool.MailPool.instance().init():
            return -1
        if -1 == mission_pool.MissionPool.instance().init():
            return -1
        if -1 == tools.LRandom.instance().init():
            return -1
        self.tid = PGame.timer.schedule(self.update, 1000)
        return 0

    def fini(self):
        PGame.timer.cancel(self.tid)
        if -1 == tools.LRandom.instance().fini():
            return -1
        if -1 == mission_pool.MissionPool.instance().fini():
            return -1
        if -1 == mail_pool.MailPool.instance().fini():
            return -1
        if -1 == promotion_pool.PromotionPool.instance().fini():
            return -1
        if -1 == player_pool.PlayerPool.instance().fini():
            return -1
        if -1 == db_log.DbLog.instance().fini():
            return -1
        if -1 == db_gtool.DbGtool.instance().fini():
            return -1
        if -1 == db_player.DbPlayer.instance().fini():
            return -1
        if -1 == config.Config.instance().fini():
            return -1
        return 0

    def update(self):
        player_pool.PlayerPool.instance().update()
        promotion_pool.PromotionPool.instance().update()
        mail_pool.MailPool.instance().update()
        mission_pool.MissionPool.instance().update()
        player_data.client_check()
