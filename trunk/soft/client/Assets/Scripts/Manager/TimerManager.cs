using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using LuaInterface;

public class TimerSub {
    public string name;
    public float time;
    public LuaFunction luafunc;
    public LuaTable param;
    public Action func;
    public bool runInLua;
    public float n = 0;
}

public class TimerRepeatSub {
    public string name;
    public float time;
    public float repeatRate;
    public LuaFunction luafunc;
    public LuaTable param;
    public Action func;
    public bool runInLua;
    public float n = 0;
    public bool first = true;
}


public class TimerManager : MonoBehaviour {
    private Dictionary<string, TimerSub> m_timersubs = new Dictionary<string, TimerSub>();
    private Dictionary<string, TimerRepeatSub> m_timerresubs = new Dictionary<string, TimerRepeatSub>();

    static long dtime_;
    static long dtime1_;
    private System.DateTime ydt_ = System.DateTime.Parse("1/1/1970");
    [Range(0.1f, 10f)]
    public float m_time_scale = 1f;
    public float m_action_time_scale = 1f;
    public float m_action_time_scale_time = 0;

    public void AddTimer(string name, Action ac, float time) {
        TimerSub ts = new TimerSub();
        ts.name = name;
        ts.luafunc = null;
        ts.param = null;
        ts.runInLua = false;
        ts.func = ac;
        ts.time = time;
        m_timersubs[name] = ts;
    }

    public void AddTimer(string name, LuaFunction luafunc, LuaTable param, float time) {
        TimerSub ts = new TimerSub();
        ts.name = name;
        ts.luafunc = luafunc;
        ts.param = param;
        ts.runInLua = true;
        ts.func = null;
        ts.time = time;
        m_timersubs[name] = ts;
    }

    public void RemoveTimer(string name) {
        if (m_timersubs.ContainsKey(name)) {
            if (m_timersubs[name].luafunc != null) {
                m_timersubs[name].luafunc.Dispose();
                m_timersubs[name].luafunc = null;
            }
            if ((m_timersubs[name].param != null)) {
                m_timersubs[name].param.Dispose();
                m_timersubs[name].param = null;
            }
            m_timersubs.Remove(name);
        }      
    }

    public void AddRepeatTimer(string name, LuaFunction luafunc, LuaTable param,float time, float rep) {
        if (!m_timerresubs.ContainsKey(name))
        {
            TimerRepeatSub ts = new TimerRepeatSub();
            ts.name = name;
            ts.luafunc = luafunc;
            ts.param = param;
            ts.func = null;
            ts.runInLua = true;
            ts.time = time;
            ts.repeatRate = rep;
            m_timerresubs[name] = ts;
        }
    }

    public void AddRepeatTimer(string name, Action ac, float time, float rep) {
        TimerRepeatSub ts = new TimerRepeatSub();
        ts.name = name;
        ts.luafunc = null;
        ts.param = null;
        ts.func = ac;
        ts.runInLua = false;
        ts.time = time;
        ts.repeatRate = rep;
        m_timerresubs[name] = ts;
    }

    public void RemoveRepeatTimer(string name) {
        if (m_timerresubs.ContainsKey(name)) {
            if (m_timerresubs[name].luafunc != null) {
                m_timerresubs[name].luafunc.Dispose();
                m_timerresubs[name].luafunc = null;
            }
            if (m_timerresubs[name].param != null) {
                m_timerresubs[name].param.Dispose();
                m_timerresubs[name].param = null;
            }
            m_timerresubs.Remove(name);
        }
    }

    public void SetTimeScale(float s)
    {
        m_time_scale = s;
        Time.timeScale = m_time_scale * m_action_time_scale;
    }

    public void ActionTimeScale(float s, float t)
    {
        m_action_time_scale = s;
        m_action_time_scale_time = t;
        Time.timeScale = m_time_scale * m_action_time_scale;
    }

    List<string> dnames = new List<string>();
    List<TimerSub> tss = new List<TimerSub>();
    List<TimerRepeatSub> trs = new List<TimerRepeatSub>();


    void Update() {
        Time.timeScale = m_time_scale * m_action_time_scale;
        if (m_action_time_scale_time > 0)
        {
            m_action_time_scale_time -= Time.deltaTime;
            if (m_action_time_scale_time <= 0)
            {
                m_action_time_scale = 1f;
            }
        }
        dnames.Clear();
        if (m_timersubs.Count > 0) {
            tss.Clear();
            foreach (TimerSub ts in m_timersubs.Values) {
                tss.Add(ts);
            }
            for (int i = 0; i < tss.Count; ++i) {
                TimerSub ts = tss[i];
                ts.n += Time.deltaTime;
                if (ts.n > ts.time) {
                    if (ts.runInLua)
                        ts.luafunc.Call(ts.param);
                    else
                        ts.func();
                    dnames.Add(ts.name);
                }
            }
        }
        for (int i = 0; i < dnames.Count; ++i) {
            //m_timersubs.Remove(dnames[i]);
            RemoveTimer(dnames[i]);
        }

        if (m_timerresubs.Count > 0) {
            trs.Clear();
            foreach (TimerRepeatSub ts in m_timerresubs.Values) {
                trs.Add(ts);
            }
            for (int i = 0; i < trs.Count; ++i) {
                TimerRepeatSub ts = trs[i];
                ts.n += Time.deltaTime;
                if (ts.first) {
                    if (ts.n > ts.time) {
                        ts.n = 0;
                        ts.first = false;
                        if (ts.runInLua)
                            ts.luafunc.Call(ts.param);
                        else
                            ts.func();
                    }
                }
                else {
                    if (ts.n > ts.repeatRate) {
                        ts.n = 0;
                        if (ts.runInLua)
                            ts.luafunc.Call(ts.param);
                        else
                            ts.func();
                    }
                }
            }
        }
    }

    ////////////////////////////////////////////

    public void set_server_time(ulong server_time) {
        dtime_ = System.DateTime.Now.Ticks / 10000 - (long)server_time;
        dtime1_ = (System.DateTime.Now.Ticks - System.DateTime.Parse("1/1/1970").Ticks) / 10000 - 28800000 - (long)server_time;
    }

    public void set_server_time(string server_time) {
        dtime_ = System.DateTime.Now.Ticks / 10000 - long.Parse(server_time);
        dtime1_ = (System.DateTime.Now.Ticks - System.DateTime.Parse("1/1/1970").Ticks) / 10000 - 28800000 - long.Parse(server_time);
    }
    public System.DateTime dtnow() {
        return System.DateTime.Now.AddTicks(-dtime1_ * 10000);
    }

    public ulong now() {
        return (ulong)(System.DateTime.Now.Ticks / 10000 - dtime_);
    }

    public string now_string() {
        return now().ToString();
    }
    public ulong native_now() {
        return (ulong)(System.DateTime.Now.Ticks / 10000);
    }

    public System.DateTime time2dt(ulong time) {
        long tm = (long)(time + 28800000) * 10000;
        return ydt_.AddTicks(tm);
    }

    public DateTime get_time_show(string time) {
        long ticks = (long.Parse(time) + dtime_) * 10000;
        System.DateTime dt = new DateTime(ticks);
        return dt;
    }
    public DateTime GetTime(string timeStamp) {
        DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
        long lTime = long.Parse(timeStamp + "0000000");
        TimeSpan toNow = new TimeSpan(lTime);
        return dtStart.Add(toNow);
    }
    public int last_time_today() {
        System.DateTime dt = System.DateTime.Parse(dtnow().ToShortDateString() + " 23:59:59");
        long tick = (dt.Ticks - dtnow().Ticks) / 10000;
        tick = tick % 86400000;
        return (int)tick;
    }

    public bool trigger_time(ulong old_time, int hour, int minute) {
        System.DateTime old_dt = time2dt(old_time);
        ulong new_time = now();
        System.DateTime new_dt = time2dt(new_time);

        if (new_time <= old_time) {
            return false;
        }

        if (new_time - old_time >= 86400000) {
            return true;
        }

        bool old_small = is_small(old_dt, hour, minute);
        bool new_small = is_small(new_dt, hour, minute);

        if (is_same_day(old_dt, new_dt)) {
            if (old_small && !new_small) {
                return true;
            }
            else {
                return false;
            }
        }
        else {
            if (!old_small && !new_small) {
                return true;
            }
            else if (old_small && new_small) {
                return true;
            }
            else {
                return false;
            }
        }
    }

    public bool trigger_week_time(ulong old_time) {
        System.DateTime old_dt = time2dt(old_time);
        ulong new_time = now();
        System.DateTime new_dt = time2dt(new_time);

        if (new_time <= old_time) {
            return false;
        }

        if (new_time - old_time >= 86400000 * 7) {
            return true;
        }

        int nw = (int)new_dt.DayOfWeek;
        if (nw == 0) {
            nw = 7;
        }
        int ow = (int)old_dt.DayOfWeek;
        if (ow == 0) {
            ow = 7;
        }

        if (nw < ow) {
            return true;
        }
        else if (nw == ow) {
            if (new_time - old_time >= 86400000 * 6) {
                return true;
            }
        }

        return false;
    }

    public bool trigger_month_time(ulong old_time) {
        System.DateTime old_dt = time2dt(old_time);
        ulong new_time = now();
        System.DateTime new_dt = time2dt(new_time);

        if (new_time <= old_time) {
            return false;
        }

        if (new_time - old_time >= 86400000L * 31) {
            return true;
        }

        int nw = new_dt.Month;
        int ow = old_dt.Month;

        if (nw != ow) {
            return true;
        }

        return false;
    }

    private bool is_same_day(System.DateTime old_dt, System.DateTime new_dt) {
        if (old_dt.Year != new_dt.Year) {
            return false;
        }
        else if (old_dt.Month != new_dt.Month) {
            return false;
        }
        else if (old_dt.Day != new_dt.Day) {
            return false;
        }
        return true;
    }

    private bool is_small(System.DateTime dt, int hour, int minute) {
        if (dt.Hour < hour) {
            return true;
        }
        else if (dt.Hour == hour) {
            if (dt.Minute < minute) {
                return true;
            }
            else {
                return false;
            }
        }
        return false;
    }

    public int run_day(ulong old_time) {
        ulong now_time = now();
        if (old_time >= now_time) {
            return 0;
        }
        ulong delta_time = now_time - old_time;
        ulong day_num = delta_time / 86400000;
        ulong ltime = old_time + day_num * 86400000;
        if (trigger_time(ltime, 0, 0)) {
            day_num++;
        }
        return (int)day_num;
    }
}
