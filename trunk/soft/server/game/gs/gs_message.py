from pgame.service import PGame
from pgame.utils.packet import RpcPacket
from common.opcodes import Opcodes, Errors
from common.proto.arena_msg_pb2 import *
from common.proto.center_msg_pb2 import *
from common.proto.player_msg_pb2 import *
from common.proto.item_msg_pb2 import *
from common.proto.mission_msg_pb2 import *
from common.proto.arena_msg_pb2 import *
from common.proto.promotion_msg_pb2 import *
import channel, tools
import sys, random
import player_data


def send_sys_kick(guid):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return
    pck = RpcPacket(Opcodes.SYS_KICK, cif.hid)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_center_enter_server():
    msg = smsg_center_enter_server()
    msg.server_id = PGame.env.get_setting_value('qid')
    msg = msg.SerializeToString()
    pck = RpcPacket(opcode=Opcodes.SMSG_CENTER_ENTER_SERVER, msg=msg)
    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = gs")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck.set_addr(addr)
    host = PGame.env.get_server_value('center', 'host')
    port = PGame.env.get_server_value('center', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = center")
        return
    addr = "tcp://" + host + ":" + str(port)

    PGame.pipe.push(pck, addr=addr)


def send_smsg_center_heart_beat():
    msg = smsg_center_heart_beat()
    msg.server_id = PGame.env.get_setting_value('qid')
    msg = msg.SerializeToString()
    host = PGame.env.get_server_value('center', 'host')
    port = PGame.env.get_server_value('center', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = center")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck = RpcPacket(opcode=Opcodes.SMSG_CENTER_HEART_BEAT, msg=msg)
    PGame.pipe.push(pck, addr=addr)


def send_smsg_login_player(guid, player):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    code = random.randint(0, 999999)
    tools.LRandom.instance().player_codes[player.guid] = code

    msg = smsg_login_player()
    time_now = PGame.timer.now()
    msg.time_now = time_now
    msg.player.CopyFrom(player.obj)
    for guid in player.equips.keys():
        equip = player.equips[guid]
        msg.equips.add().CopyFrom(equip.obj)
    for guid in player.pets.keys():
        pet = player.pets[guid]
        msg.pets.add().CopyFrom(pet.obj)
    msg.code = code
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_LOGIN_PLAYER, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_reconnection(guid, player):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_reconnection()
    time_now = PGame.timer.now()
    msg.time_now = time_now
    msg.player.CopyFrom(player.obj)
    for guid in player.equips.keys():
        equip = player.equips[guid]
        msg.equips.add().CopyFrom(equip.obj)
    for guid in player.pets.keys():
        pet = player.pets[guid]
        msg.pets.add().CopyFrom(pet.obj)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_RECONNECTION, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mineral(guid, time, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mineral()
    msg.time = time
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MINERAL, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mission(guid, time, seed, count, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mission()
    msg.time = time
    msg.seed = seed
    for i in range(len(count)):
        msg.count.append(count[i])
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MISSION, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_success(guid, opcode):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    pck = RpcPacket(opcode, cif.hid)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_error(guid, code, text=None):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_error()
    msg.code = code
    if text is not None:
        msg.text = text
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_ERROR, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_login_error(hid, addr, code, text=None):
    msg = smsg_error()
    msg.code = code
    if text is not None:
        msg.text = text
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_ERROR, hid, msg)
    PGame.pipe.push(pck, addr=addr)


def send_smsg_reconnection_error(hid, addr, code, text=None):
    msg = smsg_error()
    msg.code = code
    if text is not None:
        msg.text = text
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_ERROR, hid, msg)
    PGame.pipe.push(pck, addr=addr)


def global_error(guid):
    frame = sys._getframe()
    if frame is None:
        return
    back = frame.f_back
    if back is None:
        return
    code = back.f_code
    if code is None:
        return
    fname = code.co_filename
    line = back.f_lineno
    rname = sys.argv[0]
    for i in range(2):
        index = rname.rfind("/")
        if index != -1:
            rname = rname[:index]
    if len(rname) + 1 <= len(fname):
        fname = fname[len(rname) + 1:]
    text = fname + ' ==> line:' + str(line)
    send_smsg_error(guid, Errors.ERROR_GLOBAL, text)


def send_smsg_gm_command(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_gm_command()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_GM_COMMAND, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_refresh_player(guid, refresh_time, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_refresh_player()
    msg.refresh_time = refresh_time
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_REFRESH_PLAYER, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_check_data(guid, check_data):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_check_data()
    msg.check_data = check_data
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_CHECK_DATA, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_libao_exchange(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_libao_exchange()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_LIBAO_EXCHANGE, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_equip_enhance(guid, result):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_equip_enhance()
    msg.result = result

    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_EQUIP_ENHANCE, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_equip_enchant(guid, enchant_id, enchant_value):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_equip_enchant()
    msg.enchant_id = enchant_id
    msg.enchant_value = enchant_value
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_EQUIP_ENCHANT, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_equip_reforge(guid, equip):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_equip_reforge()
    msg.equip.CopyFrom(equip.obj)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_EQUIP_REFORGE, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_forge(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_forge()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_FORGE, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_checked(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_check()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_CHECK, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_shop_buy(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_shop_buy()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_SHOP_BUY, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mail_list(guid, mails):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mail_list()
    for i in range(len(mails)):
        msg.mails.add().CopyFrom(mails[i])
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MAIL_LIST, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mail_get(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mail_get()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MAIL_GET, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_pet_get(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_pet_get()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_PET_GET, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_draw_card(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_draw_card()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_DRAW_CARD, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_dungeon(guid, dungeon_event):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_dungeon()
    msg.dungeon_event = dungeon_event
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_DUNGEON, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_dungeon_event(guid, seed, event, assets, dungeon_assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_dungeon_event()
    msg.seed = seed
    msg.event = event
    msg.assets = assets
    msg.dungeon_assets = dungeon_assets
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_DUNGEON_EVENT, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_tower(guid, seed, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_tower()
    msg.seed = seed
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_TOWER, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_tower_sweep(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_tower_sweep()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_TOWER_SWEEP, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mission_ex(guid, time, seed, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mission_ex()
    msg.time = time
    msg.seed = seed
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MISSION_EX, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mission_ex_meet(guid, mission_ex_time):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_mission_ex_meet()
    msg.mission_ex_time = mission_ex_time
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_MISSION_EX_MEET, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_mail_update(guid):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    pck = RpcPacket(Opcodes.SMSG_MAIL_UPDATE, cif.hid)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_rank_get(guid, rank):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_rank_get()
    if rank is not None:
        msg.rank.CopyFrom(rank.obj)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_RANK_GET, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_change_player_name(guid, res):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_change_player_name()
    msg.res = res
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_PLAYER_CHANGE_NAME, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_change_player_icon(guid, res):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_change_player_icon()
    msg.res = res
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_PLAYER_CHANGE_ICON, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_view_player_cn(hid, addr, msg):
    pck = RpcPacket(Opcodes.SMSG_VIEW_PLAYER_ASK, hid, msg)
    pck.set_addr(addr)
    PGame.pipe.push(pck, sname="center")


def send_smsg_view_player_inquire(hid, addr, msg):
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_VIEW_PLAYER_INQUIRE, hid, msg)
    pck.set_addr(addr)
    PGame.pipe.push(pck, "center")


def send_smsg_view_player(guid, msg):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    pck = RpcPacket(Opcodes.SMSG_VIEW_PLAYER, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_task_end(guid, map_id, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_task_end()
    msg.map_id = map_id
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_TASK_END, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_daily_draw(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_daily_draw()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_DAILY_DRAW, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_daily_reward_draw(guid, assets):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_daily_reward_draw()
    if assets is not None:
        msg.assets.CopyFrom(assets)
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_DAILY_REWARD_DRAW, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_arena_room_inquire(player, hid):
    msg = smsg_arena_room_inquire()
    msg.arena_room_guid = player.arena_room
    msg.arena_segment = player.arena_segment
    msg.player_guid = player.guid
    msg.player_name = player.name
    msg.player_level = player.level
    msg.player_avatar = player.avatar
    msg.player_power = player_data.get_fight_power(player)

    msg = msg.SerializeToString()
    pck = RpcPacket(opcode=Opcodes.SMSG_ARENA_ROOM_INQUIRE, hid=hid, msg=msg)
    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = gs")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck.set_addr(addr)

    host = PGame.env.get_server_value('arena', 'host')
    port = PGame.env.get_server_value('arena', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = arena")
        return
    addr = "tcp://" + host + ":" + str(port)
    print(3)
    PGame.pipe.push(pck, addr=addr)


def send_smsg_arena_room(guid, msg):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return
    print(4)

    pck = RpcPacket(Opcodes.SMSG_ARENA_ROOM, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_arena_fight_init_ask(hid, msg):
    pck = RpcPacket(opcode=Opcodes.SMSG_ARENA_FIGHT_INIT_ASK, hid=hid, msg=msg)
    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = gs")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck.set_addr(addr)

    host = PGame.env.get_server_value('arena', 'host')
    port = PGame.env.get_server_value('arena', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = arena")
        return
    addr = "tcp://" + host + ":" + str(port)

    PGame.pipe.push(pck, addr=addr)


def send_smsg_arena_fight_init_inquire(hid, addr, msg):

    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_ARENA_FIGHT_INIT_INQUIRE, hid=hid, msg=msg)
    pck.set_addr(addr)
    host = PGame.env.get_server_value('arena', 'host')
    port = PGame.env.get_server_value('arena', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = arena")
        return
    addr = "tcp://" + host + ":" + str(port)
    PGame.pipe.push(pck, addr=addr)


def send_smsg_arena_fight_init(guid, msg):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    pck = RpcPacket(Opcodes.SMSG_ARENA_FIGHT_INIT, hid=cif.hid, msg=msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_arena_fight_report(hid, win, player, gag_player_guid):
    msg = smsg_arena_fight_report()
    msg.arena_room_guid = player.arena_room
    msg.player_guid = player.guid
    msg.gag_player_guid = gag_player_guid
    msg.win = win
    msg = msg.SerializeToString()

    pck = RpcPacket(opcode=Opcodes.SMSG_ARENA_FIGHT_REPORT, hid=hid, msg=msg)
    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = gs")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck.set_addr(addr)

    host = PGame.env.get_server_value('arena', 'host')
    port = PGame.env.get_server_value('arena', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = arena")
        return
    addr = "tcp://" + host + ":" + str(port)

    PGame.pipe.push(pck, addr=addr)


def send_smsg_arena_fight(guid, seed, arena_integral, arena_win, arena_num):
    cif = channel.Channel.instance().get_cif(guid)
    if cif is None:
        return

    msg = smsg_arena_fight()
    msg.seed = seed
    msg.arena_integral = arena_integral
    msg.arena_win = arena_win
    msg.arena_num = arena_num
    msg = msg.SerializeToString()
    pck = RpcPacket(Opcodes.SMSG_ARENA_FIGHT, cif.hid, msg)
    PGame.pipe.push(pck, addr=cif.addr)


def send_smsg_arena_list_registered(player):
    cif = channel.Channel.instance().get_cif(player.guid)
    if cif is None:
        return

    msg = smsg_arena_list_registered()
    msg.player_guid = player.guid
    msg.player_level = player.level
    msg.player_icon = player.avatar
    msg.player_segment = player.arena_segment
    msg.player_power = player_data.get_fight_power(player)

    msg = msg.SerializeToString()

    pck = RpcPacket(opcode=Opcodes.SMSG_ARENA_LIST_REGISTERED, hid=cif.hid, msg=msg)
    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = gs")
        return

    addr = "tcp://" + host + ":" + str(port)
    pck.set_addr(addr)

    host = PGame.env.get_server_value('arena', 'host')
    port = PGame.env.get_server_value('arena', 'port')
    if host is None or port is None:
        PGame.log.error("make_addr error name = arena")
        return
    addr = "tcp://" + host + ":" + str(port)

    PGame.pipe.push(pck, addr=addr)
