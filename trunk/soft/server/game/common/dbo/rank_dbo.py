from common.proto.rank_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into rank_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " player_guid = %s,"
    param = param + (proto_utils.repeated2bytes("uint64", req.param.player_guid),)
    sql += " player_name = %s,"
    param = param + (proto_utils.repeated2bytes("string", req.param.player_name),)
    sql += " player_icon = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_icon),)
    sql += " player_level = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_level),)
    sql += " player_data = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.player_data),)
    sql += " last_time = %s,"
    param = param + (req.param.last_time,)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from rank_t where guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = rank_t()
        data.guid = ret[i][0]
        proto_utils.bytes2repeated("uint64", data.player_guid, ret[i][1])
        proto_utils.bytes2repeated("string", data.player_name, ret[i][2])
        proto_utils.bytes2repeated("int32", data.player_icon, ret[i][3])
        proto_utils.bytes2repeated("int32", data.player_level, ret[i][4])
        proto_utils.bytes2repeated("int32", data.player_data, ret[i][5])
        data.last_time = ret[i][6]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update rank_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("player_guid"):
        sql += " player_guid = %s,"
        param = param + (proto_utils.repeated2bytes("uint64", req.param.player_guid),)
    if req.param.has_changed("player_name"):
        sql += " player_name = %s,"
        param = param + (proto_utils.repeated2bytes("string", req.param.player_name),)
    if req.param.has_changed("player_icon"):
        sql += " player_icon = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_icon),)
    if req.param.has_changed("player_level"):
        sql += " player_level = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_level),)
    if req.param.has_changed("player_data"):
        sql += " player_data = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.player_data),)
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
    sql = "delete from rank_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from rank_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = rank_t()
        data.guid = ret[i][0]
        proto_utils.bytes2repeated("uint64", data.player_guid, ret[i][1])
        proto_utils.bytes2repeated("string", data.player_name, ret[i][2])
        proto_utils.bytes2repeated("int32", data.player_icon, ret[i][3])
        proto_utils.bytes2repeated("int32", data.player_level, ret[i][4])
        proto_utils.bytes2repeated("int32", data.player_data, ret[i][5])
        data.last_time = ret[i][6]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table rank_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
