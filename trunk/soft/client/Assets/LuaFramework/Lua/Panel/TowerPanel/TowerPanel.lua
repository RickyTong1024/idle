TowerPanel = {}
TowerPanel.Control = {}
local this = TowerPanel.Control

function TowerPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.tower_floor_conten = this.transform_:Find("root_panel/tower_left/ve/conten")
    this.tower_res = this.transform_:Find("root_panel/tower_left/tower_res")
    this.monster_levle = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/monster_levle"):GetComponent("LocalizationText")
    this.monster_root = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/monster_root")
    this.start_challenge = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/start_challenge")
    this.start_sweep = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/start_sweep")
    this.tower_floor_count = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/tower_floor/tower_floor_count"):GetComponent("LocalizationText")
    this.rewards_text = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/rewards_text"):GetComponent("LocalizationText")
    this.monster_name = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/monster_name"):GetComponent("LocalizationText")
    this.tower_scroll_content = this.transform_:Find("root_panel/tower_right/tower_battle_show/tower_floor_back/tower_scroll_rect/Viewport/tower_scroll_content")
    this.close_tower = this.transform_:Find("root_panel/close_tower")
    this.tower_sweep_start = this.transform_:Find("root_panel/tower_center/tower_sweep_start")
    this.tower_sweep_compute = this.transform_:Find("root_panel/tower_center/tower_sweep_compute")
    this.sweep_close = this.transform_:Find("root_panel/tower_center/tower_sweep_start/sweep_close")
    this.compute_ok = this.transform_:Find("root_panel/tower_center/tower_sweep_compute/compute_ok")
    this.start_ok = this.transform_:Find("root_panel/tower_center/tower_sweep_start/start_ok")
    this.add_one = this.transform_:Find("root_panel/tower_center/tower_sweep_start/show_num_back/add_one")
    this.sub_one = this.transform_:Find("root_panel/tower_center/tower_sweep_start/show_num_back/sub_one")
    this.tag_image_ = this.transform_:Find("root_panel/tower_left/ve/tag_image")
    this.select_tower = 0
    this.sweep_num = 0
    this.buy_times = 0
    this.buy_price = nil
    this.superlist_ = nil
    this.tower_data = {}
    this.first_obj_ = nil
    TowerPanel.Init()
    TowerPanel.RegisterButton()
    TowerPanel.RegisterMessage()
end

function TowerPanel.RegisterButton()
    GameSys.ButtonRegister(this.lua_script_, this.start_challenge.gameObject,"click", TowerPanel.StarChallenge)
    GameSys.ButtonRegister(this.lua_script_, this.start_sweep.gameObject,"click", TowerPanel.StarSweep)
    GameSys.ButtonRegister(this.lua_script_, this.close_tower.gameObject,"click", TowerPanel.ClosePanel)
    GameSys.ButtonRegister(this.lua_script_, this.sweep_close.gameObject,"click", TowerPanel.CloseSweep)
    GameSys.ButtonRegister(this.lua_script_, this.compute_ok.gameObject,"click", TowerPanel.CloseCompute)
    GameSys.ButtonRegister(this.lua_script_, this.start_ok.gameObject,"click", TowerPanel.SendSweepMessage)
    GameSys.ButtonRegister(this.lua_script_, this.add_one.gameObject,"click", TowerPanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.sub_one.gameObject,"click", TowerPanel.ButtonClick)
end

function TowerPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_TOWER_SWEEP, TowerPanel.SMSG_TOWER_SWEEP)
    Message.register_handle("battle_end", TowerPanel.BattleEnd)
end

function TowerPanel.RemoveMessage()
    Message.remove_handle("battle_end", TowerPanel.BattleEnd)
    Message.remove_net_handle(opcodes.SMSG_TOWER_SWEEP, TowerPanel.SMSG_TOWER_SWEEP)
end

function TowerPanel.Init()
    this.tower_data = TowerPanel.GetTower()
    --Util.ClearChild(this.tower_floor_conten)
    local init_index = 0

    this.superlist_ = this.tower_floor_conten:GetComponent("UIScrollGrid")
    this.superlist_.prefab = this.tower_res.gameObject
    this.superlist_.IsReverseLayer = true
    this.superlist_.IsReverseScroll = true
    this.superlist_.SetDataHandle = function(go, index)
        index = index + 1
        local floor_text = go.transform:Find("tower_floor_back/tower_floor_num_back/floor_text"):GetComponent("LocalizationText")
        floor_text.text = this.tower_data[index].stair
        local tower_floor_index = PlayerData.player.tower + 1
        if tower_floor_index >= this.tower_data[index].stair then
            floor_text.color = Color(255/255, 233/255, 125/255)
            if tower_floor_index == this.tower_data[index].stair then
                init_index = index
                this.first_obj_ = go
            end
            go.transform:Find("tower_floor_back/fire").gameObject:SetActive(true)
        else
            floor_text.color = Color(180/255, 190/255, 200/255)
            go.transform:Find("tower_floor_back/fire").gameObject:SetActive(false)

        end
        local click_tar = go.transform:Find("tower_floor_back/tower_floor_num_back")
        local index_obj = go.transform:Find("tower_floor_back/id"):GetChild(0).gameObject
        index_obj.name = tostring(index).."tower"
        GameSys.ButtonRegister(this.lua_script_, index_obj.gameObject, "click", TowerPanel.SelectTower, {this.tower_data[index].stair})
        this.tag_image_.transform:SetAsLastSibling()
        go.gameObject:SetActive(true)
    end
    this.superlist_:Init()
    this.superlist_:SetData(#this.tower_data)
    this.select_tower = PlayerData.player.tower + 1
    this.start_challenge.gameObject:SetActive(true)
    this.start_sweep.gameObject:SetActive(false)
    TowerPanel.Reset()
end

function TowerPanel.TagImage(v3)
    this.tag_image_.transform:SetParent(this.tower_floor_conten:GetChild(0), false)
    this.tag_image_.transform:SetAsLastSibling()
    this.tag_image_:GetComponent("RectTransform").anchoredPosition = Vector3(150, v3.y - 105, 0)
end

function TowerPanel.SetTowerPosition()
    local height = 210 * PlayerData.player.tower
    local rect_3 = this.tower_floor_conten:GetChild(0):GetComponent("RectTransform").anchoredPosition
    rect_3 = Vector3(rect_3.x, -height , rect_3.z)
    TowerPanel.TagImage(rect_3)
    this.tower_floor_conten:GetChild(0):GetComponent("RectTransform").anchoredPosition = rect_3
    this.superlist_:OnScroll(Vector2(0, (height)/this.tower_floor_conten:GetChild(0):GetComponent("RectTransform").sizeDelta.y))
end

function TowerPanel.SelectTower(obj, param)
    this.select_tower = param[1]
    local rect_3 = obj.transform.parent.parent.parent:GetComponent("RectTransform").anchoredPosition
    TowerPanel.TagImage(rect_3)
    TowerPanel.RefreshRight(this.select_tower)
end

function TowerPanel.RefreshRight(floor)
    local index = tonumber(floor)
    local t_tower_config = Config.get_config_value("t_tower", index)
    local player_tower = PlayerData.player.tower + 1
    if t_tower_config ~= nil then
        this.tower_floor_count.text = string.format("第%s层", t_tower_config.stair)
        local monster_ = Config.get_config_value("t_monster", t_tower_config.monster)
        if monster_ ~= nil then
            local role_ = Config.get_config_value("t_role", monster_.role_id)
            if role_ ~= nil then
                this.monster_root.transform:Find("icon"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "monster"):GetSprite(role_.icon)
                this.monster_name.text = role_.name
            else
                local str = "出现错误，请联系管理员"
                GUIRoot.ShowPanel("MessagePanel", {str})
            end
            this.monster_levle.text = monster_.level
        else
            local str = "出现错误，请联系管理员"
            GUIRoot.ShowPanel("MessagePanel", {str})
        end
        if t_tower_config.stair > player_tower then
            this.start_sweep.gameObject:SetActive(false)
            this.start_challenge.gameObject:SetActive(false)
            this.rewards_text.text = "奖励物品"
            if t_tower_config.freward ~= nil then
                this.rewards_text.text = "首次奖励"
                TowerPanel.ShowIcon(t_tower_config.freward, this.tower_scroll_content)
            elseif t_tower_config.reward ~= nil then
                TowerPanel.ShowIcon(t_tower_config.reward, this.tower_scroll_content)
            end
        elseif t_tower_config.stair < player_tower then
            this.start_sweep.gameObject:SetActive(true)
            this.start_challenge.gameObject:SetActive(false)
            this.rewards_text.text = "奖励物品"
            if t_tower_config.reward ~= nil then
                TowerPanel.ShowIcon(t_tower_config.reward, this.tower_scroll_content)
            end
        else
            this.start_sweep.gameObject:SetActive(false)
            this.start_challenge.gameObject:SetActive(true)
            this.rewards_text.text = "奖励物品"
            if t_tower_config.freward ~= nil then
                this.rewards_text.text = "首次奖励"
                TowerPanel.ShowIcon(t_tower_config.freward, this.tower_scroll_content)
            elseif t_tower_config.reward ~= nil then
                TowerPanel.ShowIcon(t_tower_config.reward, this.tower_scroll_content)
            end
        end
    else
        local str = "出现错误，请联系管理员"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return
    end
end

function TowerPanel.ShowIcon(reward, conten)
    Util.ClearChild(conten)
    for i = 0, #reward do
        if reward[i] ~= nil then
            local asset = {}
            asset.type = reward[i].type
            asset.value1 = reward[i].value1
            asset.value2 = reward[i].value2
            asset.value3 = reward[i].value3
            local icon_r = CommonPanel.GetIcon2type(asset, {"icon"..i}, this.lua_script_)
            icon_r.transform:SetParent(conten)
            icon_r.transform.localPosition = Vector3.zero
            icon_r.transform.localScale = Vector3.one
            icon_r.gameObject:SetActive(true)
        end
    end
end

function TowerPanel.StarChallenge()
    soundMgr:play_sound("counter")
    Battle.GoBattle(Battle.BATTLE_TYPE.tower,{this.select_tower}, State.state.ss_hall)
end


function TowerPanel.SendSweepMessage()
    if this.buy_price > PlayerData.player.jewel then
        local str = "钻石不足"
        GUIRoot.ShowPanel("MessagePanel", {str})
    else
        local msg = mission_msg_pb.cmsg_tower_sweep()
        msg.tower_stair = this.select_tower
        msg.sweep_num = this.sweep_num
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_TOWER_SWEEP, data, {opcodes.SMSG_TOWER_SWEEP}, "蓄力中", 60)
    end
end

function  TowerPanel.StarSweep()
    local t_tower_config = Config.get_config_value("t_tower", this.select_tower)
    if t_tower_config ~= nil then
        local conten_sweep = this.tower_sweep_start.transform:Find("sweep_scroll_rect/Viewport/sweep_scroll_content")
        Util.ClearChild(conten_sweep)
        this.sweep_num = 0
        TowerPanel.ShowIcon(t_tower_config.reward, conten_sweep)
        TowerPanel.CountNum(1)
        this.tower_sweep_start.gameObject:SetActive(true)
    else
        local str = "出现错误，请联系管理员"
        GUIRoot.ShowPanel("MessagePanel", {str})
        return
    end
end

function  TowerPanel.ButtonClick(obj)
    if obj.name == "add_one" then
        TowerPanel.CountNum(1)
    elseif obj.name == "sub_one" then
        if this.sweep_num > 0 then
            TowerPanel.CountNum(-1)
        end
    end
end

function TowerPanel.CountNum(num)
    local t_const_free_time = Config.get_config_value("t_const", "free_tower_num")
    local free_times = t_const_free_time.value - PlayerData.player.tower_sweep_free
    this.sweep_num = this.sweep_num + num
    if this.sweep_num > 100 then
        this.sweep_num = 100
    elseif this.sweep_num <= 0 then
        this.sweep_num = 1
    end
    this.buy_times = this.sweep_num - free_times
    this.buy_price = TowerPanel.GetCount2Absolute(this.buy_times)
    this.tower_sweep_start.transform:Find("price"):GetComponent("LocalizationText").text = GameSys.PriceEnoughColor(this.buy_price, this.buy_price <= PlayerData.player.jewel)
    this.tower_sweep_start.transform:Find("remain_times"):GetComponent("LocalizationText").text = string.format("剩余免费扫荡次数:%s", free_times)
    this.tower_sweep_start.transform:Find("show_num_back/show_num"):GetComponent("LocalizationText").text = this.sweep_num
    local tower = Config.get_config_value("t_tower", this.select_tower)
    if tower ~= nil then
        local monster = Config.get_config_value("t_monster", tower.monster)
        if monster ~= nil then
            local role_ = Config.get_config_value("t_role", monster.role_id)
            if role_ ~= nil then
                this.tower_sweep_start.transform:Find("name"):GetComponent("LocalizationText").text = role_.name
                this.tower_sweep_start.transform:Find("back/icon"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "monster"):GetSprite(role_.icon)
            end
        end
    end

end

function TowerPanel.GetCount2Absolute (num)
    if num > 0 then
        local pirce = 0
        local max_price = #Config.t_price
        if PlayerData.player.tower_sweep_num >= max_price then
            local t_price = Config.get_config_value("t_price", max_price)
            if t_price ~= nil then
                pirce = pirce + t_price.tower_sweep * (num)
            end
        else
            local abs = num + PlayerData.player.tower_sweep_num
            local high = 0
            for i = PlayerData.player.tower_sweep_num + 1 , abs do
                local t_price = Config.get_config_value("t_price", i)
                if t_price ~= nil then
                    high = t_price.tower_sweep
                    pirce = pirce + t_price.tower_sweep
                else
                    pirce = pirce + high
                end
            end
        end

        return pirce
    else
        return 0
    end
end

function TowerPanel.CloseSweep()

    this.tower_sweep_start.gameObject:SetActive(false)
end

function TowerPanel.ClosePanel()
    GUIRoot.ClosePanel("TowerPanel")
end

function TowerPanel.CloseCompute()
    this.tower_sweep_compute.gameObject:SetActive(false)
end

function TowerPanel.OpenCompute(assets)
    local reward = GameSys.ShowAssets(assets, this.lua_script_)
    local sweep_scroll_content = this.tower_sweep_compute.transform:Find("sweep_scroll_rect/Viewport/sweep_scroll_content")
    local sweep_times = this.tower_sweep_compute.transform:Find("sweep_times")
    for i = 1, #reward do
        reward[i].transform:SetParent(sweep_scroll_content)
        reward[i].transform.localPosition = Vector3.zero
        reward[i].transform.localScale = Vector3.one
        reward[i].gameObject:SetActive(true)
    end
    sweep_times:GetComponent("Text").text = this.sweep_num
    this.tower_sweep_compute.gameObject:SetActive(true)
end

function TowerPanel.GetTower()
    local t_tower = {}
    for k, v in pairs(Config.t_tower) do
        table.insert(t_tower, v)
    end
    local com = function(a, b)
        local a_stair = tonumber(a.stair)
        local b_stair = tonumber(b.stair)
        return a_stair > b_stair
    end

    if #t_tower > 1 then
        table.sort(t_tower, com)
    end
    return t_tower
end

function TowerPanel.OnDestroy(obj)
    TowerPanel.RemoveMessage()
    this.lua_script_:ClearClick()
    this = {}
end

function TowerPanel.BattleEnd()
    this.select_tower = PlayerData.player.tower + 1
    this.superlist_:SetData(#this.tower_data)
    TowerPanel.Reset()
end

function TowerPanel.Reset()
    TowerPanel.SetTowerPosition()
    TowerPanel.RefreshRight(this.select_tower)
    if this.first_obj_ ~= nil then
        local rect_3 = this.first_obj_:GetComponent("RectTransform").anchoredPosition
        TowerPanel.TagImage(rect_3)
    end
end
---- ----

function TowerPanel.SMSG_TOWER_SWEEP(message)
    local msg = mission_msg_pb.smsg_tower_sweep()
    msg:ParseFromString(message.luabuff)
    if msg ~= nil then
        local free_tower_num = Config.get_config_value('t_const','free_tower_num').value
        PlayerData.add_assets(msg.assets)
        if PlayerData.player.tower_sweep_free ~= free_tower_num then
            if free_tower_num >= PlayerData.player.tower_sweep_free + this.sweep_num then
                PlayerData.player.tower_sweep_free = PlayerData.player.tower_sweep_free + this.sweep_num

            else
                PlayerData.player.tower_sweep_num = PlayerData.player.tower_sweep_free + this.sweep_num - free_tower_num
                PlayerData.player.tower_sweep_free = free_tower_num
            end
        else
            PlayerData.player.tower_sweep_num =  PlayerData.player.tower_sweep_num + this.sweep_num
        end
        -- PlayerData.player.tower_sweep_free = PlayerData.player.tower_sweep_free + this.sweep_num
        PlayerData.add_resource(2, -this.buy_price)
        TowerPanel.CloseSweep()
    end
end