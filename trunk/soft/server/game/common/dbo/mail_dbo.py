from common.proto.mail_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into mail_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " receiver_guid = %s,"
    param = param + (req.param.receiver_guid,)
    sql += " sender_date = %s,"
    param = param + (req.param.sender_date,)
    sql += " title = %s,"
    param = param + (req.param.title,)
    sql += " text = %s,"
    param = param + (req.param.text,)
    sql += " sender_name = %s,"
    param = param + (req.param.sender_name,)
    sql += " type = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.type),)
    sql += " value1 = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.value1),)
    sql += " value2 = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.value2),)
    sql += " value3 = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.value3),)
    sql += " creat_time = %s,"
    param = param + (req.param.creat_time,)
    sql += " used = %s,"
    param = param + (req.param.used,)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from mail_t where receiver_guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = mail_t()
        data.guid = ret[i][0]
        data.receiver_guid = ret[i][1]
        data.sender_date = ret[i][2]
        data.title = ret[i][3]
        data.text = ret[i][4]
        data.sender_name = ret[i][5]
        proto_utils.bytes2repeated("int32", data.type, ret[i][6])
        proto_utils.bytes2repeated("int32", data.value1, ret[i][7])
        proto_utils.bytes2repeated("int32", data.value2, ret[i][8])
        proto_utils.bytes2repeated("int32", data.value3, ret[i][9])
        data.creat_time = ret[i][10]
        data.used = ret[i][11]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update mail_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("receiver_guid"):
        sql += " receiver_guid = %s,"
        param = param + (req.param.receiver_guid,)
    if req.param.has_changed("sender_date"):
        sql += " sender_date = %s,"
        param = param + (req.param.sender_date,)
    if req.param.has_changed("title"):
        sql += " title = %s,"
        param = param + (req.param.title,)
    if req.param.has_changed("text"):
        sql += " text = %s,"
        param = param + (req.param.text,)
    if req.param.has_changed("sender_name"):
        sql += " sender_name = %s,"
        param = param + (req.param.sender_name,)
    if req.param.has_changed("type"):
        sql += " type = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.type),)
    if req.param.has_changed("value1"):
        sql += " value1 = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.value1),)
    if req.param.has_changed("value2"):
        sql += " value2 = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.value2),)
    if req.param.has_changed("value3"):
        sql += " value3 = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.value3),)
    if req.param.has_changed("creat_time"):
        sql += " creat_time = %s,"
        param = param + (req.param.creat_time,)
    if req.param.has_changed("used"):
        sql += " used = %s,"
        param = param + (req.param.used,)
    sql = sql.rstrip(",")
    sql += " where guid = %s"
    param = param + (req.param.guid,)

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def remove(db, req):
    sql = "delete from mail_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from mail_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = mail_t()
        data.guid = ret[i][0]
        data.receiver_guid = ret[i][1]
        data.sender_date = ret[i][2]
        data.title = ret[i][3]
        data.text = ret[i][4]
        data.sender_name = ret[i][5]
        proto_utils.bytes2repeated("int32", data.type, ret[i][6])
        proto_utils.bytes2repeated("int32", data.value1, ret[i][7])
        proto_utils.bytes2repeated("int32", data.value2, ret[i][8])
        proto_utils.bytes2repeated("int32", data.value3, ret[i][9])
        data.creat_time = ret[i][10]
        data.used = ret[i][11]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table mail_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
