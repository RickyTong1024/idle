resMgr = {}

resMgr.usedBundles = {}
resMgr.gameConfigBundle = nil
resMgr.unitConfigBundle = nil
resMgr.mapConfigBundle = nil
resMgr.commonAtlasBundle = nil

function resMgr.Init()
    resMgr.usedBundles = {}
    resMgr.gameConfigBundle = resMgr.LoadAssetBundle("res/config")
    resMgr.unitConfigBundle = resMgr.LoadAssetBundle("res/unit_config")
    resMgr.mapConfigBundle = resMgr.LoadAssetBundle("res/map_config")
    resMgr.commonAtlasBundle = resMgr.LoadAssetBundle("res/ui/common")
end

function resMgr.Finish()
    resMgr.UnloadAssetBundle("res/config")
    resMgr.UnloadAssetBundle("res/unit_config")
    resMgr.UnloadAssetBundle("res/map_config")
    resMgr.UnloadAssetBundle("res/ui/common")
    for ab_name in pairs(resMgr.usedBundles) do
        if not platform_config_common.DebugMode then
            resMgr.usedBundles[ab_name].bundle:Unload(true)
        end
    end
    resMgr.usedBundles = {}
    resMgr.gameConfigBundle = nil
    resMgr.unitConfigBundle = nil
    resMgr.mapConfigBundle = nil
    resMgr.commonAtlasBundle = nil
end

--加载bundle
function resMgr.LoadAssetBundle(ab_name)
    ab_name = string.lower(ab_name)
    if not GameSys.StringEnd(ab_name, platform_config_common.ExtName) then
        ab_name = ab_name .. platform_config_common.ExtName
    end
    if resMgr.usedBundles[ab_name] == nil then
        local load_bundle = nil
        if not platform_config_common.DebugMode then
            local uri = Util.DataPath .. ab_name
            load_bundle = AssetBundle.LoadFromFile(uri)
        end
        resMgr.usedBundles[ab_name] = {}
        resMgr.usedBundles[ab_name].used_num = 1
        resMgr.usedBundles[ab_name].bundle = load_bundle
    else
        resMgr.usedBundles[ab_name].used_num = resMgr.usedBundles[ab_name].used_num + 1
    end
    return resMgr.usedBundles[ab_name].bundle
end
--卸载bundle
function resMgr.UnloadAssetBundle(ab_name)
    ab_name = string.lower(ab_name)
    if not GameSys.StringEnd(ab_name, platform_config_common.ExtName) then
        ab_name = ab_name .. platform_config_common.ExtName
    end
    if resMgr.usedBundles[ab_name] == nil then
        return
    end
    resMgr.usedBundles[ab_name].used_num = resMgr.usedBundles[ab_name].used_num - 1
    if resMgr.usedBundles[ab_name].used_num <= 0 then
        if not platform_config_common.DebugMode then
            resMgr.usedBundles[ab_name].bundle:Unload(true)
        end
        resMgr.usedBundles[ab_name] = nil
    end
end
--通过路径加载资源 DebugMode下使用
function resMgr.LoadAssetAtPath(path, type)
    return Util.LoadAssetAtPath(path, type)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------
function resMgr.LoadTxt(txt_name)
    if not platform_config_common.DebugMode then
        return resMgr.gameConfigBundle:LoadAsset(txt_name, typeof(UnityEngine.TextAsset))
    end
    return resMgr.LoadAssetAtPath("Assets/res/config/" .. txt_name .. ".txt", typeof(UnityEngine.TextAsset))
end

function resMgr.LoadUnitXml(xml_name)
    if not platform_config_common.DebugMode then
        return resMgr.unitConfigBundle:LoadAsset(xml_name, typeof(UnityEngine.TextAsset))
    end
    return resMgr.LoadAssetAtPath("Assets/res/unit_config/" .. xml_name .. ".xml", typeof(UnityEngine.TextAsset))
end

function resMgr.LoadMapConfig(txt_name)
    if not platform_config_common.DebugMode then
        return resMgr.mapConfigBundle:LoadAsset(txt_name, typeof(UnityEngine.TextAsset))
    end
    return resMgr.LoadAssetAtPath("Assets/res/map_config/" .. txt_name .. ".txt", typeof(UnityEngine.TextAsset))
end

function resMgr.LoadCommonAtlas()
    if not platform_config_common.DebugMode then
        return resMgr.commonAtlasBundle:LoadAsset("common", typeof(UnityEngine.U2D.SpriteAtlas))
    end
    return resMgr.LoadAssetAtPath("Assets/res/ui/common/common" .. ".spriteatlas", typeof(UnityEngine.U2D.SpriteAtlas))
end
----------------------------------------------------------------------------------------------------------------------------------------------------------
--加载界面
function resMgr.LoadPanel(panel_name)
    local ab_name = "res/ui/panels/" .. panel_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local sprite_atlas = bundle:LoadAsset(panel_name, typeof(UnityEngine.U2D.SpriteAtlas))
        local panel_ins = bundle:LoadAsset(panel_name, typeof(UnityEngine.GameObject))
        return panel_ins, sprite_atlas
    else
        local sprite_atlas = resMgr.LoadAssetAtPath("Assets/res/ui/panels/" .. panel_name .. "/" .. panel_name .. ".spriteatlas", typeof(UnityEngine.U2D.SpriteAtlas))
        local panel_ins = resMgr.LoadAssetAtPath("Assets/res/ui/panels/" .. panel_name .. "/" .. panel_name .. ".prefab", typeof(UnityEngine.GameObject))
        return panel_ins, sprite_atlas
    end
end
--卸载界面
function resMgr.UnloadPanel(panel_name)
    local ab_name = "res/ui/panels/" .. panel_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载战斗场景
function resMgr.LoadScene(name)
    local ab_name = "res/scene/" .. name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local texture = bundle:LoadAsset(name, typeof(UnityEngine.Texture))
        return texture
    else
        local texture = resMgr.LoadAssetAtPath("Assets/res/scene/" .. name .. ".jpg", typeof(UnityEngine.Texture))
        return texture
    end
end
--卸载战斗场景
function resMgr.UnloadScene(name)
    local ab_name = "res/scene/" .. name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载unit
function resMgr.LoadUnit(unit_name)
    local ab_name = "res/unit/" .. unit_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local unit_ins = bundle:LoadAsset(unit_name, typeof(UnityEngine.GameObject))
        return unit_ins
    else
        local unit_ins = resMgr.LoadAssetAtPath("Assets/res/unit/" .. unit_name .. "/" .. unit_name .. ".prefab", typeof(UnityEngine.GameObject))
        return unit_ins
    end
end
--卸载unit
function resMgr.UnloadUnit(unit_name)
    local ab_name = "res/unit/" .. unit_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)

end
--加载特效
function resMgr.LoadEffect(effect_name)
    local ab_name = "res/effect/" .. effect_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local effect_ins = bundle:LoadAsset(effect_name, typeof(UnityEngine.GameObject))
        return effect_ins
    else
        local effect_ins = resMgr.LoadAssetAtPath("Assets/res/effect/" .. effect_name .. ".prefab", typeof(UnityEngine.GameObject))
        return effect_ins
    end
end
--卸载特效
function resMgr.UnloadEffect(effect_name)
    local ab_name = "res/effect/" .. effect_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载UI特效
function resMgr.LoadUIEffect(ui_effect_name)
    local ab_name = "res/effect/ui_effect/" .. ui_effect_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local effect_ins = bundle:LoadAsset(ui_effect_name, typeof(UnityEngine.GameObject))
        return effect_ins
    else
        local effect_ins = resMgr.LoadAssetAtPath("Assets/res/effect/ui_effect/" .. ui_effect_name .. ".prefab", typeof(UnityEngine.GameObject))
        return effect_ins
    end
end
--卸载UI特效
function resMgr.UnloadUIEffect(effect_name)
    local ab_name = "res/effect/ui_effect/" .. effect_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载音乐
function resMgr.LoadMusic(music_name)
    local ab_name = "res/music/" .. music_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local clip = bundle:LoadAsset(music_name, typeof(UnityEngine.AudioClip))
        return clip
    else
        local clip = nil
        clip = resMgr.LoadAssetAtPath("Assets/res/music/" .. music_name .. ".mp3", typeof(UnityEngine.AudioClip))
        if clip == nil then
            clip = resMgr.LoadAssetAtPath("Assets/res/music/" .. music_name .. ".wav", typeof(UnityEngine.AudioClip))
        end
        return clip
    end
end
--卸载音乐
function resMgr.UnloadMusic(music_name)
    local ab_name = "res/music/" .. music_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载音效
function resMgr.LoadSound(sound_name)
    local ab_name = "res/sound/" .. sound_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local clip = bundle:LoadAsset(sound_name, typeof(UnityEngine.AudioClip))
        return clip
    else
        local clip = nil
        clip = resMgr.LoadAssetAtPath("Assets/res/sound/" .. sound_name .. ".mp3", typeof(UnityEngine.AudioClip))
        if clip == nil then
            clip = resMgr.LoadAssetAtPath("Assets/res/sound/" .. sound_name .. ".wav", typeof(UnityEngine.AudioClip))
        end
        return clip
    end
end
--卸载音效
function resMgr.UnloadSound(sound_name)
    local ab_name = "res/sound/" .. sound_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载地图
function resMgr.LoadMap(map_name)
    local ab_name = "res/map/" .. map_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local texture = bundle:LoadAsset(map_name, typeof(UnityEngine.Texture))
        return texture
    else
        local texture = resMgr.LoadAssetAtPath("Assets/res/map/" .. map_name .. ".jpg", typeof(UnityEngine.Texture))
        return texture
    end
end
--卸载地图
function resMgr.UnloadMap(map_name)
    local ab_name = "res/map/" .. map_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--记载旁白背景
function resMgr.LoadStory(story_name)
    local ab_name = "res/story/" .. story_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local texture = bundle:LoadAsset(story_name, typeof(UnityEngine.Texture))
        return texture
    else
        local texture = resMgr.LoadAssetAtPath("Assets/res/story/" .. story_name .. ".jpg", typeof(UnityEngine.Texture))
        return texture
    end
end
--卸载旁白背景
function resMgr.UnloadStory(story_name)
    local ab_name = "res/story/" .. story_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载图集
function resMgr.LoadAtlas(atlas_name)
    local ab_name = "res/ui/atlas/" .. atlas_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local atlas = bundle:LoadAsset(atlas_name, typeof(UnityEngine.U2D.SpriteAtlas))
        return atlas
    else
        local atlas = resMgr.LoadAssetAtPath("Assets/res/ui/atlas/" .. atlas_name .. ".spriteatlas", typeof(UnityEngine.U2D.SpriteAtlas))
        return atlas
    end
end
--卸载图集
function resMgr.UnloadAtlas(atlas_name)
    local ab_name = "res/ui/atlas/" .. atlas_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end
--加载场景下子节点
function resMgr.LoadSceneObj(obj_name)
    local ab_name = "res/scene_objs/" .. obj_name .. platform_config_common.ExtName
    local bundle = resMgr.LoadAssetBundle(ab_name)
    if not platform_config_common.DebugMode then
        local obj = bundle:LoadAsset(obj_name, typeof(GameObject))
        return obj
    else
        local obj = resMgr.LoadAssetAtPath("Assets/res/scene_objs/" .. obj_name .. ".prefab", typeof(GameObject))
        return obj
    end
end
--卸载场景下子节点
function resMgr.UnloadSceneObj(obj_name)
    local ab_name = "res/scene_objs/" .. obj_name .. platform_config_common.ExtName
    resMgr.UnloadAssetBundle(ab_name)
end


----------------------------工具------------------------
function resMgr.GetUsedRess()
    local res = {}
    res.config = {}
    res.effect = {}
    res.map = {}
    res.map_config = {}
    res.music = {}
    res.scene = {}
    res.scene_objs = {}
    res.sound = {}
    res.story = {}
    res.ui = {}
    res.unit = {}
    res.unit_config = {}
    for ab_name , info in pairs(resMgr.usedBundles) do
        if GameSys.StringStart(ab_name, "res/config") then
            res.config[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/effect") then
            res.effect[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/map/") then
            res.map[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/map_config") then
            res.map_config[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/music") then
            res.music[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/scene/") then
            res.scene[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/scene_objs/") then
            res.scene_objs[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/sound") then
            res.sound[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/story") then
            res.story[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/ui") then
            res.ui[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/unit/") then
            res.unit[ab_name] = info
        elseif GameSys.StringStart(ab_name, "res/unit_config") then
            res.unit_config[ab_name] = info
        end
    end
    return res
end

function resMgr.GetUsedTypeRes(type, res)
    local rr = nil
    if string.lower(type) == "config" then
        rr = res.config
    elseif string.lower(type) == "effect" then
        rr = res.effect
    elseif string.lower(type) == "map" then
        rr = res.map
    elseif string.lower(type) == "map_config" then
        rr = res.map_config
    elseif string.lower(type) == "music" then
        rr = res.music
    elseif string.lower(type) == "scene" then
        rr = res.scene
    elseif string.lower(type) == "scene_objs" then
        rr = res.scene_objs
    elseif string.lower(type) == "sound" then
        rr = res.sound
    elseif string.lower(type) == "story" then
        rr = res.story
    elseif string.lower(type) == "ui" then
        rr = res.ui
    elseif string.lower(type) == "unit" then
        rr = res.unit
    elseif string.lower(type) == "unit_config" then
        rr = res.unit_config
    end
    return rr
end

function resMgr.ResLog(type)
    if type == nil then
        type = "all"
    end
    local res = resMgr.GetUsedRess()
    if string.lower(type) == "all" then
        for a, r in pairs(res) do
            print("-----------------------"..a.."-----------------------------")
            for ab_name, info in pairs(r) do
                print(string.format("%s 引用个数:%d", ab_name, info.used_num))
            end
        end
        return
    else
        local rr = resMgr.GetUsedTypeRes(type, res)
        print("-------------------------"..string.lower(type).."---------------------------")
        for ab_name, info in pairs(rr) do
            print(string.format("%s 引用个数:%d", ab_name, info.used_num))
        end
    end
end

resMgr.check_mark = false
resMgr.mark_ress = nil

function resMgr.CheckMark()
    resMgr.check_mark = true
    resMgr.mark_ress = resMgr.GetUsedRess()
end

function resMgr.Diff(type)
    if not resMgr.check_mark then
        return
    end
    resMgr.check_mark = false
    if type == nil then
        type = "all"
    end
    local res = resMgr.GetUsedRess()
    if string.lower(type) == "all" then
        for type in pairs(res) do
            resMgr.LogDiff(type, res)
        end
    else
        resMgr.LogDiff(type, res)
    end
end

function resMgr.LogDiff(type, res)
    local old_rr = resMgr.GetUsedTypeRes(type, resMgr.mark_ress)
    local rr = resMgr.GetUsedTypeRes(type, res)
    local names = {}
    for name in pairs(rr) do
        if old_rr[name] ~= nil then
            table.insert(names, name)
        end
    end
    print("-------------------------"..string.lower(type).."---------------------------")
    for i = 1, #names do
        local name = names[i]
        print(string.format("%s 引用个数:%d", name, rr[name].used_num))
    end
end
