et = dict()
et['player'] = 1
et['item'] = 2
et['acc'] = 3
et['equip'] = 4
et['mail'] = 5
et['mail_server'] = 6
et['pet'] = 7
et['rank'] = 8
et['arena_list'] = 9
et['arena_room'] = 10


def make_guid(tp, serverid, i):
    return ((tp << 56) & 0xFF00000000000000) | ((serverid << 44) & 0x00FFF00000000000) | (i & 0x00000FFFFFFFFFFF)


def type_guid(guid):
    return (guid >> 56) & 0x00000000000000FF


def index_guid(guid):
    return guid & 0x00000FFFFFFFFFFF


def sid_guid(guid):
    return (guid >> 44) & 0x0000000000000FFF
