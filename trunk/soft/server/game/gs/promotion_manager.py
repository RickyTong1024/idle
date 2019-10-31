from pgame.service import PGame
from pgame.dispatcher import reg_handle
from common.opcodes import Opcodes, Errors, LogWay
from common.proto.player_msg_pb2 import *
from common.proto.arena_msg_pb2 import *
from common.proto.center_msg_pb2 import *
from common.proto.common_msg_pb2 import *
from common.proto.promotion_msg_pb2 import *
import config, channel, player_data, gs_message
from pgame.utils import proto_utils


@reg_handle(Opcodes.CNMSG_HEART_BEAT)
def deal_cnmsg_heart_beat(pck):
    gs_message.send_smsg_center_heart_beat()


# 商店
@reg_handle(Opcodes.CMSG_SHOP_BUY)
def deal_cmsg_shop_buy(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cmsg_shop_buy()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 解包
    shop_id = msg.id
    shop_num = msg.num

    t_shop = config.Config.instance().t_shop.get(shop_id)
    if t_shop is None:
        gs_message.global_error(cif.guid)
        return

    if t_shop.unlock_map > player.map:
        gs_message.global_error(cif.guid)
        return

    if shop_num <= 0 or shop_num > 100:
        gs_message.global_error(cif.guid)
        return

    index = 0
    if t_shop.shop_type == 1:
        # 限购商店
        index = player_data.get_index(player.shop_ids, shop_id)
        if index is None:
            index = len(player.shop_ids)
            player.shop_ids.append(shop_id)
            player.shop_nums.append(0)

        if shop_num + player.shop_nums[index] > t_shop.buy_num or player.shop_nums[index] > t_shop.buy_num:
            gs_message.global_error(cif.guid)
            return

    if t_shop.price_table == 2:
        # 购买价格随购买次数变化
        t_price = config.Config.instance().t_price.get(t_shop.price_table)
        index = player_data.get_index(player.shop_ids, shop_id)
        if index is None:
            index = len(player.shop_ids)
            player.shop_ids.append(shop_id)
            player.shop_nums.append(0)
        num = player.shop_nums[index]
        price = 0
        for i in range(num, shop_num + num):
            if i + 1 > len(t_price.price):
                price += t_price.price[len(t_price.price)-1].value
            else:
                price += t_price.price[i].value
    else:
        price = t_shop.price_value2 * shop_num

    if player_data.get_resource_num(player, t_shop.price_value1) < price:
        gs_message.global_error(cif.guid)
        return

    if t_shop.shop_type == 1 or t_shop.price_table == 2:
        player.shop_nums[index] += shop_num

    assets = msg_assets()
    for i in range(shop_num):
        assets = player_data.add_assets(player, t_shop.type, t_shop.value1, t_shop.value2, t_shop.value3, assets)
    player_data.add_resource(player, t_shop.price_value1, -price)
    gs_message.send_smsg_shop_buy(player.guid, assets)


# 签到
@reg_handle(Opcodes.CMSG_CHECK)
def deal_cmsg_check(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_check()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    # 判断成立条件
    check_day = msg.check_day
    if player.is_checked:
        gs_message.global_error(cif.guid)
        return

    if player.checked_days != check_day:
        gs_message.global_error(cif.guid)
        return

    check_day = check_day + 1
    reward_id = check_day
    if check_day > 30:
        reward_id = check_day % 30

    t_sign = config.Config.instance().t_sign.get(reward_id)
    if check_day <= 30:
        assets = player_data.add_assets(player, t_sign.reward[0].type, t_sign.reward[0].value1, t_sign.reward[0].value2, t_sign.reward[0].value3, log_way=LogWay.LOG_SIGN)
    else:
        assets = player_data.add_assets(player, t_sign.reward[1].type, t_sign.reward[1].value1, t_sign.reward[1].value2, t_sign.reward[1].value3, log_way=LogWay.LOG_SIGN)
    # 返回成功消息
    player.checked_days += 1
    player.is_checked = 1
    player_data.daily_schedule(player, 1001, 1)
    gs_message.send_smsg_checked(player.guid, assets)

# 领取任务
@reg_handle(Opcodes.CMSG_TASK_RECEIVE)
def deal_cmsg_task_receive(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_task_receive()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    task_id = msg.task_id

    if task_id in player.task_ids:
        gs_message.global_error(player.guid)
        return

    t_quest_sub = config.Config.instance().t_quest_sub.get(task_id)
    if t_quest_sub is None:
        gs_message.global_error(player.guid)
        return

    t_quest = config.Config.instance().t_quest.get(t_quest_sub.quest)
    if t_quest is None:
        gs_message.global_error(player.guid)
        return

    if t_quest_sub.quest in player.tasks:
        gs_message.global_error(player.guid)
        return

    if t_quest_sub.pre_sub != 0:
        gs_message.global_error(player.guid)
        return

    if t_quest.required == 1:
        if player.level < t_quest.required_param1:
            gs_message.global_error(player.guid)
            return

    elif t_quest.required == 2:
        if t_quest.required_param2 not in player.task_ends:
            gs_message.global_error(player.guid)
            return

    if t_quest.type == 3:
        quest_num = config.Config.instance().const('quest_num')
        if player.task_num >= quest_num:
            gs_message.global_error(player.guid)
            return

    player.tasks.append(t_quest_sub.quest)

    player.task_ids.append(t_quest_sub.id)
    player.task_reaches.append(0)

    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_TASK_RECEIVE)


# 完成任务
@reg_handle(Opcodes.CMSG_TASK_END)
def deal_cmsg_task_ends(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_task_end()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    task_id = msg.task_id
    t_quest_sub = config.Config.instance().t_quest_sub.get(task_id)
    if t_quest_sub is None:
        gs_message.global_error(cif.guid)
        return

    if task_id not in player.task_ids:
        gs_message.global_error(cif.guid)
        return

    if t_quest_sub.event_type == 2:
        if player_data.get_task_reaches(player, task_id) < t_quest_sub.event_param2:
            gs_message.global_error(cif.guid)
            return

    elif t_quest_sub.event_type == 4:
        if player_data.get_assets_num(player, t_quest_sub.event_param1, t_quest_sub.event_param2) < t_quest_sub.event_param3:
            gs_message.global_error(player.guid)
            return

        player_data.remove_assets(player, t_quest_sub.event_param1, t_quest_sub.event_param2, t_quest_sub.event_param3)

    elif t_quest_sub.event_type == 11 or t_quest_sub.event_type == 14 or t_quest_sub.event_type == 15:
        if player_data.get_task_reaches(player, task_id) != 1:
            gs_message.global_error(cif.guid)
            return

    task_line = player_data.get_task_line(t_quest_sub.quest)
    if task_line is None:
        PGame.log.error('task_line is None')
        return

    if task_line[task_id] is None:
        t_quest = config.Config.instance().t_quest.get(t_quest_sub.quest)
        if t_quest.type == 3:
            player.task_num += 1
        for i in range(len(player.tasks)):
            if player.tasks[i] == t_quest_sub.quest:
                del player.tasks[i]
                break

        t_quest = config.Config.instance().t_quest.get(t_quest_sub.quest)
        if t_quest.type != 3:
            player.task_ends.append(t_quest_sub.quest)
        for i in range(len(player.task_ids)-1, -1, -1):
            quest_sub = config.Config.instance().t_quest_sub.get(player.task_ids[i])
            if quest_sub.quest == t_quest_sub.quest:
                del player.task_ids[i]
                del player.task_reaches[i]
    else:
        for i in range(len(player.task_ids)):
            if player.task_ids[i] == task_id:
                player.task_reaches[i] = -1
                break
        player.task_ids.append(task_line[task_id])
        player.task_reaches.append(0)

    map_id = 0
    t_maps = config.Config.instance().t_map.get()
    for i in range(len(t_maps)):
        if t_maps[i].map_param == task_id:
            map_id = t_maps[i].id
            player.map = map_id
            break

    assets = msg_assets()
    for i in range(len(t_quest_sub.reward)):
        if t_quest_sub.reward[i].type != 0:
            assets = player_data.add_assets(player, t_quest_sub.reward[i].type, t_quest_sub.reward[i].value1, t_quest_sub.reward[i].value2, t_quest_sub.reward[i].value3, assets)

    gs_message.send_smsg_task_end(player.guid, map_id, assets)


# 领取每日任务
@reg_handle(Opcodes.CMSG_DAILY_DRAW)
def deal_cmsg_daily_draw(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_daily_draw()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    daily_id = msg.daily_id
    if daily_id not in player.daily_ids:
        gs_message.global_error(player.guid)
        return

    t_daily = config.Config.instance().t_daily.get(daily_id)
    if t_daily is None:
        gs_message.global_error(player.guid)
        return

    index = player_data.get_index(player.daily_ids, daily_id)
    daily_num = player.daily_nums[index]
    if daily_num == 0 or daily_num < t_daily.num:
        gs_message.global_error(cif.guid)
        return

    assets = msg_assets()
    assets = player_data.add_assets(player, t_daily.type, t_daily.value1, t_daily.value2, t_daily.value3, assets)
    player_data.daily_reached(player, daily_id)
    gs_message.send_smsg_daily_draw(player.guid, assets)


# 日常任务奖励
@reg_handle(Opcodes.CMSG_DAILY_REWARD_DRAW)
def deal_cmsg_daily_reward_draw(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_daily_reward_draw()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    daily_reward_id = msg.daily_reward_id
    t_daily_reward = config.Config.instance().t_daily_reward.get(daily_reward_id)
    if t_daily_reward is None:
        gs_message.global_error(player.guid)
        return

    if daily_reward_id in player.daily_rewards:
        gs_message.global_error(player.guid)
        return

    sum_num = 0
    for i in range(len(player.daily_ids)):
        t_daily = config.Config.instance().t_daily.get(player.daily_ids[i])
        if player.daily_reaches[i] < 1:
            continue
        sum_num += t_daily.point

    if sum_num < daily_reward_id:
        gs_message.global_error(player.guid)
        return

    assets = msg_assets()
    for i in range(len(t_daily_reward.reward)):
        assets = player_data.add_assets(player, t_daily_reward.reward[i].type, t_daily_reward.reward[i].value1, t_daily_reward.reward[i].value2, t_daily_reward.reward[i].value3, assets)
    player.daily_rewards.append(daily_reward_id)
    gs_message.send_smsg_daily_reward_draw(player.guid, assets)


# 更新player昵称
@reg_handle(Opcodes.CMSG_PLAYER_CHANGE_NAME)
def deal_cmsg_change_player_name(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_change_player_name()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    new_name = msg.new_name
    if new_name is None:
        gs_message.global_error(cif.guid)
        return

    expend_jewel = config.Config.instance().const("change_name_jewel")
    if player.jewel < expend_jewel:
        gs_message.global_error(cif.guid)
        return

    # 名称符合
    if player_data.check_name(new_name):
        player.name = new_name
        player_data.add_resource(player, 2, -expend_jewel)
        gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PLAYER_CHANGE_NAME)
    else:
        gs_message.send_smsg_error(player.guid, Errors.ERROR_NAME)


# 更新player头像
@reg_handle(Opcodes.CMSG_PLAYER_CHANGE_ICON)
def deal_cmsg_change_player_icon(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_change_player_icon()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    new_icon = msg.new_icon
    if new_icon is None:
        gs_message.global_error(cif.guid)
        return

    t_icon = config.Config.instance().t_sign.get(new_icon)
    if t_icon is None:
        gs_message.global_error(cif.guid)
        return

    player.avatar = new_icon
    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PLAYER_CHANGE_ICON)


# 更新旁白id
@reg_handle(Opcodes.CMSG_ASIDE)
def deal_cmsg_aside(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_aside()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    player.aside = msg.aside_id
    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_ASIDE)


# 更新cmsg_portal
@reg_handle(Opcodes.CMSG_PORTAL)
def deal_cmsg_portal(pck):
    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        gs_message.global_error(cif.guid)
        return

    msg = cmsg_portal()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    player = PGame.pool.get(cif.guid)
    if player is None:
        gs_message.global_error(cif.guid)
        return

    if msg.portal_id - player.portal != 1:
        gs_message.global_error(cif.guid)
        return

    player.portal += 1
    gs_message.send_smsg_success(player.guid, Opcodes.SMSG_PORTAL)


@reg_handle(Opcodes.CNMSG_ERROR)
def deal_cnmsg_error(pck):
    """中心服报错"""

    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = cnmsg_error()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    gs_message.send_smsg_error(cif.guid, msg.code)


@reg_handle(Opcodes.AMSG_ERROR)
def deal_amsg_error(pck):
    """竞技场服务器报错"""

    cif = channel.Channel.instance().get_info(pck.hid)
    if cif is None:
        return

    msg = amsg_error()
    if not proto_utils.parse(msg, pck.msg):
        gs_message.global_error(cif.guid)
        return

    gs_message.send_smsg_error(cif.guid, msg.code)
