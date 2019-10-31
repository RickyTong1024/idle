using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.U2D;

public class LuaFuncEx {
    public LuaFuncEx() {

    }

    public LuaFuncEx(LuaFunction func, LuaTable p) {
        luaFunc = func;
        param = p;
    }

    public LuaFunction luaFunc;
    public LuaTable param;
    public LuaTable param_ex;
}

public class LuaUIBehaviour : MonoBehaviour {
    private string data = null;
    private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();

    private Dictionary<string, LuaFuncEx> m_buttons = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_cus_btn_clicks = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_cus_btn_ups = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_cus_btn_downs = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_toggles = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_sliders = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_scrollbars = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_dropdowns = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_inputchangeds = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_inputends = new Dictionary<string, LuaFuncEx>();
    private Dictionary<string, LuaFuncEx> m_scrollviews = new Dictionary<string, LuaFuncEx>();

    private enum ControlType {
        button,
        toggle,
        slider,
        scrollbar,
        dropdown,
        inputchanged,
        inputend,
        scrollview,
    }

    private Dictionary<string, LuaTable> m_param = new Dictionary<string, LuaTable>();

    void CallLuaFunc<T>(string funcName, T arg1) {
        Util.CallLuaFunction<T>(gameObject.name, funcName, arg1);
    }

    protected void Awake() {
        CallLuaFunc<GameObject>("Awake", gameObject);
    }

    public void OnParam(LuaTable t) {
        CallLuaFunc<LuaTable>("OnParam", t);
    }

    public void OnReParam(LuaTable t) {
        CallLuaFunc<LuaTable>("OnReParam", t);
    }

    private void OnEnable()
    {
        CallLuaFunc<GameObject>("OnEnable", gameObject);
    }

    protected void Start() {
        CallLuaFunc<GameObject>("Start", gameObject);
    }

    protected void OnDisable() {
        CallLuaFunc<GameObject>("OnDisable", gameObject);
    }

    //---------------------------------ugui内部组件回调注册 与 销毁 -------------------------------------

    //添加 button  toggle 回调
    public void AddButtonEvent(GameObject go, string btnType, LuaFunction luafunc, LuaTable t = null) {
        RemoveButtonEvent(go, btnType);
        LuaFuncEx lua_func_ex = new LuaFuncEx(luafunc, t);
        if (btnType == "click") {
            m_buttons.Add(go.name, lua_func_ex);
            go.GetComponent<Button>().onClick.AddListener(delegate () {
                LuaFuncEx btn_lua_func_ex = null;
                if (m_buttons.TryGetValue(go.name, out btn_lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, lua_func_ex.param);
                }
            });
        }
        else if (btnType == "toggle") {
            m_toggles.Add(go.name, lua_func_ex);
            go.GetComponent<Toggle>().onValueChanged.AddListener(delegate (bool b) {
                LuaFuncEx toggle_lua_func_ex = null;
                if (m_toggles.TryGetValue(go.name, out toggle_lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, b, lua_func_ex.param);
                }
            }
           );
        }
    }

    //移除 button toggle 回调
    public void RemoveButtonEvent(GameObject go, string btnType) {
        if (go == null) {
            return;
        }
        Dictionary<string, LuaFuncEx> cur_dic = null;
        if (btnType == "click") {
            go.GetComponent<Button>().onClick.RemoveAllListeners();
            cur_dic = m_buttons;
        }
        else if (btnType == "toggle") {
            go.GetComponent<Toggle>().onValueChanged.RemoveAllListeners();
            cur_dic = m_toggles;
        }
        RemoveExInDic(go, cur_dic);
    }
    //移除所有的 button toggle 回调
    public void RemoveAllBtnEvents(string btnType) {
        if (btnType == "click") {
            if (m_buttons.Count == 0) {
                return;
            }
            RemoveTypeEvents(m_buttons, ControlType.button);
        }
        else if (btnType == "toggle") {
            if (m_toggles.Count == 0) {
                return;
            }
            RemoveTypeEvents(m_toggles, ControlType.toggle);
        }
    }

    //添加自定义按钮事件
    public void AddCustomButtonEvent(GameObject go, string type, LuaFunction luafunc, LuaTable t = null) {
        RemoveCustomButtonEvent(go, type);
        LuaFuncEx lua_func_ex = new LuaFuncEx(luafunc, t);
        if (type == "click") {
            m_cus_btn_clicks.Add(go.name, lua_func_ex);
            go.GetComponent<CustomButton>().onCustomClick.AddListener(delegate (PointerEventData event_data) {
                LuaFuncEx btn_lua_func_ex = null;
                if (m_cus_btn_clicks.TryGetValue(go.name, out btn_lua_func_ex)) {
                    btn_lua_func_ex.luaFunc.Call(go, btn_lua_func_ex.param, event_data);
                }
            });
        }
        else if (type == "up") {
            m_cus_btn_ups.Add(go.name, lua_func_ex);
            go.GetComponent<CustomButton>().onPointUp.AddListener(delegate (PointerEventData event_data) {
                LuaFuncEx btn_lua_func_ex = null;
                if (m_cus_btn_ups.TryGetValue(go.name, out btn_lua_func_ex)) {
                    btn_lua_func_ex.luaFunc.Call(go, btn_lua_func_ex.param, event_data);
                }
            });
        }
        else if (type == "down") {
            m_cus_btn_downs.Add(go.name, lua_func_ex);
            go.GetComponent<CustomButton>().onPointDown.AddListener(delegate (PointerEventData event_data) {
                LuaFuncEx btn_lua_func_ex = null;
                if (m_cus_btn_downs.TryGetValue(go.name, out btn_lua_func_ex)) {
                    btn_lua_func_ex.luaFunc.Call(go, btn_lua_func_ex.param, event_data);
                }
            });
        }
    }

    //移除自定义按钮事件
    public void RemoveCustomButtonEvent(GameObject go, string type) {
        if (go == null) {
            return;
        }
        Dictionary<string, LuaFuncEx> cur_dic = null;
        if (type == "click") {
            go.GetComponent<CustomButton>().onCustomClick.RemoveAllListeners();
            cur_dic = m_cus_btn_clicks;
        }
        else if (type == "up") {
            go.GetComponent<CustomButton>().onPointUp.RemoveAllListeners();
            cur_dic = m_cus_btn_ups;
        }
        else if (type == "down") {
            go.GetComponent<CustomButton>().onPointDown.RemoveAllListeners();
            cur_dic = m_cus_btn_downs;
        }
        RemoveExInDic(go, cur_dic);
    }


    //添加 slider 回调
    public void AddSliderEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveSliderEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_sliders.Add(go.name, luaFuncEx);
        go.GetComponent<Slider>().onValueChanged.AddListener(
            delegate (float num) {
                LuaFuncEx lua_func_ex = null;
                if (m_sliders.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, num, lua_func_ex.param);
                }
            }
        );
    }
    //移除 slider 回调
    public void RemoveSliderEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<Slider>().onValueChanged.RemoveAllListeners();
        RemoveExInDic(go, m_sliders);
    }
    //移除 所有的 slider 回调
    public void RemoveAllSliderEvent() {
        if (m_sliders.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_sliders, ControlType.slider);
    }
    //添加 scrollbar 回调
    public void AddScrollBarEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveScrollBarEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_scrollbars.Add(go.name, luaFuncEx);
        go.GetComponent<Scrollbar>().onValueChanged.AddListener(
            delegate (float num) {
                LuaFuncEx lua_func_ex = null;
                if (m_scrollbars.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, num, lua_func_ex.param);
                }
            }
        );
    }
    //移除 scrollbar 回调
    public void RemoveScrollBarEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<Scrollbar>().onValueChanged.RemoveAllListeners();
        RemoveExInDic(go, m_scrollbars);
    }
    //移除 所有的scrollbar 回调
    public void RemoveAllScrollBarEvents() {
        if (m_scrollbars.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_scrollbars, ControlType.scrollbar);
    }
    //添加 dropdown 回调
    public void AddDropDownEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveDropDownEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_dropdowns.Add(go.name, luaFuncEx);
        go.GetComponent<Dropdown>().onValueChanged.AddListener(
            delegate (int index) {
                LuaFuncEx lua_func_ex = null;
                if (m_dropdowns.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, index, lua_func_ex.param);
                }
            }
        );
    }
    //移除 dropdown 回调
    public void RemoveDropDownEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<Dropdown>().onValueChanged.RemoveAllListeners();
        RemoveExInDic(go, m_dropdowns);
    }
    //移除所有的 dropdown 回调
    public void RemoveAllDropDownEvents() {
        if (m_dropdowns.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_dropdowns, ControlType.dropdown);
    }
    //添加 inputfield 的 valuechange 回调
    public void AddInputChangedEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveInputChangedEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_inputchangeds.Add(go.name, luaFuncEx);
        go.GetComponent<InputField>().onValueChanged.AddListener(
            delegate (string str) {
                LuaFuncEx lua_func_ex = null;
                if (m_inputchangeds.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, str, lua_func_ex.param);
                }
            }
        );
    }
    //移除 inputfield 的 valuechange 回调
    public void RemoveInputChangedEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<InputField>().onValueChanged.RemoveAllListeners();
        RemoveExInDic(go, m_inputchangeds);
    }
    //移除所有的 inputfield 的 valuechange 回调
    public void RemoveAllInputChangedEvents() {
        if (m_inputchangeds.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_inputchangeds, ControlType.inputchanged);
    }
    //添加 inputfield 的 endedit 回调
    public void AddInputEndEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveInputEndEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_inputends.Add(go.name, luaFuncEx);
        go.GetComponent<InputField>().onEndEdit.AddListener(
            delegate (string str) {
                LuaFuncEx lua_func_ex = null;
                if (m_inputends.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, str, lua_func_ex.param);
                }
            }
        );
    }
    //移除 inputfield 的 endedit 回调
    public void RemoveInputEndEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<InputField>().onEndEdit.RemoveAllListeners();
        RemoveExInDic(go, m_inputends);
    }
    //移除所有的 inputfield 的 endedit 回调
    public void RemoveAllInputEndEvents() {
        if (m_inputends.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_inputends, ControlType.inputend);
    }
    //添加 scrollview 的 回调
    public void AddScrollViewEvent(GameObject go, LuaFunction luafunc, LuaTable t = null) {
        if (go == null || luafunc == null) return;
        RemoveScrollViewEvent(go);
        LuaFuncEx luaFuncEx = new LuaFuncEx(luafunc, t);
        m_scrollviews.Add(go.name, luaFuncEx);
        go.GetComponent<ScrollRect>().onValueChanged.AddListener(
            delegate (Vector2 vec) {
                LuaFuncEx lua_func_ex = null;
                if (m_scrollviews.TryGetValue(go.name, out lua_func_ex)) {
                    lua_func_ex.luaFunc.Call(go, vec, lua_func_ex.param);
                }
            }
        );
    }
    //移除 scrollview 的 回调
    public void RemoveScrollViewEvent(GameObject go) {
        if (go == null) {
            return;
        }
        go.GetComponent<ScrollRect>().onValueChanged.RemoveAllListeners();
        RemoveExInDic(go, m_scrollviews);
    }
    //移除所有的 scrollview 的 回调
    public void RemoveAllScrollViewEvents() {
        if (m_scrollviews.Count == 0) {
            return;
        }
        RemoveTypeEvents(m_scrollviews, ControlType.scrollview);
    }
    //移除panel内所有的注册事件
    public void RemoveAllEvents() {
        RemoveAllBtnEvents("click");
        RemoveAllBtnEvents("toggle");
        RemoveAllDropDownEvents();
        RemoveAllSliderEvent();
        RemoveAllInputChangedEvents();
        RemoveAllInputEndEvents();
        RemoveAllScrollBarEvents();
        RemoveAllScrollViewEvents();
    }


    private void RemoveExInDic(GameObject go, Dictionary<string, LuaFuncEx> event_dic) {
        if (go == null) {
            return;
        }
        LuaFuncEx old_lua_func = null;
        if (event_dic.TryGetValue(go.name, out old_lua_func)) {
            ClearLuaFuncEx(old_lua_func);
            event_dic.Remove(go.name);
        }
    }

    private void ClearLuaFuncEx(LuaFuncEx luaFuncEx) {
        if (luaFuncEx == null) {
            return;
        }
        if (luaFuncEx.luaFunc != null) {
            luaFuncEx.luaFunc.Dispose();
            luaFuncEx.luaFunc = null;
        }
        if (luaFuncEx.param != null) {
            luaFuncEx.param.Dispose();
            luaFuncEx.param = null;
        }
        if (luaFuncEx.param_ex != null) {
            luaFuncEx.param_ex.Dispose();
            luaFuncEx.param_ex = null;
        }
    }

    private void RemoveTypeEvents(Dictionary<string, LuaFuncEx> event_dic, ControlType type) {
        foreach (var item in event_dic) {
            string control_name = item.Key;
            LuaFuncEx luaFuncEx = item.Value;
            ClearLuaFuncEx(luaFuncEx);
            Transform control_tr = Util.FindSub(transform, control_name);
            if (control_tr == null) {
                continue;
            }
            switch (type) {
                case ControlType.button:
                Button btn = control_tr.GetComponent<Button>();
                btn.onClick.RemoveAllListeners();
                break;
                case ControlType.toggle:
                Toggle to = control_tr.GetComponent<Toggle>();
                to.onValueChanged.RemoveAllListeners();
                break;
                case ControlType.slider:
                Slider sli = control_tr.GetComponent<Slider>();
                sli.onValueChanged.RemoveAllListeners();
                break;
                case ControlType.scrollbar:
                Scrollbar scro = control_tr.GetComponent<Scrollbar>();
                scro.onValueChanged.RemoveAllListeners();
                break;
                case ControlType.dropdown:
                Dropdown dropdown = control_tr.GetComponent<Dropdown>();
                dropdown.onValueChanged.RemoveAllListeners();
                break;
                case ControlType.inputchanged:
                InputField inputField = control_tr.GetComponent<InputField>();
                inputField.onValueChanged.RemoveAllListeners();
                break;
                case ControlType.inputend:
                InputField inputField01 = control_tr.GetComponent<InputField>();
                inputField01.onEndEdit.RemoveAllListeners();
                break;
                case ControlType.scrollview:
                ScrollRect scrollRect = control_tr.GetComponent<ScrollRect>();
                scrollRect.onValueChanged.RemoveAllListeners();
                break;
                default:
                break;
            }
        }
        event_dic.Clear();
    }


    //---------------------------------自定义组件 drag press enter exit click up down  回调注册 与 销毁 -------------------------------------

    private UIEventPanel GetUIEventPanel(GameObject go) {
        UIEventPanel uIEventPanel = go.GetComponent<UIEventPanel>();
        if (uIEventPanel == null) {
            uIEventPanel = go.AddComponent<UIEventPanel>();
        }
        return uIEventPanel;
    }
    //添加开始拖拽回调
    public void AddBeginDragEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetBeginDragCallBack(luafunc, param);
    }
    //移除开始拖拽回调
    public void RemoveDragEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveBeginDragCallBack();
    }
    //添加拖拽中的回调
    public void AddOnDragEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetDragCallBack(luafunc, param);
    }
    //移除拖拽中的回调
    public void RemoveOnDragEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveDragCallBack();
    }
    //添加拖拽结束的回调
    public void AddEndDragEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetEndDragCallBack(luafunc, param);
    }
    //移除拖拽结束的回调
    public void RemoveEndDragEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveEndDragCallBack();
    }
    //添加点击回调
    public void AddClickEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetClickCallBack(luafunc, param);
    }
    //移除点击回调
    public void RemoveClickEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveClickCallBack();
    }
    //添加鼠标抬起的回调
    public void AddUpEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetUpCallBack(luafunc, param);
    }
    //移除鼠标抬起的回调
    public void RemoveUpEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveUpCallBack();
    }
    //添加鼠标按下的回调
    public void AddDownEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetDownCallBack(luafunc, param);
    }
    //移除鼠标按下的回调
    public void RemoveDownEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveDownCallBack();
    }
    //添加鼠标进入的回调
    public void AddEnterEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetEnterCallBack(luafunc, param);
    }
    //移除鼠标进入的回调
    public void RemoveEnterEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveEnterCallBack();
    }
    //添加鼠标移出的回调
    public void AddExitEvent(GameObject go, LuaFunction luafunc, LuaTable param = null) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.SetExitCallBack(luafunc, param);
    }
    //移除鼠标移出的回调
    public void RemoveExitEvent(GameObject go) {
        UIEventPanel uIEventPanel = GetUIEventPanel(go);
        uIEventPanel.RemoveExitCallBack();
    }

    public void AddDrag(GameObject go, string slotTag, LuaFunction onBeginDragFunc, LuaFunction onDragFunc, LuaFunction onEndFunc, LuaTable param = null) {
        DragPanel dragItem = go.AddComponent<DragPanel>();
        dragItem.SetDragItem(slotTag, onBeginDragFunc, onDragFunc, onEndFunc, param);
    }

    public void RemoveDrag(GameObject go) {
        if (go.GetComponent<DragPanel>() != null) {
            Destroy(go.GetComponent<DragPanel>());
        }
    }

    public void AddPress(GameObject go, float start_press_beat, float end_press_beat, float change_time, LuaFunction down_func, LuaFunction up_func, LuaTable param) {
        PressControl pressControl = go.AddComponent<PressControl>();
        pressControl.SetPressControl(start_press_beat, end_press_beat, change_time, down_func, up_func, param);
    }

    public void RemovePress(GameObject go) {
        if (go.GetComponent<PressControl>() != null) {
            Destroy(go.GetComponent<PressControl>());
        }
    }

    public void AddRectEvent(GameObject go, LuaFunction luafunc) {
        if (go == null || luafunc == null) return;
        go.GetComponent<ScrollRect>().onValueChanged.AddListener(
            delegate (Vector2 vec) {
                luafunc.Call(vec);
            }
        );
    }

    public void AddPress(GameObject go, LuaFunction luafunc) {
        if (go == null || luafunc == null) return;
        buttons.Add(go.name, luafunc);
    }

    /// <summary>
    /// 删除单击事件
    /// </summary>
    /// <param name="go"></param>
    public void RemoveClick(GameObject go) {
        if (go == null) return;
        LuaFunction luafunc = null;
        if (buttons.TryGetValue(go.name, out luafunc)) {
            luafunc.Dispose();
            luafunc = null;
            buttons.Remove(go.name);
            m_param.Remove(go.name);
        }
    }

    /// <summary>
    /// 清除单击事件
    /// </summary>
    public void ClearClick() {
        foreach (var de in buttons) {
            if (de.Value != null) {
                de.Value.Dispose();
            }
        }
        buttons.Clear();
        m_param.Clear();
    }




    //-----------------------------------------------------------------
    protected void OnDestroy() {
        RemoveAllEvents();
        CallLuaFunc<GameObject>("OnDestroy", gameObject);
    }
}
