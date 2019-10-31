import signal
import time
import platform
from tornado.ioloop import IOLoop
from pgame.env import Env
from pgame.log import Log
from pgame.timer import Timer
from pgame.game import Game
from pgame.pipe import Pipe
from pgame.tcp import Tcp
from pgame.pool import Pool
from pgame.http import Http

class MGame:
    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def init(self, name, conf_path='./conf'):
        self.name = name
        
        self.env = Env(self)
        if -1 == self.env.init(conf_path):
            return -1

        self.timer = Timer(self)
        if -1 == self.timer.init():
            return -1

        self.log = Log(self)
        if -1 == self.log.init():
            return -1

        self.pool = Pool(self)
        if -1 == self.pool.init():
            return -1

        self.game = Game(self)
        if -1 == self.game.init():
            return -1

        self.http = Http(self)
        if -1 == self.http.init():
            return -1

        self.pipe = Pipe(self)
        if -1 == self.pipe.init(self.name):
            return -1

        self.tcp = Tcp(self)
        if -1 == self.tcp.init(self.name):
            return -1

        print("server started")
        return 0

    def run(self):
        osname = platform.system()
        if osname == 'Windows':
            signal.signal(signal.SIGINT, self.exit_signal)
        else:
            signal.signal(signal.SIGCONT, self.exit_signal)
        self.stop = False
        IOLoop.current().add_timeout(time.time() + 1, self.timeout)
        IOLoop.current().start()

    def timeout(self, *args, **kwargs):
        if self.stop:
            IOLoop.current().stop()
        else:
            IOLoop.current().add_timeout(time.time() + 1, self.timeout)

    def exit_signal(self, signum, frame):
        if not self.stop:
            print("exit signal")
            self.stop = True

    def fini(self):
        if -1 == self.tcp.fini():
            return -1

        if -1 == self.pipe.fini():
            return -1

        if -1 == self.http.fini():
            return -1

        if -1 == self.game.fini():
            return -1

        if -1 == self.pool.fini():
            return -1
        
        if -1 == self.timer.fini():
            return -1

        if -1 == self.log.fini():
            return -1

        if -1 == self.env.fini():
            return -1
        
        print("server stoped")
        return 0

PGame = MGame.instance()
