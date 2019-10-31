using UnityEngine;
using System.Collections;
using UnityEngine.Networking;

public class ExceptionManager : MonoBehaviour
{
    private int m_num = 0;
    void OnEnable()
    {
        Application.logMessageReceived += Handler;
    }
    void OnDisable()
    {
        Application.logMessageReceived -= Handler;
    }

    void Handler(string logString, string stackTrace, LogType type)
    {
        if (m_num >= 5)
        {
            return;
        }
        if (type == LogType.Error || type == LogType.Exception || type == LogType.Assert)
        {
            StartCoroutine(Post(logString, stackTrace));
            m_num++;
        }
    }

    IEnumerator Post(string logString, string stackTrace)
    {
        WWWForm wf = new WWWForm();
        if (PlayerPrefs.HasKey("username"))
        {
            wf.AddField("username", PlayerPrefs.GetString("username"));
        }
        else
        {
            wf.AddField("username", "");
        }
        wf.AddField("msg", logString);
        wf.AddField("stack", stackTrace);
        string url = platform_config_common.exception_url + "set";
        using (var w = UnityWebRequest.Post(url, wf))
        {
            yield return w.SendWebRequest();
        }
    }
}
