from pgame.service import PGame
from pgame.request import Request
from pgame.dispatcher import reg_handle
from common.opcodes import Opcodes, Errors
from common.proto.player_msg_pb2 import *
from common.proto.center_msg_pb2 import *
from common.proto.common_msg_pb2 import *
from common.proto.rank_db_pb2 import *
from common import guid_tool
from common.db import db_gtool
import player_pool, player_data, gs_message, channel, db_player, mail_pool, tools
from pgame.utils import proto_utils
import config
import json


@reg_handle(Opcodes.CMSG_LOGIN_PLAYER)
def deal_cmsg_login_player(pck):
    msg = cmsg_login_player()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(pck.hid)
        return

    debug = PGame.env.get_setting_value('debug')
    if debug == 0:
        # 登录服 外部处理
        body = json.dumps({"token": msg.username, "password": msg.password})
        headers = {'Content-type': 'text/xml;charset=UTF-8'}
        host = PGame.env.get_server_value('account', 'host')
        port = PGame.env.get_server_value('account', 'port')
        url = 'http://' + host + ':' + str(port)
        PGame.http.post(url+'/check', headers, body, login_call_back, [pck.hid, pck.get_addr(), msg])
    else:
        login_acc(msg, pck.hid, pck.get_addr())


def login_call_back(response, extra):
    hid = extra[0]
    addr = extra[1]
    msg = extra[2]

    if response is None:
        gs_message.global_error(hid)
        return

    r = response.read()
    data = json.loads(r)
    errno = data['res']
    if errno != 0:
        gs_message.send_smsg_login_error(hid, addr, Errors.ERROR_LOGIN)
        return

    login_acc(msg, hid, addr)


def login_acc(msg, hid, addr):
    username = msg.username
    serverid = msg.serverid
    lang = msg.lang
    guid = db_gtool.DbGtool.instance().assign(guid_tool.et["player"])
    req = Request(Request.opc_query, [guid_tool.et["acc"], guid, username, serverid])
    req.add_extra(hid)
    req.add_extra(addr)
    req.add_callback(login_acc_callback)
    db_player.DbPlayer.instance().request(req)


def login_acc_callback(req):
    hid = req.extra[0]
    addr = req.extra[1]
    if req.res < 0 or len(req.datas) == 0:
        return
    guid = req.datas[0].guid
    username = req.datas[0].username
    if guid not in tools.LRandom.instance().player_username.keys():
        tools.LRandom.instance().player_username[guid] = username
    cif = channel.Channel.instance().get_info(hid)
    if cif is not None:
        # 需要通知账号在其他机器上登陆
        gs_message.send_sys_kick(guid)
        channel.Channel.instance().del_info(cif.hid)
    cif = channel.Channel.instance().add_info(hid, guid, addr)
    player = PGame.pool.get(guid)
    if player is None:
        player_pool.PlayerPool.instance().load_player(guid, cif.hid)
    else:
        player_data.client_login(player)
        gs_message.send_smsg_login_player(guid, player)


@reg_handle(Opcodes.CMSG_RECONNECTION)
def deal_cmsg_reconnection(pck):
    msg = cmsg_reconnection()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.send_smsg_reconnection_error(pck.hid, pck.get_addr(), Errors.ERROR_RECONNECTION)
        return

    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        cif = channel.Channel.instance().add_info(pck.hid, msg.player_guid, pck.get_addr())

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.send_smsg_error(cif.guid, Errors.ERROR_RECONNECTION)
        return

    if msg.player_guid in tools.LRandom.instance().player_codes.keys():
        code = tools.LRandom.instance().player_codes[msg.player_guid]
        if code != msg.code:
            gs_message.send_smsg_error(cif.guid, Errors.ERROR_RECONNECTION)
            return

    gs_message.send_smsg_reconnection(player.guid, player)


@reg_handle(Opcodes.SYS_LEAVE_WORLD)
def deal_sys_leave_world(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return
    channel.Channel.instance().del_info(cif.hid)
    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return
    player_data.client_logout(player)


@reg_handle(Opcodes.CMSG_NAMED)
def deal_cmsg_named(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_named()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    name = msg.name
    icon = msg.icon
    if name is None:
        gs_message.global_error(player.guid)
        return

    if player.name != '':
        gs_message.global_error(player.guid)
        return

    t_icon = config.Config.instance().t_sign.get(icon)
    if t_icon is None:
        gs_message.global_error(cif.guid)
        return

    if not player_data.check_name(name):
        gs_message.send_smsg_error(player.guid, Errors.ERROR_NAME)
        return

    player.name = name
    player.avatar = icon

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_NAMED)


@reg_handle(Opcodes.CMSG_GM_COMMAND)
def deal_cmsg_gm_command(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_gm_command()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    gm_command = msg.text
    command = gm_command.split(' ')
    assets = msg_assets()
    if len(command) <= 0:
        gs_message.global_error(cif.guid)
        return
    if command[0] == 'addasset':
        if len(command) <= 4:
            gs_message.global_error(cif.guid)
            return
        try:
            tp = int(command[1])
            value1 = int(command[2])
            value2 = int(command[3])
            value3 = int(command[4])
        except Exception:
            gs_message.global_error(cif.guid)
            return
        assets = player_data.add_assets(player, tp, value1, value2, value3)
    elif command[0] == 'refresh_day':
        refresh_assets, refresh_time = player_data.player_refresh(player)
        gs_message.send_smsg_refresh_player(player.guid, refresh_time, refresh_assets)
    elif command[0] == 'refresh_week':
        player_data.player_refresh_week(player)
    elif command[0] == 'refresh_month':
        player_data.player_refresh_month(player)
    elif command[0] == 'create_mail':
        tp = [int(command[1]), int(command[1]), int(command[1])]
        value1 = [int(command[2]), int(command[2]), int(command[2])]
        value2 = [int(command[3]), int(command[3]), int(command[3])]
        value3 = [int(command[4]), int(command[4]), int(command[4])]

        mail_pool.MailPool.instance().create_mail(player, 'test', 'test', 'nova', tp, value1, value2, value3)
    elif command[0] == 'create_server_mail':
        tp = int(command[1])
        value1 = int(command[2])
        value2 = int(command[3])
        value3 = int(command[4])
        mail_pool.MailPool.instance().create_mail_server('server', 'test', 'nova', tp, value1, value2, value3)
    gs_message.send_smsg_gm_command(player.guid, assets)


@reg_handle(Opcodes.CMSG_LIBAO_EXCHANGE)
def deal_cmsg_libao_exchange(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_libao_exchange()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    code = msg.code
    username = msg.username
    body = json.dumps({'code': code})
    headers = {'Content-type': 'application/json'}
    host = PGame.env.get_server_value('libao', 'host')
    port = PGame.env.get_server_value('libao', 'port')
    url = 'http://' + host + ':' + str(port) + '/libao'
    PGame.http.post(url, headers, body, libao_callback, [player.guid])


def libao_callback(response, extra):
    guid = extra[0]
    if response is None:
        gs_message.global_error(guid)
        return

    r = response.read()
    data = json.loads(r)
    res = data['res']
    assets = data['assets']
    pc = data['pc']

    player = PGame.pool.get(guid)
    if player is None:
        return

    if res == -1:
        gs_message.global_error(guid)
        return
    elif res == -2:
        gs_message.global_error(guid)
        return
    elif res == -3:
        gs_message.global_error(guid)
        return

    if pc != 0:
        for i in range(len(player.libao_nums)):
            if player.libao_nums[i] == pc:
                gs_message.global_error(guid)
                return
        player.libao_nums.append(pc)

    for i in range(len(assets)):
        player_data.add_assets(player, assets[i][0], assets[i][1], assets[i][2], assets[i][3])

    gs_message.send_smsg_libao_exchange(player.guid, assets)


# 充值
@reg_handle(Opcodes.CMSG_RECHARGE)
def deal_cmsg_recharge(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_recharge()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    recharge_id = msg.recharge_id
    t_recharge = config.Config.instance().t_recharge.get(recharge_id)
    if t_recharge is None:
        gs_message.global_error(cif.guid)
        return

    if t_recharge.id not in player.recharge_ids:
        gs_message.global_error(cif.guid)
        return

    player_data.add_resource(player, 2, t_recharge.crystal)

    if t_recharge.type == 3:
        for i in range(len(player.recharge_ids)):
            if recharge_id == player.recharge_ids[i]:
                player.recharge_ids[i] = t_recharge.pre_id
                break

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_RECHARGE)


# 排行榜
@reg_handle(Opcodes.CMSG_RANK_GET)
def deal_cmsg_rank_get(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_rank_get()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    rank_type = msg.type
    if rank_type <= 0 or rank_type > 3:
        gs_message.global_error(cif.guid)
        return

    sid = PGame.env.get_setting_value('qid')
    guid = guid_tool.make_guid(guid_tool.et['rank'], sid, rank_type)
    rank = PGame.pool.get(guid)
    if rank is None:
        gs_message.global_error(cif.guid)
        return

    return_rank = rank_t()
    return_rank.guid = rank.guid
    return_rank.last_time = rank.last_time
    if len(rank.player_guid) >= 30:
        l = 30
    else:
        l = len(rank.player_guid)
    for i in range(l):
        return_rank.player_guid.append(rank.player_guid[i])
        return_rank.player_name.append(rank.player_name[i])
        return_rank.player_icon.append(rank.player_icon[i])
        return_rank.player_level.append(rank.player_level[i])
        return_rank.player_data.append(rank.player_data[i])
    gs_message.send_smsg_rank_get(player.guid, return_rank)


# 查看玩家
@reg_handle(Opcodes.CMSG_VIEW_PLAYER)
def deal_cmsg_view_player(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_view_player()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    host = PGame.env.get_server_value('gs', 'host')
    port = PGame.env.get_server_value('gs', 'port')
    addr = "tcp://" + host + ":" + str(port)
    gs_message.send_smsg_view_player_cn(pck.hid, addr, pck.msg)


@reg_handle(Opcodes.CNMSG_VIEW_PLAYER_INQUIRE)
def deal_cnmsg_view_player_call(pck):
    msg = cmsg_view_player()
    if not proto_utils.parse(msg, pck.msg):
        return

    view_player_guid = msg.player_guid
    view_player = PGame.pool.get(view_player_guid)
    if view_player is None:
        player_pool.PlayerPool.instance().load_player2(view_player_guid, view_player_callback,
                                                       [view_player_guid, pck.hid, pck.get_addr(), False])
    else:
        view_player_callback([view_player_guid, pck.hid, pck.get_addr(), True])


def view_player_callback(req):
    view_player_guid = req[0]
    hid = req[1]
    addr = req[2]
    is_online = req[3]
    view_player = PGame.pool.get(view_player_guid)
    if view_player is None:
        return

    msg = smsg_view_player()
    msg.player_name = view_player.name
    msg.player_level = view_player.level
    msg.player_role = view_player.role_id
    attr = player_data.get_attr(view_player)

    for i in attr.keys():
        msg.player_attrs_ids.append(i)
        msg.player_attrs_values.append(attr[i])

    for i in range(len(view_player.equip_enhances)):
        msg.player_equip_enhances.append(view_player.equip_enhances[i])

    for i in range(len(view_player.equip_shows)):
        msg.player_equip_shows.append(view_player.equip_shows[i])

    msg.player_power = player_data.get_fight_power(view_player)
    msg.player_online = is_online
    for i in range(len(view_player.spell_ids)):
        msg.spell_ids.append(view_player.spell_ids[i])
        msg.spell_levels.append(view_player.spell_levels[i])

    for i in range(len(view_player.spell_passive_slots)):
        msg.spell_passive_slots.append(view_player.spell_passive_slots[i])

    for i in range(len(view_player.spell_passive_ids)):
        msg.spell_passive_ids.append(view_player.spell_passive_ids[i])

    for i in range(len(view_player.equip_slots)):
        if view_player.equip_slots[i] in view_player.equips.keys():
            equip = view_player.equips[view_player.equip_slots[i]]
            msg.player_equips.add().CopyFrom(equip.obj)

        msg.rune_slot1s.append(view_player.rune_slot1s[i])
        msg.rune_slot2s.append(view_player.rune_slot2s[i])
        msg.rune_slot3s.append(view_player.rune_slot3s[i])

    for i in range(len(view_player.pet_slots)):
        if view_player.pet_slots[i] in view_player.pets.keys():
            pet = view_player.pets[view_player.pet_slots[i]]
            msg.player_pets.add().CopyFrom(pet.obj)

    gs_message.send_smsg_view_player_inquire(hid, addr, msg)


@reg_handle(Opcodes.CNMSG_VIEW_PLAYER)
def deal_cnmsg_view_player(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = smsg_view_player()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    gs_message.send_smsg_view_player(player.guid, pck.msg)
