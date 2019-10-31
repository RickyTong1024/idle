using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class platform_config_common {
    public const int Version = 1;                               //游戏版本
    public static int ResVersion = 1;                           //资源版本
    public static bool DebugMode = true;                        //调试模式-不进行热更流程
    public static bool UpdateMode = false;                      //更新模式-默认关闭 
    public const int GameFrameRate = 60;                        //游戏帧频
    public const string AppName = "LootHero";                      //应用程序名称
    public const string LuaTempDir = "LuaTemp/";                //临时目录
    public const string ExtName = ".unity3d";                   //素材扩展名
    public const string AssetDir = "StreamingAssets";           //素材目录 
    
    public static bool test = true;                                             //测试模式,测试服
    public static string platform = "test";                                     //平台字段
    public static string oss_url = "http://loot.oss.yymoon.com/test/";          //oss地址
    public static int third_login = 0;                                          //0 无第三方登陆  1 有第三方登陆
    public static int lang = 1;                                                 //1是中文 2繁体 3是英文
    public static string hostIp = "";                                     
    public static string updateBuildUrl = "";
    public static string updateResUrl = "";                                        //热更文件地址  
    public static string LuaFrameworkRoot {
        get {
            return Application.dataPath + "/" + "LuaFramework";
        }
    }

    public static string login_url {
        get {
            return "http://" + hostIp + ":10001/";
        }
    }

    public static string storage_url {
        get {
            return "http://" + hostIp + ":10004/";
        }
    }

    public static string libao_url {
        get {
            return "http://" + hostIp + ":10004/";
        }
    }

    public static string pay_url {
        get {
            return "http://" + hostIp + ":10004/";
        }
    }

    public static string exception_url {
        get
        {
            return "http://" + hostIp + ":10005/";
        }
    }
}
