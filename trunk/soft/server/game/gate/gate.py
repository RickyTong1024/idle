import sys
sys.path.append('..')

from pgame import unit
from gate_manager import GateManager

if __name__ == '__main__':
    name = "gate"
    if len(sys.argv) > 1:
        name = sys.argv[1]
    unit.start(name, GateManager)
