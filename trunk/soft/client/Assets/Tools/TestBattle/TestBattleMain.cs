using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class TestBattleMain : MonoBehaviour {
    public static TestBattleMain instance;
    private LuaManager luaMgr;
    private PanelManager panelMgr;
    private SoundManager soundMgr;
    private TimerManager timerMgr;

    [HideInInspector]
    public int my_id = 1;
    [HideInInspector]
    public int enemy_id = 1;
    [HideInInspector]
    public float attack_speed = 1;

    public int[] spells = new int[] { };
    public int[] attachs = new int[] { };
    public string[] behaviours = new string[] { };


    private void Awake() {
        if (instance == null) {
            instance = this;
        }

        luaMgr = gameObject.AddComponent<LuaManager>();
        panelMgr = gameObject.AddComponent<PanelManager>();
        soundMgr = gameObject.AddComponent<SoundManager>();
        timerMgr = gameObject.AddComponent<TimerManager>();
    }

    public void Start() {
        luaMgr.OtherTestStart(panelMgr, timerMgr, my_id, enemy_id);
    }

    public void SetAttackIndex(int index) {
        CallMethodNoLog("TestBattle", "SetAttackIndex", index);
    }

    public void ShowSpell(int id) {
        float speed = 1;
        if (id < 1000) {
            speed = attack_speed;
        }
        CallMethodNoLog("TestBattle", "TestSpell", id, speed);
    }

    public void ShowAttach(int id) {
        CallMethodNoLog("TestBattle", "TestAttachStart", id);
    }
    public void CloseAttach(int id) {
        CallMethodNoLog("TestBattle", "TestAttachEnd", id);
    }

    public void ShowBehaviour(string name) {
        CallMethodNoLog("TestBattle", "TestShowBehaviour", name);
    }

    public void Change(int my_id, int enemy_id) {

        CallMethodNoLog("TestBattle", "ChangeRole", my_id, enemy_id);
    }

    object[] CallMethodNoLog(string module, string func, params object[] args) {
        return CallFunctionNoLog(module + "." + func, args);
    }

    public object[] CallFunctionNoLog(string funcName, params object[] args) {
        LuaManager luaManager = null;
        if (Main.instance != null) {
            luaManager = Main.instance.LuaManager;
        }
        else {
            luaManager = GameObject.FindObjectOfType<LuaManager>();
        }
        LuaFunction func = luaManager.Lua.GetFunction(funcName, false);
        if (func != null) {
            return func.LazyCall(args);
        }
        return null;
    }


}
