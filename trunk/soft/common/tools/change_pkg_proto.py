import sys

if __name__ == '__main__':
    if len(sys.argv) > 1:
        fname = sys.argv[1]
        with open(fname, 'r') as f:
            content = f.read()
            flag = True
            start = 0
            while flag:
                flag = False
                i1 = content.find("_pb2 as ", start)
                start = i1 + 21
                if i1 >= 0:
                    flag = True
                    i2 = content.rfind("import", 0, i1)
                    content = content[0:i2 + 7] + "common.proto." + content[i2 + 7:]
        with open(fname, 'w') as f:
            f.write(content)
