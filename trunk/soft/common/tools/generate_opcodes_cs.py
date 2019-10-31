#!/usr/bin/env python
#coding=utf-8

import sys


ofile_path = '..\..\server\game\common\opcodes.py'


def main(python_path):
    ofile = open(ofile_path, "r", encoding='UTF-8')
    opy = open(python_path, "w")
    l = 0
    cnt = False

    for line in ofile:
        index = line.find('=')
        if index != -1:
            index2 = line.find('#')
            if index2 != -1:
                line = line[:index2]
            index1 = line.find('=')

            if index1 != -1:
                ss = line.split('=')
                line = ss[0]
                s = ss[1]
                s = s.replace(',', '')
                s = s.replace(' ', '')
                s = s.replace('\t', '')
                s = s.replace('\n', '')
                s = s.replace('\r', '')
                l = int(s)
            else:
                l = l + 1

            line = line.replace(',', '')
            line = line.replace(' ', '')
            line = line.replace('\t', '')
            line = line.replace('\n', '')
            line = line.replace('\r', '')
            if line == "":
                continue
            print(line, l)
            opy.write('\t%s = %d,\n' % (line, l))
        else:
            index = line.find('class')
            if index != -1:
                if cnt:
                    opy.write('};\n\n\n')
                cnt = True
                index = line.find(' ')
                if index != -1:
                    line = line[index + 1:]
                index = line.find(':')
                if index != -1:
                    line = line[:index]
                line = line.lower()
                line = 'public enum ' + line + '_t\n{\n'
                opy.write(line)
    opy.write('};\n')
    opy.close()


if __name__ == '__main__':
    if len(sys.argv) >= 2:
        for i in range(len(sys.argv) - 1):
            python_path = sys.argv[i + 1]
            main(python_path)
