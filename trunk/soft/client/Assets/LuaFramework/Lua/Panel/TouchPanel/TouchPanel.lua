TouchPanel = {}

TouchPanel.Control = {}
local this = TouchPanel.Control
function TouchPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.toucheffect_ = this.transform_:Find("toucheffect"):GetComponent("RawImage")
    this.effect_tran_ = this.transform_:Find("toucheffect"):GetComponent("RectTransform")
    this.toucheffect_.texture = UIEffect.Camera.targetTexture
    this.pos = {}
    this.show_time = 0.5
end

function TouchPanel.OnEnable()
    this.transform_:SetAsLastSibling()
    UpdateBeat:Add(TouchPanel.Update, TouchPanel)
end

function TouchPanel.OnDisable()
    UIEffect.Hide("ui_touch01")
    UpdateBeat:Remove(TouchPanel.Update, TouchPanel)
end

function TouchPanel.OnDestroy(obj)
    this = {}
end

function TouchPanel.OnParam(params)
    this.show_time = 0.5
    this.pos = params[1]
    TouchPanel.ShowEffect()
end

function TouchPanel.OnReParam(params)
    TouchPanel.OnParam(params)
end

function TouchPanel.ShowEffect()
    UIEffect.Hide("ui_touch01")
    local x = Screen.width
    local y = Screen.height
    local size = GUIRoot.UICamera.orthographicSize
    local camera_size = {
        x = size * 2 * 100 * (x / y),
        y = size * 2 * 100
    }
    local scale_x = camera_size.x / x
    local scale_y = camera_size.y / y
    local tempa = this.pos.x * scale_x
    local tempb = this.pos.y * scale_y
    this.effect_tran_.anchoredPosition = Vector2(tempa , tempb)
    local r = UIEffect.Show("ui_touch01")
    this.toucheffect_.uvRect = r
    this.effect_tran_.gameObject:SetActive(true)
end

function TouchPanel.Update()
    if this.show_time >= 0 then
        this.show_time = this.show_time - Time.deltaTime
    end
    if this.show_time < 0 then
        GUIRoot.ClosePanel("TouchPanel")
    end
end