MapTwoPanel = {}
MapTwoPanel.Control = {}
local this = MapTwoPanel.Control

MapTwoPanel.OPEN_TYPE = {
    open_nil = 0,
    dark_detail = 1,
    dungeno_detail = 2,
}

function MapTwoPanel.Awake(obj)

    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.dungeno_two_panel_ = this.transform_:Find("dungeno_two_panel")
    this.dungeon_close_btn_ = this.transform_:Find("dungeno_two_panel/dungeon_back_ground/dungeon_close_btn")
    this.portal_panel_ = this.transform_:Find("portal_panel")
    this.protal_close_btn_ = this.transform_:Find("portal_panel/back_image/protal_close_btn")
    this.protal_surper_content_ = this.transform_:Find("portal_panel/back_image/panel_among/protal_item_root/protal_surper_content")
    this.protal_item_res_ = this.transform_:Find("portal_panel/back_image/panel_among/protal_item_root/protal_item_res")
    this.darkmonster_close_btn_ = this.transform_:Find("darkmonster_two_panel/darkmonster_back_ground/darkmonster_close_btn")
    this.darkmonster_two_panel_ = this.transform_:Find("darkmonster_two_panel")
    this.portal_surper_list_ = nil
    this.pass_map_ = {}
    this.cur_open_ = MapTwoPanel.OPEN_TYPE.open_nil
    this.open_data_ = nil
    this.btn_fun_ = nil
    MapTwoPanel.InitSurperList()
    MapTwoPanel.RegisterBtnListers()
    MapTwoPanel.RegisterMessage()
end


function MapTwoPanel.RegisterMessage()
end

function MapTwoPanel.RemoveMessage()
end

function MapTwoPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.dungeon_close_btn_.gameObject, "click", MapTwoPanel.MapTwoPanelClose)
    GameSys.ButtonRegister(this.lua_script_, this.protal_close_btn_.gameObject, "click", MapTwoPanel.MapTwoPanelClose)
    GameSys.ButtonRegister(this.lua_script_, this.darkmonster_close_btn_.gameObject, "click", MapTwoPanel.MapTwoPanelClose)

end

function MapTwoPanel.OnDestroy()
    MapTwoPanel.RemoveMessage()
end

function MapTwoPanel.OnParam(params)
    this.cur_open_ = params[1]
    this.open_data_ = params[2]
    this.btn_fun_ = params[3]
    MapTwoPanel.Init()
end

function MapTwoPanel.Init()
    if this.cur_open_ == MapTwoPanel.OPEN_TYPE.dark_detail then
        MapTwoPanel.ShowDarkDesc()
    elseif this.cur_open_ == MapTwoPanel.OPEN_TYPE.dungeno_detail then
        MapTwoPanel.ShowDungeon()
    else
        MapTwoPanel.MapTwoPanelClose()
    end
end

------功能---------

function MapTwoPanel.MapTwoPanelClose()
    GUIRoot.ClosePanel("MapTwoPanel")
end

function MapTwoPanel.ShowDungeon()
    local dungeno_data = Config.get_config_value("t_dungeon", this.open_data_.def1)
    if dungeno_data ~= nil then
        this.dungeno_two_panel_.transform:Find("dungeon_back_ground/panel_among/dungeon_name"):GetComponent("LocalizationText").text = dungeno_data.name
        local monster_root = this.dungeno_two_panel_.transform:Find("dungeon_back_ground/panel_among/dungeno_mon_root")
        GameSys.ClearChild(monster_root)
        for i = 1, #dungeno_data.monster + 1 do
            local cur_monster = Config.get_config_value("t_monster", dungeno_data.monster[i -1].id)
            if cur_monster ~= nil then
                local cur_monster_role = Config.get_config_value("t_role", cur_monster.role_id)
                if cur_monster_role ~= nil then
                    local role_icon = CommonPanel.GetIcon("role_icon_res", "role", {"icon"}, cur_monster_role.icon, 0, 0, this.lua_script_)
                    role_icon.transform:SetParent(monster_root, false)
                    role_icon.transform.localPosition = Vector3.zero
                    role_icon.transform.localScale = Vector3.one
                    local icon_text = role_icon.transform:Find("generic")
                    icon_text:GetComponent("LocalizationText").text = string.format("Lv %s", cur_monster.level)
                    icon_text.gameObject:SetActive(true)
                    role_icon.gameObject:SetActive(true)
                end

            end

        end
        local mat_root = this.dungeno_two_panel_.transform:Find("dungeon_back_ground/panel_among/rewards_view/mat_view")
        GameSys.ClearChild(mat_root)
        for i = 1, #dungeno_data.reward do
            local asset ={
                ["type"] = dungeno_data.reward[i].type,
                ["value1"] = dungeno_data.reward[i].value1,
                ["value2"] = dungeno_data.reward[i].value2,
                ["value3"] = dungeno_data.reward[i].value3,
            }
            local reward_icon = CommonPanel.GetIcon2type(asset,{"dungeno_"..dungeno_data.id..dungeno_data.reward[i].value1..i}, this.lua_script_)
            reward_icon.transform:SetParent(mat_root, false)
            reward_icon.transform.localPosition = Vector3.zero
            reward_icon.transform.localScale = Vector3.one
            reward_icon.gameObject:SetActive(true)
        end
        local fight_btn = this.dungeno_two_panel_.transform:Find("dungeon_back_ground/panel_botton/dungeon_btn_image")
        GameSys.ButtonRegister(this.lua_script_, fight_btn.gameObject, "click", this.btn_fun_, {dungeno_data.id})
        this.dungeno_two_panel_.gameObject:SetActive(true)
    end

end

function MapTwoPanel.InitSurperList()
    this.portal_surper_list_ = this.protal_surper_content_:GetComponent("UIScrollGrid")
    this.portal_surper_list_.prefab = this.protal_item_res_.gameObject
    this.portal_surper_list_.SetDataHandle = function(go, index)
        index = index + 1
        go.transform:Find("back_image/protal_name_text"):GetComponent("LocalizationText").text = this.pass_map_[index].name
        local click_obj = go.transform:Find("back_image/click_obj").transform:GetChild(0).gameObject
        click_obj.name = "portal"..this.pass_map_[index].id
        GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", this.btn_fun_, {this.pass_map_[index].id})
        go.gameObject:SetActive(true)
    end
    this.portal_surper_list_:Init()
end

function MapTwoPanel.ShowDarkDesc()
    local dark_data = this.open_data_
    if dark_data ~= nil then
        local monster_root = this.darkmonster_two_panel_.transform:Find("darkmonster_back_ground/panel_among/dark_mon_root")
        GameSys.ClearChild(monster_root)
        local cur_monster = Config.get_config_value("t_monster", dark_data.monsterid)
        if cur_monster ~= nil then
            local cur_monster_role = Config.get_config_value("t_role", cur_monster.role_id)
            if cur_monster_role ~= nil then
                local role_icon = CommonPanel.GetIcon("role_icon_res", "role", {"icon"}, cur_monster_role.icon, 0, 0, this.lua_script_)
                role_icon.transform:SetParent(monster_root, false)
                role_icon.transform.localPosition = Vector3.zero
                role_icon.transform.localScale = Vector3.one
                local icon_text = role_icon.transform:Find("generic")
                icon_text:GetComponent("LocalizationText").text = string.format("Lv %s", cur_monster.level)
                this.darkmonster_two_panel_.transform:Find("darkmonster_back_ground/panel_among/monster_name"):GetComponent("LocalizationText").text = cur_monster_role.name
                icon_text.gameObject:SetActive(true)
                role_icon.gameObject:SetActive(true)
            end
        end
        local mat_root = this.darkmonster_two_panel_.transform:Find("darkmonster_back_ground/panel_among/rewards_view/mat_view")
        GameSys.ClearChild(mat_root)
        for i = 1, #dark_data.drops do
            local asset ={
                ["type"] = dark_data.drops[i].type,
                ["value1"] = dark_data.drops[i].value1,
                ["value2"] = dark_data.drops[i].value2,
                ["value3"] = dark_data.drops[i].value3,
            }
            local reward_icon = CommonPanel.GetIcon2type(asset,{"darkmonster_"..dark_data.id..dark_data.drops[i].value1..i}, this.lua_script_)
            reward_icon.transform:SetParent(mat_root, false)
            reward_icon.transform.localPosition = Vector3.zero
            reward_icon.transform.localScale = Vector3.one
            reward_icon.gameObject:SetActive(true)
        end
        this.darkmonster_two_panel_.gameObject:SetActive(true)
    end
end

