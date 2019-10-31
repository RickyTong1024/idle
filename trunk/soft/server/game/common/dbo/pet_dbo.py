from common.proto.pet_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into pet_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " player_guid = %s,"
    param = param + (req.param.player_guid,)
    sql += " level = %s,"
    param = param + (req.param.level,)
    sql += " exp = %s,"
    param = param + (req.param.exp,)
    sql += " template_id = %s,"
    param = param + (req.param.template_id,)
    sql += " enhance = %s,"
    param = param + (req.param.enhance,)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from pet_t where player_guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = pet_t()
        data.guid = ret[i][0]
        data.player_guid = ret[i][1]
        data.level = ret[i][2]
        data.exp = ret[i][3]
        data.template_id = ret[i][4]
        data.enhance = ret[i][5]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update pet_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("player_guid"):
        sql += " player_guid = %s,"
        param = param + (req.param.player_guid,)
    if req.param.has_changed("level"):
        sql += " level = %s,"
        param = param + (req.param.level,)
    if req.param.has_changed("exp"):
        sql += " exp = %s,"
        param = param + (req.param.exp,)
    if req.param.has_changed("template_id"):
        sql += " template_id = %s,"
        param = param + (req.param.template_id,)
    if req.param.has_changed("enhance"):
        sql += " enhance = %s,"
        param = param + (req.param.enhance,)
    sql = sql.rstrip(",")
    sql += " where guid = %s"
    param = param + (req.param.guid,)

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def remove(db, req):
    sql = "delete from pet_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from pet_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = pet_t()
        data.guid = ret[i][0]
        data.player_guid = ret[i][1]
        data.level = ret[i][2]
        data.exp = ret[i][3]
        data.template_id = ret[i][4]
        data.enhance = ret[i][5]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table pet_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
