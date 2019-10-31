from pgame.service_base import ServiceBase
import time
import datetime
from tornado.ioloop import IOLoop


# 定时器
class Timer(ServiceBase):
    def init(self):
        self.timer_handler_map = {}
        self.timer_handler_iter = 0
        return 0

    def fini(self):
        for key in self.timer_handler_map:
            tcb = self.timer_handler_map[key]
            tcb.stop()
        self.timer_handler_map = {}
        return 0

    def schedule(self, callback, tick):
        tcb = TimerCallBack(self.PGame, callback, tick)
        tcb.start()
        tid = self.timer_handler_iter
        self.timer_handler_iter += 1
        self.timer_handler_map[tid] = tcb
        return tid

    def cancel(self, tid):
        if tid in self.timer_handler_map.keys():
            tcb = self.timer_handler_map[tid]
            tcb.stop()
            del self.timer_handler_map[tid]

    def now(self):
        return int(time.time() * 1000)

    def hour(self):
        return time.localtime(time.time())[3]

    def weekday(self):
        return int(time.strftime("%w"))

    def day(self):
        return time.localtime(time.time())[2]

    def month(self):
        return time.localtime(time.time())[1]

    def trigger_time(self, old_time, hour, minute):
        new_time = self.now()

        if new_time <= old_time:
            return False

        if new_time - old_time >= 86400000:
            return True

        old_small = self.is_small(old_time, hour, minute)
        new_small = self.is_small(new_time, hour, minute)

        if self.is_same_day(old_time, new_time):
            if old_small and not new_small:
                return True
            else:
                return False
        else:
            if not old_small and not new_small:
                return True
            elif old_small and new_small:
                return True
            else:
                return False

    def trigger_week_time(self, old_time):
        new_time = self.now()

        if new_time <= old_time:
            return False

        if new_time - old_time >= 86400000 * 7:
            return True

        nw = self.get_week(new_time)
        ow = self.get_week(old_time)

        if nw < ow:
            return True
        elif nw == ow:
            if new_time - old_time >= 86400000 * 6:
                return True

        return False

    def trigger_month_time(self, old_time):
        new_time = self.now()

        if new_time < old_time:
            return False

        if new_time - old_time >= 86400000 * 31:
            return True

        nw = time.localtime(new_time / 1000)[1]
        ow = time.localtime(old_time / 1000)[1]

        if nw != ow:
            return True

        return False

    def run_day(self, old_time):
        now_time = self.now()

        if old_time >= now_time:
            return 0

        delta_time = now_time - old_time
        day_num = delta_time / 86400000
        ltime = old_time + day_num * 86400000

        if self.trigger_time(ltime, 0, 0):
            day_num += 1

        return day_num

    def is_same_day(self, old_dt, new_dt):
        if time.localtime(old_dt / 1000)[0] != time.localtime(new_dt / 1000)[0]:
            return False
        elif time.localtime(old_dt / 1000)[1] != time.localtime(new_dt / 1000)[1]:
            return False
        elif time.localtime(old_dt / 1000)[2] != time.localtime(new_dt / 1000)[2]:
            return False

        return True

    def is_small(self, dt, hour, minute):
        if time.localtime(dt / 1000)[3] < hour:
            return True
        elif time.localtime(dt / 1000)[3] == hour:
            if time.localtime(dt / 1000)[4] < minute:
                return True
            else:
                return False

        return False

    def get_week(self, dt):
        week = datetime.datetime(time.localtime(dt / 1000)[0], time.localtime(dt / 1000)[1], time.localtime(dt / 1000)[2]).strftime("%w")
        if week == 0:
            week = 7
        return week


class TimerCallBack:
    def __init__(self, pgame, callback, tick):
        self.PGame = pgame
        self.callback = callback
        self.tick = tick
        self.is_stop = False

    def start(self):
        IOLoop.current().add_timeout(time.time() + self.tick / 1000, self.update)

    def update(self):
        try:
            self.callback()
        except:
            self.PGame.log.trace()
        if not self.is_stop:
            IOLoop.current().add_timeout(time.time() + self.tick / 1000, self.update)

    def stop(self):
        self.is_stop = True
