BossPanel = {}
BossPanel.Control = {}
local this = BossPanel.Control

function BossPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

    this.back_close_btn = this.transform_:Find("back_close_btn")
    this.content_root = this.transform_:Find("back_image/scroll_rect/view/content_root")
    this.close_btn = this.transform_:Find("back_image/close_btn")
    this.boss_slot = this.transform_:Find("boss_slot")
    this.add_count_btn = this.transform_:Find("back_image/challenge_count_text/add_count_btn")
    BossPanel.RegisterListers()
end

function BossPanel.OnDestroy()
    BossPanel.RemoveListers()
    this = {}
end

function BossPanel.RegisterListers()
    GameSys.ButtonRegister(this.lua_script, this.back_close_btn.gameObject, "click", BossPanel.OnCloseBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script, this.close_btn.gameObject, "click", BossPanel.OnCloseBtnClick, nil)
    GameSys.ButtonRegister(this.lua_script, this.add_count_btn.gameObject, "click", BossPanel.OnAddBtnClick, nil)
end

function BossPanel.RemoveListers()

end

function BossPanel.Start(obj)
    BossPanel.RefreshPanel()
end

function BossPanel.RefreshPanel()
    BossPanel.SetData()
    BossPanel.CreateBossSlots()
end

function BossPanel.SetData()
    this.boss_infos = {}
    local t_boss_info = Config.t_boss
    for type, t_boss in pairs(t_boss_info) do
        table.insert(this.boss_infos, t_boss)
    end
    table.sort(this.boss_infos, function(a, b) return (a.type < b.type) end)
end

function BossPanel.CreateBossSlots()
    Util.ClearChild(this.content_root)
    for i = 1, #this.boss_infos do
        local t_boss = this.boss_infos[i]
        local slot_ins = GameObject.Instantiate(this.boss_slot.gameObject)
        slot_ins:SetActive(true)
        slot_ins.transform:SetParent(this.content_root)
        slot_ins.transform.localScale = Vector3.one
        local boss_name_text = slot_ins.transform:Find("back_image/name_text")
        local icon = slot_ins.transform:Find("back_image/icon_back_image/icon")
        local mat_root = slot_ins.transform:Find("back_image/mat_root")
        local t_boss_reward = Config.get_config_value("t_boss_reward", t_boss.type)
        local t_monster = Config.get_config_value("t_monster", t_boss_reward.monster)
        local t_role = Config.get_config_value("t_role", t_monster.role_id)
        local name = t_role.name
        boss_name_text:GetComponent("Text").text = name
        local icon_alias = t_boss.res
        if icon_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(this.lua_script.gameObject.name, "monster"):GetSprite(icon_alias)
            if sprite ~= nil then
                icon:GetComponent("Image").sprite = sprite
            end
        end
        Util.ClearChild(mat_root)
        for i = 0, #t_boss.reward do
            local reward = t_boss.reward[i]
            if reward.type ~= "" then
                local mat_icon = GameSys.GetAssetIcon(reward, this.lua_script)
                mat_icon.transform:SetParent(mat_root)
                mat_icon.transform.localScale =Vector3.one
            end
        end
        slot_ins.name = "select_boss_"..i
        GameSys.ButtonRegister(this.lua_script, slot_ins, "click", BossPanel.OnSelectBossClick, {i})
    end
end

function BossPanel.OnSelectBossClick(obj, params)
    local index = params[1]
    print("select boss ".. index)
end

function BossPanel.OnCloseBtnClick(obj, params)
    BossPanel.Close()
end

function  BossPanel.OnAddBtnClick(obj, params)
    print("去购买次数")
end

function BossPanel.Close()
    GUIRoot.ClosePanel("BossPanel")
end