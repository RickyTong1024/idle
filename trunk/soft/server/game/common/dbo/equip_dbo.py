from common.proto.equip_db_pb2 import *
from pgame.utils import proto_utils


def insert(db, req):
    param = ()
    sql = "insert into equip_t set"
    sql += " guid = %s,"
    param = param + (req.param.guid,)
    sql += " player_guid = %s,"
    param = param + (req.param.player_guid,)
    sql += " template_id = %s,"
    param = param + (req.param.template_id,)
    sql += " level = %s,"
    param = param + (req.param.level,)
    sql += " enchant_id = %s,"
    param = param + (req.param.enchant_id,)
    sql += " enchant_value = %s,"
    param = param + (req.param.enchant_value,)
    sql += " enchant_count = %s,"
    param = param + (req.param.enchant_count,)
    sql += " attr = %s,"
    param = param + (req.param.attr,)
    sql += " value = %s,"
    param = param + (req.param.value,)
    sql += " color = %s,"
    param = param + (req.param.color,)
    sql += " percent = %s,"
    param = param + (req.param.percent,)
    sql += " attr_types = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.attr_types),)
    sql += " attr_ids = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.attr_ids),)
    sql += " attr_values = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.attr_values),)
    sql += " attr_colors = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.attr_colors),)
    sql += " attr_pers = %s,"
    param = param + (proto_utils.repeated2bytes("int32", req.param.attr_pers),)
    sql += " reforge_count = %s,"
    param = param + (req.param.reforge_count,)
    sql = sql.rstrip(",")

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query(db, req):
    sql = "select * from equip_t where player_guid = %s"
    param = (req.param[1],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = equip_t()
        data.guid = ret[i][0]
        data.player_guid = ret[i][1]
        data.template_id = ret[i][2]
        data.level = ret[i][3]
        data.enchant_id = ret[i][4]
        data.enchant_value = ret[i][5]
        data.enchant_count = ret[i][6]
        data.attr = ret[i][7]
        data.value = ret[i][8]
        data.color = ret[i][9]
        data.percent = ret[i][10]
        proto_utils.bytes2repeated("int32", data.attr_types, ret[i][11])
        proto_utils.bytes2repeated("int32", data.attr_ids, ret[i][12])
        proto_utils.bytes2repeated("int32", data.attr_values, ret[i][13])
        proto_utils.bytes2repeated("int32", data.attr_colors, ret[i][14])
        proto_utils.bytes2repeated("int32", data.attr_pers, ret[i][15])
        data.reforge_count = ret[i][16]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def update(db, req):
    param = ()
    sql = "update equip_t set"
    if req.param.has_changed("guid"):
        sql += " guid = %s,"
        param = param + (req.param.guid,)
    if req.param.has_changed("player_guid"):
        sql += " player_guid = %s,"
        param = param + (req.param.player_guid,)
    if req.param.has_changed("template_id"):
        sql += " template_id = %s,"
        param = param + (req.param.template_id,)
    if req.param.has_changed("level"):
        sql += " level = %s,"
        param = param + (req.param.level,)
    if req.param.has_changed("enchant_id"):
        sql += " enchant_id = %s,"
        param = param + (req.param.enchant_id,)
    if req.param.has_changed("enchant_value"):
        sql += " enchant_value = %s,"
        param = param + (req.param.enchant_value,)
    if req.param.has_changed("enchant_count"):
        sql += " enchant_count = %s,"
        param = param + (req.param.enchant_count,)
    if req.param.has_changed("attr"):
        sql += " attr = %s,"
        param = param + (req.param.attr,)
    if req.param.has_changed("value"):
        sql += " value = %s,"
        param = param + (req.param.value,)
    if req.param.has_changed("color"):
        sql += " color = %s,"
        param = param + (req.param.color,)
    if req.param.has_changed("percent"):
        sql += " percent = %s,"
        param = param + (req.param.percent,)
    if req.param.has_changed("attr_types"):
        sql += " attr_types = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.attr_types),)
    if req.param.has_changed("attr_ids"):
        sql += " attr_ids = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.attr_ids),)
    if req.param.has_changed("attr_values"):
        sql += " attr_values = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.attr_values),)
    if req.param.has_changed("attr_colors"):
        sql += " attr_colors = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.attr_colors),)
    if req.param.has_changed("attr_pers"):
        sql += " attr_pers = %s,"
        param = param + (proto_utils.repeated2bytes("int32", req.param.attr_pers),)
    if req.param.has_changed("reforge_count"):
        sql += " reforge_count = %s,"
        param = param + (req.param.reforge_count,)
    sql = sql.rstrip(",")
    sql += " where guid = %s"
    param = param + (req.param.guid,)

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def remove(db, req):
    sql = "delete from equip_t where guid = %s"
    param = (req.param,)
    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0


def query_all(db, req):
    sql = "select * from equip_t"

    cur = db.cursor()
    cur.execute(sql)
    ret = cur.fetchall()
    for i in range(len(ret)):
        data = equip_t()
        data.guid = ret[i][0]
        data.player_guid = ret[i][1]
        data.template_id = ret[i][2]
        data.level = ret[i][3]
        data.enchant_id = ret[i][4]
        data.enchant_value = ret[i][5]
        data.enchant_count = ret[i][6]
        data.attr = ret[i][7]
        data.value = ret[i][8]
        data.color = ret[i][9]
        data.percent = ret[i][10]
        proto_utils.bytes2repeated("int32", data.attr_types, ret[i][11])
        proto_utils.bytes2repeated("int32", data.attr_ids, ret[i][12])
        proto_utils.bytes2repeated("int32", data.attr_values, ret[i][13])
        proto_utils.bytes2repeated("int32", data.attr_colors, ret[i][14])
        proto_utils.bytes2repeated("int32", data.attr_pers, ret[i][15])
        data.reforge_count = ret[i][16]
        req.add_data(data)
    db.commit()
    cur.close()
    return 0


def remove_all(db, req):
    sql = "truncate table equip_t"
    cur = db.cursor()
    cur.execute(sql)
    db.commit()
    cur.close()
    return 0
