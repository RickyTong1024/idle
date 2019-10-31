using UnityEngine;
using System.Collections;
using LuaInterface;

public class LuaManager : MonoBehaviour {
    private LuaState lua;
    private LuaLoader loader;
    private LuaLooper loop = null;

    public LuaState Lua {
        get { return lua; }
    }

    void Start() {
    }

    public void InitStart() {
        loader = new LuaLoader();
        lua = new LuaState();
        this.OpenLibs();
        lua.LuaSetTop(0);

        LuaBinder.Bind(lua);
        DelegateFactory.Init();
        LuaCoroutine.Register(lua, this);

        InitLuaPath();
        InitLuaBundle();
        this.lua.Start();    //启动LUAVM
        this.StartLooper();
        this.StartMain();
    }

    public void OtherTestStart(params object[] param) {
        InitLuaPath();
        InitLuaBundle();
      
        this.lua.Start();    //启动LUAVM
        this.StartLooper();

        lua.DoFile("Battle/TestBattle.lua");
        LuaFunction main = null;
        main = lua.GetFunction("TestStart");
        main.Call(param);
        main.Dispose();
        main = null;
    }

    private void StartLooper() {
        loop = gameObject.AddComponent<LuaLooper>();
        loop.luaState = lua;
    }

    //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
    private protected void OpenCJson() {
        lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
        lua.OpenLibs(LuaDLL.luaopen_cjson);
        lua.LuaSetField(-2, "cjson");

        lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
        lua.LuaSetField(-2, "cjson.safe");
    }

    private void StartMain() {
        lua.DoFile("Main.lua");
        LuaFunction main = null;
        main = lua.GetFunction("Main");
        main.Call();
        main.Dispose();
        main = null;
    }

    /// <summary>
    /// 初始化加载第三方库
    /// </summary>
    private void OpenLibs() {
        lua.OpenLibs(LuaDLL.luaopen_pb);
        lua.OpenLibs(LuaDLL.luaopen_sproto_core);
        lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
        lua.OpenLibs(LuaDLL.luaopen_lpeg);
        lua.OpenLibs(LuaDLL.luaopen_bit);
        lua.OpenLibs(LuaDLL.luaopen_socket_core);

        this.OpenCJson();
    }

    /// <summary>
    /// 初始化Lua代码加载路径
    /// </summary>
    private void InitLuaPath() {
        if (platform_config_common.DebugMode) {
            string rootPath = platform_config_common.LuaFrameworkRoot;
            lua.AddSearchPath(rootPath + "/Lua");
            lua.AddSearchPath(rootPath + "/ToLua/Lua");
        }
        else {
            lua.AddSearchPath(Util.DataPath + "lua");
        }
    }

    /// <summary>
    /// 初始化LuaBundle
    /// </summary>
    private void InitLuaBundle() {
        if (!platform_config_common.DebugMode) {
            loader.AddBundle("lua/lua.unity3d");
            loader.AddBundle("lua/lua_cjson.unity3d");
            loader.AddBundle("lua/lua_lpeg.unity3d");
            loader.AddBundle("lua/lua_misc.unity3d");
            loader.AddBundle("lua/lua_socket.unity3d");

            loader.AddBundle("lua/lua_system.unity3d");
            loader.AddBundle("lua/lua_system_reflection.unity3d");
            loader.AddBundle("lua/lua_system_injection.unity3d");
            loader.AddBundle("lua/lua_unityengine.unity3d");


            //加载自己定义的lua文件
            loader.AddBundle("lua/lua_battle.unity3d");
            loader.AddBundle("lua/lua_common.unity3d");
            loader.AddBundle("lua/lua_net.unity3d");
            loader.AddBundle("lua/lua_other.unity3d");
            loader.AddBundle("lua/lua_protobuf.unity3d");
            
            loader.AddBundle("lua/lua_panel_artifactdetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_artifactpanel.unity3d");
            loader.AddBundle("lua/lua_panel_assetwindowpanel.unity3d");
            loader.AddBundle("lua/lua_panel_attrchangepanel.unity3d");
            loader.AddBundle("lua/lua_panel_bagpanel.unity3d");
            loader.AddBundle("lua/lua_panel_basicuipanel.unity3d");
            loader.AddBundle("lua/lua_panel_battlepanel.unity3d");
            loader.AddBundle("lua/lua_panel_bookpanel.unity3d");
            loader.AddBundle("lua/lua_panel_bosspanel.unity3d");
            loader.AddBundle("lua/lua_panel_buypanel.unity3d");
            loader.AddBundle("lua/lua_panel_changedresspanel.unity3d");
            loader.AddBundle("lua/lua_panel_changeequippanel.unity3d");
            loader.AddBundle("lua/lua_panel_changepetpanel.unity3d");
            loader.AddBundle("lua/lua_panel_changerunepanel.unity3d");
            loader.AddBundle("lua/lua_panel_changespellpanel.unity3d");
            loader.AddBundle("lua/lua_panel_commonpanel.unity3d");
            loader.AddBundle("lua/lua_panel_dressdetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_equipdetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_equipenchantpanel.unity3d");
            loader.AddBundle("lua/lua_panel_equipenhancepanel.unity3d");
            loader.AddBundle("lua/lua_panel_equipinlaypanel.unity3d");
            loader.AddBundle("lua/lua_panel_equippanel.unity3d");
            loader.AddBundle("lua/lua_panel_equipreforgepanel.unity3d");
            loader.AddBundle("lua/lua_panel_esportspanel.unity3d");
            loader.AddBundle("lua/lua_panel_forgepanel.unity3d");
            loader.AddBundle("lua/lua_panel_forgesurepanel.unity3d");
            loader.AddBundle("lua/lua_panel_hallpanel.unity3d");
            loader.AddBundle("lua/lua_panel_halltwopanel.unity3d");
            loader.AddBundle("lua/lua_panel_loadingpanel.unity3d");
            loader.AddBundle("lua/lua_panel_loadingpixelpanel.unity3d");
            loader.AddBundle("lua/lua_panel_mailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_mappanel.unity3d");
            loader.AddBundle("lua/lua_panel_maptwopanel.unity3d");
            loader.AddBundle("lua/lua_panel_maskpanel.unity3d");
            loader.AddBundle("lua/lua_panel_messagepanel.unity3d");
            loader.AddBundle("lua/lua_panel_monsterdetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_monsterpanel.unity3d");
            loader.AddBundle("lua/lua_panel_namepanel.unity3d");
            loader.AddBundle("lua/lua_panel_narratorpanel.unity3d");
            loader.AddBundle("lua/lua_panel_passivedetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_petdetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_petenhancepanel.unity3d");
            loader.AddBundle("lua/lua_panel_petpanel.unity3d");
            loader.AddBundle("lua/lua_panel_petsyntpanel.unity3d");
            loader.AddBundle("lua/lua_panel_petupgradepanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerequippanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerpanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerpetpanel.unity3d");           
            loader.AddBundle("lua/lua_panel_playersetpanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerspellpanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerunlockpassivepanel.unity3d");
            loader.AddBundle("lua/lua_panel_playerunlockspellpanel.unity3d");
            loader.AddBundle("lua/lua_panel_portalpanel.unity3d");
            loader.AddBundle("lua/lua_panel_powerchangepanel.unity3d");
            loader.AddBundle("lua/lua_panel_rankpanel.unity3d");
            loader.AddBundle("lua/lua_panel_rechargepanel.unity3d");
            loader.AddBundle("lua/lua_panel_selectpanel.unity3d");
            loader.AddBundle("lua/lua_panel_sellpanel.unity3d");
            loader.AddBundle("lua/lua_panel_setingpanel.unity3d");
            loader.AddBundle("lua/lua_panel_shoppanel.unity3d");
            loader.AddBundle("lua/lua_panel_showassetpanel.unity3d");
            loader.AddBundle("lua/lua_panel_signpanel.unity3d");
            loader.AddBundle("lua/lua_panel_spelldetailpanel.unity3d");
            loader.AddBundle("lua/lua_panel_startpanel.unity3d");
            loader.AddBundle("lua/lua_panel_talkpanel.unity3d");
            loader.AddBundle("lua/lua_panel_taskpanel.unity3d");
            loader.AddBundle("lua/lua_panel_toprespanel.unity3d");
            loader.AddBundle("lua/lua_panel_touchpanel.unity3d");
            loader.AddBundle("lua/lua_panel_towerpanel.unity3d");
            loader.AddBundle("lua/lua_panel_unlockdescpanel.unity3d");
            loader.AddBundle("lua/lua_panel_unlockpanel.unity3d");
            loader.AddBundle("lua/lua_panel_usepanel.unity3d");

            loader.AddBundle("lua/lua_uicontrol.unity3d");
        }
    }

    public void DoFile(string filename) {
        lua.DoFile(filename);
    }

    public void CallLuaFunction(string moudle, string func_name) {
        if (lua == null) {
            return;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            func.Call();
            func.Dispose();
        }
    }

    public void CallLuaFunction<T>(string moudle, string func_name, T arg1) {
        if (lua == null) {
            return;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            func.Call<T>(arg1);
            func.Dispose();
        }
    }

    public void CallLuaFunction<T1, T2>(string moudle, string func_name, T1 arg1, T2 arg2) {
        if (lua == null) {
            return;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            func.Call<T1, T2>(arg1, arg2);
            func.Dispose();
        }
    }

    public void CallLuaFunction<T1, T2, T3>(string moudle, string func_name, T1 arg1, T2 arg2, T3 arg3) {
        if (lua == null) {
            return;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            func.Call<T1, T2, T3>(arg1, arg2, arg3);
            func.Dispose();
        }
    }

    public R InvokeLuaFunction<R>(string moudle, string func_name) {
        if (lua == null) {
            return default;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            R r = func.Invoke<R>();
            func.Dispose();
            return r;
        }
        return default;
    }

    public R InvokeLuaFunction<T, R>(string moudle, string func_name, T arg1) {
        if (lua == null) {
            return default;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            R r = func.Invoke<T, R>(arg1);
            func.Dispose();
            return r;
        }
        return default;
    }

    public R InvokeLuaFunction<T1, T2, R>(string moudle, string func_name, T1 arg1, T2 arg2) {
        if (lua == null) {
            return default;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            R r = func.Invoke<T1, T2, R>(arg1, arg2);
            func.Dispose();
            return r;
        }
        return default;
    }

    public R InvokeLuaFunction<T1, T2, T3, R>(string moudle, string func_name, T1 arg1, T2 arg2, T3 arg3) {
        if (lua == null) {
            return default;
        }
        LuaFunction func = lua.GetFunction(moudle + "." + func_name, false);
        if (func != null) {
            R r = func.Invoke<T1, T2, T3, R>(arg1, arg2, arg3);
            func.Dispose();
            return r;            
        }
        return default;
    }

    public void LuaGC() {
        if (lua == null) {
            return;
        }
        lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
    }

    void Close() {
        if (loop != null) {
            loop.Destroy();
            loop = null;
        }
        if (lua != null) {
            lua.Dispose();
            lua = null;
        }
        loader = null;
    }

    private void OnDestroy() {
        //lua.DoFile("Main.lua");
        LuaFunction main_end = null;
        main_end = lua.GetFunction("MainEnd");
        if (main_end != null) {
            main_end.Call();
            main_end.Dispose();
            main_end = null;
        } 
        Close();
    }
}