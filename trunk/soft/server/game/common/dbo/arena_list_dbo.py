from common.proto.arena_list_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into arena_list_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " player_guids = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.player_guids),)
    sql += " player_names = %s,"
    param = param + (proto_utils.repeated2bytes("string", req.param.player_names),)
    sql += " player_levels = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_levels),)
    sql += " player_icons = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_icons),)
    sql += " player_segments = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_segments),)
    sql += " is_npc = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.is_npc),)
    sql += " player_powers = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_powers),)
    sql += " last_time = %s,"
    param = param + (req.param.last_time,)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from arena_list_t where guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = arena_list_t()
        data.guid = ret[i][0]
        proto_utils.bytes2repeated("uint64", data.player_guids, ret[i][1])
        proto_utils.bytes2repeated("string", data.player_names, ret[i][2])
        proto_utils.bytes2repeated("int32", data.player_levels, ret[i][3])
        proto_utils.bytes2repeated("int32", data.player_icons, ret[i][4])
        proto_utils.bytes2repeated("int32", data.player_segments, ret[i][5])
        proto_utils.bytes2repeated("int32", data.is_npc, ret[i][6])
        proto_utils.bytes2repeated("int32", data.player_powers, ret[i][7])
        data.last_time = ret[i][8]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update arena_list_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("player_guids"):
        sql += " player_guids = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.player_guids),)
    if req.param.has_changed("player_names"):
        sql += " player_names = %s,"
        param = param + (proto_utils.repeated2bytes("string", req.param.player_names),)
    if req.param.has_changed("player_levels"):
        sql += " player_levels = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_levels),)
    if req.param.has_changed("player_icons"):
        sql += " player_icons = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_icons),)
    if req.param.has_changed("player_segments"):
        sql += " player_segments = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_segments),)
    if req.param.has_changed("is_npc"):
        sql += " is_npc = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.is_npc),)
    if req.param.has_changed("player_powers"):
        sql += " player_powers = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_powers),)
    if req.param.has_changed("last_time"):
        sql += " last_time = %s,"
        param = param + (req.param.last_time,)
    sql = sql.rstrip(",")
    sql += " where guid = %s"
    param = param + (req.param.guid,)

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def remove(db, req):
    sql = "delete from arena_list_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from arena_list_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = arena_list_t()
        data.guid = ret[i][0]
        proto_utils.bytes2repeated("uint64", data.player_guids, ret[i][1])
        proto_utils.bytes2repeated("string", data.player_names, ret[i][2])
        proto_utils.bytes2repeated("int32", data.player_levels, ret[i][3])
        proto_utils.bytes2repeated("int32", data.player_icons, ret[i][4])
        proto_utils.bytes2repeated("int32", data.player_segments, ret[i][5])
        proto_utils.bytes2repeated("int32", data.is_npc, ret[i][6])
        proto_utils.bytes2repeated("int32", data.player_powers, ret[i][7])
        data.last_time = ret[i][8]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table arena_list_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
