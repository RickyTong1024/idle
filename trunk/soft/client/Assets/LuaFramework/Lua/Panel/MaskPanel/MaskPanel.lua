MaskPanel = {}
MaskPanel.Control = {}
local this = MaskPanel.Control

function MaskPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.mask_ = this.transform_:Find("mask")
end

function MaskPanel.OnEnable()
    this.mask_.gameObject:SetActive(false)
    this.transform_:SetAsLastSibling()
    timerMgr:AddTimer("MaskPanel", MaskPanel.ShowRing, nil, 3)
end

function MapPanel.OnDisable()
    timerMgr:RemoveTimer("MaskPanel")
end

function MaskPanel.ShowRing()
    this.mask_.gameObject:SetActive(true)
end

function MaskPanel.OnDestroy()
    this = {}
end

