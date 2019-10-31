from pgame.service_base import ServiceBase
import json


class Env(ServiceBase):
    def init(self, conf_path):
        try:
            with open(conf_path + "/server.json", "r") as f:
                content = json.load(f)
        except:
            print("server.json read error")
            return -1

        self.servers = {}
        if 'server' in content.keys():
            for k in content["server"]:
                it = content["server"][k]
                for i in range(len(it)):
                    self.servers[it[i]["id"]] = it[i]

        self.dbs = {}
        if 'db' in content.keys():
            for k in content["db"]:
                it = content["db"][k]
                for i in range(len(it)):
                    self.dbs[it[i]["id"]] = it[i]

        self.settings = {}
        if 'setting' in content.keys():
            for k in content['setting']:
                self.settings[k] = content['setting'][k]

        return 0

    def fini(self):
        return 0

    def get_server_value(self, name, key):
        if name in self.servers.keys():
            if key in self.servers[name].keys():
                return self.servers[name][key]
        return None

    def get_db_value(self, name, key):
        if name in self.dbs.keys():
            if key in self.dbs[name].keys():
                return self.dbs[name][key]
        return None

    def get_setting_value(self, name):
        if name in self.settings.keys():
            return self.settings[name]
        return None
