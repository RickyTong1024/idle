from pgame.service_base import ServiceBase
from pgame.request import Request
import time
import traceback
from pgame.db import Db
from common.dbo import log_dbo


class Log(ServiceBase):
    def init(self):
        self.mode = self.PGame.env.get_setting_value('log')
        if self.mode is None:
            return -1
        return 0

    def fini(self):
        return 0

    def trace(self):
        print('########################################################')
        print('traceback.print_exc():')
        print(traceback.print_exc())
        print('########################################################')

    def debug(self, text):
        if self.mode != 'debug':
            return
        print(time.strftime('[%Y-%m-%d %H:%M:%S]', time.localtime(time.time())), '[debug]', text)

    def error(self, text):
        print(time.strftime('[%Y-%m-%d %H:%M:%S]', time.localtime(time.time())), '[error]', text)
