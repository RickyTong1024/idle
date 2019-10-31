using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;

public class Packet {
    public byte m_compress;
    public ushort m_opcode;
    public int m_hid;
    public int m_size;
    public const int size = 12;
}

public enum DisType {
    Exception,
    Disconnect,
}

public class SocketClient {
    public static bool loggedIn = false;

    private TcpClient client = null;
    private string m_name;
    private NetworkStream outStream = null;
    private MemoryStream memStream;
    private BinaryReader reader;

    private const int RECV_BUFSIZE = 32 * 1024;
    private byte[] byteBuffer = new byte[RECV_BUFSIZE];
    private Packet m_packet = new Packet();

    // Use this for initialization
    public SocketClient() {
        memStream = new MemoryStream();
        reader = new BinaryReader(memStream);
    }

    public void SendConnect(string name, string addr, int port) {
        m_name = name;
        ConnectServer(addr, port);
    }

    /// <summary>
    /// 连接服务器
    /// </summary>
    void ConnectServer(string host, int port) {
        client = null;
        IPAddress[] address = Dns.GetHostAddresses(host);
        if (address.Length == 0) {
            Debug.Log("Ipaddress length 0");
            return;
        }
        if (address[0].AddressFamily == AddressFamily.InterNetworkV6) {
            client = new TcpClient(AddressFamily.InterNetworkV6);
        }
        else {
            client = new TcpClient(AddressFamily.InterNetwork);
        }

        client.SendTimeout = 1000;
        client.ReceiveTimeout = 1000;
        client.NoDelay = true;
        try {
            client.BeginConnect(host, port, new AsyncCallback(OnConnect), null);
        }
        catch (Exception e) {
            Close();
            Debug.LogError(e.Message);
        }
    }

    /// <summary>
    /// 连接上服务器
    /// </summary>
    void OnConnect(IAsyncResult asr) {
        if (!client.Connected) {
            NetMessage mes = new NetMessage();
            mes.opcode = -3;
            NetworkManager.AddEvent(m_name, mes);
            Close();
        }
        else {
            client.EndConnect(asr);
            outStream = client.GetStream();
            client.GetStream().BeginRead(byteBuffer, 0, RECV_BUFSIZE, new AsyncCallback(OnRead), null);
            NetMessage mes = new NetMessage();
            mes.opcode = -1;
            NetworkManager.AddEvent(m_name, mes);
        }
    }

    /// <summary>
    /// 写数据
    /// </summary>
    void WriteMessage(byte[] message) {
        MemoryStream ms = null;
        using (ms = new MemoryStream()) {
            ms.Position = 0;
            BinaryWriter writer = new BinaryWriter(ms);
            writer.Write(message);
            writer.Flush();
            if (client != null && client.Connected) {
                //NetworkStream stream = client.GetStream(); 
                byte[] payload = ms.ToArray();
                outStream.BeginWrite(payload, 0, payload.Length, new AsyncCallback(OnWrite), null);
            }
            else {
                Debug.LogError("client.connected----->>false");
            }
        }
    }

    /// <summary>
    /// 读取消息
    /// </summary>
    void OnRead(IAsyncResult asr) {
        int bytesRead = 0;
        try {
            lock (client.GetStream()) {         //读取字节流到缓冲区
                bytesRead = client.GetStream().EndRead(asr);
            }
            if (bytesRead < 1) {                //包尺寸有问题，断线处理
                OnDisconnected(DisType.Disconnect, "bytesRead < 1");
                return;
            }
            OnReceive(byteBuffer, bytesRead);   //分析数据包内容，抛给逻辑层
            lock (client.GetStream()) {         //分析完，再次监听服务器发过来的新消息
                Array.Clear(byteBuffer, 0, byteBuffer.Length);   //清空数组
                client.GetStream().BeginRead(byteBuffer, 0, RECV_BUFSIZE, new AsyncCallback(OnRead), null);
            }
        }
        catch (Exception ex) {
            OnDisconnected(DisType.Exception, ex.Message);
        }
    }

    /// <summary>
    /// 丢失链接
    /// </summary>
    void OnDisconnected(DisType dis, string msg) {
        Close();
    }

    public void Close() {
        if (client != null) {
            client.Close();
            client = null;
            NetMessage mes = new NetMessage();
            mes.opcode = -2;
            NetworkManager.AddEvent(m_name, mes);
        }
        loggedIn = false;
        reader.Close();
        memStream.Close();
    }

    /// <summary>
    /// 打印字节
    /// </summary>
    /// <param name="bytes"></param>
    void PrintBytes() {
        string returnStr = string.Empty;
        for (int i = 0; i < byteBuffer.Length; i++) {
            returnStr += byteBuffer[i].ToString("X2");
        }
        Debug.LogError(returnStr);
    }

    /// <summary>
    /// 向链接写入数据流
    /// </summary>
    void OnWrite(IAsyncResult r) {
        try {
            outStream.EndWrite(r);
        }
        catch (Exception ex) {
            Debug.LogError("OnWrite--->>>" + ex.Message);
        }
    }

    /// <summary>
    /// 接收到消息
    /// </summary>
    void OnReceive(byte[] bytes, int length) {
        memStream.Seek(0, SeekOrigin.End);
        memStream.Write(bytes, 0, length);
        //Reset to beginning
        memStream.Seek(0, SeekOrigin.Begin);
        while (RemainingBytes() >= Packet.size) {
            byte[] _lenbyte = new byte[Packet.size];
            reader.Read(_lenbyte, 0, Packet.size);
            m_packet.m_compress = _lenbyte[0];
            m_packet.m_opcode = System.BitConverter.ToUInt16(_lenbyte, 2);
            m_packet.m_hid = System.BitConverter.ToInt32(_lenbyte, 4);
            m_packet.m_size = System.BitConverter.ToInt32(_lenbyte, 8);
            if (RemainingBytes() >= m_packet.m_size) {
                MemoryStream ms = new MemoryStream();
                BinaryWriter writer = new BinaryWriter(ms);
                writer.Write(reader.ReadBytes(m_packet.m_size));
                ms.Seek(0, SeekOrigin.Begin);
                OnReceivedMessage(ms);
            }
            else {
                //Back up the position two bytes
                memStream.Position = memStream.Position - Packet.size;
                break;
            }
        }
        //Create a new stream with any leftover bytes
        byte[] leftover = reader.ReadBytes((int)RemainingBytes());
        memStream.SetLength(0);     //Clear
        memStream.Write(leftover, 0, leftover.Length);
    }

    /// <summary>
    /// 剩余的字节
    /// </summary>
    private long RemainingBytes() {
        return memStream.Length - memStream.Position;
    }

    /// <summary>
    /// 接收到消息
    /// </summary>
    /// <param name="ms"></param>
    void OnReceivedMessage(MemoryStream ms) {
        BinaryReader r = new BinaryReader(ms);
        byte[] bf = r.ReadBytes((int)(ms.Length - ms.Position));
        if (m_packet.m_compress != 0) {
            bf = Util.Decompress(bf);
        }
        NetMessage mes = new NetMessage();
        mes.opcode = m_packet.m_opcode;
        mes.buffer = bf;
        NetworkManager.AddEvent(m_name, mes);
    }


    /// <summary>
    /// 会话发送
    /// </summary>
    void SessionSend(byte[] bytes) {
        WriteMessage(bytes);
    }

    /// <summary>
    /// 发送消息
    /// </summary>
    public void SendMessage(byte[] buffer) {
        SessionSend(buffer);
    }

    public bool is_close() {
        return client == null;
    }
}
