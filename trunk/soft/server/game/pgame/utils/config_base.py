from pgame.utils.config_loader import ConfigLoader
from pgame.service import PGame


class ConfigSub:
    def __init__(self, tb, tb1):
        self.tb = tb
        self.tb1 = tb1

    def get(self, *args):
        if len(args) == 0:
            return self.tb
        else:
            data = self.tb1
            for i in range(len(args)):
                index = args[i]
                if index not in data.keys():
                    return None
                data = data[index]
            return data


class ConfigBase:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def init(self, lang_name=None):
        path = PGame.env.get_setting_value("conf_path")
        if lang_name is not None:
            self.lang = PGame.env.get_setting_value('lang')
            if self.lang is None:
                PGame.log.error('env lang cant find')
                return -1
            if self.lang is None:
                PGame.log.error('env conf_path cant find')
                return -1
            self.cl = ConfigLoader(path, self.lang_str)
            self.load(lang_name)
        else:
            self.cl = ConfigLoader(path)

        self.load_config()
        return 0

    def fini(self):
        return 0

    def load_config(self):
        pass

    def load(self, name):
        tb, tb1 = self.cl.load(name + '.txt')
        cs = ConfigSub(tb, tb1)
        setattr(self, name, cs)

    def lang_str(self, s):
        ss = self.t_lang.get(s)
        if ss is None:
            return ""
        return ss.col[self.lang]

    def const(self, s):
        c = self.t_const.get(s)
        if c is None:
            return 0
        return c.value
