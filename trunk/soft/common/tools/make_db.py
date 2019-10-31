import pymysql
import glob
import re
import sys


def get_tables(files):
    tbs = []
    for fname in files:
        with open(fname, 'r') as f:
            lines = f.readlines()
        tb = Table()
        for line in lines:
            a = line.rstrip()
            lin = re.split(" | = |\t", a)
            lin = [item for item in filter(lambda y:y != '', lin)]
            if lin:
                if lin[0] == 'message':
                    tb.set_name(lin[1])
                elif lin[0] == 'optional' or lin[0] == 'required':
                    tb.add_colomn(lin[2], lin[1], int(lin[4].rstrip(";")))
                elif lin[0] == 'repeated':
                    tb.add_colomn(lin[2], 'repeated', int(lin[4].rstrip(";")))
                elif lin[0] == '//using':
                    if lin[1] == 'datetime':
                        tb.add_colomn('dt', 'dt', 9999)
                    elif lin[1] == 'index':
                        tb.add_index(lin[2], int(lin[3]))
                    elif lin[1] == 'auto':
                        tb.add_colomn(lin[2], 'auto', -1)
        tb.make()
        tbs.append(tb)
    return tbs


def exist_table(tb):
    cur.execute('show tables')
    tables = [cur.fetchall()]
    table_list = re.findall('(\'.*?\')', str(tables))
    table_list = [re.sub("'", '', each) for each in table_list]
    if tb.name in table_list:
        return True
    else:
        return False


def get_colomns(tb):
    colomns = []
    cur.execute("desc " + tb.name)
    rows = cur.fetchall()
    for row in rows:
        colomns.append(row[0])
    return colomns


def type_to_sql(data_type):
    if data_type == "int32" or data_type == "uint32":
        return "int not null default 0"
    elif data_type == "int64" or data_type == "uint64":
        return "bigint not null default 0"
    elif data_type == "string":
        return "text"
    elif data_type == "bytes" or data_type == "repeated":
        return "mediumblob"
    elif data_type == "dt":
        return "timestamp not null default now()"
    elif data_type == "double":
        return "double not null default 0"
    elif data_type == "auto":
        return "int not null AUTO_INCREMENT"


def add_col(tb, col, last_col):
    sql = "alter table " + tb.name + " add " + col.name
    sql += " " + type_to_sql(col.data_type)
    sql += " after " + last_col.name + ";"
    cur.execute(sql)


def del_col(tb, col_name):
    sql = "alter table " + tb.name + " drop " + col_name
    cur.execute(sql)


def deal_table(tb):
    print(tb.name)
    if exist_table(tb):
        colomns = get_colomns(tb)
        for i in range(len(colomns)):
            flag = False
            for j in range(len(tb.colomns)):
                if colomns[i] == tb.colomns[j].name:
                    flag = True
                    break
            if not flag:
                del_col(tb, colomns[i])

        for i in range(len(tb.colomns)):
            flag = False
            for j in range(len(colomns)):
                if tb.colomns[i].name == colomns[j]:
                    flag = True
                    break
            if not flag:
                add_col(tb, tb.colomns[i], tb.colomns[i - 1])
    else:
        sql1 = ""
        for i in range(len(tb.colomns)):
            col = tb.colomns[i]
            sql1 += col.name + " " + type_to_sql(col.data_type) + ", "
        for i in range(len(tb.indexes)):
            index = tb.indexes[i]
            sql1 += "index " + index.name + "_index" + "(" + index.name
            if index.length > 0:
                sql1 += "(" + str(index.length) + ")"
            sql1 += "), "
        sql1 += "primary key(" + tb.colomns[0].name + ")" 
        sql = "create table " + tb.name + "(" + sql1 + ") ENGINE = InnoDB default charset = utf8mb4"
        print(sql)
        cur.execute(sql)


class TableColomn:
    def __init__(self, name, data_type, index):
        self.name = name
        self.data_type = data_type
        self.index = index


class TableIndex:
    def __init__(self, name, length):
        self.name = name
        self.length = length


class Table:
    def __init__(self):
        self.name = None
        self.colomns = []
        self.indexes = []

    def set_name(self, name):
        self.name = name

    def add_colomn(self, name, data_type, index):
        self.colomns.append(TableColomn(name, data_type, index))

    def add_index(self, name, length):
        self.indexes.append(TableIndex(name, length))

    def make(self):
        self.colomns = sorted(self.colomns, key=lambda t:t.index)


if __name__ == '__main__':
    print(sys.argv[1] + "/*_db.proto")
    if len(sys.argv) > 1:
        files = glob.glob(sys.argv[1] + "/*_db.proto")
        conn = pymysql.connect(user='root', passwd='root', db='loot')
        conn.autocommit(1)
        cur = conn.cursor()   
        tbs = get_tables(files)
        for i in range(len(tbs)):
            tb = tbs[i]
            deal_table(tb)       
        cur.close()
        conn.close()
