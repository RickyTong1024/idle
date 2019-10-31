using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightTime : MonoBehaviour
{
    // Start is called before the first frame update
    public float m_start_time;
    public float m_end_time;
    [Range(0, 1f)]
    public float m_fade;
    private float m_time;
    private int m_state;
    private Light m_light;
    private float m_intensity;

    void Start()
    {
        m_state = 0;
        m_time = 0;
        m_light = this.gameObject.GetComponent<Light>();
        m_intensity = m_light.intensity;
        m_light.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        m_time = m_time + Time.deltaTime;
        if (m_state == 0)
        {
            if (m_time >= m_start_time)
            {
                m_light.enabled = true;
                m_state = 1;
            }
        }
        else if (m_state == 1)
        {
            float ld = 1;
            float tt = m_end_time - m_start_time;
            float tt1 = tt * 0.1f;
            float t1 = m_start_time + tt1 - m_time;
            if (tt1 > 0 && t1 > 0)
            {
                ld = 1 - t1 / tt1;
            }
            float tt2 = tt * m_fade * 0.9f;
            float t2 = m_time - (m_end_time - tt1);
            if (tt1 > 0 && t2 > 0)
            {
                ld = 1 - t2 / tt2;
            }
            m_light.intensity = m_intensity * ld;
            if (m_time >= m_end_time)
            {
                m_light.enabled = false;
                m_state = 2;
            }
        }
    }
}
