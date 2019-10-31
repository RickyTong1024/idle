using System;
using UnityEngine.UI;
using UnityEngine;

[DisallowMultipleComponent]
[AddComponentMenu("UGUI Localization/Localization Text")]
public class LocalizationText : Text {

    [Header("Localization")]
    [SerializeField]
    protected bool m_Underline;

    [Header("Localization")]
    [SerializeField]
    protected string m_KeyString;

    [Header("Localization")]
    [SerializeField]
    protected bool m_ClientLanguage;

    public bool underLine {
        get { return this.m_Underline; }
        set { this.m_Underline = value; }
    }

    public bool clientLanguage {
        get { return this.m_ClientLanguage; }
        set { this.m_ClientLanguage = value; }
    }

    public string keyString {
        get { return this.m_KeyString; }
        set { this.m_KeyString = value; }
    }

    protected override void Start() {
        if (Application.isPlaying) {
            if (m_ClientLanguage && m_KeyString != "") {
                string str = Util.InvokeLuaFunction<string, string>("Config", "get_Text_lang", m_KeyString);
                if (str == null) {
                    text = "";
                }
                else {
                    text = str;
                }
            }
        }

        if (m_Underline && Application.isPlaying) {
            this.m_Underline = false;
            LocalizationText underline = Instantiate(this) as LocalizationText;
            underline.name = "Underline";
            underline.m_Underline = false;
            underline.m_ClientLanguage = false;
            underline.text = "";
            underline.transform.SetParent(this.transform);
            RectTransform rt = underline.rectTransform;
            underline.transform.localScale = Vector3.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.offsetMax = Vector2.zero;
            rt.offsetMin = Vector2.zero;
            rt.anchorMax = new Vector2(1, 0.7f);
            rt.anchorMin = Vector2.zero;
            underline.text = "_";
            float perlineWidth = underline.preferredWidth;
            float width = this.preferredWidth;
            int lineCount = (int)Mathf.Round(width / perlineWidth);
            for (int i = 1; i < lineCount; i++) {
                underline.text += "_";
            }
        }

        base.Start();

    }

    public void CreateLink(LocalizationText text) {
        if (text == null)
            return;
    }
}

