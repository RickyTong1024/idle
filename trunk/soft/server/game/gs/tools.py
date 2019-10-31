import math
import random


def to_int(num):
    if num < 0:
        return math.ceil(num - 0.000001)
    else:
        return math.floor(num + 0.000001)


def randseq(seq, seed=0):
    all_weights = 0
    for j in range(len(seq)):
        all_weights += seq[j][1]
    if seed == 0:
        result_weights = random.randint(0, all_weights - 1)
    else:
        result_weights = LRandom.instance().random(0, all_weights - 1)
    local_weights = 0
    for j in range(len(seq)):
        local_weights += seq[j][1]
        if local_weights > result_weights:
            return seq[j][0]


class LRandom:
    m = 2**16
    a = 214013
    b = 2531011

    @classmethod
    def instance(cls):
        if not hasattr(cls, "_instance"):
            cls._instance = cls()
        return cls._instance

    def __init__(self):
        self.seed = 0
        self.fight_duration = dict()
        self.player_codes = dict()
        self.player_username = dict()

    def init(self):
        return 0

    def fini(self):
        return 0

    def make_seed(self, s):
        self.seed = s

    def random(self, a, b):
        self.seed = (self.a * self.seed + self.b) % self.m
        return to_int(a + (b - a) * self.seed / self.m)


'''
lr = LRandom()
lr.Seed(111)

t = {}
for i in range(10000):
    n = lr.Random(0, 10)
    if n not in t:
        t[n] = 1
    else:
        t[n] = t[n] + 1

for k in t.keys():
    print(k, t[k])
'''