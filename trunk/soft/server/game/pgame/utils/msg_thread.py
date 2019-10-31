#!/usr/bin/env python  
#coding=utf-8

import threading


class MsgThread(threading.Thread):
    def __init__(self, queue_num):
        threading.Thread.__init__(self)
        self.queues = list()
        self.locks = list()
        for i in range(queue_num):
            self.queues.append([])
            self.locks.append(threading.Lock())
        self.isstop = False

    def add_queue(self, index, s):
        self.locks[index].acquire()
        self.queues[index].append(s)
        self.locks[index].release()

    def get_queue(self, index):
        self.locks[index].acquire()
        tins = list(self.queues[index])
        self.queues[index] = []
        self.locks[index].release()
        return tins
    
    def stop(self):
        self.isstop = True
