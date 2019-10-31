UIEffect = {}

UIEffect.UIEffectRoot = nil
UIEffect.EffectRoot = nil
UIEffect.Camera = nil
local mpos_ = {{0.666, 0.666}, {0, 0.666}, {-0.666, 0.666}, {0.666, 0}, {0, 0}, {-0.666, 0}, {0.666, -0.666}, {0, -0.666}, {-0.666, -0.666}}
local effects_ = {}

function UIEffect.Init()
    UIEffect.UIEffectRoot = panelMgr.Root:Find("UIEffectRoot")
    UIEffect.EffectRoot = panelMgr.Root:Find("UIEffectRoot/EffectRoot")
	UIEffect.Camera = UIEffect.UIEffectRoot:Find("UiEffectCamera"):GetComponent("Camera")
end

function UIEffect.Finish()
	for i = 1, 9 do
		if effects_[i] ~= nil then
			local effect = effects_[i]
			GameObject.Destroy(effect.obj)
			resMgr.UnloadEffect(effect.name)
		end
	end
	effects_ = {}
	UIEffect.UIEffectRoot = nil
	UIEffect.EffectRoot = nil
	UIEffect.Camera = nil
end

function UIEffect.Show(name)
	local index = -1
	for i = 1, 9 do
		if effects_[i] ~= nil then
			if effects_[i].name == name then
				return UIEffect.GetRect(i), effects_[i].obj
			end
		else
			if index == -1 then
				index = i
			end
		end
	end
	local go = resMgr.LoadUIEffect(name)
    local obj = GameObject.Instantiate(go)
	obj.transform:SetParent(UIEffect.EffectRoot)
    obj.transform.localPosition = Vector3(mpos_[index][1], mpos_[index][2], 0)
    obj.transform.localEulerAngles = Vector3(0, 0, 0)
    obj.transform.localScale = Vector3(1, 1, 1)
	local effect = {}
	effect.name = name
	effect.obj = obj
	effects_[index] = effect
    return UIEffect.GetRect(index), effect.obj
end

function UIEffect.Hide(name)
	local index = -1
	for i = 1, 9 do
		if effects_[i] ~= nil then
			if effects_[i].name == name then
				index = i
				break
			end
		end
	end
    if index == -1 then
		return
    end
	local effect = effects_[index]
    GameObject.Destroy(effect.obj)
	resMgr.UnloadUIEffect(name)
	effects_[index] = nil
end

function UIEffect.GetRect(index)
	if index == 1 then
		return UnityEngine.Rect(0, 0.666, 0.333, 0.3333)
	elseif index == 2 then
		return UnityEngine.Rect(0.333, 0.666, 0.333, 0.3333)
	elseif index == 3 then
		return UnityEngine.Rect(0.666, 0.666, 0.333, 0.3333)
	elseif index == 4 then
		return UnityEngine.Rect(0, 0.3333, 0.333, 0.3333)
	elseif index == 5 then
		return UnityEngine.Rect(0.333, 0.3333, 0.333, 0.3333)
	elseif index == 6 then
		return UnityEngine.Rect(0.666, 0.333, 0.333, 0.3333)
	elseif index == 7 then
		return UnityEngine.Rect(0, 0, 0.333, 0.3333)
	elseif index == 8 then
		return UnityEngine.Rect(0.333, 0, 0.333, 0.3333)
	else
		return UnityEngine.Rect(0.666, 0, 0.333, 0.3333)
	end
    return nil
end
