LoadingPixelPanel = {}
LoadingPixelPanel.Control = {}
local this = LoadingPixelPanel.Control

function LoadingPixelPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.pe_ = GUIRoot.UICamera.transform:GetComponent("PostEffect")
end

function LoadingPixelPanel.OnEnable()
    this.transform_:SetAsLastSibling()
    this.time_ = 0
    this.is_mid_ = false
    this.pe_.enabled = true
    this.call_back_ = nil
    this.call_back_params = nil
    UpdateBeat:Add(LoadingPixelPanel.Update, LoadingPixelPanel)
end

function LoadingPixelPanel.OnDisable()
    this.pe_.enabled = false
    UpdateBeat:Remove(LoadingPixelPanel.Update, LoadingPixelPanel)
end

function LoadingPixelPanel.OnDestroy()
    this = {}
end

function LoadingPixelPanel.OnParam(params)
    this.call_back_ = params[1]
    this.call_back_params_ = params[2]
end

function LoadingPixelPanel.OnReParam(params)
    LoadingPixelPanel.OnParam(params)
end

function LoadingPixelPanel.Update()
	this.time_ = this.time_ + Time.deltaTime
	local v = 256
    if this.time_ < 0.5 then
		v = 256 - 224 * this.time_ / 0.5
		this.pe_.EffectMaterial:SetInt("_PixelSize", v)
	elseif this.time_ < 1 then
		if not this.is_mid_ then
            this.is_mid_ = true
            if this.call_back_ ~= nil then
                this.call_back_(this.call_back_params_)
            end
        end
		v = 256 - 224 * this.time_ / 0.5
		this.pe_.EffectMaterial:SetInt("_PixelSize", v)
    else
        GUIRoot.ClosePanel("LoadingPixelPanel")
    end
end