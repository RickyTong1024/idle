#!/usr/bin/env python
# coding=utf-8
import struct
import zlib


class Packet:
    HSIZE = 12
    MAX_PCK_SIZE = 512
    COMPRESS_SIZE = 512

    def __init__(self, opcode=0, hid=0, msg=None):
        self.compress = False
        self.opcode = opcode
        self.hid = hid
        if msg is None:
            self.msg = bytes()
        else:
            self.msg = msg
        self.size = len(self.msg)

    def from_bytes(self, chunk, checkmax=True):
        if len(chunk) < self.HSIZE:
            return 0
        self.compress, self.opcode, hid, self.size = struct.unpack("?HiI", chunk[:self.HSIZE])
        if checkmax and self.size > self.MAX_PCK_SIZE:
            return -1
        total_size = self.HSIZE + self.size
        if len(chunk) < total_size:
            return 0
        self.msg = chunk[self.HSIZE:total_size]
        if self.compress:
            self.msg = zlib.decompress(self.msg)
            self.size = len(self.msg)
            self.compress = False
        return total_size

    def to_bytes(self):
        if self.size >= self.COMPRESS_SIZE:
            self.msg = zlib.compress(self.msg)
            self.size = len(self.msg)
            self.compress = True
        return struct.pack("?HiI%ds" % (self.size,), self.compress, self.opcode, self.hid, self.size, self.msg)


class RpcPacket:
    RP_REQUEST = 0
    RP_PUSH = 1
    RP_RESPONSE = 2

    HSIZE = 20

    def __init__(self, opcode=0, hid=0, msg=None):
        self.tp = 0
        self.opcode = opcode
        self.hid = hid
        if msg is None:
            self.msg = bytes()
        else:
            self.msg = msg
        self.size = len(self.msg)
        self.pid = 0
        self.sname = b''
        self.addr = b''
        self.addr_size = 0  

    def set_addr(self, addr):
        self.addr = addr.encode('utf-8')
        self.addr_size = len(self.addr)

    def get_addr(self):
        return self.addr.decode()

    def from_bytes(self, chunk):
        if len(chunk) < self.HSIZE:
            return 0
        self.tp, self.opcode, self.hid, self.pid, self.size, self.addr_size = struct.unpack("HHiIII", chunk[:self.HSIZE])
        total_size = self.HSIZE + self.size + self.addr_size
        if len(chunk) < total_size:
            return 0
        self.msg = chunk[self.HSIZE:self.HSIZE + self.size]
        self.addr = chunk[self.HSIZE + self.size:total_size]
        return total_size

    def to_bytes(self):
        return struct.pack("HHiIII%ds%ds" % (self.size, self.addr_size,), self.tp, self.opcode, self.hid, self.pid, self.size, self.addr_size, self.msg, self.addr)
