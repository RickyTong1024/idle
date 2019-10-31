using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Main : MonoBehaviour {
    public static Main instance;
    private GameManager gameMgr;
    private LuaManager luaMgr;
    private NetworkManager networkMgr;
    private MessageManager messageMgr;
    private PanelManager panelMgr;
    private SoundManager soundMgr;
    private TimerManager timerMgr;
    private SpriteManager spriteMgr;
    private ExceptionManager exceptionMgr;

    private void Awake() {
        if (instance == null) {
            instance = this;
        }

        float _scalew = 640f / (float)Screen.width;
        float _width = (float)Screen.width * _scalew;
        float _height = (float)Screen.height * _scalew;
        Screen.SetResolution((int)_width, (int)_height, true);

        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = platform_config_common.GameFrameRate;

        gameMgr = gameObject.AddComponent<GameManager>();
        luaMgr = gameObject.AddComponent<LuaManager>();
        networkMgr = gameObject.AddComponent<NetworkManager>();
        messageMgr = gameObject.AddComponent<MessageManager>();
        panelMgr = gameObject.AddComponent<PanelManager>();
        soundMgr = gameObject.AddComponent<SoundManager>();
        timerMgr = gameObject.AddComponent<TimerManager>();
        spriteMgr = gameObject.AddComponent<SpriteManager>();
        exceptionMgr = gameObject.AddComponent<ExceptionManager>();
    }

    public GameManager GameManager {
        get {
            return gameMgr;
        }
    }

    public LuaManager LuaManager {
        get {
            return luaMgr;
        }
    }

    public NetworkManager NetworkManager {
        get {
            return networkMgr;
        }
    }

    public MessageManager MessageManager {
        get {
            return messageMgr;
        }
    }

    public PanelManager PanelManager {
        get {
            return panelMgr;
        }
    }

    public TimerManager TimerManager
    {
        get
        {
            return timerMgr;
        }
    }

    public SoundManager SoundManager {
        get {
            return soundMgr;
        }
    }

    public ExceptionManager ExceptionManager
    {
        get
        {
            return exceptionMgr;
        }
    }
}
