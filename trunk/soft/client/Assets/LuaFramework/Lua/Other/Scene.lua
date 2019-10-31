Scene = {}

Scene.SceneRoot = nil
Scene.UnitRoot = nil
Scene.Camera = nil

local back_
local cur_scene_name_

function Scene.Init()
	Scene.SceneRoot = panelMgr.Root:Find("SceneRoot")
	Scene.SceneRoot.gameObject:SetActive(false)
	Scene.UnitRoot = panelMgr.Root:Find("SceneRoot/UnitRoot")
    Scene.Camera = Scene.SceneRoot:Find("camera/UnitCamera"):GetComponent("Camera")
	Scene.CameraNode = Scene.SceneRoot:Find("camera")
	back_ = Scene.SceneRoot:Find("back"):GetComponent("MeshRenderer")
	back_.enabled = false
	cur_scene_name_ = nil
end

function Scene.Finish()
	Scene.Hide()
	Scene.SceneRoot = nil
	Scene.UnitRoot = nil
	Scene.Camera = nil
	Scene.CameraNode = nil
	back_ = nil
	cur_scene_name_ = nil
end

function Scene.Show(name)
	if cur_scene_name_ ~= nil then
		Scene.Hide()
	end
    Scene.SceneRoot.gameObject:SetActive(true)
	local texture = resMgr.LoadScene(name)
	cur_scene_name_ = name
	back_.material.mainTexture = texture
	back_.enabled = true
end

function Scene.Hide()
	back_.material.mainTexture = nil
	back_.enabled = false
	if cur_scene_name_ ~= nil then
		resMgr.UnloadScene(cur_scene_name_)
	end
	Scene.SceneRoot.gameObject:SetActive(false)
	cur_scene_name_ = nil
end

function Scene.Shake(t)
	Scene.CameraNode:DOShakePosition(0.2, Vector3(0.2, 0.2, 0))
end
