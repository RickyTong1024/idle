SceneObjs = {}

SceneObjs.UI = nil
SceneObjs.SceneRoot = nil
SceneObjs.HallRoot = nil
SceneObjs.UIEffectRoot = nil

function SceneObjs.Init()
    SceneObjs.res = {}
    local root = panelMgr.Root
    local ui = resMgr.LoadSceneObj("UI")
    SceneObjs.UI = GameObject.Instantiate(ui)
    SceneObjs.UI.name = "UI"
    SceneObjs.UI.transform:SetParent(root, false)

    local scene_root = resMgr.LoadSceneObj("SceneRoot")
    SceneObjs.SceneRoot = GameObject.Instantiate(scene_root)
    SceneObjs.SceneRoot.name = "SceneRoot"
    SceneObjs.SceneRoot.transform:SetParent(root, false)

    local hall_root = resMgr.LoadSceneObj("HallRoot")
    SceneObjs.HallRoot = GameObject.Instantiate(hall_root)
    SceneObjs.HallRoot.name = "HallRoot"
    SceneObjs.HallRoot.transform:SetParent(root, false)

    local ui_effect_root = resMgr.LoadSceneObj("UIEffectRoot")
    SceneObjs.UIEffectRoot = GameObject.Instantiate(ui_effect_root)
    SceneObjs.UIEffectRoot.name = "UIEffectRoot"
    SceneObjs.UIEffectRoot.transform:SetParent(root, false)
end

function SceneObjs.Finish()
    GameObject.Destroy(SceneObjs.UI)
    GameObject.Destroy(SceneObjs.SceneRoot)
    GameObject.Destroy(SceneObjs.HallRoot)
    GameObject.Destroy(SceneObjs.UIEffectRoot)
    resMgr.UnloadSceneObj("UI")
    resMgr.UnloadSceneObj("SceneRoot")
    resMgr.UnloadSceneObj("HallRoot")
    resMgr.UnloadSceneObj("UIEffectRoot")
end