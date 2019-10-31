

def insert(db, req):

    sql = 'insert into log_t (id, username, serverid, player_guid, log_tp, tp, value1, value2, value3, way, op, dt) values (0, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())'
    param = (req.param[0], req.param[1], req.param[2], req.param[3], req.param[4], req.param[5], req.param[6], req.param[7], req.param[8], req.param[9], )

    cur = db.cursor()
    cur.execute(sql, param)
    db.commit()
    cur.close()
    return 0
