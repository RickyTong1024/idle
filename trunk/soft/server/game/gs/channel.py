class ChannelInfo:
    def __init__(self):
        self.guid = 0
        self.hid = 0
        self.addr = ""


class Channel:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.channel_infos = {}
        self.channel_infos_hid = {}
    
    def add_info(self, hid, guid, addr):
        info = self.get_info(hid)
        if info is not None:
            self.del_info(info.hid)
        cif = ChannelInfo()
        cif.hid = hid
        cif.guid = guid
        cif.addr = addr

        self.channel_infos[guid] = cif
        self.channel_infos_hid[hid] = cif.guid
        return cif

    def del_info(self, hid):
        if hid in self.channel_infos_hid.keys():
            guid = self.channel_infos_hid[hid]
            del self.channel_infos[guid]
            del self.channel_infos_hid[hid]

    def get_info(self, hid):
        if hid in self.channel_infos_hid.keys():
            guid = self.channel_infos_hid[hid]
            if guid in self.channel_infos.keys():
                return self.channel_infos[guid]
        return None

    def get_cif(self, guid):
        if guid in self.channel_infos.keys():
            return self.channel_infos[guid]
        return None
