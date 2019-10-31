using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using LuaInterface;

public class DragPanel : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler {
    LuaFunction onBeginDragFunc = null;
    LuaFunction onDragFunc = null;
    LuaFunction onEndFunc = null;
    LuaTable param = null;
    public string drag_tag = "";

    public void Start() {
        SetAllTag(transform, "DragPanel");
    }

    void SetAllTag(Transform p, string tag) {
        if (p.childCount == 0) {
            p.gameObject.tag = tag;
        }
        else {
            for (int i = 0; i < p.childCount; i++) {
                p.GetChild(i).tag = tag;
                SetAllTag(p.GetChild(i), tag);
            }
        }
    }

    public void SetDragItem(string tag, LuaFunction beginFunc, LuaFunction dragFunc, LuaFunction endFunc, LuaTable param = null) {
        onBeginDragFunc = beginFunc;
        onDragFunc = dragFunc;
        onEndFunc = endFunc;
        this.param = param;
        this.drag_tag = tag;
    }

    public void OnBeginDrag(PointerEventData eventData) {
        if (onBeginDragFunc != null) {
            onBeginDragFunc.Call(eventData, param);
        }
    }

    public void OnDrag(PointerEventData eventData) {
        if (onDragFunc != null) {
            onDragFunc.Call(eventData, param);
        }
    }

    public void OnEndDrag(PointerEventData eventData) {
        if (onEndFunc != null) {
            onEndFunc.Call(eventData, param);
        }
    }

    private void OnDestroy() {
        RemoveLua();
    }

    public void RemoveLua() {
        if (onBeginDragFunc != null) {
            onBeginDragFunc.Dispose();
        }
        if (onDragFunc != null) {
            onDragFunc.Dispose();
        }
        if (onEndFunc != null) {
            onEndFunc.Dispose();
        }
        param = null;
        drag_tag = "";
    }
}
