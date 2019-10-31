using System;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

[DisallowMultipleComponent]
[AddComponentMenu("UGUI IdleToggle/Idle Toggle")]
public class IdleToggle : Toggle
{

    [Header("extension")]
    [SerializeField]
    protected Graphic m_TextGraphic;

    public Graphic TextGraphic
    {
        get { return this.m_TextGraphic; }
        set { this.m_TextGraphic = value; }
    }

    protected IdleToggle()
    { }

#if UNITY_EDITOR
    protected override void OnValidate()
    {
        base.OnValidate();

        if (!UnityEditor.PrefabUtility.IsPartOfPrefabAsset(this) && !Application.isPlaying)
            CanvasUpdateRegistry.RegisterCanvasElementForLayoutRebuild(this);
    }

#endif // if UNITY_EDITOR

    protected override void OnDidApplyAnimationProperties()
    {
        // Check if isOn has been changed by the animation.
        // Unfortunately there is no way to check if we don�t have a graphic.
        if (graphic != null)
        {
            bool oldValue = !Mathf.Approximately(graphic.canvasRenderer.GetColor().a, 0);
            if (base.isOn != oldValue)
            {
                base.isOn = oldValue;
                Set(!oldValue);
            }
        }
        if (TextGraphic != null)
        {
            bool oldValue = !Mathf.Approximately(TextGraphic.canvasRenderer.GetColor().a, 0);
            if (base.isOn != oldValue)
            {
                base.isOn = oldValue;
                Set(!oldValue);
            }
        }

        base.OnDidApplyAnimationProperties();
    }

    private void SetToggleGroup(ToggleGroup newGroup, bool setMemberValue)
    {
        ToggleGroup oldGroup = base.group;

        // Sometimes IsActive returns false in OnDisable so don't check for it.
        // Rather remove the toggle too often than too little.
        if (base.group != null)
            base.group.UnregisterToggle(this);

        // At runtime the group variable should be set but not when calling this method from OnEnable or OnDisable.
        // That's why we use the setMemberValue parameter.
        if (setMemberValue)
            base.group = newGroup;

        // Only register to the new group if this Toggle is active.
        if (newGroup != null && IsActive())
            newGroup.RegisterToggle(this);

        // If we are in a new group, and this toggle is on, notify group.
        // Note: Don't refer to m_Group here as it's not guaranteed to have been set.
        if (newGroup != null && newGroup != oldGroup && isOn && IsActive())
            newGroup.NotifyToggleOn(this);
    }


    void Set(bool value)
    {
        Set(value, true);
    }

    void Set(bool value, bool sendCallback)
    {
        if (base.isOn == value)
            return;

        // if we are in a group and set to true, do group logic
        base.isOn = value;
        if (base.group != null && IsActive())
        {
            if (base.isOn || (!base.group.AnyTogglesOn() && !base.group.allowSwitchOff))
            {
                base.isOn = true;
                base.group.NotifyToggleOn(this);
            }
        }

        PlayEffect(toggleTransition == ToggleTransition.None);
        if (sendCallback)
        {
            UISystemProfilerApi.AddMarker("Toggle.value", this);
            onValueChanged.Invoke(base.isOn);
        }
    }

    /// <summary>
    /// Play the appropriate effect.
    /// </summary>
    private void PlayEffect(bool instant)
    {
        if (graphic == null)
            return;

#if UNITY_EDITOR
        if (!Application.isPlaying)
            graphic.canvasRenderer.SetAlpha(base.isOn ? 1f : 0f);
            if (m_TextGraphic != null)
                m_TextGraphic.CrossFadeAlpha(base.isOn ? 1f : 0f, instant ? 0f : 0.1f, true);
        else
#endif
            setgraphic(instant);

    }

    private void setgraphic(bool instant)
    {
        graphic.CrossFadeAlpha(base.isOn ? 1f : 0f, instant ? 0f : 0.1f, true);
        if (m_TextGraphic != null)
            m_TextGraphic.CrossFadeAlpha(base.isOn ? 1f : 0f, instant ? 0f : 0.1f, true);
    }

    /// <summary>
    /// Assume the correct visual state.
    /// </summary>
    protected override void Start()
    {
        PlayEffect(true);
    }

    private void InternalToggle()
    {
        if (!IsActive() || !IsInteractable())
            return;

        base.isOn = !base.isOn;
    }

}

