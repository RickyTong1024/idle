from pgame.service import PGame
from common.opcodes import Opcodes
from common.proto.player_msg_pb2 import *
from common.proto.common_msg_pb2 import *
from pgame.utils import proto_utils
from pgame.dispatcher import reg_handle
import gs_message, channel, pet_data, config, player_data


# 宠物获取
@reg_handle(Opcodes.CMSG_PET_GET)
def deal_cmsg_pet_get(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_pet_get()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    pet_id = msg.pet_id
    t_pet = config.Config.instance().t_pet.get(pet_id)
    if t_pet is None:
        gs_message.global_error(cif.guid)
        return

    shard_num = player_data.get_item_num(player, t_pet.shard_id)
    if shard_num < t_pet.shard_num:
        gs_message.global_error(cif.guid)
        return

    for guid in player.pets.keys():
        if player.pets[guid].template_id == pet_id:
            gs_message.global_error(cif.guid)
            return

    player_data.remove_item(player, t_pet.shard_id, t_pet.shard_num)
    assets = msg_assets()
    assets = player_data.add_assets(player, 6, pet_id, 0, 0, assets)

    gs_message.send_smsg_pet_get(player.guid, assets)


# 宠物上阵
@reg_handle(Opcodes.CMSG_PET_ON)
def deal_cmsg_pet_on(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_pet_on()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    pet_guid = msg.pet_guid
    slot = msg.slot - 1

    if pet_guid not in player.pets.keys():
        gs_message.global_error(cif.guid)
        return

    if slot < 0 or slot >= 4:
        gs_message.global_error(cif.guid)
        return

    pet = player.pets[pet_guid]
    t_pet = config.Config.instance().t_pet.get(pet.template_id)
    if t_pet is None:
        gs_message.global_error(cif.guid)
        return

    # 上阵 下阵 更换
    for i in range(len(player.pet_slots)):
        if player.pet_slots[i] == pet_guid and i != slot:
            player.pet_slots[i] = 0
            break

    if player.pet_slots[slot] == pet_guid:
        player.pet_slots[slot] = 0
    else:
        player.pet_slots[slot] = pet_guid

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PET_ON)


# 宠物进阶
@reg_handle(Opcodes.CMSG_PET_ENHANCE)
def deal_cmsg_pet_enhance(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_pet_enhance()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    pet_guid = msg.pet_guid

    if pet_guid not in player.pets.keys():
        gs_message.global_error(cif.guid)
        return

    pet = player.pets[pet_guid]
    t_pet = config.Config.instance().t_pet.get(pet.template_id)
    if t_pet is None:
        gs_message.global_error(cif.guid)
        return

    t_pet_enhance = config.Config.instance().t_pet_enhance.get(pet.enhance + 1)
    if t_pet_enhance is None:   # 进阶到满或数据错误
        gs_message.global_error(cif.guid)
        return

    if pet.level < t_pet_enhance.level:
        gs_message.global_error(cif.guid)
        return

    shard_num = player_data.get_item_num(player, t_pet.shard_id)
    if shard_num < t_pet_enhance.shard:
        gs_message.global_error(cif.guid)
        return

    player_data.remove_item(player, t_pet.shard_id, t_pet_enhance.shard)
    player.pets[pet_guid].enhance += 1

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PET_ENHANCE)


# 宠物位置交换
@reg_handle(Opcodes.CMSG_PET_EXCHANGE)
def deal_cmsg_pet_enhance(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_pet_exchange()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    slots = msg.slots

    if len(slots) != 2:
        gs_message.global_error(cif.guid)
        return

    for i in range(len(slots)):
        if slots[i] <= 0 or slots[i] > 4:
            gs_message.global_error(cif.guid)
            return

    pet_guid = player.pet_slots[slots[0] - 1]
    player.pet_slots[slots[0] - 1] = player.pet_slots[slots[1] - 1]
    player.pet_slots[slots[1] - 1] = pet_guid

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PET_EXCHANGE)


# 宠物喂养
@reg_handle(Opcodes.CMSG_PET_FEED)
def deal_cmsg_pet_feed(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_pet_feed()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    pet_guid = msg.pet_guid
    if pet_guid not in player.pets.keys():
        gs_message.global_error(cif.guid)
        return

    if len(msg.pet_food_id) != len(msg.pet_food_num):
        gs_message.global_error(cif.guid)
        return

    pet_foods = list()
    pet_food_nums = list()
    for i in range(len(msg.pet_food_id)):
        pet_food_id = msg.pet_food_id[i]
        pet_food_num = msg.pet_food_num[i]
        if pet_food_num < 0:
            gs_message.global_error(cif.guid)
            return

        pet_food = config.Config.instance().t_item.get(pet_food_id)
        if pet_food is None:
            gs_message.global_error(cif.guid)
            return

        if player_data.get_item_num(player, pet_food_id) < pet_food_num:
            gs_message.global_error(cif.guid)
            return
        if pet_food_num != 0:
            pet_foods.append(pet_food)
            pet_food_nums.append(pet_food_num)

    pet = player.pets[pet_guid]

    for i in range(len(pet_foods)):
        player_data.remove_item(player, pet_foods[i].id, pet_food_nums[i])
        pet_data.pet_add_exp(pet, pet_foods[i].res[0].value * pet_food_nums[i])

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PET_FEED)
