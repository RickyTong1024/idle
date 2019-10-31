GUIRoot = {}

GUIRoot.UIRoot = nil
GUIRoot.UICamera = nil

GUIRoot.common_guis = {}
GUIRoot.start_guis = {}
GUIRoot.hall_guis = {}
GUIRoot.map_guis = {}
GUIRoot.battle_guis = {}
GUIRoot.util_guis = {}
GUIRoot.game_guis = {}
GUIRoot.panelAtlas = {}
GUIRoot.usedAtlas = {}
GUIRoot.ui_effects = {}

GUIRoot.CommonPanel = "CommonPanel"
GUIRoot.StartPanel = "StartPanel"
GUIRoot.HallPanel = "HallPanel"
GUIRoot.MapPanel = "MapPanel"
GUIRoot.BattlePanel = "BattlePanel"
GUIRoot.UitlPanels = { "AttrChangePanel", "PowerChangePanel", "LoadingPanel", "LoadingPixelPanel", "MessagePanel", "TouchPanel", "MaskPanel" }

function GUIRoot.Init()
    GUIRoot.UIRoot = panelMgr.Root:Find("UI/UIRoot")
    GUIRoot.UICamera = panelMgr.Root:Find("UI/UICamera"):GetComponent("Camera")

    GUIRoot.common_guis = {}
    GUIRoot.start_guis = {}
    GUIRoot.hall_guis = {}
    GUIRoot.map_guis = {}
    GUIRoot.battle_guis = {}
    GUIRoot.util_guis = {}
    GUIRoot.game_guis = {}
    GUIRoot.ui_effects = {}
    GUIRoot.spriteAtlas = {}
    GUIRoot.usedAtlas = {}

    GUIRoot.ShowPanel("CommonPanel", nil, nil)
end

function GUIRoot.Finish()
    GUIRoot.CloseAllPanels()

    GUIRoot.UIRoot = nil
    GUIRoot.UICamera = nil

    GUIRoot.common_guis = {}
    GUIRoot.start_guis = {}
    GUIRoot.hall_guis = {}
    GUIRoot.map_guis = {}
    GUIRoot.battle_guis = {}
    GUIRoot.util_guis = {}
    GUIRoot.game_guis = {}
    GUIRoot.panelAtlas = {}
    GUIRoot.usedAtlas = {}
    GUIRoot.ui_effects = {}
end

function GUIRoot.GetUIRoot(panel_name)
    local cur_root = ""
    if panel_name == GUIRoot.CommonPanel then
        cur_root = "CommonRoot"
    elseif panel_name == GUIRoot.StartPanel then
        cur_root = "StartRoot"
    elseif panel_name == GUIRoot.HallPanel then
        cur_root = "HallRoot"
    elseif panel_name == GUIRoot.MapPanel then
        cur_root = "MapRoot"
    elseif panel_name == GUIRoot.BattlePanel then
        cur_root = "BattleRoot"
    elseif GameSys.hasInTable(GUIRoot.UitlPanels, panel_name) then
        cur_root = "UtilRoot"
    else
        cur_root = "GameUIRoot"
    end
    local cur_gui_table = GUIRoot.GetGuiTable(cur_root)
    return cur_root, cur_gui_table
end

function GUIRoot.GetGuiTable(root)
    if root == "CommonRoot" then
        return GUIRoot.common_guis
    elseif root == "StartRoot" then
        return GUIRoot.start_guis
    elseif root == "HallRoot" then
        return GUIRoot.hall_guis
    elseif root == "MapRoot" then
        return GUIRoot.map_guis
    elseif root == "BattleRoot" then
        return GUIRoot.battle_guis
    elseif root == "UtilRoot" then
        return GUIRoot.util_guis
    elseif root == "GameUIRoot" then
        return GUIRoot.game_guis
    else
        return {}
    end
end

function GUIRoot.GetSelfAtlas(panel_name)
    return GUIRoot.panelAtlas[panel_name]
end

function GUIRoot.LoadAtlas(panel_name, atlas_name)
    if GUIRoot.usedAtlas[panel_name] == nil then
        GUIRoot.usedAtlas[panel_name] = {}
    end
    if GUIRoot.usedAtlas[panel_name][atlas_name] == nil then
        local atlas = resMgr.LoadAtlas(atlas_name)
        GUIRoot.usedAtlas[panel_name][atlas_name] = atlas
        return atlas
    end
    return GUIRoot.usedAtlas[panel_name][atlas_name]
end

function GUIRoot.LoadUIEffect(panel_name, effect_name)
    if GUIRoot.ui_effects[panel_name] == nil then
        GUIRoot.ui_effects[panel_name] = {}
    end
    if GUIRoot.ui_effects[panel_name][effect_name] == nil then
        local uv_rect = UIEffect.Show(effect_name)
        GUIRoot.ui_effects[panel_name][effect_name] = uv_rect
        return uv_rect
    end
    return GUIRoot.ui_effects[panel_name][effect_name]
end

function GUIRoot.CreatePanel(panel_name, ui_root, call_back)
    local panel, atlas = resMgr.LoadPanel(panel_name)
    if panel == nil then
        log("加载界面失败")
        return nil
    end
    GUIRoot.panelAtlas[panel_name] = atlas
    local panel_ins = GameObject.Instantiate(panel)
    panel_ins.name = panel_name
    panel_ins.layer = LayerMask.NameToLayer("UI")
    local root = GUIRoot.UIRoot:Find(ui_root)
    panel_ins.transform:SetParent(root, false)
    panel_ins.transform.localScale = Vector3.one
    local lua_script = panel_ins:AddComponent(typeof(LuaUIBehaviour))
    if call_back ~= nil then
        call_back()
    end
    return panel_ins, lua_script
end

function GUIRoot.DestroyPanel(panel_name, guis)
    if guis[panel_name] ~= nil then
        GameObject.Destroy(guis[panel_name])
        if GUIRoot.usedAtlas[panel_name] ~= nil then
            local atlas = GUIRoot.usedAtlas[panel_name]
            for name in pairs(atlas) do
                resMgr.UnloadAtlas(name)
                atlas[name] = nil
            end
            GUIRoot.usedAtlas[panel_name] = nil
        end
        if GUIRoot.ui_effects[panel_name] ~= nil then
            local effects = GUIRoot.ui_effects[panel_name]
            for effect_name in pairs(effects) do
                UIEffect.Hide(effect_name)
            end
        end
        GUIRoot.ui_effects[panel_name] = nil
        resMgr.UnloadPanel(panel_name)
        guis[panel_name] = nil
        GUIRoot.panelAtlas[panel_name] = nil
    end
end

function GUIRoot.DestroyAllPanels(guis)
    for panel_name in pairs(guis) do
        GUIRoot.DestroyPanel(panel_name, guis)
    end
    guis = {}
end

function GUIRoot.ShowPanel(panel_name, params, call_back)
    local ui_root, guis = GUIRoot.GetUIRoot(panel_name)
    local is_show = false
    if guis[panel_name] == nil then
        local panel, luab = GUIRoot.CreatePanel(panel_name, ui_root, call_back)
        if panel == nil then
            return
        end
        guis[panel_name] = panel
        if params ~= nil then
            luab:OnParam(params)
        end
        is_show = true
    else
        if not guis[panel_name].activeSelf then
            guis[panel_name]:SetActive(true)
            is_show = true
        end
        local luab = guis[panel_name]:GetComponent("LuaUIBehaviour")
        if params ~= nil then
            luab:OnReParam(params)
        end
    end
    if is_show then
        local common_msg = CommonMessage()
        common_msg.name = "show_panel"
        common_msg.m_object:Add(ui_root)
        common_msg.m_object:Add(panel_name)
        messMgr:AddCommonMessage(common_msg)
    end
end

function GUIRoot.ClosePanel(panel_name, is_delete)
    local is_close = false
    local ui_root, guis = GUIRoot.GetUIRoot(panel_name)
    if is_delete == nil then
        is_delete = true
        if ui_root == "UtilRoot" then
            is_delete = false
        end
    end
    if guis[panel_name] ~= nil then
        if is_delete then
            GUIRoot.DestroyPanel(panel_name, guis)
        else
            guis[panel_name]:SetActive(false)
        end
        is_close = true
    end
    if is_close then
        local common_msg = CommonMessage()
        common_msg.name = "close_panel"
        common_msg.m_object:Add(ui_root)
        common_msg.m_object:Add(panel_name)
        messMgr:AddCommonMessage(common_msg)
    end
end

--------------------------------------------------------------------------------------

function GUIRoot.ShowPanels(root)
    local guis = GUIRoot.GetGuiTable(root)
    for _, panel in pairs(guis) do
        if not panel.activeSelf then
            panel:SetActive(true)
        end
    end
end

function GUIRoot.ClosePanels(root, is_delete)
    local guis = GUIRoot.GetGuiTable(root)
    if is_delete == nil then
        is_delete = true
    end
    if is_delete then
        local guis = GUIRoot.GetGuiTable(root)
        GUIRoot.DestroyAllPanels(guis)
        guis = {}
    else
        for _, panel in pairs(guis) do
            panel:SetActive(false)
        end
    end
end

function GUIRoot.CloseLogicPanels(is_delete)
    GUIRoot.ClosePanels("StartRoot", is_delete)
    GUIRoot.ClosePanels("HallRoot", is_delete)
    GUIRoot.ClosePanels("MapRoot", is_delete)
    GUIRoot.ClosePanels("UtilRoot", is_delete)
    GUIRoot.ClosePanels("BattleRoot", is_delete)
    GUIRoot.ClosePanels("GameUIRoot", is_delete)
end

function GUIRoot.CloseAllPanels(is_delete)
    GUIRoot.CloseLogicPanels(is_delete)
    GUIRoot.ClosePanels("CommonRoot", is_delete)
end
