import sys
sys.path.append('..')

from pgame import unit
from arena_manager import ArenaManager

if __name__ == '__main__':
    name = "arena"
    if len(sys.argv) > 1:
        name = sys.argv[1]
    unit.start(name, ArenaManager)
