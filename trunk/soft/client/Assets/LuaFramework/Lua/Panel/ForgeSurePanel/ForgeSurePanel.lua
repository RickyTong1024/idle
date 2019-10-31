ForgeSurePanel = {}

ForgeSurePanel.Control = {}
local this = ForgeSurePanel.Control

function ForgeSurePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.select_num_ = 1
    this.forge_id_ = 0
    this.forge_mat_obj_ = {}
    this.can_forge_ = true

    this.twolevel_close_btn_ = this.transform_:Find("back_ground/twolevel_close_btn")
    this.mat_view_ = this.transform_:Find("back_ground/panel_among/mat_view/mat_view")
    this.icon_root_ = this.transform_:Find("back_ground/panel_among/forge_target_back/icon_root")
    this.forge_name_text_ = this.transform_:Find("back_ground/panel_among/forge_name_text"):GetComponent("LocalizationText")
    this.target_price_ = this.transform_:Find("back_ground/panel_among/target_price"):GetComponent("LocalizationText")
    this.forge_target_reserved_ = this.transform_:Find("back_ground/panel_among/forge_target_reserved"):GetComponent("LocalizationText")
    this.forge_target_level_ = this.transform_:Find("back_ground/panel_among/forge_target_level"):GetComponent("LocalizationText")
    this.target_counter_ = this.transform_:Find("back_ground/panel_among/target_counter")
    this.count_text_ = this.transform_:Find("back_ground/panel_among/target_counter/count/count_text"):GetComponent("LocalizationText")
    this.sub_btn_ = this.transform_:Find("back_ground/panel_among/target_counter/count/sub_btn")
    this.add_btn_ = this.transform_:Find("back_ground/panel_among/target_counter/count/add_btn")
    this.sub_ten_btn_ = this.transform_:Find("back_ground/panel_among/target_counter/count/sub_ten_btn")
    this.add_ten_btn_ = this.transform_:Find("back_ground/panel_among/target_counter/count/add_ten_btn")
    this.target_btn_image_ = this.transform_:Find("back_ground/panel_botton/target_btn_image")
    this.btn_func_ = nil
    ForgeSurePanel.RegisterStaticButton()
    ForgeSurePanel.RegisterMessage()
end

function ForgeSurePanel.Start()
    ForgeSurePanel.OpenForgeWin()
end

function ForgeSurePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_FORGE, ForgeSurePanel.SMSG_FORGE)

end

function ForgeSurePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_FORGE, ForgeSurePanel.SMSG_FORGE)
end

function ForgeSurePanel.OnDestroy()
    ForgeSurePanel.RemoveMessage()
    this.lua_script_:ClearClick()
    this = {}
end

function ForgeSurePanel.RegisterStaticButton()
    GameSys.ButtonRegister(this.lua_script_, this.twolevel_close_btn_.gameObject, "click", ForgeSurePanel.HideTwoPanel)
    GameSys.ButtonRegister(this.lua_script_, this.target_btn_image_.gameObject, "click", ForgeSurePanel.ForgeSure)
    GameSys.ButtonRegister(this.lua_script_, this.sub_btn_.gameObject, "click", ForgeSurePanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.add_btn_.gameObject, "click", ForgeSurePanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.sub_ten_btn_.gameObject, "click", ForgeSurePanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.add_ten_btn_.gameObject, "click", ForgeSurePanel.ButtonClick)

end

function ForgeSurePanel.ButtonClick(obj)
    if obj.name == "sub_btn" then
        ForgeSurePanel.OnClickCout(-1)
    elseif obj.name == "add_btn" then
        ForgeSurePanel.OnClickCout(1)
    elseif obj.name == "sub_ten_btn" then
        ForgeSurePanel.OnClickCout(-10)
    elseif obj.name == "add_ten_btn" then
        ForgeSurePanel.OnClickCout(10)
    end
end

function ForgeSurePanel.Textdeal(text)
    local str = ""
    local tab_ = GameSys.WidthSingle(text)
    if #tab_ > 6 then
        for i = 1, 5 do
            str = str..tab_[i]
        end
        str = str.."..."
        return str
    else
        return text
    end
end

function ForgeSurePanel.OnParam(param)
    this.forge_id_ = param[1]
    this.btn_func_ = param[2]
    
end

function ForgeSurePanel.OpenForgeWin()
    this.select_num_ = 1
    this.forge_mat_obj_ = {}
    ForgeSurePanel.InitTwoPanel()
end

function ForgeSurePanel.InitTwoPanel()
    this.can_forge_ = true
    local forge_temp = ForgeSurePanel.GetWillForge()
    if forge_temp ~= nil then
        local forge_asset = {}
        forge_asset.type = forge_temp.type
        forge_asset.value1 = forge_temp.value1
        forge_asset.value2 = forge_temp.value2
        forge_asset.value3= forge_temp.value3
        if forge_temp.type == 4 or forge_temp.type == 3 then
            this.target_counter_.gameObject:SetActive(false)
        else
            this.target_counter_.gameObject:SetActive(true)
        end
        this.forge_name_text_.text = GameSys.GetAssetName(forge_asset)
        this.forge_target_level_.text = ForgeSurePanel.GetLevel(forge_asset)
        if this.forge_target_level_.text == "" then
            this.forge_target_reserved_.gameObject:GetComponent("RectTransform").pivot = Vector2(0.5, 0.5)
        end
        this.forge_target_reserved_.text = ForgeSurePanel.GetReserved(forge_asset)
        GameSys.ClearChild(this.icon_root_)
        local forge_tager_icon = CommonPanel.GetIcon2type(forge_asset,{}, this.lua_script_)
        forge_tager_icon.transform:SetParent(this.icon_root_, false)
        forge_tager_icon.transform.localPosition = Vector3.zero
        forge_tager_icon.transform.localScale = Vector3.one
        GameSys.ClearChild(this.mat_view_)
        for i = 1, #forge_temp.mat do
            local forge_asset_mat = {}
            forge_asset_mat.type = forge_temp.mat[i].type
            forge_asset_mat.value1 = forge_temp.mat[i].value1
            forge_asset_mat.value2 = forge_temp.mat[i].value2
            forge_asset_mat.value3= forge_temp.mat[i].value3
            local forge_mat_icon = CommonPanel.GetIcon2type(forge_asset_mat, {"forge_mat"..forge_temp.mat[i].value1}, this.lua_script_)
            forge_mat_icon.transform:SetParent(this.mat_view_, false)
            forge_mat_icon.transform.localPosition = Vector3.zero
            forge_mat_icon.transform.localScale = Vector3.one
            local player_mat_num = GameSys.GetAssetCount(forge_temp.mat[i].type, forge_temp.mat[i].value1)
            local temp_text = string.format("%s/%s", player_mat_num, forge_temp.mat[i].value2 * this.select_num_)
            local num_obj = forge_mat_icon.transform:Find("generic")
            num_obj:GetComponent("LocalizationText").text = GameSys.MatEnoughColor(temp_text, player_mat_num >= forge_temp.mat[i].value2 * this.select_num_)
            if player_mat_num < forge_temp.mat[i].value2 * this.select_num_ then
                this.can_forge_ = false
            end
            table.insert(this.forge_mat_obj_, num_obj)
            forge_mat_icon.transform:Find("num").gameObject:SetActive(false)
            num_obj.gameObject:SetActive(true)
        end
        this.count_text_.text = this.select_num_
        local temp_price = 0
        if forge_temp ~= nil then
            temp_price = forge_temp.gold * this.select_num_
        end

        this.target_price_.text = GameSys.MatEnoughColor(temp_price, PlayerData.player.gold >= temp_price)
        if PlayerData.player.gold < temp_price then
            this.can_forge_ = false
        end
    else
        GUIRoot.ShowPanel("MessagePanel",  {'锻造未知物品'})
    end
end

function ForgeSurePanel.OnClickCout(num)
    this.select_num_ = this.select_num_ + num
    if this.select_num_ < 1 then
        this.select_num_ = 1
    elseif this.select_num_ > 100 then
        this.select_num_ = 100
    end
    this.count_text_.text = this.select_num_
    local forget_price_config = ForgeSurePanel.GetWillForge()
    local temp_price = 0
    if forget_price_config ~= nil then
        temp_price = forget_price_config.gold * this.select_num_
    end
    this.target_price_.text = GameSys.MatEnoughColor(GameSys.unit_conversion(temp_price), PlayerData.player.gold >= temp_price)
    this.can_forge_ = true
    if PlayerData.player.gold < temp_price then
        this.can_forge_ = false
    end

    if  this.forge_mat_obj_ ~= nil then
        for i = 1, #forget_price_config.mat do
            if this.forge_mat_obj_[i] ~= nil then
                local player_mat_num = GameSys.GetAssetCount(forget_price_config.mat[i].type, forget_price_config.mat[i].value1)
                local temp_text = string.format("%s/%s", GameSys.unit_conversion(player_mat_num), GameSys.unit_conversion(forget_price_config.mat[i].value2 * this.select_num_))
                this.forge_mat_obj_[i]:GetComponent("LocalizationText").text = GameSys.MatEnoughColor(temp_text, player_mat_num >= forget_price_config.mat[i].value2 * this.select_num_)
                if player_mat_num < forget_price_config.mat[i].value2 * this.select_num_ then
                    this.can_forge_ = false
                end
            end
        end
    end
end

function ForgeSurePanel.GetLevel(asset)
    local level_text = ""
    if asset.type == 3 then
        local forge_equip = Config.get_config_value("t_equip", asset.value1)
        if forge_equip ~= nil then
            level_text = string.format("等级 %s - %s", forge_equip.min_level, forge_equip.max_level)
        end
    end
    return level_text
end

function ForgeSurePanel.MinAndMaxColor()
    local my_color = Config.t_equip_random_rate
    local temp = {}
    for _, v in pairs(my_color) do
        table.insert(temp, v)
    end
    if #temp > 1 then
        table.sort(temp, function(a, b)
            local aid = a.color
            local bid = b.color
            return aid < bid
        end)
    end
    if #temp > 1 then
        return temp[1].color , temp[#temp].color
    else
        return 1 , 5
    end

end

function ForgeSurePanel.GetReserved(asset)
    local reserved_text = ""
    if asset.type == 3 then
        local forge_equip = Config.get_config_value('t_equip', asset.value1)
        local t_level_min = Config.get_config_value("t_level", forge_equip.min_level)
        local t_level_max = Config.get_config_value("t_level", forge_equip.max_level)
        local t_attr = Config.get_config_value("t_attr", forge_equip.attr)
        local const_min_equip = Config.get_config_value("t_const", "equip_attr_min")
        local value_min = (t_level_min.std_attr * forge_equip.value / 100 * t_attr.value) * const_min_equip.value / 100
        local value_max = t_level_max.std_attr * forge_equip.value / 100 * t_attr.value
        if value_min < 1 then
            value_min = 1
        end
        if value_max < 1 then
            value_max = 1
        end
        local min, max = ForgeSurePanel.MinAndMaxColor()
        if forge_equip ~= nil then
            reserved_text = string.format("%s %s - %s\n\n随机属性 %s-%s 条", GameSys.GetAttrNameText(forge_equip.attr), toInt(value_min), toInt(value_max) ,
                    forge_equip.max_q * (min - 1) , forge_equip.max_q * (max - 1))
        end
    elseif asset.type == 5 then
        local forge_rune = Config.get_config_value("t_rune", asset.value1)
        if forge_rune ~= nil then
            reserved_text = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(forge_rune.attr_id), forge_rune.attr_value)
        end
    elseif asset.type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        for i = 1, #t_artifact.attrs do
            reserved_text = string.format("%s\n%s", reserved_text, GameSys.TextDealPlaceholder(GameSys.GetAttributeText(t_artifact.attrs[i].id), t_artifact.attrs[i].value))
        end
        reserved_text = string.sub(reserved_text, 2)
    else
        local forge_item = Config.get_config_value("t_item", asset.value1)
        if forge_item ~= nil then
            reserved_text = forge_item.desc
        end
    end
    return reserved_text
end

function ForgeSurePanel.HideTwoPanel()
    GUIRoot.ClosePanel("ForgeSurePanel")
end

function ForgeSurePanel.GetWillForge()
    local t_forge_data = Config.get_config_value("t_forge", this.forge_id_)
    if t_forge_data then
        return t_forge_data
    else
        ForgeSurePanel.HideTwoPanel()
    end
end


function ForgeSurePanel.ForgeSure()
    local send_forge_config = ForgeSurePanel.GetWillForge()
    if send_forge_config then
        if this.can_forge_ then
            if send_forge_config.type == 4 then
                if send_forge_config.type == 4 and GameSys.GetArtifactState(send_forge_config.value1) < 0 then
                    GUIRoot.ShowPanel("MessagePanel", {'未获得神器模板'})
                elseif PlayerData.player.in_map == 1 then
                    GUIRoot.ShowPanel("MessagePanel", {'野外无法锻造'})
                else
                    local msg = item_msg_pb.cmsg_forge()
                    msg.forge_id = this.forge_id_
                    msg.forge_num = 1
                    local data = msg:SerializeToString()
                    GameTcp.Send(opcodes.CMSG_FORGE, data, {opcodes.SMSG_FORGE}, "锻造中", 60)
                end
            elseif send_forge_config.type == 3 then
                if GameSys.CanGetEquipNum() < this.select_num_ then
                    GUIRoot.ShowPanel("MessagePanel",  {string.format("将超出上限，还可获取%s件装备", GameSys.CanGetEquipNum())})
                    return
                end
                local msg = item_msg_pb.cmsg_forge()
                msg.forge_id = this.forge_id_
                msg.forge_num = this.select_num_
                local data = msg:SerializeToString()
                GameTcp.Send(opcodes.CMSG_FORGE, data, {opcodes.SMSG_FORGE}, "锻造中", 60)
            else
                local msg = item_msg_pb.cmsg_forge()
                msg.forge_id = this.forge_id_
                msg.forge_num = this.select_num_
                local data = msg:SerializeToString()
                GameTcp.Send(opcodes.CMSG_FORGE, data, {opcodes.SMSG_FORGE}, "锻造中", 60)
            end
        else
            GUIRoot.ShowPanel("MessagePanel",  {'材料不足'})
        end
    else
        GUIRoot.ShowPanel("MessagePanel",  {'锻造未知物品'})
    end
end

-------net message
function ForgeSurePanel.SMSG_FORGE(message)
    local msg = item_msg_pb.smsg_forge()
    msg:ParseFromString(message.luabuff)
    local t_forge = Config.get_config_value("t_forge", this.forge_id_)
    PlayerData.add_resource(1, - t_forge.gold * this.select_num_)
    PlayerData.task_operation(7)
    soundMgr:play_sound("enhance_success")
    for i = 1, #t_forge.mat do
        if t_forge.mat[i].type == 2 then
            PlayerData.remove_item(t_forge.mat[i].value1, t_forge.mat[i].value2 * this.select_num_)
        elseif t_forge.mat[i].type == 5 then
            PlayerData.remove_rune(t_forge.mat[i].value1, t_forge.mat[i].value2 * this.select_num_)
        end
    end
    PlayerData.add_assets(msg.assets)
    ForgeSurePanel.HideTwoPanel()
    if this.btn_func_ ~= nil then
        this.btn_func_()
    end

    -- 每日任务
    PlayerData.daily_schedule(1007, 1)
    AssetsChangeControl.OnDailyChanged()
    local msg = CommonMessage()
    msg.name = "forge_success"
    messMgr:AddCommonMessage(msg)
end