from pgame.service_base import ServiceBase


class Pool(ServiceBase):
    def init(self):
        self.guid_obj = {}
        self.type_guid = {}
        self.guid_type = {}
        return 0

    def fini(self):
        return 0

    def add(self, tp, guid, obj):
        self.remove(tp, guid)
        self.guid_obj[guid] = obj
        self.type_guid[tp].add(guid)
        self.guid_type[guid] = tp

    def remove(self, tp, guid):
        if guid in self.guid_obj:
            del self.guid_obj[guid]
        if tp not in self.type_guid:
            self.type_guid[tp] = set()
        if guid in self.guid_type:
            tp = self.guid_type[guid]
            del self.guid_type[guid]
            self.type_guid[tp].remove(guid)

    def get(self, guid):
        if guid in self.guid_obj.keys():
            return self.guid_obj[guid]
        return None

    # 慎用，性能比较低
    def get_type(self, tp):
        if tp not in self.type_guid:
            return []
        else:
            objs = []
            for guid in self.type_guid[tp]:
                objs.append(self.guid_obj[guid])
            return objs
