using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;

public class PressControl : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    private float press_beat = 0;
    private float add_speed = 0;

    public float start_press_beat = 0;
    public float end_press_beat = 0;
    public float change_time = 1;


    private bool start_press = false;
    private float timer = 0;
    private float press_count = 0;

    private LuaFunction down_func;
    private LuaFunction up_func;
    private LuaTable func_param;

    private void Awake()
    {
        down_func = null;
        up_func = null;
        func_param = null;
    }

    public void SetPressControl(float start_press_beat, float end_press_beat, float change_time, LuaFunction down_func, LuaFunction up_func, LuaTable param)
    {
        this.down_func = down_func;
        this.up_func = up_func;
        func_param = param;
        this.start_press_beat = start_press_beat;
        this.end_press_beat = end_press_beat;
        this.change_time = change_time;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        start_press = true;
        timer = 0;
        press_count = 0;
        press_beat = start_press_beat;
        add_speed = (start_press_beat - end_press_beat) / change_time;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        start_press = false;
        timer = 0;
        if (press_count <= 0)
        {
            if (down_func != null)
            {
                down_func.Call(func_param);
            }
        }
        if (up_func != null)
        {
            up_func = null;
        }
        press_count = 0;
        press_beat = 0;
    }


    private void Update()
    {
        if (start_press && press_beat > 0)
        {
            timer += Time.deltaTime;
            if (timer >= press_beat)
            {
                if (down_func != null)
                {
                    down_func.Call(func_param);
                }
                timer = 0;
                press_count++;
            }
            if (press_beat > end_press_beat)
            {
                press_beat -= Time.deltaTime * add_speed;
                if (press_beat <= end_press_beat)
                {
                    press_beat = end_press_beat;
                }
            }
        }
    }

    private void OnDestroy()
    {
        RemoveLua();
    }

    public void RemoveLua()
    {
        if (up_func != null)
        {
            up_func.Dispose();
        }
        if (down_func != null)
        {
            down_func.Dispose();
        }
        func_param = null;
    }
}
