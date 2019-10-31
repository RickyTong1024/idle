import os
import sys
from shutil import copy

def conv_UTF8(fdir):
    files = os.listdir ('./')

    for f in files:
        if os.path.splitext (f)[1] == '.txt':
            print(f)
            ifs = open(f,'rb')
            try:
                content = ifs.read ().decode('gbk').encode('utf8')
                ifs.close()
                ofs = None
                if len(content) > 0:
                    try:
                        ofs = open(fdir + f, 'wb')
                        ofs.write(content)
                    finally:
                        if ofs:
                            ofs.close ()
            finally:
                ifs.close ()

if __name__ == '__main__':
    if len(sys.argv) > 0:
        conv_UTF8 (sys.argv[1])
