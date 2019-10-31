import sys
import re

if __name__ == '__main__':
    if len(sys.argv) > 2:
        dicts = []
        fname1 = sys.argv[2]
        with open(fname1, 'r') as f:
            lines = f.readlines()
        for line in lines:
            a = line.rstrip()
            lin = re.split(" | = |\t", a)
            lin = [item for item in filter(lambda y:y !=  '', lin)]
            if lin != []:
                if lin[0] == '//using':
                    if lin[1] == 'dict':
                        dicts.append(lin[2])
        fname = sys.argv[1]
        with open(fname, 'r') as f:
            content = f.read()
            i1 = content.find("full_name='dhc.")
            i1 += 15
            i2 = content.find("'", i1)
            cname = content[i1:i2]
        with open(fname, 'a+') as f:
            f.write("\n")
            f.write("%s_tmp = %s\n" % (cname, cname,))
            f.write("\n")
            f.write("from pgame.utils import proto_utils\n")
            f.write("class %s(proto_utils.object_t_db):\n" % (cname + "_db",))
            f.write("   def __init__(self):\n")
            f.write("      proto_utils.object_t_db.__init__(self, %s)\n" % (cname + "_tmp",))
            f.write("      self.children = [\n")
            for i in range(len(dicts)):
                f.write("            '%s',\n" % (dicts[i],))
            f.write("         ]\n")
            for i in range(len(dicts)):
                f.write("      self.%s = {}\n" % (dicts[i],))
            f.write("\n")
            f.write("proto_utils.make_db_proto(%s, %s)\n" % (cname + "_db", cname + "_tmp",))
            f.write("\n")
            f.write("%s = %s\n" % (cname, cname + "_db",))
