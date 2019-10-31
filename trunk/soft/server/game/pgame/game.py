from pgame.service_base import ServiceBase


class Game(ServiceBase):
    handles = {}
    handles_all = []

    def init(self):
        self.tid = self.PGame.timer.schedule(self.update, 30)
        self.msgs = []
        return 0

    def fini(self):
        self.PGame.timer.cancel(self.tid)
        return 0

    @classmethod
    def register(cls, opcode, func):
        if opcode not in cls.handles.keys():
            cls.handles[opcode] = []
        cls.handles[opcode].append(func)

    @classmethod
    def register_all(cls, func):
        cls.handles_all.append(func)

    def add_msg(self, pck):
        self.msgs.append(pck)

    def update(self):
        for i in range(len(self.msgs)):
            pck = self.msgs[i]
            if pck.opcode in self.handles.keys():
                handles = self.handles[pck.opcode]
                for j in range(len(handles)):
                    try:
                        handles[j](pck)
                    except:
                        self.PGame.log.trace()
            for j in range(len(self.handles_all)):
                try:
                    self.handles_all[j](pck)
                except:
                    self.PGame.log.trace()
        self.msgs = []
