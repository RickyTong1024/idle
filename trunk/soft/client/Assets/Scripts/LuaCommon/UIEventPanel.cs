using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;


public class UIEventPanel : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler,
    IPointerDownHandler, IPointerUpHandler, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    LuaFunction beginDragCallBack = null;
    LuaTable beginDragParam = null;
    LuaFunction dragCallBack = null;
    LuaTable dragParam = null;
    LuaFunction endDragCallBack = null;
    LuaTable endDragParam = null;
    LuaFunction clickCallBack = null;
    LuaTable clickParam = null;
    LuaFunction downCallBack = null;
    LuaTable downParam = null;
    LuaFunction enterCallBack = null;
    LuaTable enterParam = null;
    LuaFunction exitCallBack = null;
    LuaTable exitParam = null;
    LuaFunction upCallBack = null;
    LuaTable upParam = null;

    public void SetBeginDragCallBack(LuaFunction func, LuaTable param)
    {
        RemoveBeginDragCallBack();
        beginDragCallBack = func;
        beginDragParam = param;
    }

    public void RemoveBeginDragCallBack()
    {
        if (beginDragCallBack != null)
        {
            beginDragCallBack.Dispose();
            beginDragCallBack = null;
        }
        if (beginDragParam != null)
        {
            beginDragParam.Dispose();
            beginDragParam = null;
        }
    }


    public void OnBeginDrag(PointerEventData eventData)
    {
        if (beginDragCallBack != null)
        {
            beginDragCallBack.Call(this.gameObject, eventData, beginDragParam);
        }
    }

    public void SetDragCallBack(LuaFunction func, LuaTable param)
    {
        RemoveDragCallBack();
        dragCallBack = func;
        dragParam = param;
    }

    public void RemoveDragCallBack()
    {
        if (dragCallBack != null)
        {
            dragCallBack.Dispose();
            dragCallBack = null;
        }
        if (dragParam != null)
        {
            dragParam.Dispose();
            dragParam = null;
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (dragCallBack != null)
        {
            dragCallBack.Call(this.gameObject, eventData, dragParam);
        }
    }

    public void SetEndDragCallBack(LuaFunction func, LuaTable param)
    {
        RemoveEndDragCallBack();
        endDragCallBack = func;
        endDragParam = param;
    }

    public void RemoveEndDragCallBack()
    {
        if (endDragCallBack != null)
        {
            endDragCallBack.Dispose();
            endDragCallBack = null;
        }
        if (endDragParam != null)
        {
            endDragParam.Dispose();
            endDragParam = null;
        }        
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        if (endDragCallBack != null)
        {
            endDragCallBack.Call(this.gameObject, eventData, endDragParam);
        }
    }

    public void SetClickCallBack(LuaFunction func, LuaTable param)
    {
        RemoveClickCallBack();
        clickCallBack = func;
        clickParam = param;
    }

    public void RemoveClickCallBack()
    {
        if (clickCallBack != null)
        {
            clickCallBack.Dispose();
            clickCallBack = null;
        }
        if (clickParam != null)
        {
            clickParam.Dispose();
            clickParam = null;
        }        
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (clickCallBack != null)
        {
            clickCallBack.Call(this.gameObject, eventData, clickParam);
        }
    }

    public void SetDownCallBack(LuaFunction func, LuaTable param)
    {
        RemoveDownCallBack();
        downCallBack = func;
        downParam = param;
    }

    public void RemoveDownCallBack()
    {
        if (downCallBack != null)
        {
            downCallBack.Dispose();
            downCallBack = null;
        }
        if (downParam != null)
        {
            downParam.Dispose();
            downParam = null;
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (downCallBack != null)
        {
            downCallBack.Call(this.gameObject, eventData, downParam);
        }
    }

    public void SetEnterCallBack(LuaFunction func, LuaTable param)
    {
        RemoveEnterCallBack();
        enterCallBack = func;
        enterParam = param;
    }

    public void RemoveEnterCallBack()
    {
        if (enterCallBack != null)
        {
            enterCallBack.Dispose();
            enterCallBack = null;
        }
        if (enterParam != null)
        {
            enterCallBack.Dispose();
            enterCallBack = null;
        }
    }
    public void OnPointerEnter(PointerEventData eventData)
    {
        if (enterCallBack != null)
        {
            enterCallBack.Call(this.gameObject, eventData, enterParam);
        }
    }

    public void SetExitCallBack(LuaFunction func, LuaTable param)
    {
        RemoveExitCallBack();
        exitCallBack = func;
        exitParam = param;
    }

    public void RemoveExitCallBack()
    {
        if (exitCallBack != null)
        {
            exitCallBack.Dispose();
            exitCallBack = null;
        }
        if (exitParam != null)
        {
            exitParam.Dispose();
            exitParam = null;
        }
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (exitCallBack != null)
        {
            exitCallBack.Call(this.gameObject, eventData, exitParam);
        }
    }

    public void SetUpCallBack(LuaFunction func, LuaTable param)
    {
        RemoveUpCallBack();
        upCallBack = func;
        upParam = param;
    }

    public void RemoveUpCallBack()
    {
        if (upCallBack != null)
        {
            upCallBack.Dispose();
            upCallBack = null;
        }
        if (upParam != null)
        {
            upParam.Dispose();
            upParam = null;
        }       
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (upCallBack != null)
        {
            upCallBack.Call(this.gameObject, eventData, upParam);
        }
    }

    public void RemoveAllEvents()
    {
        RemoveBeginDragCallBack();
        RemoveDragCallBack();
        RemoveEndDragCallBack();
        RemoveClickCallBack();
        RemoveDownCallBack();
        RemoveUpCallBack();
        RemoveEnterCallBack();
        RemoveExitCallBack();
    }

    private void OnDestroy()
    {
        RemoveAllEvents();
    }
}
