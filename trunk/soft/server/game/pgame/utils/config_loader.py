class ConfigObject(object):
    def __init__(self):
        self.col = []


class ConfigLoader(object):
    def __init__(self, path, convert=None):
        self.path = path
        self.convert = convert

    def load(self, name):
        self.x = 0
        self.y = 0
        self.data = []
        self.types = []
        self.records = []
        with open(self.path + "/" + name, "r", encoding="utf-8") as f:
            i = 0
            content = f.read()
            for byte in content:
                self.data.append(byte)
                if byte == '\n':
                    self.y = self.y + 1
                if byte == '\n' or byte == '\t':
                    if self.y > 0:
                        self.records.append(i + 1)
                i = i + 1

            f.seek(0, 0)
            for byte in f.read():
                if byte == '\t':
                    self.x = self.x + 1
                elif byte == '\n':
                    break

        self.x = self.x + 1
        self.y = self.y - 3

        indexs = []
        for j in range(self.get_x()):
            aname, ais_none = self.get(j, -1)
            if not ais_none:
                if aname[0] == "*":
                    indexs.append(aname[1:])
                    
        t_datas = {}
        t_datas1 = []
        for i in range(self.get_y()):
            t_data = ConfigObject()
            for j in range(self.get_x()):
                tp, _ = self.get(j, -2)
                aname, ais_none = self.get(j, -1)
                data = None
                if not ais_none:
                    data, is_none = self.get(j, i)
                    if tp == "INT":
                        data = int(data)
                    elif tp == "FLOAT":
                        data = float(data)
                    if aname[0] == "*":
                        aname = aname[1:]                        
                    if aname[0] == "#":
                        aname = aname[1:]
                        if self.convert is not None:
                            data = self.convert(data)
                    if aname.find(".") != -1:
                        names = aname.split(".")
                        aname = names[0]
                        if not hasattr(t_data, aname):
                            setattr(t_data, aname, [])
                            setattr(t_data, "indexes_" + aname, [])
                        index = int(names[1])
                        t_sub = getattr(t_data, aname)
                        tindex = -1
                        indexes = getattr(t_data, "indexes_" + aname)
                        for k in range(len(indexes)):
                            if indexes[k] == index:
                                tindex = k
                        if tindex == -1 and not is_none:
                            indexes.append(index)
                            t_sub.append(ConfigObject())
                            tindex = index
                        if tindex != -1:
                            setattr(t_sub[tindex], names[2], data)
                    else:
                        setattr(t_data, aname, data)
                t_data.col.append(data)
            datas = t_datas
            for j in range(len(indexs)):
                idata = getattr(t_data, indexs[j])
                if i < len(indexs) - 1:
                    if idata not in datas.keys():
                        datas[idata] = {}
                    datas = datas[idata]
                else:
                    datas[idata] = t_data
            t_datas1.append(t_data)
        return t_datas1, t_datas

    def get(self, x, y):
        index = (y + 2) * self.x + x
        if index >= len(self.records):
            return None

        begin = self.records[index]
        end = begin
        while True:
            if self.data[end] != '\t' and self.data[end] != '\n' and self.data[end] != '\r':
                end = end + 1
            else:
                break

        if begin == end:
            return '0', True
        tmpdata = ''.join(self.data[begin:end])
        tmpdata = tmpdata.replace("{nn}", "\n")
        return tmpdata, False

    def get_x(self):
        return self.x

    def get_y(self):
        return self.y
