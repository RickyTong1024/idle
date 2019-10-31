using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.Serialization;

namespace UnityEngine.UI {
    [AddComponentMenu("UI/CustomButton", 30)]
    public class CustomButton : Button {
        [FormerlySerializedAs("onPointDown")]
        [SerializeField]
        private ButtonDownEvent m_OnPointDown = new ButtonDownEvent();
        [FormerlySerializedAs("onPointUp")]
        [SerializeField]
        private ButtonUpEvent m_OnPointUp = new ButtonUpEvent();
        [FormerlySerializedAs("onCustomClick")]
        [SerializeField]
        private ButtonCustomClickEvent m_OnCustomClick = new ButtonCustomClickEvent();
       

        [Serializable]
        public class ButtonDownEvent : UnityEvent<PointerEventData> { }
        [Serializable]
        public class ButtonUpEvent : UnityEvent<PointerEventData> { }
        [Serializable]
        public class ButtonCustomClickEvent : UnityEvent<PointerEventData> { }

        public ButtonDownEvent onPointDown {
            get { return m_OnPointDown; }
            set { m_OnPointDown = value; }
        }

        public ButtonUpEvent onPointUp {
            get { return m_OnPointUp; }
            set { m_OnPointUp = value; }
        }

        public ButtonCustomClickEvent onCustomClick {
            get { return m_OnCustomClick; }
            set { m_OnCustomClick = value; }
        }

        public override void OnPointerDown(PointerEventData eventData) {
            base.OnPointerDown(eventData);
            if (!IsActive() || !IsInteractable())
                return;
            m_OnPointDown.Invoke(eventData);
        }

        public override void OnPointerUp(PointerEventData eventData) {
            base.OnPointerUp(eventData);
            if (!IsActive() || !IsInteractable())
                return;
            m_OnPointUp.Invoke(eventData);
        }

        public override void OnPointerClick(PointerEventData eventData) {
            base.OnPointerClick(eventData);
            if (!IsActive() || !IsInteractable())
                return;
            m_OnCustomClick.Invoke(eventData);
        }
    }
}