import sys
sys.path.append('..')

from pgame import unit
from gs_manager import GsManager

if __name__ == '__main__':
    name = "gs"
    if len(sys.argv) > 1:
        name = sys.argv[1]
    unit.start(name, GsManager)
