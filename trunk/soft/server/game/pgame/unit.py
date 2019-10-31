from pgame.service import PGame


def start(name, cls):
    if -1 == PGame.init(name):
        return
    c = cls()
    if -1 == c.init():
        return
    PGame.run()
    if -1 == c.fini():
        return
    if -1 == PGame.fini():
        return
