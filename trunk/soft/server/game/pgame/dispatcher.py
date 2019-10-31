from pgame.game import Game


def reg_handle(opcode):
    def wrapper(func):
        Game.register(opcode, func)

    return wrapper


def reg_handle_all(func):
    Game.register_all(func)
