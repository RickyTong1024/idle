using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class EventTrriggerL : EventTrigger
{
    // Start is called before the first frame update
    ScrollRect m_scrollrect;
    void Start()
    {
        ScrollRect scrollrect = GetComponentInParent<ScrollRect>();
        if (scrollrect != null)
        {
            Transform rect = scrollrect.content;
            if (rect != null)
            {
                if (transform.IsChildOf(rect.parent))
                {
                    m_scrollrect = scrollrect;
                }
            }
        }
    }

    public override void OnBeginDrag(PointerEventData eventData)
    {
        if (m_scrollrect != null)
        {
            m_scrollrect.OnBeginDrag(eventData);
        }
    }

    public override void OnDrag(PointerEventData eventData)
    {
        if (m_scrollrect != null)
        {
            m_scrollrect.OnDrag(eventData);
        }
    }

    public override void OnEndDrag(PointerEventData eventData)
    {
        if (m_scrollrect != null)
        {
           m_scrollrect.OnEndDrag(eventData);
        }
    }

    public override void OnInitializePotentialDrag(PointerEventData eventData)
    {
        if (m_scrollrect != null)
        {
            m_scrollrect.OnInitializePotentialDrag(eventData);
        }
    }

    public override void OnScroll(PointerEventData eventData)
    {
        if (m_scrollrect != null)
        {
            m_scrollrect.OnScroll(eventData);
        }
    }
}
