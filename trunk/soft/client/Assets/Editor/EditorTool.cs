using UnityEngine;
using UnityEditor;
using System.Collections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEngine.UI;

public class EditorTool : EditorWindow {
	public string m_name;
    RuntimeAnimatorController re;
	static EditorTool m_window;
    string m_gm_command;
    string path_name;
    GameObject PrefabObj;
    Font m_font;
    Dictionary<string, string> _langDic = new Dictionary<string, string>();
    string hex_1;
    string hex_2;
    public string m_local_langKey;
    [MenuItem("Tools/EditorTool")]
	static void Execute()
	{
		if (m_window == null)
			m_window = (EditorTool)GetWindow(typeof (EditorTool));
		m_window.Show ();
	}

    void OnGUI()
	{
		{
			GUILayout.Label("--- 获取预设层级路径 ---");
			GUILayout.BeginHorizontal();
			bool _ok = GUILayout.Button("获取", GUILayout.Width(120f));

            path_name = EditorGUILayout.TextArea(path_name);
            GUILayout.EndHorizontal();
			
			if (_ok) {
				shengcheng();
			}

            GUILayout.Label("--- gm命令 ---");
            m_gm_command = EditorGUILayout.TextArea(m_gm_command);
            _ok = GUILayout.Button("发送", GUILayout.Width(120f));

            if (_ok)
            {
                CommonMessage mes = new CommonMessage();
                mes.name = "edit_gm_command";
                mes.m_object.Add(m_gm_command);
                Main.instance.MessageManager.AddCommonMessage(mes);
            }

            GUILayout.Label("--- 查找本地化语言Key 所在预设 ---");
            m_local_langKey = EditorGUILayout.TextArea(m_local_langKey);
            _ok = GUILayout.Button("发送", GUILayout.Width(120f));

            if (_ok)
            {
                findLocalKey();
            }

            GUILayout.Label("--- 替换设置button ---");
            re = EditorGUILayout.ObjectField(re, typeof(RuntimeAnimatorController), true) as RuntimeAnimatorController;
            _ok = GUILayout.Button("替换", GUILayout.Width(120f));
     
            if (_ok)
            {
                ChangeTextSize();
            }

            GUILayout.Label("--- 设置预设 keyString ---");
            _ok = GUILayout.Button("批量处理", GUILayout.Width(120f));

            if (_ok)
            {
                setKeyString();
            }

            GUILayout.Label("--- 处理lua 脚本中文替换为代号 ---");
            _ok = GUILayout.Button("批量处理", GUILayout.Width(120f));

            if (_ok)
            {
                ChineseChangeTypeCode();
            }
            

            GUILayout.Label("--- 更改预制体上所有的text字体为制定文本 ---");
            GUILayout.Label("预制体");
            PrefabObj = EditorGUILayout.ObjectField(PrefabObj, typeof(GameObject), true) as GameObject;
            GUILayout.Label("字体");
            m_font = EditorGUILayout.ObjectField(m_font, typeof(Font), true) as Font;
            _ok = GUILayout.Button("更改", GUILayout.Width(120f));
            if (_ok)
            {
                ChangeFont(m_font, PrefabObj);
            }

            GUILayout.Label("--- 批量更改预制体上所有的text字体为制定文本 ---");
            _ok = GUILayout.Button("更改", GUILayout.Width(120f));
            if (_ok)
            {
                ChangeFont(m_font);
            }


            GUILayout.Label("--- 替换指定hexadecimal 字体颜色 ---");
            GUILayout.Label("被替换的颜色：");
            hex_1 = EditorGUILayout.TextArea(hex_1);
            GUILayout.Label("替换色：");
            hex_2 = EditorGUILayout.TextArea(hex_2);
            _ok = GUILayout.Button("替换", GUILayout.Width(120f));
            if (_ok)
            {
                changeCommonColor();
            }

            GUILayout.Label("--- 去掉描边 ---");
            _ok = GUILayout.Button("去掉描边 ", GUILayout.Width(120f));
            if (_ok)
            {
                RemoveMB();
            }

            GUILayout.Label("--- 删除本地账号 ---");
            _ok = GUILayout.Button("删除本地账号 ", GUILayout.Width(120f));
            if (_ok) {
                RemoveLocalAcc();
            }
        }		
	}
    void ChineseChangeTypeCode()
    {
        HashSet<string> files = new HashSet<string>();
        DirectoryInfo direction = new DirectoryInfo("Assets/LuaFramework/Lua");
        FileInfo[] fileinfos = direction.GetFiles("*", SearchOption.AllDirectories);
        for (int i = 0; i < fileinfos.Length; ++i)
        {
            if (!fileinfos[i].Name.EndsWith(".lua"))
            {
                continue;
            }
            string name = fileinfos[i].FullName;
           Debug.Log(fileinfos[i].Name);
            string startName = fileinfos[i].Name.Split('.')[1];
            List<string> infoall = LoadFile(name);
            //string rxChinaCharacter = "(?<=\")()(?=\")";
            string rxscode = "\"(.+)\"";
            string rxchina = "[\u4e00-\u9fa5]";
            for (int j = 1; j < infoall.Count; j++)
            {
                //Regex.Matches(infoall[j], regex);//C#调用正则
                if (Regex.IsMatch(infoall[j], rxscode))
                {
                    if (Regex.IsMatch(infoall[j], rxchina))
                    {
                        var m = Regex.Match(infoall[j], "(?<=\").*([\u4e00-\u9fa5]+).*(?=\")");
                        var res = m.Value;                      
                        Debug.Log(res);
                    }
                    
                }
            }
            string infoma = "";
            for (int k = 0; k < infoall.Count; k++)
            {
                infoma = string.Format("{0}\n{1}", infoma, infoall[k]);
            }
            name = name.Replace("Lua", "Lua_Change");
            //CreateFile(name, infoma);

        }
    }

    List<string> LoadFile(string path)
    {
        //使用流的形式读取
        StreamReader sr = null;
        try
        {
            sr = File.OpenText(path);

        }
        catch (Exception)
        {
            //路径与名称未找到文件则直接返回空
            return null;
        }

        string line;
        List<string> arrlist = new List<string>();
        while ((line = sr.ReadLine()) != null)
        {
            //一行一行的读取
            //将每一行的内容存入数组链表容器中
            arrlist.Add(line);
        }
        //关闭流
        sr.Close();
        //销毁流
        sr.Dispose();
        //将数组链表容器返回
        return arrlist;
    }

    void CreateFile(string path, string info)
    {
        //文件流信息
        StreamWriter sw;
        Debug.Log(path);
        FileInfo t = new FileInfo(path);
        if (!t.Exists)
        {
            //如果此文件不存在则创建			
            sw = t.CreateText();
        }
        else
        {
            //如果此文件存在则打开
            sw = t.AppendText();
        }
        Debug.Log(info);
        //以行的形式写入信息
        sw.WriteLine(info);
        //关闭流
        sw.Close();
        //销毁流
        sw.Dispose();
    }


    void add_getHaveLocalization()
    {
        StreamReader sr = null;
        try
        {
            sr = File.OpenText(Application.dataPath + "//" + "t_localization.txt");
        }
        catch (Exception e)
        {
            Debug.Log(e.ToString());
        }
        List<string> lines = new List<string>(File.ReadAllLines(Application.dataPath + "//" + "t_localization.txt"));
        string line;
        while ((line = sr.ReadLine()) != null)
        {
            if (line.Contains("\t"))
            {
                if (line.Split('\t')[0].Contains("Prefabs_Localization_"))
                {
                    _langDic.Add(line.Split('\t')[0], line.Split('\t')[1]);
                }
            }
            lines.RemoveAt(0);
        }
        sr.Close();
        sr.Dispose();
    }

    void setKeyString()
    {
        add_getHaveLocalization();
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            LocalizationText[] local_text = temp.GetComponentsInChildren<LocalizationText>(true);
            
            for (int j = 0; j < local_text.Length; ++j)
            {
                if (local_text[j].clientLanguage && local_text[j].keyString == "")
                {
                    if (_langDic.ContainsValue(local_text[j].text))
                    {
                        local_text[j].keyString = returnHasKey(local_text[j].text);
                        EditorUtility.SetDirty(temp.gameObject);
                    }
                    else
                    {
                        string key = generateKeyString();
                        local_text[j].keyString = key;
                        _langDic.Add(key, local_text[j].text);
                        EditorUtility.SetDirty(temp.gameObject);
                    }
                    
                }
                else if (local_text[j].clientLanguage && local_text[j].keyString != "")
                {
                    if (_langDic.ContainsValue(local_text[j].text))
                    {
                        local_text[j].keyString = returnHasKey(local_text[j].text);
                        EditorUtility.SetDirty(temp.gameObject);
                    }
                    else
                    {
                        string key = generateKeyString();
                        local_text[j].keyString = key;
                        Debug.Log("kkk");
                        _langDic.Add(key, local_text[j].text);
                        Debug.Log("ttttt");
                        EditorUtility.SetDirty(temp.gameObject);
                    }
                }
            }
        }
        // 生成语言 key -value
        CreateText();
    }


    void CreateText()
    {
        Debug.Log("创建");
        string  str = "";
        foreach (KeyValuePair<string, string> kvp in _langDic)
        {

            str += kvp.Key + "\t";
            string temp = kvp.Value;
            if (temp.Contains("\r") || temp.Contains("\n"))
            {
                temp = temp.Replace("\r", "{nn}");
                temp = temp.Replace("\n", "{nn}");
            }
            str += temp +"\t\n";
        }
        CreateFile(Application.dataPath, "else.txt", str);
        _langDic.Clear();

    }

    void CreateFile(string path, string name, string info)
    {
        StreamWriter sw;
        FileInfo t = new FileInfo(path + "//" + name);
        if (!t.Exists)
        {
            sw = t.CreateText();
        }
        else
        {
            sw = t.AppendText();
        }
        sw.WriteLine(info);
        sw.Close();
        sw.Dispose();
    }

    string returnHasKey(string value)
    {
        string keytemp = "";
        foreach (KeyValuePair<string, string> kvp in _langDic)
        {
            if (kvp.Value.Equals(value))
            {
                keytemp = kvp.Key;
            }
        }
        return keytemp;
    }

    string generateKeyString()
    {
        string m_startName = "Prefabs_Localization_";
        int end_num = _langDic.Count;
        string key = m_startName + end_num;
        while (_langDic.ContainsKey(key))
        {
            end_num++;
            key = m_startName + end_num;
        }
        return key;
    }


    void shengcheng()
	{
        GameObject[] selectedsGameobject = Selection.gameObjects;
       
        for (int i = 0; i < selectedsGameobject.Length; i++)
        {
            GameObject temp = selectedsGameobject[i];
            List<string> path = new List<string>();
            while (true)
            {
                if (temp.transform.parent != null)
                {
                    path.Add(temp.name);
                    temp = temp.transform.parent.gameObject;
                }
                else
                {
                    break;
                }
            }

            path.Reverse();
            path_name = "";
            string obj_name = "";
            for (int j = 1; j < path.Count;j++)
            {
                if (j > 1)
                {
                    path_name += "/" + path[j];
                }
                else
                {
                    path_name += path[j];
                }

                if (j == path.Count - 1)
                {
                    obj_name = path[j];
                }
            }
            path_name = string.Format("this.{0}_ = this.transform_:Find(\"{1}\")", obj_name, path_name);
            
        }

    }


    static void ChangeFont(Font m_font, GameObject m_prefab)
    {

        var textComponents = m_prefab.GetComponentsInChildren<Text>();
        foreach (var component in textComponents)
            component.font = m_font;
        var LocalizationTextComponents = m_prefab.GetComponentsInChildren<LocalizationText>();
        foreach (var component in LocalizationTextComponents)
            component.font = m_font;
        PrefabUtility.SavePrefabAsset(m_prefab);
    }

    static void ChangeFont(Font m_font)
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            Image[] sps = temp.GetComponentsInChildren<Image>(true);
            LocalizationText[] local_text = temp.GetComponentsInChildren<LocalizationText>(true);
            Text[] m_text = temp.GetComponentsInChildren<Text>(true);
            bool is_change = false;
            for (int j = 0; j < local_text.Length; ++j)
            {
                if (local_text[j].font != m_font)
                {
                    is_change = true;
                    local_text[j].font = m_font;
                }
            }

            for (int j = 0; j < m_text.Length; ++j)
            {
                if (m_text[j].font != m_font)
                {
                    is_change = true;
                    m_text[j].font = m_font;
                }
            }

            /* for (int k = 0; k < sps.Length; k++)
             {
                 if (sps[k].overrideSprite != null && sps[k].overrideSprite.name == "gjrui_004")
                 {
                     sps[k].rectTransform.anchorMin = new Vector2(1, 1);
                     sps[k].rectTransform.anchorMax = new Vector2(1, 1);
                     sps[k].rectTransform.pivot = new Vector2(1, 1);
                     sps[k].rectTransform.anchoredPosition = new Vector2(4, 2.5f);
                     is_change = true;
                 }
             }*/

            if (is_change)
            {
                PrefabUtility.SavePrefabAsset(temp);
            }

        }

    }

    void changeCommonColor()
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        Color m_hex1 = HexToColor(hex_1);
        Color m_hex2 = HexToColor(hex_1);
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            Image[] sps = temp.GetComponentsInChildren<Image>(true);
            LocalizationText[] local_text = temp.GetComponentsInChildren<LocalizationText>(true);
            Text[] m_text = temp.GetComponentsInChildren<Text>(true);
            bool is_change = false;
            for (int j = 0; j < local_text.Length; ++j)
            {
                if (local_text[j].color == m_hex1)
                {
                    is_change = true;
                    local_text[j].color = m_hex2;
                }
            }

            if (is_change)
            {
                PrefabUtility.SavePrefabAsset(temp);
            }

        }
    }

    Color HexToColor(string hex)
    {
        byte br = byte.Parse(hex.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
        byte bg = byte.Parse(hex.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
        byte bb = byte.Parse(hex.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
        float r = br / 255f;
        float g = bg / 255f;
        float b = bb / 255f;
        return new Color(r, g, b);
    }

    void RemoveLocalAcc() {
        PlayerPrefs.DeleteAll();
    }

    void RemoveMB()
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            Outline[] sps = temp.GetComponentsInChildren<Outline>(true);
            bool c = false;
            for (int j = 0; j < sps.Length; ++j)
            {
                c = true;
                Color ccc = sps[j].effectColor;
                sps[j].effectColor = new Color(ccc.r, ccc.g, ccc.b, 178.0f / 255.0f);
            }

            PrefabUtility.SavePrefabAsset(temp);
        }
    }

    void ChangeBtnAnimator()
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        List<string> btn_name = new List<string>();
        btn_name.Add("gjrui_007");
        btn_name.Add("gjrui_008");
        btn_name.Add("gjrui_009");
        btn_name.Add("gjrui_0010");
        btn_name.Add("gjrui_0011");
        btn_name.Add("gjrui_032");
        btn_name.Add("gjrui_033");
        btn_name.Add("gjrui_034");
        btn_name.Add("gjrui_035");
        btn_name.Add("gjrui_036");
        btn_name.Add("gjrui_065");
        btn_name.Add("uirs_zc_002");
        btn_name.Add("rwcj_reui003");
        btn_name.Add("zjmuire_007");
        btn_name.Add("zjmuire_008");
        btn_name.Add("zjmuire_009");
        btn_name.Add("zjmuire_0010");
        btn_name.Add("zjmuire_0011");
        btn_name.Add("zd_set_001b");
        btn_name.Add("zd_set_002");
        btn_name.Add("zd_set_001a");
        btn_name.Add("gjrui_067");

        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            Button[] sps = temp.GetComponentsInChildren<Button>(true);
            for (int j = 0; j < sps.Length; ++j)
            {
                string spritename = sps[j].gameObject.GetComponent<Image>().sprite.name;
                if (btn_name.Contains(spritename))
                {
                    Animator animator2 = sps[j].gameObject.GetComponent<Animator>();
                    if (animator2 == null)
                    {
                        Animator animator = sps[j].gameObject.AddComponent<Animator>();
                        animator.runtimeAnimatorController = re;
                        sps[j].transition = Selectable.Transition.Animation;
                        sps[j].animationTriggers.normalTrigger = "";
                        sps[j].animationTriggers.highlightedTrigger = "";
                        sps[j].animationTriggers.pressedTrigger = "Highlighted";
                        sps[j].animationTriggers.disabledTrigger = "";
                    }
                    else
                    {
                        sps[j].animationTriggers.normalTrigger = "Pressed";
                        sps[j].animationTriggers.highlightedTrigger = "Pressed";
                        sps[j].animationTriggers.pressedTrigger = "Highlighted";
                        sps[j].animationTriggers.disabledTrigger = "Pressed";
                    }
                }
              
            }
            PrefabUtility.SavePrefabAsset(temp);
        }
    }

    void findLocalKey()
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            LocalizationText[] sps = temp.GetComponentsInChildren<LocalizationText>(true);
            bool c = false;
            for (int j = 0; j < sps.Length; ++j)
            {
                if (sps[j].keyString == m_local_langKey)
                {
                    sps[j].keyString = "";
                    sps[j].clientLanguage = false;
                    PrefabUtility.SavePrefabAsset(temp);
                    /*GameObject temp2 = sps[j].gameObject;
                    List<string> path = new List<string>();
                    while (true)
                    {
                        if (temp2.transform.parent != null)
                        {
                            path.Add(temp2.name);
                            temp2 = temp2.transform.parent.gameObject;
                        }
                        else
                        {
                            break;
                        }
                    }

                    path.Reverse();
                    string path_name2 = "";
                    for (int k = 0; k < path.Count; k++)
                    {
                        if (k > 0)
                        {
                            path_name2 += "/" + path[k];
                        }
                        else
                        {
                            path_name2 += path[k];
                        }

                    }
                    Debug.Log(string.Format("{0}/{1}",temp2.transform.root.name, path_name2));
                    */
                }
            }
        }
    }

    void ChangeTextSize()
    {
        UnityEngine.Object[] selection = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
        List<string> btn_name = new List<string>();

        btn_name.Add("gjrui_007");
        btn_name.Add("gjrui_008");
        btn_name.Add("gjrui_009");
        btn_name.Add("gjrui_010");
        btn_name.Add("gjrui_011");
        btn_name.Add("gjrui_034");
        btn_name.Add("gjrui_035");
        btn_name.Add("gjrui_036");
        btn_name.Add("gjrui_065");
        btn_name.Add("uirs_zc_002");
        btn_name.Add("rwcj_reui003");
        btn_name.Add("zjmuire_007");
        btn_name.Add("zjmuire_008");
        btn_name.Add("zjmuire_009");
        btn_name.Add("zjmuire_010");
        btn_name.Add("zjmuire_011");
        btn_name.Add("zd_set_001b");
        btn_name.Add("zd_set_002");
        btn_name.Add("zd_set_001a");
        btn_name.Add("gjrui_067");
        btn_name.Add("gjrui_012");
        btn_name.Add("gjrui_013");
        btn_name.Add("gjrui_011_f");
        btn_name.Add("gjrui_005");
        btn_name.Add("gjrui_006");
        for (int i = 0; i < selection.Length; ++i)
        {
            GameObject temp = selection[i] as GameObject;
            if (temp == null)
            {
                continue;
            }

            Button[] sps = temp.GetComponentsInChildren<Button>(true);
            for (int j = 0; j < sps.Length; ++j)
            {

                sps[j].transition = Selectable.Transition.None;

                Animator animator2 = sps[j].gameObject.GetComponent<Animator>();
                if (animator2 != null)
                {
                     GameObject.DestroyImmediate(animator2, true);
                }


                /* if (sps[j].sprite != null)
                 {
                     string spritename = sps[j].sprite.name;
                     if (btn_name.Contains(spritename))
                     {

                         for (int b = 0; b < sps[j].gameObject.transform.childCount; b++)
                         {
                             LocalizationText lox = sps[j].gameObject.transform.GetChild(b).gameObject.GetComponent<LocalizationText>();
                             if (lox != null)
                             {
                                 if (lox.fontSize < 24)
                                 {
                                     lox.fontSize = 24;
                                 }
                             }
                             Text lox2 = sps[j].gameObject.transform.GetChild(b).gameObject.GetComponent<Text>();
                             if (lox2 != null)
                             {
                                 if (lox.fontSize < 24)
                                 {
                                     lox2.fontSize = 24;
                                 }
                             }

                         }

                     }
                 }*/

            }
            PrefabUtility.SavePrefabAsset(temp);
        }
    }
}