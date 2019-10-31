using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using LuaInterface;

public class SoundSub {
    public float time;
    public string name;
    public AudioSource sound;
}

public class SoundManager : MonoBehaviour {
    private AudioSource m_play_mus;
    private string m_mus_name = "";
    private string m_last_mus_name = "";
    private bool m_stop_mus = false;
    private float m_sound_volume = 0.5f;
    private float m_sound_effect_volume = 0.5f;
    private List<SoundSub> m_sounds = new List<SoundSub>();

    private void Start() {
        m_play_mus = transform.gameObject.AddComponent<AudioSource>();
        if (PlayerPrefs.HasKey("SoundVolume")) {
            m_sound_volume = PlayerPrefs.GetFloat("SoundVolume");
        }
        else {
            m_sound_volume = 0.5f;
            PlayerPrefs.SetFloat("SoundVolume", m_sound_volume);
        }

        if (PlayerPrefs.HasKey("SoundEffectVolume")) {
            m_sound_effect_volume = PlayerPrefs.GetFloat("SoundEffectVolume");
        }
        else {
            m_sound_effect_volume = 0.5f;
            PlayerPrefs.SetFloat("SoundEffectVolume", m_sound_effect_volume);
        }
    }

    public float SoundVolume {
        get {
            return m_sound_volume;
        }
        set {
            m_sound_volume = value;
            PlayerPrefs.SetFloat("SoundVolume", m_sound_volume);
            m_play_mus.volume = m_sound_volume;
        }
    }

    public float SoundEffectVolume {
        get {
            return m_sound_effect_volume;
        }
        set {
            m_sound_effect_volume = value;
            PlayerPrefs.SetFloat("SoundEffectVolume", m_sound_effect_volume);
            for (int i = 0; i < m_sounds.Count; ++i) {
                m_sounds[i].sound.volume = m_sound_effect_volume;
            }
        }
    }

    public void play_mus(string name) {
        m_mus_name = name;
        m_stop_mus = true;
    }

    public void play_sound(string name) {
        if (m_sounds.Count >= 10) {
            return;
        }
        int num = 0;
        for (int i = 0; i < m_sounds.Count; ++i) {
            if (name == m_sounds[i].name) {
                num++;
            }
        }
        if (num >= 3) {
            return;
        }

        AudioClip _clip = Util.InvokeLuaFunction<string, AudioClip>("resMgr", "LoadSound", name);
        if (_clip != null) {
            AudioSource _source = transform.gameObject.AddComponent<AudioSource>();
            _source.volume = m_sound_effect_volume;
            _source.clip = _clip;
            _source.Play();

            SoundSub ss = new SoundSub();
            ss.name = name;
            ss.sound = _source;
            ss.time = 0;
            m_sounds.Add(ss);
        }
    }

    void Update() {
        //“Ù–ß
        List<SoundSub> dels = new List<SoundSub>();
        for (int i = 0; i < m_sounds.Count; ++i) {
            SoundSub ss = m_sounds[i];
            ss.time += Time.deltaTime;
            if (ss.time > ss.sound.clip.length) {
                dels.Add(ss);
                UnityEngine.Object.Destroy(ss.sound);
                Util.CallLuaFunction<string>("resMgr", "UnloadSound", ss.name);
            }
        }
        for (int i = 0; i < dels.Count; ++i) {
            m_sounds.Remove(dels[i]);
        }
        //“Ù¿÷
        if (m_stop_mus == true) {
            if (m_play_mus.volume > 0) {
                m_play_mus.volume -= Time.deltaTime;
            }

            if (m_play_mus.volume <= 0) {
                m_stop_mus = false;
                m_play_mus.volume = 0.0f;
                m_play_mus.Stop();
                if (m_last_mus_name != "") {
                    Util.CallLuaFunction<string>("resMgr", "UnloadMusic", m_last_mus_name);
                    m_last_mus_name = "";
                }
                if (m_mus_name.Length > 0) {
                    AudioClip _clip = Util.InvokeLuaFunction<string, AudioClip>("resMgr", "LoadMusic", m_mus_name);
                    if (_clip != null) {
                        m_play_mus.clip = _clip;
                        m_play_mus.loop = true;
                        m_play_mus.Play();
                        m_last_mus_name = m_mus_name;
                    }
                }
            }
        }
        else if (m_play_mus.isPlaying && m_play_mus.volume < m_sound_volume) {
            m_play_mus.volume += Time.deltaTime / 2;
        }
    }
}