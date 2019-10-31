import copy, struct


class object_t_db:
    def __init__(self, cls):
        self.obj = cls()
        self._has_changed = {}
        self._repeated_save = {}
        self.new_tops = []
        self.remove_tops = []

    def __deepcopy__(self, memo):
        res = self.__class__()
        memo[id(self)] = res
        res.obj = copy.deepcopy(self.obj)
        res._has_changed = copy.deepcopy(self._has_changed)
        res._repeated_save = copy.deepcopy(self._repeated_save)
        res.new_tops = copy.deepcopy(self.new_tops)
        res.remove_tops = copy.deepcopy(self.remove_tops)
        return res

    def is_changed(self):
        if len(self._has_changed) > 0:
            return True
        for field in self.obj.DESCRIPTOR.fields:
            if field.label == 3:
                if field.name not in self._repeated_save.keys():
                    return True
                v1 = self._repeated_save[field.name]
                v2 = getattr(self, field.name)
                if self.is_changed_v(v1, v2):
                    return True
        return False
        
    def has_changed(self, field_name):
        if field_name in self._has_changed.keys():
            return True
        for field in self.obj.DESCRIPTOR.fields:
            if field.label == 3 and field.name == field_name:
                if field.name not in self._repeated_save.keys():
                    return True
                v1 = self._repeated_save[field.name]
                v2 = getattr(self, field.name)
                return self.is_changed_v(v1, v2) 
        return False

    def clear_changed(self):
        self._has_changed = {}
        self._repeated_save = {}
        for field in self.obj.DESCRIPTOR.fields:
            if field.label == 3:
                v = getattr(self, field.name)
                self._repeated_save[field.name] = copy.deepcopy(v)

    def is_changed_v(self, v1, v2):
        if len(v1) != len(v2):
            return True
        for i in range(len(v1)):
            if v1[i] != v2[i]:
                return True
        return False
        
    def new(self, obj, field=None):
        guid = obj.guid
        if field is not None:
            fd = getattr(self, field)
            fd[guid] = obj
        if guid not in self.new_tops:
            self.new_tops.append(guid)

    def delete(self, guid, field):
        fd = getattr(self, field)
        del fd[guid]
        if guid in self.new_tops:
            self.new_tops.remove(guid)
        else:
            self.remove_tops.append(guid)

    def clear_top(self):
        self.new_tops = []
        self.remove_tops = []        


def make_db_proto(cls1, cls):
    for field in cls.DESCRIPTOR.fields:
        if field.label == 3:
            add_db_repeated_property(cls1, field)
        else:
            add_db_property(cls1, field)

    def ParseFromString(self, s):
        return self.obj.ParseFromString(s)
    cls1.ParseFromString = ParseFromString

    def SerializeToString(self):
        return self.obj.SerializeToString()
    cls1.SerializeToString = SerializeToString

    def ClearField(self, field_name):
        return self.obj.ClearField(field_name)
    cls1.ClearField = ClearField


def add_db_repeated_property(cls1, field):
    def gt(self):
        return getattr(self.obj, field.name)

    def st(self, new_value):
        raise("can't set")

    setattr(cls1, field.name, property(gt, st))


def add_db_property(cls1, field):
    def gt(self):
        return getattr(self.obj, field.name)

    def st(self, new_value):
        self._has_changed[field.name] = True
        setattr(self.obj, field.name, new_value)

    setattr(cls1, field.name, property(gt, st))


def parse(msg, s):
    try:
        msg.ParseFromString(s)
        if not msg.IsInitialized():
            return False
    except:
        return False
    return True


def get_type_info(tp):
    if tp == "int32":
        return "i", 4
    elif tp == "uint32":
        return "I", 4
    elif tp == "int64":
        return "q", 8
    elif tp == "uint64":
        return "Q", 8
    elif tp == "bytes":
        return "%ds", -2
    elif tp == "string":
        return "%ds", -1
    elif tp == "double":
        return "d", 8


def repeated2bytes(tp, obj):
    bs, length = get_type_info(tp)
    l = len(obj)
    ssm = struct.pack('=I', l)
    for i in range(l):
        if length == -1:
            v = obj[i].encode("utf8")
            ssm = struct.pack(('=%dsI' + bs) % (len(ssm), len(v),), ssm, len(v), v)
        elif length == -2:
            ssm = struct.pack(('=%dsI' + bs) % (len(ssm), len(obj[i]),), ssm, len(obj[i]), obj[i])
        else:
            ssm = struct.pack(('=%ds' + bs) % (len(ssm),), ssm, obj[i])
    return ssm


def bytes2repeated(tp, obj, ssm):
    if ssm is None:
        return
    bs, length = get_type_info(tp)
    l, ssm = struct.unpack('=I%ds' % (len(ssm) - 4), ssm)
    for i in range(l):
        if length < 0:
            v, ssm = struct.unpack('=I%ds' % (len(ssm) - 4,), ssm)
            v, ssm = struct.unpack(("=" + bs + '%ds') % (v, len(ssm) - v,), ssm)
            if length == -1:
                v = v.decode()
        else:
            v, ssm = struct.unpack(("=" + bs + '%ds') % (len(ssm) - length,), ssm)
        obj.append(v)

