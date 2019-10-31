from common.proto.player_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into player_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " server_id = %s,"
    param = param + (req.param.server_id,)
    sql += " name = %s,"
    param = param + (req.param.name,)
    sql += " avatar = %s,"
    param = param + (req.param.avatar,)
    sql += " role_id = %s,"
    param = param + (req.param.role_id,)
    sql += " last_refresh_time = %s,"
    param = param + (req.param.last_refresh_time,)
    sql += " last_refresh_week_time = %s,"
    param = param + (req.param.last_refresh_week_time,)
    sql += " last_refresh_month_time = %s,"
    param = param + (req.param.last_refresh_month_time,)
    sql += " level = %s,"
    param = param + (req.param.level,)
    sql += " gold = %s,"
    param = param + (req.param.gold,)
    sql += " jewel = %s,"
    param = param + (req.param.jewel,)
    sql += " exp = %s,"
    param = param + (req.param.exp,)
    sql += " honor = %s,"
    param = param + (req.param.honor,)
    sql += " reputation = %s,"
    param = param + (req.param.reputation,)
    sql += " integral = %s,"
    param = param + (req.param.integral,)
    sql += " is_checked = %s,"
    param = param + (req.param.is_checked,)
    sql += " checked_days = %s,"
    param = param + (req.param.checked_days,)
    sql += " aside = %s,"
    param = param + (req.param.aside,)
    sql += " portal = %s,"
    param = param + (req.param.portal,)
    sql += " has_mail = %s,"
    param = param + (req.param.has_mail,)
    sql += " tower = %s,"
    param = param + (req.param.tower,)
    sql += " tower_sweep_free = %s,"
    param = param + (req.param.tower_sweep_free,)
    sql += " tower_sweep_num = %s,"
    param = param + (req.param.tower_sweep_num,)
    sql += " recharge_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.recharge_ids),)
    sql += " map = %s,"
    param = param + (req.param.map,)
    sql += " in_map = %s,"
    param = param + (req.param.in_map,)
    sql += " map_die_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.map_die_ids),)
    sql += " map_die_times = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.map_die_times),)
    sql += " mission = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.mission),)
    sql += " mission_time = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.mission_time),)
    sql += " mission_ex = %s,"
    param = param + (req.param.mission_ex,)
    sql += " mission_ex_time = %s,"
    param = param + (req.param.mission_ex_time,)
    sql += " mission_ex_count = %s,"
    param = param + (req.param.mission_ex_count,)
    sql += " arena_room = %s,"
    param = param + (req.param.arena_room,)
    sql += " arena_segment = %s,"
    param = param + (req.param.arena_segment,)
    sql += " arena_integral = %s,"
    param = param + (req.param.arena_integral,)
    sql += " arena_win = %s,"
    param = param + (req.param.arena_win,)
    sql += " arena_num = %s,"
    param = param + (req.param.arena_num,)
    sql += " arena_list_index = %s,"
    param = param + (req.param.arena_list_index,)
    sql += " arena_fight = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.arena_fight),)
    sql += " seed = %s,"
    param = param + (req.param.seed,)
    sql += " mineral_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.mineral_ids),)
    sql += " mineral_times = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.mineral_times),)
    sql += " dungeons = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.dungeons),)
    sql += " dungeon_tags = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_tags),)
    sql += " dungeon_cengs = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_cengs),)
    sql += " dungeon_events = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_events),)
    sql += " dungeon_assets = %s,"
    param = param + (proto_utils.repeated2bytes("bytes", req.param.dungeon_assets),)
    sql += " artifact_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_ids),)
    sql += " artifact_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_nums),)
    sql += " artifact_unlocks = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_unlocks),)
    sql += " item_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.item_ids),)
    sql += " item_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.item_nums),)
    sql += " spell_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.spell_ids),)
    sql += " spell_levels = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.spell_levels),)
    sql += " spell_passive_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.spell_passive_ids),)
    sql += " rune_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.rune_ids),)
    sql += " rune_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.rune_nums),)
    sql += " equip_dresses = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.equip_dresses),)
    sql += " equip_dresses_unlock = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.equip_dresses_unlock),)
    sql += " equip_slots = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.equip_slots),)
    sql += " equip_shows = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.equip_shows),)
    sql += " equip_enhances = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.equip_enhances),)
    sql += " monsters = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.monsters),)
    sql += " monster_tasks = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.monster_tasks),)
    sql += " monster_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.monster_nums),)
    sql += " monster_unlocks = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.monster_unlocks),)
    sql += " pet_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.pet_ids),)
    sql += " pet_unlocks = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.pet_unlocks),)
    sql += " spell_passive_slots = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.spell_passive_slots),)
    sql += " rune_slot1s = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot1s),)
    sql += " rune_slot2s = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot2s),)
    sql += " rune_slot3s = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot3s),)
    sql += " pet_slots = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.pet_slots),)
    sql += " shop_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.shop_ids),)
    sql += " shop_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.shop_nums),)
    sql += " daily_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.daily_ids),)
    sql += " daily_nums = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.daily_nums),)
    sql += " daily_reaches = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.daily_reaches),)
    sql += " daily_rewards = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.daily_rewards),)
    sql += " tasks = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.tasks),)
    sql += " task_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.task_ids),)
    sql += " task_reaches = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.task_reaches),)
    sql += " task_ends = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.task_ends),)
    sql += " task_num = %s,"
    param = param + (req.param.task_num,)
    sql += " mail_note = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.mail_note),)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from player_t where guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = player_t()
        data.guid = ret[i][0]
        data.server_id = ret[i][1]
        data.name = ret[i][2]
        data.avatar = ret[i][3]
        data.role_id = ret[i][4]
        data.last_refresh_time = ret[i][5]
        data.last_refresh_week_time = ret[i][6]
        data.last_refresh_month_time = ret[i][7]
        data.level = ret[i][8]
        data.gold = ret[i][9]
        data.jewel = ret[i][10]
        data.exp = ret[i][11]
        data.honor = ret[i][12]
        data.reputation = ret[i][13]
        data.integral = ret[i][14]
        data.is_checked = ret[i][15]
        data.checked_days = ret[i][16]
        data.aside = ret[i][17]
        data.portal = ret[i][18]
        data.has_mail = ret[i][19]
        data.tower = ret[i][20]
        data.tower_sweep_free = ret[i][21]
        data.tower_sweep_num = ret[i][22]
        proto_utils.bytes2repeated("int32", data.recharge_ids, ret[i][23])
        data.map = ret[i][24]
        data.in_map = ret[i][25]
        proto_utils.bytes2repeated("int32", data.map_die_ids, ret[i][26])
        proto_utils.bytes2repeated("uint64", data.map_die_times, ret[i][27])
        proto_utils.bytes2repeated("int32", data.mission, ret[i][28])
        proto_utils.bytes2repeated("uint64", data.mission_time, ret[i][29])
        data.mission_ex = ret[i][30]
        data.mission_ex_time = ret[i][31]
        data.mission_ex_count = ret[i][32]
        data.arena_room = ret[i][33]
        data.arena_segment = ret[i][34]
        data.arena_integral = ret[i][35]
        data.arena_win = ret[i][36]
        data.arena_num = ret[i][37]
        data.arena_list_index = ret[i][38]
        proto_utils.bytes2repeated("uint64", data.arena_fight, ret[i][39])
        data.seed = ret[i][40]
        proto_utils.bytes2repeated("int32", data.mineral_ids, ret[i][41])
        proto_utils.bytes2repeated("uint64", data.mineral_times, ret[i][42])
        proto_utils.bytes2repeated("int32", data.dungeons, ret[i][43])
        proto_utils.bytes2repeated("int32", data.dungeon_tags, ret[i][44])
        proto_utils.bytes2repeated("int32", data.dungeon_cengs, ret[i][45])
        proto_utils.bytes2repeated("int32", data.dungeon_events, ret[i][46])
        proto_utils.bytes2repeated("bytes", data.dungeon_assets, ret[i][47])
        proto_utils.bytes2repeated("int32", data.artifact_ids, ret[i][48])
        proto_utils.bytes2repeated("int32", data.artifact_nums, ret[i][49])
        proto_utils.bytes2repeated("int32", data.artifact_unlocks, ret[i][50])
        proto_utils.bytes2repeated("int32", data.item_ids, ret[i][51])
        proto_utils.bytes2repeated("int32", data.item_nums, ret[i][52])
        proto_utils.bytes2repeated("int32", data.spell_ids, ret[i][53])
        proto_utils.bytes2repeated("int32", data.spell_levels, ret[i][54])
        proto_utils.bytes2repeated("int32", data.spell_passive_ids, ret[i][55])
        proto_utils.bytes2repeated("int32", data.rune_ids, ret[i][56])
        proto_utils.bytes2repeated("int32", data.rune_nums, ret[i][57])
        proto_utils.bytes2repeated("int32", data.equip_dresses, ret[i][58])
        proto_utils.bytes2repeated("int32", data.equip_dresses_unlock, ret[i][59])
        proto_utils.bytes2repeated("uint64", data.equip_slots, ret[i][60])
        proto_utils.bytes2repeated("int32", data.equip_shows, ret[i][61])
        proto_utils.bytes2repeated("int32", data.equip_enhances, ret[i][62])
        proto_utils.bytes2repeated("int32", data.monsters, ret[i][63])
        proto_utils.bytes2repeated("int32", data.monster_tasks, ret[i][64])
        proto_utils.bytes2repeated("int32", data.monster_nums, ret[i][65])
        proto_utils.bytes2repeated("int32", data.monster_unlocks, ret[i][66])
        proto_utils.bytes2repeated("int32", data.pet_ids, ret[i][67])
        proto_utils.bytes2repeated("int32", data.pet_unlocks, ret[i][68])
        proto_utils.bytes2repeated("int32", data.spell_passive_slots, ret[i][69])
        proto_utils.bytes2repeated("int32", data.rune_slot1s, ret[i][70])
        proto_utils.bytes2repeated("int32", data.rune_slot2s, ret[i][71])
        proto_utils.bytes2repeated("int32", data.rune_slot3s, ret[i][72])
        proto_utils.bytes2repeated("uint64", data.pet_slots, ret[i][73])
        proto_utils.bytes2repeated("int32", data.shop_ids, ret[i][74])
        proto_utils.bytes2repeated("int32", data.shop_nums, ret[i][75])
        proto_utils.bytes2repeated("int32", data.daily_ids, ret[i][76])
        proto_utils.bytes2repeated("int32", data.daily_nums, ret[i][77])
        proto_utils.bytes2repeated("int32", data.daily_reaches, ret[i][78])
        proto_utils.bytes2repeated("int32", data.daily_rewards, ret[i][79])
        proto_utils.bytes2repeated("int32", data.tasks, ret[i][80])
        proto_utils.bytes2repeated("int32", data.task_ids, ret[i][81])
        proto_utils.bytes2repeated("int32", data.task_reaches, ret[i][82])
        proto_utils.bytes2repeated("int32", data.task_ends, ret[i][83])
        data.task_num = ret[i][84]
        proto_utils.bytes2repeated("uint64", data.mail_note, ret[i][85])
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update player_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("server_id"):
        sql += " server_id = %s,"
        param = param + (req.param.server_id,)
    if req.param.has_changed("name"):
        sql += " name = %s,"
        param = param + (req.param.name,)
    if req.param.has_changed("avatar"):
        sql += " avatar = %s,"
        param = param + (req.param.avatar,)
    if req.param.has_changed("role_id"):
        sql += " role_id = %s,"
        param = param + (req.param.role_id,)
    if req.param.has_changed("last_refresh_time"):
        sql += " last_refresh_time = %s,"
        param = param + (req.param.last_refresh_time,)
    if req.param.has_changed("last_refresh_week_time"):
        sql += " last_refresh_week_time = %s,"
        param = param + (req.param.last_refresh_week_time,)
    if req.param.has_changed("last_refresh_month_time"):
        sql += " last_refresh_month_time = %s,"
        param = param + (req.param.last_refresh_month_time,)
    if req.param.has_changed("level"):
        sql += " level = %s,"
        param = param + (req.param.level,)
    if req.param.has_changed("gold"):
        sql += " gold = %s,"
        param = param + (req.param.gold,)
    if req.param.has_changed("jewel"):
        sql += " jewel = %s,"
        param = param + (req.param.jewel,)
    if req.param.has_changed("exp"):
        sql += " exp = %s,"
        param = param + (req.param.exp,)
    if req.param.has_changed("honor"):
        sql += " honor = %s,"
        param = param + (req.param.honor,)
    if req.param.has_changed("reputation"):
        sql += " reputation = %s,"
        param = param + (req.param.reputation,)
    if req.param.has_changed("integral"):
        sql += " integral = %s,"
        param = param + (req.param.integral,)
    if req.param.has_changed("is_checked"):
        sql += " is_checked = %s,"
        param = param + (req.param.is_checked,)
    if req.param.has_changed("checked_days"):
        sql += " checked_days = %s,"
        param = param + (req.param.checked_days,)
    if req.param.has_changed("aside"):
        sql += " aside = %s,"
        param = param + (req.param.aside,)
    if req.param.has_changed("portal"):
        sql += " portal = %s,"
        param = param + (req.param.portal,)
    if req.param.has_changed("has_mail"):
        sql += " has_mail = %s,"
        param = param + (req.param.has_mail,)
    if req.param.has_changed("tower"):
        sql += " tower = %s,"
        param = param + (req.param.tower,)
    if req.param.has_changed("tower_sweep_free"):
        sql += " tower_sweep_free = %s,"
        param = param + (req.param.tower_sweep_free,)
    if req.param.has_changed("tower_sweep_num"):
        sql += " tower_sweep_num = %s,"
        param = param + (req.param.tower_sweep_num,)
    if req.param.has_changed("recharge_ids"):
        sql += " recharge_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.recharge_ids),)
    if req.param.has_changed("map"):
        sql += " map = %s,"
        param = param + (req.param.map,)
    if req.param.has_changed("in_map"):
        sql += " in_map = %s,"
        param = param + (req.param.in_map,)
    if req.param.has_changed("map_die_ids"):
        sql += " map_die_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.map_die_ids),)
    if req.param.has_changed("map_die_times"):
        sql += " map_die_times = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.map_die_times),)
    if req.param.has_changed("mission"):
        sql += " mission = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.mission),)
    if req.param.has_changed("mission_time"):
        sql += " mission_time = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.mission_time),)
    if req.param.has_changed("mission_ex"):
        sql += " mission_ex = %s,"
        param = param + (req.param.mission_ex,)
    if req.param.has_changed("mission_ex_time"):
        sql += " mission_ex_time = %s,"
        param = param + (req.param.mission_ex_time,)
    if req.param.has_changed("mission_ex_count"):
        sql += " mission_ex_count = %s,"
        param = param + (req.param.mission_ex_count,)
    if req.param.has_changed("arena_room"):
        sql += " arena_room = %s,"
        param = param + (req.param.arena_room,)
    if req.param.has_changed("arena_segment"):
        sql += " arena_segment = %s,"
        param = param + (req.param.arena_segment,)
    if req.param.has_changed("arena_integral"):
        sql += " arena_integral = %s,"
        param = param + (req.param.arena_integral,)
    if req.param.has_changed("arena_win"):
        sql += " arena_win = %s,"
        param = param + (req.param.arena_win,)
    if req.param.has_changed("arena_num"):
        sql += " arena_num = %s,"
        param = param + (req.param.arena_num,)
    if req.param.has_changed("arena_list_index"):
        sql += " arena_list_index = %s,"
        param = param + (req.param.arena_list_index,)
    if req.param.has_changed("arena_fight"):
        sql += " arena_fight = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.arena_fight),)
    if req.param.has_changed("seed"):
        sql += " seed = %s,"
        param = param + (req.param.seed,)
    if req.param.has_changed("mineral_ids"):
        sql += " mineral_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.mineral_ids),)
    if req.param.has_changed("mineral_times"):
        sql += " mineral_times = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.mineral_times),)
    if req.param.has_changed("dungeons"):
        sql += " dungeons = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.dungeons),)
    if req.param.has_changed("dungeon_tags"):
        sql += " dungeon_tags = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_tags),)
    if req.param.has_changed("dungeon_cengs"):
        sql += " dungeon_cengs = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_cengs),)
    if req.param.has_changed("dungeon_events"):
        sql += " dungeon_events = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.dungeon_events),)
    if req.param.has_changed("dungeon_assets"):
        sql += " dungeon_assets = %s,"
        param = param + (proto_utils.repeated2bytes("bytes", req.param.dungeon_assets),)
    if req.param.has_changed("artifact_ids"):
        sql += " artifact_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_ids),)
    if req.param.has_changed("artifact_nums"):
        sql += " artifact_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_nums),)
    if req.param.has_changed("artifact_unlocks"):
        sql += " artifact_unlocks = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.artifact_unlocks),)
    if req.param.has_changed("item_ids"):
        sql += " item_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.item_ids),)
    if req.param.has_changed("item_nums"):
        sql += " item_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.item_nums),)
    if req.param.has_changed("spell_ids"):
        sql += " spell_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.spell_ids),)
    if req.param.has_changed("spell_levels"):
        sql += " spell_levels = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.spell_levels),)
    if req.param.has_changed("spell_passive_ids"):
        sql += " spell_passive_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.spell_passive_ids),)
    if req.param.has_changed("rune_ids"):
        sql += " rune_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.rune_ids),)
    if req.param.has_changed("rune_nums"):
        sql += " rune_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.rune_nums),)
    if req.param.has_changed("equip_dresses"):
        sql += " equip_dresses = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.equip_dresses),)
    if req.param.has_changed("equip_dresses_unlock"):
        sql += " equip_dresses_unlock = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.equip_dresses_unlock),)
    if req.param.has_changed("equip_slots"):
        sql += " equip_slots = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.equip_slots),)
    if req.param.has_changed("equip_shows"):
        sql += " equip_shows = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.equip_shows),)
    if req.param.has_changed("equip_enhances"):
        sql += " equip_enhances = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.equip_enhances),)
    if req.param.has_changed("monsters"):
        sql += " monsters = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.monsters),)
    if req.param.has_changed("monster_tasks"):
        sql += " monster_tasks = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.monster_tasks),)
    if req.param.has_changed("monster_nums"):
        sql += " monster_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.monster_nums),)
    if req.param.has_changed("monster_unlocks"):
        sql += " monster_unlocks = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.monster_unlocks),)
    if req.param.has_changed("pet_ids"):
        sql += " pet_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.pet_ids),)
    if req.param.has_changed("pet_unlocks"):
        sql += " pet_unlocks = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.pet_unlocks),)
    if req.param.has_changed("spell_passive_slots"):
        sql += " spell_passive_slots = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.spell_passive_slots),)
    if req.param.has_changed("rune_slot1s"):
        sql += " rune_slot1s = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot1s),)
    if req.param.has_changed("rune_slot2s"):
        sql += " rune_slot2s = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot2s),)
    if req.param.has_changed("rune_slot3s"):
        sql += " rune_slot3s = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.rune_slot3s),)
    if req.param.has_changed("pet_slots"):
        sql += " pet_slots = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.pet_slots),)
    if req.param.has_changed("shop_ids"):
        sql += " shop_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.shop_ids),)
    if req.param.has_changed("shop_nums"):
        sql += " shop_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.shop_nums),)
    if req.param.has_changed("daily_ids"):
        sql += " daily_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.daily_ids),)
    if req.param.has_changed("daily_nums"):
        sql += " daily_nums = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.daily_nums),)
    if req.param.has_changed("daily_reaches"):
        sql += " daily_reaches = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.daily_reaches),)
    if req.param.has_changed("daily_rewards"):
        sql += " daily_rewards = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.daily_rewards),)
    if req.param.has_changed("tasks"):
        sql += " tasks = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.tasks),)
    if req.param.has_changed("task_ids"):
        sql += " task_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.task_ids),)
    if req.param.has_changed("task_reaches"):
        sql += " task_reaches = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.task_reaches),)
    if req.param.has_changed("task_ends"):
        sql += " task_ends = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.task_ends),)
    if req.param.has_changed("task_num"):
        sql += " task_num = %s,"
        param = param + (req.param.task_num,)
    if req.param.has_changed("mail_note"):
        sql += " mail_note = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.mail_note),)
    sql = sql.rstrip(",")
    sql += " where guid = %s"
    param = param + (req.param.guid,)

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def remove(db, req):
    sql = "delete from player_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from player_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = player_t()
        data.guid = ret[i][0]
        data.server_id = ret[i][1]
        data.name = ret[i][2]
        data.avatar = ret[i][3]
        data.role_id = ret[i][4]
        data.last_refresh_time = ret[i][5]
        data.last_refresh_week_time = ret[i][6]
        data.last_refresh_month_time = ret[i][7]
        data.level = ret[i][8]
        data.gold = ret[i][9]
        data.jewel = ret[i][10]
        data.exp = ret[i][11]
        data.honor = ret[i][12]
        data.reputation = ret[i][13]
        data.integral = ret[i][14]
        data.is_checked = ret[i][15]
        data.checked_days = ret[i][16]
        data.aside = ret[i][17]
        data.portal = ret[i][18]
        data.has_mail = ret[i][19]
        data.tower = ret[i][20]
        data.tower_sweep_free = ret[i][21]
        data.tower_sweep_num = ret[i][22]
        proto_utils.bytes2repeated("int32", data.recharge_ids, ret[i][23])
        data.map = ret[i][24]
        data.in_map = ret[i][25]
        proto_utils.bytes2repeated("int32", data.map_die_ids, ret[i][26])
        proto_utils.bytes2repeated("uint64", data.map_die_times, ret[i][27])
        proto_utils.bytes2repeated("int32", data.mission, ret[i][28])
        proto_utils.bytes2repeated("uint64", data.mission_time, ret[i][29])
        data.mission_ex = ret[i][30]
        data.mission_ex_time = ret[i][31]
        data.mission_ex_count = ret[i][32]
        data.arena_room = ret[i][33]
        data.arena_segment = ret[i][34]
        data.arena_integral = ret[i][35]
        data.arena_win = ret[i][36]
        data.arena_num = ret[i][37]
        data.arena_list_index = ret[i][38]
        proto_utils.bytes2repeated("uint64", data.arena_fight, ret[i][39])
        data.seed = ret[i][40]
        proto_utils.bytes2repeated("int32", data.mineral_ids, ret[i][41])
        proto_utils.bytes2repeated("uint64", data.mineral_times, ret[i][42])
        proto_utils.bytes2repeated("int32", data.dungeons, ret[i][43])
        proto_utils.bytes2repeated("int32", data.dungeon_tags, ret[i][44])
        proto_utils.bytes2repeated("int32", data.dungeon_cengs, ret[i][45])
        proto_utils.bytes2repeated("int32", data.dungeon_events, ret[i][46])
        proto_utils.bytes2repeated("bytes", data.dungeon_assets, ret[i][47])
        proto_utils.bytes2repeated("int32", data.artifact_ids, ret[i][48])
        proto_utils.bytes2repeated("int32", data.artifact_nums, ret[i][49])
        proto_utils.bytes2repeated("int32", data.artifact_unlocks, ret[i][50])
        proto_utils.bytes2repeated("int32", data.item_ids, ret[i][51])
        proto_utils.bytes2repeated("int32", data.item_nums, ret[i][52])
        proto_utils.bytes2repeated("int32", data.spell_ids, ret[i][53])
        proto_utils.bytes2repeated("int32", data.spell_levels, ret[i][54])
        proto_utils.bytes2repeated("int32", data.spell_passive_ids, ret[i][55])
        proto_utils.bytes2repeated("int32", data.rune_ids, ret[i][56])
        proto_utils.bytes2repeated("int32", data.rune_nums, ret[i][57])
        proto_utils.bytes2repeated("int32", data.equip_dresses, ret[i][58])
        proto_utils.bytes2repeated("int32", data.equip_dresses_unlock, ret[i][59])
        proto_utils.bytes2repeated("uint64", data.equip_slots, ret[i][60])
        proto_utils.bytes2repeated("int32", data.equip_shows, ret[i][61])
        proto_utils.bytes2repeated("int32", data.equip_enhances, ret[i][62])
        proto_utils.bytes2repeated("int32", data.monsters, ret[i][63])
        proto_utils.bytes2repeated("int32", data.monster_tasks, ret[i][64])
        proto_utils.bytes2repeated("int32", data.monster_nums, ret[i][65])
        proto_utils.bytes2repeated("int32", data.monster_unlocks, ret[i][66])
        proto_utils.bytes2repeated("int32", data.pet_ids, ret[i][67])
        proto_utils.bytes2repeated("int32", data.pet_unlocks, ret[i][68])
        proto_utils.bytes2repeated("int32", data.spell_passive_slots, ret[i][69])
        proto_utils.bytes2repeated("int32", data.rune_slot1s, ret[i][70])
        proto_utils.bytes2repeated("int32", data.rune_slot2s, ret[i][71])
        proto_utils.bytes2repeated("int32", data.rune_slot3s, ret[i][72])
        proto_utils.bytes2repeated("uint64", data.pet_slots, ret[i][73])
        proto_utils.bytes2repeated("int32", data.shop_ids, ret[i][74])
        proto_utils.bytes2repeated("int32", data.shop_nums, ret[i][75])
        proto_utils.bytes2repeated("int32", data.daily_ids, ret[i][76])
        proto_utils.bytes2repeated("int32", data.daily_nums, ret[i][77])
        proto_utils.bytes2repeated("int32", data.daily_reaches, ret[i][78])
        proto_utils.bytes2repeated("int32", data.daily_rewards, ret[i][79])
        proto_utils.bytes2repeated("int32", data.tasks, ret[i][80])
        proto_utils.bytes2repeated("int32", data.task_ids, ret[i][81])
        proto_utils.bytes2repeated("int32", data.task_reaches, ret[i][82])
        proto_utils.bytes2repeated("int32", data.task_ends, ret[i][83])
        data.task_num = ret[i][84]
        proto_utils.bytes2repeated("uint64", data.mail_note, ret[i][85])
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table player_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
