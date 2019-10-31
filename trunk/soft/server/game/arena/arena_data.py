import config
import random


def get_index(value, array):
    """获取列表索引"""
    for i in range(len(array)):
        if value == array[i]:
            return i
    return None


def random_name():
    """随机获取昵称"""
    t_name = config.Config.instance().t_name.get()
    length = len(t_name) - 1
    name1 = t_name[random.randint(0, length)].lang[0].name1
    name2 = t_name[random.randint(0, length)].lang[0].name2
    name = name1 + name2
    return name


def random_level(average_level):
    """随机获取等级"""
    arena_npc_level_drift = config.Config.instance().const('arena_npc_level_drift')
    drift = random.randint(-arena_npc_level_drift, arena_npc_level_drift)
    return average_level + drift


def random_icon():
    """随机获取头像图标"""
    t_avatar = config.Config.instance().t_avatar.get()
    index = random.randint(0, len(t_avatar) - 1)
    return t_avatar[index].id


def random_power(average_power):
    """随机获取战斗力"""
    arena_npc_power_drift = config.Config.instance().const('arena_npc_level_drift')
    drift = random.randint(-arena_npc_power_drift, arena_npc_power_drift)
    return int(average_power + (average_power * drift) / 100)


def average_num(array):
    num_sum = 0
    for i in range(len(array)):
        num_sum += array[i]

    if len(array) == 0 or num_sum == 0:
        return 1

    return int(num_sum / len(array))


def get_power_value(power, attr_id):
    """根据战斗力获取属性值"""
    t_attr = config.Config.instance().t_attr.get(attr_id)
    if t_attr is None:
        return 0
    return power / 100 * t_attr.value


def get_level_value(level, attr_id):
    """根据等级获取属性值"""
    t_level = config.Config.instance().t_level.get(level)
    if t_level is None:
        return 0

    return get_power_value(t_level.std_attr, attr_id)


def get_npc_attr(npc_level):
    """获取npc属性"""
    attr = dict()
    t_attrs = config.Config.instance().t_attr.get()
    for i in range(len(t_attrs)):
        attr[t_attrs[i].id] = 0

    for i in range(4):
        attr[i + 1] = get_level_value(npc_level, i + 1) * 5

    for i in range(10, 16):
        attr[i + 1] = get_level_value(npc_level, i + 1)

    return attr
