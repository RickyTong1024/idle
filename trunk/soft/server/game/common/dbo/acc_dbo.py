from common.proto.acc_db_pb2 import *
from common import guid_tool
from pgame.service import PGame


def query(db, req):
    sql = "select guid, username, serverid, fenghao_time from acc_t where username = %s and serverid = %s"
    param = (req.param[2], req.param[3],)

    cur = db.cursor()
    cur.execute(sql, param)
    ret = cur.fetchall()
    data = acc_t()
    if len(ret) == 0:
        data.guid = req.param[1]
        data.username = req.param[2]
        data.serverid = req.param[3]
        data.fenghao_time = 0

        param = ()
        sql = "insert into acc_t set"
        sql += " guid = %s,"
        param = param + (data.guid,)
        sql += " username = %s,"
        param = param + (req.param[2],)
        sql += " serverid = %s,"
        param = param + (req.param[3],)
        sql += " fenghao_time = %s,"
        param = param + (0,)
        sql += " last_time = %s,"
        param = param + (PGame.timer.now(),)
        sql = sql.rstrip(",")
        cur = db.cursor()
        cur.execute(sql, param)
    else:
        data.guid = ret[0][0]
        data.username = ret[0][1]
        data.serverid = ret[0][2]
        data.fenghao_time = ret[0][3]

        sql = 'update acc_t set last_time = %s where guid = %s'
        param = (PGame.timer.now(), data.guid,)
        cur.execute(sql, param)
    req.add_data(data)
    db.commit()
    cur.close()
    return 0
