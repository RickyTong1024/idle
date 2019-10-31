using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EffectSound : MonoBehaviour
{
    public AudioClip m_clip;
    public float m_delay_time = 0;
    void Awake()
    {
        Invoke("delayfun", m_delay_time);
    }

    void delayfun()
    {
        if (Main.instance == null)
        {
            SoundManager sound = GameObject.FindObjectOfType<SoundManager>();
            if (sound == null) {
                return;
            }
            if (m_clip != null) {
                AudioSource _source = transform.gameObject.AddComponent<AudioSource>();
                Scene scene = SceneManager.GetActiveScene();
                if (scene.name == "testbattle") {
                    _source.volume = 1;
                }
                else {
                    _source.volume = sound.SoundEffectVolume;
                }
                _source.clip = m_clip;
                _source.Play();
            }
        }
        else
        {
            if (m_clip != null) {
                AudioSource _source = transform.gameObject.AddComponent<AudioSource>();
                Scene scene = SceneManager.GetActiveScene();
                if (scene.name == "testbattle") {
                    _source.volume = 1;
                }
                else {
                    _source.volume = Main.instance.SoundManager.SoundEffectVolume;
                }
                _source.clip = m_clip;
                _source.Play();
            }
        }
        
    }

    private void OnDestroy()
    {
        CancelInvoke("delayfun");
    }
}
