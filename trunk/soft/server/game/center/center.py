import sys
sys.path.append('..')

from pgame import unit
from center_manager import CenterManager

if __name__ == '__main__':
    name = "center"
    if len(sys.argv) > 1:
        name = sys.argv[1]
    unit.start(name, CenterManager)
