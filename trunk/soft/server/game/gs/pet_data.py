from common import guid_tool
from common.proto.pet_db_pb2 import *
from pgame.service import PGame
from common.db import db_gtool
import config
import random


def pet_assets(player, tp, value1, value2):
    if tp == 1:
        pet = get_pet(player, value1)
        if pet is not None:
            pet_add_exp(pet, value2)


def create_pet(player, template_id):
    if template_id in player.pet_ids:
        return None
    guid = db_gtool.DbGtool.instance().assign(guid_tool.et['pet'])
    pet = pet_t()
    pet.guid = guid
    pet.player_guid = player.guid
    pet.level = 1
    pet.exp = 0
    pet.template_id = template_id
    pet.enhance = 0
    player.new(pet, 'pets')
    player.pet_ids.append(template_id)
    player.pet_unlocks.append(0)
    return pet


def get_pet(player, pet_id):
    for guid in player.pets.keys():
        if pet_id == player.pets[guid].template_id:
            return player.pets[guid]
    return None


def pet_add_exp(pet, exp):
    pet.exp += exp
    pet_upgrade(pet)


def pet_upgrade(pet):
    while True:
        t_level = config.Config.instance().t_level.get(pet.level+1)
        t_pet_enhance = config.Config.instance().t_pet_enhance.get(pet.enhance + 1)
        if t_pet_enhance is not None:
            if pet.level >= t_pet_enhance.level:
                pet.level = t_pet_enhance.level
                pet.exp = 0
                return

        if t_level is None:
            pet.exp = 0
            return

        if pet.exp >= t_level.pet_exp:
            pet.level += 1
            pet.exp -= t_level.pet_exp
        else:
            return
