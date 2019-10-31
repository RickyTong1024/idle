using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.EventSystems;
using UnityEngine.U2D;

public class PanelManager : MonoBehaviour {
    public Transform m_uiroot;

    private void Awake() {
        m_uiroot = transform.Find("UI/UIRoot");
    }


    public Transform Root {
        get {
            return transform;
        }
    }

    public GameObject SelectedUIObject() {
        if (EventSystem.current != null) {
            PointerEventData eventData = new PointerEventData(EventSystem.current);
            eventData.position = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
            List<RaycastResult> result = new List<RaycastResult>();
            EventSystem.current.RaycastAll(eventData, result);
            if (result.Count > 0) {
                return result[0].gameObject;
            }
        }
        return null;
    }
}