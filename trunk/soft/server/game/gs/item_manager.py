from pgame.service import PGame
from pgame.dispatcher import reg_handle
from common.opcodes import Opcodes, Errors
from common.proto.item_msg_pb2 import *
from common.proto.common_msg_pb2 import *
import config, channel, player_data, gs_message, pet_data, player_operation
from pgame.utils import proto_utils
import math
import tools
import random


# 物品出售
@reg_handle(Opcodes.CMSG_ITEM_SELL)
def deal_cmsg_item_sell(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_item_sell()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 解包
    item_ids = msg.item_ids
    item_nums = msg.item_nums
    for i in range(len(item_ids)):
        t_item = config.Config.instance().t_item.get(item_ids[i])
        if t_item is None:
            gs_message.global_error(cif.guid)
            return
        num = player_data.get_item_num(player, item_ids[i])
        if num < item_nums[i] or item_nums[i] <= 0:
            gs_message.global_error(cif.guid)
            return

    for i in range(len(item_ids)):
        player_data.remove_item(player, item_ids[i], item_nums[i])
        t_item = config.Config.instance().t_item.get(item_ids[i])
        player_data.add_resource(player, 1, item_nums[i] * t_item.sell)

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_ITEM_SELL)


# 装备分解
@reg_handle(Opcodes.CMSG_EQUIP_DECOMPOSE)
def deal_cmsg_equip_decompose(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return
    
    msg = cmsg_equip_decompose()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 解包
    equip_guids = msg.equip_guids
    for i in range(len(equip_guids)):
        if equip_guids[i] not in player.equips.keys():
            gs_message.global_error(cif.guid)
            return
        equip = player.equips[equip_guids[i]]

        t_equip = config.Config.instance().t_equip.get(equip.template_id)
        if t_equip is None:
            gs_message.global_error(cif.guid)
            return

    for i in range(len(equip_guids)):
        # 获得资源
        equip = player.equips[equip_guids[i]]
        t_equip = config.Config.instance().t_equip.get(equip.template_id)
        t_equip_discompose = config.Config.instance().t_equip_discompose.get(equip.color)
        if t_equip_discompose is not None:
            player_data.add_assets(player, 2, t_equip_discompose.item, t_equip.fitem_num, 0)
        player_data.add_resource(player, 1, t_equip.fprice)

        # 删除装备
        player_data.remove_equip(player, equip.guid)
    
    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_EQUIP_DECOMPOSE)


# 装备穿戴
@reg_handle(Opcodes.CMSG_EQUIP_WEAR)
def deal_cmsg_equip_wear(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_equip_wear()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    equip_guid = msg.equip_guid
    if equip_guid not in player.equips.keys():
        gs_message.global_error(cif.guid)
        return
    equip = player.equips[equip_guid]
    
    t_equip = config.Config.instance().t_equip.get(equip.template_id)
    if t_equip is None:
        gs_message.global_error(cif.guid)
        return

    if player.level < t_equip.min_level:
        gs_message.send_smsg_error(player.guid, Errors.ERROR_EQUIP_LEVEL)
        return

    slot = t_equip.type - 1
    if player.equip_slots[slot] == equip.guid:
        player.equip_slots[slot] = 0
    else:
        player.equip_slots[slot] = equip.guid

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_EQUIP_WEAR)


# 装备图鉴穿戴
@reg_handle(Opcodes.CMSG_EQUIP_SHOW_WEAR)
def deal_cmsg_equip_show_wear(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_equip_show_wear()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    equip_template_id = msg.equip_template_id
    if equip_template_id not in player.equip_dresses:
        gs_message.global_error(cif.guid)
        return

    t_equip = config.Config.instance().t_equip.get(equip_template_id)
    if t_equip is None:
        gs_message.global_error(cif.guid)
        return

    slot = t_equip.type - 1
    if player.equip_shows[slot] == equip_template_id:
        player.equip_shows[slot] = 0
    else:
        player.equip_shows[slot] = equip_template_id

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_EQUIP_SHOW_WEAR)


# 装备强化
@reg_handle(Opcodes.CMSG_EQUIP_ENHANCE)
def deal_cmsg_equip_enhance(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_equip_enhance()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    equip_guid = msg.equip_guid

    slot = -1
    for i in range(len(player.equip_enhances)):
        if player.equip_slots[i] == equip_guid:
            slot = i
    if slot == -1:
        gs_message.global_error(player.guid)
        return

    equip = player.equips[equip_guid]
    if equip is None:
        gs_message.global_error(player.guid)
        return

    t_equip = config.Config.instance().t_equip.get(equip.template_id)
    if t_equip is None:
        gs_message.global_error(player.guid)
        return

    if t_equip.enhance_limit <= player.equip_enhances[slot]:
        gs_message.global_error(player.guid)
        return

    t_equip_enhance = config.Config().instance().t_equip_enhance.get(player.equip_enhances[slot] + 1)
    if t_equip_enhance is None:
        gs_message.global_error(cif.guid)
        return

    num = player_data.get_item_num(player, t_equip_enhance.item_id)
    if num < t_equip_enhance.item_num:
        gs_message.global_error(cif.guid)
        return

    if player.gold < t_equip_enhance.gold:
        gs_message.global_error(cif.guid)
        return

    if random.randint(0, 99) > t_equip_enhance.prob:
        player.equip_enhances[slot] -= t_equip_enhance.fail
        result = False
    else:
        result = True
        player.equip_enhances[slot] += 1

    player_data.remove_item(player, t_equip_enhance.item_id, t_equip_enhance.item_num)
    player_data.add_resource(player, 1, -t_equip_enhance.gold)

    gs_message.send_smsg_equip_enhance(player.guid, result)


# 装备附魔
@reg_handle(Opcodes.CMSG_EQUIP_ENCHANT)
def deal_cmsg_equip_enchant(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return
    msg = cmsg_equip_enchant()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    equip_guid = msg.equip_guid
    if equip_guid not in player.equips.keys():
        gs_message.global_error(cif.guid)
        return
    equip = player.equips[equip_guid]

    t_equip = config.Config().instance().t_equip.get(equip.template_id)
    if t_equip is None:
        gs_message.global_error(cif.guid)
        return
    
    t_equip_enchants = config.Config().instance().t_equip_enchant.get()
    if t_equip_enchants is None:
        gs_message.global_error(cif.guid)
        return
    tp = msg.type
    if tp < 1 or tp > 2:
        gs_message.global_error(cif.guid)
        return

    price_increase = config.Config().instance().const('equip_enchant_price_increase')
    price_crystal = config.Config().instance().const('equip_enchant_price_crystal')
    price_increase = float(price_increase) / 100 + 1
    equip_gold = tools.to_int(t_equip.fprice * math.pow(price_increase, equip.enchant_count))
    if msg.type == 1:
        if equip_gold > player.gold:
            gs_message.global_error(cif.guid)
            return
    elif msg.type == 2:
        if price_crystal > player.jewel:
            gs_message.global_error(cif.guid)
            return

    seq = []
    for i in range(len(t_equip_enchants)):
        t_equip_enchant = t_equip_enchants[i]
        seq.append([t_equip_enchant.id, t_equip_enchant.weight])
    enchant_id = tools.randseq(seq)
    equip.enchant_id = enchant_id
    t_equip_enchant = config.Config.instance().t_equip_enchant.get(equip.enchant_id)
    t_attr = config.Config.instance().t_attr.get(t_equip_enchant.attr)
    t_level = config.Config.instance().t_level.get(equip.level)
    value = t_equip.value * t_level.std_attr * t_equip_enchant.power / 1000000 * t_attr.value
    equip.enchant_value = player_data.get_equip_color_value(value, equip.color)

    if msg.type == 1:
        player_data.add_resource(player, 1, -equip_gold)
        equip.enchant_count += 1
    elif msg.type == 2:
        player_data.add_resource(player, 2, -price_crystal)

    # 每日任务
    player_data.daily_schedule(player, 1008, 1)

    gs_message.send_smsg_equip_enchant(player.guid, enchant_id, equip.enchant_value)


# 装备重铸
@reg_handle(Opcodes.CMSG_EQUIP_REFORGE)
def deal_cmsg_equip_reforge(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_equip_reforge()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    equip_guid = msg.equip_guid
    color = msg.color
    if equip_guid not in player.equips.keys():
        gs_message.global_error(cif.guid)
        return

    equip = player.equips[equip_guid]

    if color > equip.color:
        gs_message.global_error(cif.guid)
        return

    t_equip = config.Config().instance().t_equip.get(equip.template_id)
    if t_equip is None:
        gs_message.global_error(cif.guid)
        return

    if color <= 1 or color > 5:
        gs_message.global_error(cif.guid)
        return

    t_equip_discompose = config.Config.instance().t_equip_discompose.get(color)
    if t_equip_discompose is None:
        gs_message.global_error(cif.guid)
        return

    if player_data.get_item_num(player, t_equip_discompose.item) < t_equip.cz_item_num:
        gs_message.global_error(cif.guid)
        return

    player_data.remove_item(player, t_equip_discompose.item, t_equip.cz_item_num)

    player_data.reforge_equip(equip, color)

    gs_message.send_smsg_equip_reforge(player.guid, equip)


# 打造
@reg_handle(Opcodes.CMSG_FORGE)
def deal_cmsg_forge(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_forge()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    forge_id = msg.forge_id
    forge_num = msg.forge_num
    t_forge = config.Config.instance().t_forge.get(forge_id)
    if t_forge is None:
        gs_message.global_error(cif.guid)
        return

    if player.gold < t_forge.gold * forge_num:
        gs_message.global_error(cif.guid)
        return

    for i in range(len(t_forge.mat)):
        if t_forge.mat[i].type == 2:
            num = player_data.get_item_num(player, t_forge.mat[i].value1)
        elif t_forge.mat[i].type == 5:
            num = player_data.get_rune_num(player, t_forge.mat[i].value1)
        else:
            num = 0
        if num < t_forge.mat[i].value2 * forge_num:
            gs_message.global_error(cif.guid)
            return

    if t_forge.type == 3:
        max_equip_bag = config.Config().instance().const('max_equip_bag')
        equip_num = len(player.equips)
        for i in range(len(player.equip_slots)):
            if player.equip_slots[i] > 0:
                equip_num -= 1
        if equip_num >= max_equip_bag:
            gs_message.global_error(cif.guid)
            return

    player_data.add_resource(player, 1, -t_forge.gold * forge_num)
    for i in range(len(t_forge.mat)):
        if t_forge.mat[i].type == 2:
            player_data.remove_item(player, t_forge.mat[i].value1, t_forge.mat[i].value2 * forge_num)
        elif t_forge.mat[i].type == 5:
            player_data.remove_rune(player, t_forge.mat[i].value1, t_forge.mat[i].value2 * forge_num)

    assets = player_data.add_assets(player, t_forge.type, t_forge.value1, t_forge.value2 * forge_num, t_forge.value3)

    # 每日任务
    player_data.daily_schedule(player, 1007, 1)

    gs_message.send_smsg_forge(player.guid, assets)


# 宝石镶嵌
@reg_handle(Opcodes.CMSG_RUNE_WEAR)
def deal_cmsg_rune_wear(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_rune_wear()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # tp: 1 装上 2 卸下 3 更换
    tp = msg.type
    slot = msg.slot - 1
    rune_slot = msg.rune_slot - 1
    rune_id = msg.rune_id

    if slot < 0 or slot >= 8:
        gs_message.global_error(cif.guid)
        return

    if rune_slot < 0 or rune_slot >= 3:
        gs_message.global_error(cif.guid)
        return

    if player.equip_slots[slot] == 0:
        gs_message.global_error(cif.guid)
        return

    t_rune = config.Config.instance().t_rune.get(rune_id)
    if t_rune is None:
        gs_message.global_error(cif.guid)
        return

    rune_slots = list()     # 取玩家的宝石槽
    rune_slots.append(player.rune_slot1s)
    rune_slots.append(player.rune_slot2s)
    rune_slots.append(player.rune_slot3s)

    if tp == 1 or tp == 3:
        runes = list()          # 取玩家宝石槽里的宝石
        for i in range(len(rune_slots)):
            rune = config.Config.instance().t_rune.get(rune_slots[i][slot])
            if rune is None:
                rune = 0
            runes.append(rune)

        for i in range(len(runes)):
            if runes[i] != 0 and i != rune_slot:
                if t_rune.type == runes[i].type:
                    gs_message.global_error(cif.guid)
                    return

        num = player_data.get_rune_num(player, rune_id)
        if num == 0:
            gs_message.global_error(cif.guid)
            return

    if tp == 1:
        rune_slots[rune_slot][slot] = rune_id
        player_data.remove_rune(player, rune_id, 1)
    elif tp == 2:
        player_data.add_rune(player, rune_slots[rune_slot][slot], 1)
        rune_slots[rune_slot][slot] = 0
    elif tp == 3:
        player_data.add_rune(player, rune_slots[rune_slot][slot], 1)
        player_data.remove_rune(player, rune_id, 1)
        rune_slots[rune_slot][slot] = rune_id

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_RUNE_WEAR)


# 技能获取
@reg_handle(Opcodes.CMSG_SPELL_GET)
def deal_cmsg_spell_get(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_spell_get()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    spell_id = msg.spell_id

    if spell_id in player.spell_ids:
        gs_message.global_error(cif.guid)
        return

    t_spell = config.Config.instance().t_spell.get(spell_id)
    if t_spell is None:
        gs_message.global_error(cif.guid)
        return

    if player.level < t_spell.unlock_level:
        gs_message.global_error(cif.guid)
        return
    player.spell_ids.append(spell_id)
    player.spell_levels.append(1)

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_SPELL_GET)


# 技能升级
@reg_handle(Opcodes.CMSG_SPELL_UPGRADE)
def deal_cmsg_spell_upgrade(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_spell_upgrade()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    spell_id = msg.spell_id

    t_spell = config.Config.instance().t_spell.get(spell_id)
    if t_spell is None:
        gs_message.global_error(player.guid)
        return

    if spell_id not in player.spell_ids:
        gs_message.global_error(player.guid)
        return

    index = 0
    for i in range(len(player.spell_ids)):
        if player.spell_ids[i] == spell_id:
            index = i
            break

    t_spell_levels = config.Config.instance().t_spell_level.get()
    if len(t_spell_levels) < player.spell_levels[index] + 1:
        gs_message.global_error(player.guid)
        return

    t_spell_level = config.Config.instance().t_spell_level.get(player.spell_levels[index] + 1)
    if t_spell_level is None:
        gs_message.global_error(player.guid)
        return

    spell_item = config.Config.instance().const('spell_item')
    if player_data.get_item_num(player, spell_item) < t_spell_level.num:
        gs_message.global_error(player.guid)
        return

    player_data.remove_item(player, spell_item, t_spell_level.num)
    player.spell_levels[index] += 1

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_SPELL_UPGRADE)


# 附能获取
@reg_handle(Opcodes.CMSG_SPELL_PASSIVE_GET)
def deal_cmsg_spell_passive_get(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_spell_passive_get()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    spell_passive_id = msg.spell_passive_id

    if spell_passive_id in player.spell_passive_ids:
        gs_message.global_error(cif.guid)
        return

    t_spell_passive = config.Config.instance().t_spell_passive.get(spell_passive_id)
    if t_spell_passive is None:
        gs_message.global_error(cif.guid)
        return

    spell_passive = config.Config.instance().t_spell_passive.get()
    next_spell = None
    for i in range(len(spell_passive)):
        if spell_passive[i].next_spell == spell_passive_id:
            next_spell = spell_passive[i]
            break

    for i in range(len(t_spell_passive.unlock)):
        if t_spell_passive.unlock[i].param1 != 0:
            pet = pet_data.get_pet(player, t_spell_passive.unlock[i].param1)
            if pet is None:
                gs_message.global_error(cif.guid)
                return

            if pet.level < t_spell_passive.unlock[i].param2:
                gs_message.global_error(cif.guid)
                return

    if next_spell is not None and next_spell.id in player.spell_passive_ids:
        for i in range(len(player.spell_passive_ids)):
            if player.spell_passive_ids[i] == next_spell.id:
                player.spell_passive_ids[i] = spell_passive_id
    else:
        player.spell_passive_ids.append(spell_passive_id)

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_SPELL_PASSIVE_GET)


#  附能装备
@reg_handle(Opcodes.CMSG_SPELL_PASSIVE_WEAR)
def deal_cmsg_spell_passive_wear(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_spell_passive_wear()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    spell_passive_id = msg.spell_passive_id
    slot = msg.slot - 1

    if spell_passive_id not in player.spell_passive_ids:
        gs_message.global_error(cif.guid)
        return

    t_spell_passive = config.Config.instance().t_spell_passive.get(spell_passive_id)
    if t_spell_passive is None:
        gs_message.global_error(cif.guid)
        return

    if slot < 0 or slot >= 3:
        gs_message.global_error(cif.guid)
        return

    if player.spell_passive_slots[slot] == spell_passive_id:
        player.spell_passive_slots[slot] = 0
    else:
        for i in range(len(player.spell_passive_slots)):
            if player.spell_passive_slots[i] == spell_passive_id:
                player.spell_passive_slots[i] = 0
                break
        player.spell_passive_slots[slot] = spell_passive_id

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_SPELL_PASSIVE_WEAR)


# 抽卡
@reg_handle(Opcodes.CMSG_DRAW_CARD)
def deal_cmsg_draw_card(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_draw_card()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    tp = msg.type
    asset_type = msg.asset_type
    num = msg.num

    if tp != 3 and tp != 5 and tp != 6:
        gs_message.global_error(player.guid)
        return

    if asset_type != 1 and asset_type != 2:
        gs_message.global_error(player.guid)
        return

    if num != 1 and num != 10:
        gs_message.global_error(player.guid)
        return

    assets = msg_assets()

    if tp == 3:
        # 装备抽卡
        t_equip_draw = config.Config.instance().t_equip_draw.get(player.map)
        if t_equip_draw is None:
            gs_message.global_error(player.guid)
            return

        if num == 1:
            equip_draw_crystal = t_equip_draw.jewel
            item_num = t_equip_draw.item
        else:
            equip_draw_crystal = t_equip_draw.jewel10
            item_num = t_equip_draw.item10
        equip_draw_item = config.Config.instance().const('equip_draw_item')
        if asset_type == 1:
            if player_data.get_resource_num(player, 2) < equip_draw_crystal:
                gs_message.global_error(player.guid)
                return
        else:
            if player_data.get_item_num(player, equip_draw_item) < item_num * num:
                gs_message.global_error(player.guid)
                return

        drop_indexes = list()
        for i in range(num):
            drop_indexes.append(list(player_operation.get_draw_index(player, t_equip_draw.drop, [], [], tp)))

        if num == 10:
            drop_indexes = player_operation.draw_ten_check(player, tp, t_equip_draw.drop, drop_indexes)

        assets = player_operation.get_draw_assets(player, drop_indexes, assets)

        if asset_type == 1:
            player_data.add_resource(player, 2, -equip_draw_crystal)
        else:
            player_data.remove_item(player, equip_draw_item, item_num * num)

    elif tp == 5:
        # 宝石抽卡

        if num == 1:
            rune_draw_crystal = config.Config.instance().const('rune_draw_crystal')
        else:
            rune_draw_crystal = config.Config.instance().const('rune_draw_crystal_10')
        rune_draw_item = config.Config.instance().const('rune_draw_item')

        if asset_type == 1:
            if player_data.get_resource_num(player, 2) < rune_draw_crystal:
                gs_message.global_error(player.guid)
                return
        else:
            if player_data.get_item_num(player, rune_draw_item) < num:
                gs_message.global_error(player.guid)
                return

        # 抽卡
        t_rune_draws = config.Config.instance().t_rune_draw.get()
        drop_indexes = list()
        for i in range(num):
            drop_indexes.append(list(player_operation.get_draw_index(player, t_rune_draws, [], [], tp)))

        if num == 10:
            drop_indexes = player_operation.draw_ten_check(player, tp, t_rune_draws, drop_indexes)

        assets = player_operation.get_draw_assets(player, drop_indexes, assets)

        if asset_type == 1:
            player_data.add_resource(player, 2, -rune_draw_crystal)
        else:
            player_data.remove_item(player, rune_draw_item, num)

    elif tp == 6:
        # 宠物抽卡

        if num == 1:
            pet_draw_crystal = config.Config.instance().const('pet_draw_crystal')
        else:
            pet_draw_crystal = config.Config.instance().const('pet_draw_crystal_10')
        pet_draw_item = config.Config.instance().const('pet_draw_item')

        if asset_type == 1:
            if player_data.get_resource_num(player, 2) < pet_draw_crystal:
                gs_message.global_error(player.guid)
                return
        else:
            if player_data.get_item_num(player, pet_draw_item) < num:
                gs_message.global_error(player.guid)
                return

        # 抽卡
        t_pet_draws = config.Config.instance().t_pet_draw.get()
        drop_indexes = list()
        for i in range(num):
            drop_indexes.append(list(player_operation.get_draw_index(player, t_pet_draws, [], [], tp)))

        if num == 10:
            drop_indexes = player_operation.draw_ten_check(player, tp, t_pet_draws, drop_indexes)

        assets = player_operation.get_draw_assets(player, drop_indexes, assets)

        if asset_type == 1:
            player_data.add_resource(player, 2, -pet_draw_crystal)
        else:
            player_data.remove_item(player, pet_draw_item, num)

    gs_message.send_smsg_draw_card(player.guid, assets)


# 图鉴解锁
@reg_handle(Opcodes.CMSG_DRAWS_UNLOCK)
def deal_cmsg_draws_unlock(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_draws_unlock()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    tp = msg.type
    draw_id = msg.draw_id
    if tp < 1 or tp > 4:
        gs_message.global_error(player.guid)
        return

    if tp == 1:
        t_pet = config.Config.instance().t_pet.get(draw_id)
        if t_pet is None:
            gs_message.global_error(player.guid)
            return

        index = player_data.get_index(player.pet_ids, draw_id)
        if index is None:
            gs_message.global_error(player.guid)
            return

        if player.pet_unlocks[index] != 0:
            gs_message.global_error(player.guid)
            return

        player.pet_unlocks[index] = 1
        player_data.add_resource(player, 5, t_pet.reputation)

    elif tp == 2:
        t_mission = config.Config.instance().t_mission.get(draw_id)
        t_monster = config.Config.instance().t_monster.get(t_mission.monsterid)
        t_role = config.Config.instance().t_role.get(t_monster.role_id)
        if t_role is None:
            gs_message.global_error(player.guid)
            return

        t_role_reputation = config.Config.instance().t_role_reputation.get(t_role.reputation)
        if t_role_reputation is None:
            gs_message.global_error(player.guid)
            return
        
        param = msg.param
        if param < 0 or param > len(t_role_reputation.kill) - 1:
            gs_message.global_error(player.guid)
            return

        index = player_data.get_index(player.monsters, draw_id)
        if index is None:
            gs_message.global_error(player.guid)
            return

        if t_role_reputation.kill[param].num > player.monster_nums[index]:
            gs_message.global_error(player.guid)
            return

        if player.monster_unlocks[index] != param:
            gs_message.global_error(player.guid)
            return

        player.monster_unlocks[index] += 1

        player_data.add_resource(player, 5, t_role_reputation.kill[param].reputation)

    elif tp == 3:
        t_equip = config.Config.instance().t_equip.get(draw_id)
        if t_equip is None:
            gs_message.global_error(player.guid)
            return

        index = player_data.get_index(player.equip_dresses, draw_id)
        if index is None:
            gs_message.global_error(player.guid)
            return

        if player.equip_dresses_unlock[index] != 0:
            gs_message.global_error(player.guid)
            return

        player.equip_dresses_unlock[index] = 1
        player_data.add_resource(player, 5, t_equip.reputation)

    elif tp == 4:
        t_artifact = config.Config.instance().t_artifact.get(draw_id)
        if t_artifact is None:
            gs_message.global_error(player.guid)
            return

        index = player_data.get_index(player.artifact_ids, draw_id)
        if index is None:
            gs_message.global_error(player.guid)
            return

        param = msg.param
        if param < 1 or param > 2:
            gs_message.global_error(player.guid)
            return

        if param == 1:
            if player.artifact_unlocks[index] != 0:
                gs_message.global_error(player.guid)
                return

            if player.artifact_nums[index] != 0:
                gs_message.global_error(player.guid)
                return

            player.artifact_unlocks[index] = 1
            player_data.add_resource(player, 5, t_artifact.unlock_reputation)
        elif param == 2:
            if player.artifact_unlocks[index] != 1:
                gs_message.global_error(player.guid)
                return

            if player.artifact_nums[index] != 1:
                gs_message.global_error(player.guid)
                return

            player.artifact_unlocks[index] = 2
            player_data.add_resource(player, 5, t_artifact.has_reputation)

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_DRAWS_UNLOCK)
