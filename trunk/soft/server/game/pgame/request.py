import copy


class Request:
    opc_insert = 1
    opc_query = 2
    opc_update = 3
    opc_remove = 4
    opc_query_all = 5
    opc_remove_all = 6

    def __init__(self, op, param):
        self.op = op
        self.param = copy.deepcopy(param)
        self.datas = []
        self.extra = []
        self.res = -1
        self.callback = None

    def add_data(self, data):
        self.datas.append(data)

    def add_extra(self, extra):
        self.extra.append(extra)

    def add_callback(self, callback):
        self.callback = callback
