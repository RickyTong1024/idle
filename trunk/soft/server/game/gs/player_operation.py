from pgame.service import PGame
from common.proto.common_msg_pb2 import *
import config, player_data
import tools


def get_draw_index(player, t_configs, drops, indexes, tp, draw_id=0):
    # 抽卡随机

    if draw_id == 0:
        seq = list()
        for i in range(len(t_configs)):
            seq.append([t_configs[i].id, t_configs[i].weight])
        draw_id = tools.randseq(seq)

    t_config = None
    for i in range(len(t_configs)):
        if t_configs[i].id == draw_id:
            t_config = t_configs[i]
            break

    t_drop = config.Config.instance().t_drop.get(draw_id)
    seq = list()
    for i in range(len(t_drop.assets)):
        if tp == 6:
            if t_drop.assets[i].value1 in player.pet_ids:
                continue
            if t_config.type == 2:
                if t_drop.assets[i].value1 in player.pet_ids:
                    continue
                if t_drop.id in drops and i in indexes:
                    continue
        seq.append([i, t_drop.assets[i].weight])

    if len(seq) != 0:
        return t_config.id, tools.randseq(seq)
    else:
        # 宠物没有重复
        for i in range(t_configs):
            if t_configs[i].type == 3:
                t_config = t_configs[i]
        t_drop = config.Config.instance().t_drop.get(t_config.id)
        for i in range(len(t_drop.assets)):
            seq.append([i, t_drop.assets[i].weight])
        return t_config.id, tools.randseq(seq)


def draw_ten_check(player, tp, t_configs, drop_indexes):
    # 十连必出精品

    mark = False
    for i in range(len(drop_indexes)):
        if tp == 3:
            t_config = None
            for j in range(len(t_configs)):
                if t_configs[j].id == drop_indexes[i][0]:
                    t_config = t_configs[j]
        elif tp == 5:
            t_config = config.Config.instance().t_rune_draw.get(drop_indexes[i][0])
        else:
            t_config = config.Config.instance().t_pet_draw.get(drop_indexes[i][0])
        if t_config.type == 2:
            mark = True
            break
    if not mark:
        drop_indexes.pop()
        for i in range(len(t_configs)):
            if t_configs[i].type == 2:
                drop_indexes.append(
                    list(get_draw_index(player, t_configs, [], [], tp, t_configs[i].id)))
                break
    return drop_indexes


def get_draw_assets(player, drop_indexes, assets):
    # 获取抽卡assets

    for i in range(len(drop_indexes)):
        t_drop = config.Config.instance().t_drop.get(drop_indexes[i][0])
        drop = t_drop.assets[drop_indexes[i][1]]
        assets = player_data.add_assets(player, drop.type, drop.value1, drop.value2,
                                        drop.value3, assets=assets, merge=False)
    return assets
