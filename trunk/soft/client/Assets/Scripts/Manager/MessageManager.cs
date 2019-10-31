using UnityEngine;
using System.Collections;
using LuaInterface;
using System.Collections.Generic;

public class NetMessage {
    public int opcode;
    public float time = 0.0f;
    public byte[] buffer;
    public LuaByteBuffer luabuff;
}

public class CommonMessage {
    public string name;
    public float time = 0.0f;
    public ArrayList m_object = new ArrayList();
}

public interface IMsgHandle {
    void HandleNetMsg(NetMessage message);
    void HandleCommonMsg(CommonMessage message);
}

public class MessageManager : MonoBehaviour {
    private HashSet<IMsgHandle> msgHandles = new HashSet<IMsgHandle>();
    private List<CommonMessage> commonMsgs = new List<CommonMessage>();
    private List<NetMessage> netMsgs = new List<NetMessage>();

    public void RegisterMsgHandle(IMsgHandle handle) {
        if (!msgHandles.Contains(handle)) {
            msgHandles.Add(handle);
        }
    }

    public void RemoveMsgHandle(IMsgHandle handle) {
        if (msgHandles.Contains(handle)) {
            msgHandles.Remove(handle);
        }
    }

    public void AddCommonMessage(CommonMessage message) {
        commonMsgs.Add(message);        
    }

    public void AddNetMessage(NetMessage message) {
        netMsgs.Add(message);
    }

    void Update() {
        for (int c = 0; c < commonMsgs.Count;) {
            CommonMessage message = commonMsgs[c] as CommonMessage;
            if (message.time <= 0.0f) {
                commonMsgs.RemoveAt(c);
                foreach (IMsgHandle handle in msgHandles) {
                    if (handle != null) {
                        handle.HandleCommonMsg(message);
                    }
                }
                Util.CallLuaFunction<CommonMessage>("Message", "OnMessage", message);
            }
            else {
                message.time -= Time.deltaTime;
                c++;
            }
        }

        for (int c = 0; c < netMsgs.Count;) {
            NetMessage message = netMsgs[c] as NetMessage;
            if (message.time <= 0.0f) {
                netMsgs.RemoveAt(c);
                foreach (IMsgHandle handle in msgHandles) {
                    if (handle != null) {
                        handle.HandleNetMsg(message);
                    }
                }
                message.luabuff = new LuaByteBuffer(message.buffer);
                Util.CallLuaFunction<NetMessage>("Message", "OnNetMessage", message);
            }
            else {
                message.time -= Time.deltaTime;
                c++;
            }
        }
    }
}
