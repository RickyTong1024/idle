from pgame.service import PGame
from common.opcodes import Opcodes
from common.proto.player_msg_pb2 import *
from common.proto.common_msg_pb2 import *
from pgame.utils import proto_utils
from pgame.dispatcher import reg_handle
import gs_message, channel, player_data, mail_pool


# 获取邮件列表
@reg_handle(Opcodes.CMSG_MAIL_LIST)
def deal_cmsg_mail_list(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    mails = mail_pool.MailPool.instance().get_mail(player)
    gs_message.send_smsg_mail_list(player.guid, mails)


# 领取邮件
@reg_handle(Opcodes.CMSG_MAIL_GET)
def deal_cmsg_mail_get(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_mail_get()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 数据校验
    for i in range(len(msg.mail_guids)):
        if msg.mail_guids[i] not in player.mails and msg.mail_guids[i] not in mail_pool.MailPool.instance().mail_all_list.keys():
            gs_message.global_error(player.guid)
            break

        if msg.mail_guids[i] in player.mails:
            mail = player.mails[msg.mail_guids[i]]
            if player.guid != mail.receiver_guid:
                gs_message.global_error(player.guid)
                break

            if mail.used != 0:
                gs_message.global_error(player.guid)
                break

        if msg.mail_guids[i] in mail_pool.MailPool.instance().mail_all_list.keys():
            mail = mail_pool.MailPool.instance().mail_all_list[msg.mail_guids[i]]
            if player.guid in mail.receiver_guids:
                gs_message.global_error(player.guid)
                break

    # 邮件领取
    assets = msg_assets()
    for i in range(len(msg.mail_guids)):
        if msg.mail_guids[i] in player.mails:
            mail = player.mails[msg.mail_guids[i]]
            mail.used = 1
        else:
            mail = mail_pool.MailPool.instance().mail_all_list[msg.mail_guids[i]]
            mail_pool.MailPool.instance().update_mail_server(mail, player.guid, False)
        for j in range(len(mail.type)):
            assets = player_data.add_assets(player, mail.type[j], mail.value1[j], mail.value2[j], mail.value3[j], assets)

    # 回复消息
    gs_message.send_smsg_mail_get(player.guid, assets)


# 删除邮件
@reg_handle(Opcodes.CMSG_MAIL_REMOVE)
def deal_cmsg_mail_remove(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_mail_remove()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 数据校验
    for i in range(len(msg.mail_guids)):
        if msg.mail_guids[i] not in player.mails and msg.mail_guids[i] not in mail_pool.MailPool.instance().mail_all_list.keys():
            gs_message.global_error(player.guid)
            break

        if msg.mail_guids[i] in player.mails:
            mail = player.mails[msg.mail_guids[i]]
            if player.guid != mail.receiver_guid:
                gs_message.global_error(player.guid)
                break

            if mail.used != 1:
                gs_message.global_error(player.guid)
                break

        if msg.mail_guids[i] in mail_pool.MailPool.instance().mail_all_list.keys():
            mail = mail_pool.MailPool.instance().mail_all_list[msg.mail_guids[i]]
            if player.guid not in mail.receiver_guids:
                gs_message.global_error(player.guid)
                break

    # 邮件删除
    for i in range(len(msg.mail_guids)):
        if msg.mail_guids[i] in player.mails:
            mail_pool.MailPool.instance().remove_mail(player, msg.mail_guids[i])
        else:
            mail = mail_pool.MailPool.instance().mail_all_list[msg.mail_guids[i]]
            mail_pool.MailPool.instance().update_mail_server(mail, player.guid, True)

    mails = mail_pool.MailPool.instance().get_mail(player)
    if len(mails) == 0:
        player.has_mail = 0

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_MAIL_REMOVE)
