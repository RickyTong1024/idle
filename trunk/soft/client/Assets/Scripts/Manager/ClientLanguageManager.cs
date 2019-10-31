using LuaInterface;
using UnityEngine;

public class ClientLanguageManager : MonoBehaviour
{
    public static string UserKeyStringGetLanguageString(string keyString) {
        string str = Util.InvokeLuaFunction<string, string>("Config", "get_Text_lang", keyString);
        if (str == null) {
            return "";
        }
        else {
            return str;
        }
    }
}
