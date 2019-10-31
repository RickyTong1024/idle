import re
import sys


def get_table(fname):
    with open(fname, 'r') as f:
        lines = f.readlines()
    tb = Table()
    for line in lines:
        a = line.rstrip()
        lin = re.split(" | = |\t", a)
        lin = [item for item in filter(lambda y:y != '', lin)]
        if lin != []:
            if lin[0] == 'message':
                tb.set_name(lin[1])
            elif lin[0] == 'optional' or lin[0] == 'required':
                tb.add_colomn(lin[2], lin[1], int(lin[4].rstrip(";")))
            elif lin[0] == 'repeated':
                tb.add_colomn(lin[2], lin[1], int(lin[4].rstrip(";")), True)
            elif lin[0] == '//using':
                if lin[1] == 'datetime':
                    tb.add_colomn('dt', 'dt', 9999)
                elif lin[1] == 'load':
                    tb.load = lin[2]
    tb.make()
    return tb


def deal_table(tb, path):
    name = tb.name.rstrip("t").rstrip("_")
    fname = path + '\%s_dbo.py' % (name,)
    with open(fname, 'w') as f:
        f.write('from common.proto.%s_db_pb2 import *\n' % (name,))
        f.write('from pgame.utils import proto_utils\n')
        f.write('\n\n')

        f.write('def insert(db, req):\n')
        f.write('    param = ()\n')
        f.write('    sql = "insert into %s_t set"\n' % (name,))
        for i in range(len(tb.colomns)):
            col = tb.colomns[i]
            f.write('    sql += " %s = %%s,"\n' % (col.name,))
            if not col.is_repeated:
                f.write('    param = param + (req.param.%s,)\n' % (col.name,))
            else:
                f.write('    param = param + (proto_utils.repeated2bytes("%s", req.param.%s),)\n' % (col.data_type, col.name,))
        f.write('    sql = sql.rstrip(",")\n')
        f.write('\n')
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql, param)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')
        f.write('\n\n')

        f.write('def query(db, req):\n')
        f.write('    sql = "select * from %s_t where %s = %%s"\n' % (name, tb.load,))
        f.write('    param = (req.param[1],)\n')
        f.write('\n')
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql, param)\n')
        f.write('    ret = cur.fetchall()\n')
        f.write('    for i in range(len(ret)):\n')
        f.write('        data = %s_t()\n' % (name,))
        for i in range(len(tb.colomns)):
            col = tb.colomns[i]
            if not col.is_repeated:
                f.write('        data.%s = ret[i][%d]\n' % (col.name, i,))
            else:
                f.write('        proto_utils.bytes2repeated("%s", data.%s, ret[i][%d])\n' % (col.data_type, col.name, i,))
            
        f.write('        req.add_data(data)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')
        f.write('\n\n')

        f.write('def update(db, req):\n')
        f.write('    param = ()\n')
        f.write('    sql = "update %s_t set"\n' % (name,))
        for i in range(len(tb.colomns)):
            col = tb.colomns[i]
            f.write('    if req.param.has_changed("%s"):\n' % (col.name,))
            f.write('        sql += " %s = %%s,"\n' % (col.name,))
            if not col.is_repeated:
                f.write('        param = param + (req.param.%s,)\n' % (col.name,))
            else:
                f.write('        param = param + (proto_utils.repeated2bytes("%s", req.param.%s),)\n' % (col.data_type, col.name,))
        f.write('    sql = sql.rstrip(",")\n')
        f.write('    sql += " where guid = %s"\n')
        f.write('    param = param + (req.param.guid,)\n')
        f.write('\n')
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql, param)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')
        f.write('\n\n')

        f.write('def remove(db, req):\n')
        f.write('    sql = "delete from %s_t where guid = %%s"\n' % name)
        f.write('    param = (req.param,)\n')
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql, param)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')
        f.write('\n\n')

        f.write('def query_all(db, req):\n')
        f.write('    sql = "select * from %s_t"\n'  % name)
        f.write('\n')
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql)\n')
        f.write('    ret = cur.fetchall()\n')
        f.write('    for i in range(len(ret)):\n')
        f.write('        data = %s_t()\n' % (name,))
        for i in range(len(tb.colomns)):
            col = tb.colomns[i]
            if not col.is_repeated:
                f.write('        data.%s = ret[i][%d]\n' % (col.name, i,))
            else:
                f.write(
                    '        proto_utils.bytes2repeated("%s", data.%s, ret[i][%d])\n' % (col.data_type, col.name, i,))

        f.write('        req.add_data(data)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')
        f.write('\n\n')

        f.write('def remove_all(db, req):\n')
        f.write('    sql = "truncate table %s_t"\n' % name)
        f.write('    cur = db.cursor()\n')
        f.write('    cur.execute(sql)\n')
        f.write('    db.commit()\n')
        f.write('    cur.close()\n')
        f.write('    return 0\n')


class TableColomn:
    def __init__(self, name, data_type, index, is_repeated):
        self.name = name
        self.data_type = data_type
        self.index = index
        self.is_repeated = is_repeated


class Table:
    def __init__(self):
        self.name = None
        self.colomns = []
        self.indexes = []
        self.load = 'guid'

    def set_name(self, name):
        self.name = name

    def add_colomn(self, name, data_type, index, is_repeated=False):
        self.colomns.append(TableColomn(name, data_type, index, is_repeated))

    def make(self):
        self.colomns = sorted(self.colomns, key=lambda t:t.index)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        tb = get_table(sys.argv[1])
        deal_table(tb, sys.argv[2])
