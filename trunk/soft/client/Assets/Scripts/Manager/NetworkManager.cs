using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.Networking;

public class NetworkManager : MonoBehaviour {
    private Dictionary<string, SocketClient> m_sockets = new Dictionary<string, SocketClient>();
    private static readonly object m_lockObject = new object();
    private static Queue<KeyValuePair<string, NetMessage>> mEvents = new Queue<KeyValuePair<string, NetMessage>>();
    private static int COMPRESS_SIZE = 512;

    /// <summary>
    /// 发送链接请求
    /// </summary>
    public void Connect(string name, string addr, int port) {
        SocketClient c = new SocketClient();
        c.SendConnect(name, addr, port);
        m_sockets[name] = c;
    }

    public void Disconnect(string name) {
        if (m_sockets.ContainsKey(name)) {
            m_sockets[name].Close();
            m_sockets.Remove(name);
        }
    }
    public bool Isconnect(string name) {
        if (m_sockets.ContainsKey(name)) {
            return true;
        }
        return false;
    }

    /// <summary>
    /// 发送SOCKET消息
    /// </summary>
	public void SendMessage(string name, int opcode, byte[] buffer) {
        bool ys = false;
        if (buffer.Length >= COMPRESS_SIZE) {
            buffer = Util.Compress(buffer);
            ys = true;
        }
        byte[] _data = new byte[Packet.size + buffer.Length];
        System.BitConverter.GetBytes(ys).CopyTo(_data, 0);
        System.BitConverter.GetBytes((ushort)opcode).CopyTo(_data, 2);
        System.BitConverter.GetBytes(0).CopyTo(_data, 4);
        System.BitConverter.GetBytes(buffer.Length).CopyTo(_data, 8);
        buffer.CopyTo(_data, 12);
        if (m_sockets.ContainsKey(name)) {
            m_sockets[name].SendMessage(_data);
        }
    }

    public void SendMessageNull(string name, int opcode) {
        byte[] _data = new byte[Packet.size];
        System.BitConverter.GetBytes(false).CopyTo(_data, 0);
        System.BitConverter.GetBytes((ushort)opcode).CopyTo(_data, 2);
        System.BitConverter.GetBytes(0).CopyTo(_data, 4);
        System.BitConverter.GetBytes(0).CopyTo(_data, 8);
        if (m_sockets.ContainsKey(name)) {
            m_sockets[name].SendMessage(_data);
        }
    }

    void OnDestroy() {
        foreach (SocketClient c in m_sockets.Values) {
            c.Close();
        }
    }

    public static void AddEvent(string name, NetMessage message) {
        lock (m_lockObject) {
            mEvents.Enqueue(new KeyValuePair<string, NetMessage>(name, message));
        }
    }

    void Update() {
        List<string> names = new List<string>();
        foreach (string name in m_sockets.Keys) {
            SocketClient sc = m_sockets[name];
            if (sc.is_close()) {
                names.Add(name);
            }
        }
        for (int i = 0; i < names.Count; ++i) {
            m_sockets.Remove(names[i]);
        }
        names.Clear();
        while (true) {
            int num = 0;
            lock (m_lockObject) {
                num = mEvents.Count;
            }
            if (num > 0) {
                KeyValuePair<string, NetMessage> _event;
                lock (m_lockObject) {
                    _event = mEvents.Dequeue();
                }
                if (_event.Value.opcode == -1) {
                    Util.CallLuaFunction(_event.Key, "OnConnect");
                }
                else if (_event.Value.opcode == -2) {
                    Util.CallLuaFunction(_event.Key, "OnDisconnect");
                }
                else if (_event.Value.opcode == -3) {
                    Util.CallLuaFunction(_event.Key, "OnConnectFail");
                }
                else {
                    Main.instance.MessageManager.AddNetMessage(_event.Value);
                }
            }
            else {
                break;
            }
        }
    }

    private Dictionary<string, UnityWebRequest> get_list = new Dictionary<string, UnityWebRequest>();
    public void lua_get(string url, LuaFunction luafunc, LuaFunction failfunc, int time_out = 10) {
        StartCoroutine(LuaGet(url, luafunc, failfunc, time_out));
    }

    IEnumerator LuaGet(string url, LuaFunction luafunc, LuaFunction failfunc, int time_out) {
        if (get_list.ContainsKey(url)) {
            yield break;
        }
        UnityWebRequest w = UnityWebRequest.Get(url);
        w.timeout = time_out;
        get_list[url] = w;
        yield return w.SendWebRequest();
        if (w.isHttpError || w.isNetworkError) {
            failfunc.Call();
        }
        else {
            luafunc.Call(w.downloadHandler);
        }
        get_list.Remove(url);
    }

    private Dictionary<string, UnityWebRequest> post_list = new Dictionary<string, UnityWebRequest>();
    public void lua_post(string url, WWWForm wwwf, LuaFunction luafunc, LuaFunction failfunc, int time_out = 10) {
        StartCoroutine(LuaPost(url, wwwf, luafunc, failfunc, time_out));
    }

    IEnumerator LuaPost(string url, WWWForm wwwf, LuaFunction luafunc, LuaFunction failfunc, int time_out) {
        if (post_list.ContainsKey(url)) {
            yield break;
        }
        UnityWebRequest w = UnityWebRequest.Post(url, wwwf);
        w.timeout = time_out;
        post_list[url] = w;
        yield return w.SendWebRequest();
        if (w.isHttpError || w.isNetworkError) {
            failfunc.Call();           
        }
        else {
            luafunc.Call(w.downloadHandler);
        }
        post_list.Remove(url);
    }
}