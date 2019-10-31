using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public static class EditorUGUI
{

    [MenuItem("GameObject/UI/LocalizationText")]
    public static void CreateLocalizationText()
    {
        GameObject root = new GameObject("Text", typeof(RectTransform), typeof(LocalizationText));
        ResetInCanvasFor((RectTransform)root.transform);
        root.GetComponent<RectTransform>().sizeDelta = new Vector2(100, 30);
        root.GetComponent<LocalizationText>().text = "New Text";
        var text = root.GetComponent<LocalizationText>();
        text.text = "New Text";
        Font m_font = AssetDatabase.LoadAssetAtPath<Font>("Assets/Resources/zrch.TTF") as Font;
        if (m_font != null)
        {
            text.font = m_font;
        }
        text.color = new Color(50f / 255f, 50f / 255f, 50f / 255f);
        text.alignment = TextAnchor.UpperLeft;
        root.transform.localPosition = Vector3.zero;
    }

    [MenuItem("GameObject/UI/CustomButton")]
    public static void CreateCustomButton() {
        GameObject root = new GameObject("CustomButton", typeof(RectTransform), typeof(Image), typeof(CustomButton));
        Image i = root.GetComponent<Image>();
        ResetInCanvasFor((RectTransform)root.transform);
        root.GetComponent<RectTransform>().sizeDelta = new Vector2(160, 30);
        CustomButton cus = root.GetComponent<CustomButton>();
        cus.targetGraphic = i;
    }

    public static void TextSpacingGUI(SerializedProperty m_UseTextSpacing, SerializedProperty m_TextSpacing, ref bool m_TextSpacingPanelOpen)
    {
        LayoutF(() =>
        {            
            EditorGUILayout.PropertyField(m_UseTextSpacing);
            if (m_UseTextSpacing.boolValue)
            {
                Space();
                LayoutH(() => {
                    EditorGUI.PropertyField(GUIRect(0, 18), m_TextSpacing, new GUIContent());
                });
            }
        }, "Text Spacing", ref m_TextSpacingPanelOpen, true);
    }


    public static void TextShadowGUI(SerializedProperty m_UseShadow, SerializedProperty m_ShadowColorTopLeft, SerializedProperty m_ShadowColorTopRight,
           SerializedProperty m_ShadowColorBottomLeft, SerializedProperty m_ShadowColorBottomRight, SerializedProperty m_ShadowEffectDistance, ref bool m_TextShadowPanelOpen)
    {
        LayoutF(() =>
        {
            EditorGUILayout.PropertyField(m_UseShadow);
            if (m_UseShadow.boolValue)
            {
                Space();
                LayoutH(() => {
                    EditorGUI.PropertyField(GUIRect(0, 18), m_ShadowColorTopLeft, new GUIContent());
                    Space();
                    EditorGUI.PropertyField(GUIRect(0, 18), m_ShadowColorTopRight, new GUIContent());
                });
                Space();
                LayoutH(() => {
                    EditorGUI.PropertyField(GUIRect(0, 18), m_ShadowColorBottomLeft, new GUIContent());
                    Space();
                    EditorGUI.PropertyField(GUIRect(0, 18), m_ShadowColorBottomRight, new GUIContent());
                });
                Space();
                EditorGUILayout.PropertyField(m_ShadowEffectDistance);
            }
        }, "Shadow", ref m_TextShadowPanelOpen, true);
    }


    public static void SimpleUseGUI(string title, ref bool m_PanelOpen, float space, SerializedProperty useThis, params SerializedProperty[] sps)
    {
        LayoutF(() => {
            EditorGUILayout.PropertyField(useThis);
            if (useThis.boolValue)
            {
                foreach (var s in sps)
                {
                    if (s != null)
                    {
                        EditorGUILayout.PropertyField(s);
                    }
                }
            }
        }, title, ref m_PanelOpen, true);
    }

    private static void ResetInCanvasFor(RectTransform root)
    {
        root.SetParent(Selection.activeTransform);
        if (!InCanvas(root))
        {
            Transform canvasTF = GetCreateCanvas();
            root.SetParent(canvasTF);
        }
        if (!Transform.FindObjectOfType<UnityEngine.EventSystems.EventSystem>())
        {
            GameObject eg = new GameObject("EventSystem");
            eg.AddComponent<UnityEngine.EventSystems.EventSystem>();
            eg.AddComponent<UnityEngine.EventSystems.StandaloneInputModule>();
        }
        root.localScale = Vector3.one;
        root.localPosition = new Vector3(root.localPosition.x, root.localPosition.y, 0f);
        Selection.activeGameObject = root.gameObject;
    }


    private static bool InCanvas(Transform tf)
    {
        while (tf.parent)
        {
            tf = tf.parent;
            if (tf.GetComponent<Canvas>())
            {
                return true;
            }
        }
        return false;
    }

    private static Transform GetCreateCanvas()
    {
        Canvas c = Object.FindObjectOfType<Canvas>();
        if (c)
        {
            return c.transform;
        }
        else
        {
            GameObject g = new GameObject("Canvas");
            c = g.AddComponent<Canvas>();
            c.renderMode = RenderMode.ScreenSpaceOverlay;
            g.AddComponent<CanvasScaler>();
            g.AddComponent<GraphicRaycaster>();
            return g.transform;
        }
    }

    private static void LayoutF(System.Action action, string label, ref bool open, bool box = false)
    {
        bool _open = open;
        LayoutV(() => {
            _open = GUILayout.Toggle(
                _open,
                label,
                GUI.skin.GetStyle("foldout"),
                GUILayout.ExpandWidth(true),
                GUILayout.Height(18)
            );
            if (_open)
            {
                action();
            }
        }, box);
        open = _open;
    }

    private static Rect GUIRect(float width, float height)
    {
        return GUILayoutUtility.GetRect(width, height, GUILayout.ExpandWidth(width <= 0), GUILayout.ExpandHeight(height <= 0));
    }


    private static void Space(float space = 4f)
    {
        GUILayout.Space(space);
    }

    private static void LayoutH(System.Action action, bool box = false)
    {
        if (box)
        {
            GUIStyle style = new GUIStyle(GUI.skin.box);
            GUILayout.BeginHorizontal(style);
        }
        else
        {
            GUILayout.BeginHorizontal();
        }
        action();
        GUILayout.EndHorizontal();
    }


    private static void LayoutV(System.Action action, bool box = false)
    {
        if (box)
        {
            GUIStyle style = new GUIStyle(GUI.skin.box)
            {
                padding = new RectOffset(6, 6, 2, 2)
            };
            GUILayout.BeginVertical(style);
        }
        else
        {
            GUILayout.BeginVertical();
        }
        action();
        GUILayout.EndVertical();
    }

}
