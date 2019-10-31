using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D;
using System;
using UnityEngine.UI;

public class SpriteManager : MonoBehaviour {
#if UNITY_EDITOR
    private Dictionary<string, Action<SpriteAtlas>> m_reses = new Dictionary<string, Action<SpriteAtlas>>();
#endif
    void Awake() {
        SpriteAtlasManager.atlasRequested += on_altas_requested;
    }

    void OnDestroy() {
        SpriteAtlasManager.atlasRequested -= on_altas_requested;
    }

    void on_altas_requested(string tag, Action<SpriteAtlas> action) {
        if (Main.instance.LuaManager == null) {
#if UNITY_EDITOR
            m_reses.Add(tag, action);
#endif
            return;
        }
        SpriteAtlas spriteAtlas = GetSprite(tag);
        if (spriteAtlas == null) {
#if UNITY_EDITOR
            m_reses.Add(tag, action);
#endif
            return;
        }
        action(spriteAtlas);
    }

    SpriteAtlas GetSprite(string tag)
    {
        SpriteAtlas spriteAtlas = null;
        if (tag.ToLower() == "common")
        {
            spriteAtlas = Util.InvokeLuaFunction<SpriteAtlas>("resMgr", "LoadCommonAtlas");
        }
        else
        {
            spriteAtlas = Util.InvokeLuaFunction<string, SpriteAtlas>("GUIRoot", "GetSelfAtlas", tag);
        }
        return spriteAtlas;
    }

#if UNITY_EDITOR
    void Update() {
        if (Main.instance.LuaManager == null) {
            return;
        }
        List<String> ks = new List<string>();
        foreach (var k in m_reses.Keys) {
            SpriteAtlas spriteAtlas = GetSprite(k);
            if (spriteAtlas != null) {
                m_reses[k](spriteAtlas);
                ks.Add(k);
            }
        }
        for (int i = 0; i < ks.Count; ++i) {
            m_reses.Remove(ks[i]);
        }
    }
#endif
}
