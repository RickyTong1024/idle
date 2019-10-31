ForgePanel = {}

ForgePanel.Control = {}
local this = ForgePanel.Control
function ForgePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.btn_name = {"forge_btn_equip_nol", "forge_btn_other_nol",  "forge_btn_rune_nol"}
    this.forge_botton_btn ={}
    this.page_text = {}
    this.cur_page_type_ = 1
    this.forge_equip_data_ = nil
    this.forge_rune_data_ = nil
    this.forge_item_data_ = nil
    this.superlist_= nil
    this.forge_id_ = nil
    this.bag_type_ = 0
    table.insert(this.page_text, "装 备")
    table.insert(this.page_text, "物 品")
    table.insert(this.page_text, "宝 石")

    this.page_btn_res_ = this.transform_:Find("back_ground/panel_down/page_btn_res")
    this.page_btn_res_group_ = this.transform_:Find("back_ground/panel_down/page_btn_res_group")
    this.icon_res_ = this.transform_:Find("back_ground/panel_among/icon_res")
    this.target_rect_ = this.transform_:Find("back_ground/panel_among/target_main_panel/target_rect")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.name_text_ = this.transform_:Find("back_ground/panel_among/top_title/name_text"):GetComponent("LocalizationText")
    this.nul_show_ = this.transform_:Find("back_ground/panel_among/nul_show")
    ForgePanel.RegisterStaticButton()
    ForgePanel.RegisterMessage()
    ForgePanel.InitSuperList()
end

function ForgePanel.OnParam(params)
    if params ~= nil then
        this.bag_type_ = params[1]
        this.cur_page_type_ = this.bag_type_
    end
end

function ForgePanel.Start()
    ForgePanel.GetAllForgeConfig()
    this.superlist_:SetData(ForgePanel.GetDataNum())
    this.name_text_.text = this.page_text[this.cur_page_type_]
    this.forge_botton_btn[this.cur_page_type_].gameObject:GetComponent("Toggle").isOn = true
    ForgePanel.CheckEquipRed()
end

function ForgePanel.RemoveMessage()
    AssetsChangeControl.RemoveItemChanged(ForgePanel.CheckEquipRed)
    AssetsChangeControl.RemoveGoldChanged(ForgePanel.CheckEquipRed)
end

function ForgePanel.RegisterMessage()
    AssetsChangeControl.AddItemChanged(ForgePanel.CheckEquipRed)
    AssetsChangeControl.AddGoldChanged(ForgePanel.CheckEquipRed)
end

function ForgePanel.OnDestroy()
    ForgePanel.RemoveMessage()
    this.lua_script_:ClearClick()
    this = {}
end

function ForgePanel.RegisterStaticButton()
    local forge_btn_num = #this.btn_name
     for i = 1, forge_btn_num do
        local btn_t = GameObject.Instantiate(this.page_btn_res_.gameObject)
        btn_t.transform:SetParent(this.page_btn_res_group_, false)
        btn_t.transform.localPosition = Vector3.zero
        btn_t.transform.localScale = Vector3.one
        btn_t.gameObject:GetComponent("Toggle").group = this.page_btn_res_group_:GetComponent("ToggleGroup")
        btn_t.gameObject:GetComponent("Toggle").isOn = false
        btn_t.name = this.btn_name[i]
        btn_t.transform:Find("nol/Text"):GetComponent("LocalizationText").text = this.page_text[i]
        btn_t.transform:Find("sel/Text"):GetComponent("LocalizationText").text = this.page_text[i]
        btn_t:SetActive(true)
        table.insert(this.forge_botton_btn, btn_t.transform)
    end
    this.forge_botton_btn[this.cur_page_type_].gameObject:GetComponent("Toggle").isOn = true
    for    i = 1, #this.forge_botton_btn do
        GameSys.ButtonRegister(this.lua_script_, this.forge_botton_btn[i].gameObject, "toggle", ForgePanel.ToggleClick)
    end
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ForgePanel.HidePanel)
    AssetsChangeControl.RemoveItemChanged(BagPanel.CheckBagRed)
    AssetsChangeControl.RemoveGoldChanged(BagPanel.CheckBagRed)
end

function ForgePanel.InitSuperList()
    GameSys.ClearChild(this.target_rect_)
    this.superlist_ = this.target_rect_:GetComponent("UIScrollGrid")
    this.superlist_.prefab = this.icon_res_.gameObject
    this.superlist_.SetDataHandle = function(go, index)
        local can_forge_min = {}
        local value = nil
        local asset = {}
        if this.cur_page_type_ == 1 then
            value = this.forge_equip_data_[index + 1]
        elseif this.cur_page_type_ == 3 then
            value = this.forge_rune_data_[index + 1]
        elseif this.cur_page_type_ == 2 then
            value = this.forge_item_data_[index + 1]
        end
        asset.type = value.type
        asset.value1 = value.value1
        asset.value2 = value.value2
        asset.value3 = value.value3
        local com_icon = CommonPanel.GetIcon2type(asset, {"forge_big"..index..value.value1}, this.lua_script_)
        local root_big_icon = go.transform:Find("back_image/big_icon_root")
        GameSys.ClearChild(root_big_icon)
        com_icon.transform:SetParent(root_big_icon, false)
        com_icon.transform.localScale = Vector3.one
        com_icon.transform.localPosition = Vector3.zero
        go.transform:Find("back_image/forge_title_text"):GetComponent("LocalizationText").text = GameSys.GetAssetName(asset)-- 锻造物品名称
        local click_obj = go.transform:Find("back_image/click_obj").transform:GetChild(0).gameObject
        if click_obj ~= nil then
            this.lua_script_:RemoveClick(click_obj)
            click_obj.name = "forget"..value.id
            GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", ForgePanel.OpenForgeWin, {value.id})
        end
        local small_icon_parent = go.transform:Find("back_image/small_rewards_obj")
        GameSys.ClearChild(small_icon_parent)
        for i = 1, #value.mat do
            local asset2 = {}
            asset2.type = value.mat[i].type
            asset2.value1 = value.mat[i].value1
            asset2.value2 = 0
            asset2.value3 = value.mat[i].value3

            --local com_icon2 = CommonPanel.GetMatRect(asset2, value.mat[i].value2, "forge"..index..value.mat[i].value1, this.lua_script_)
            local com_icon2 = CommonPanel.GetIcon2type(asset2, {"forge"..index..value.mat[i].value1}, this.lua_script_)
            com_icon2.transform:SetParent(small_icon_parent, false)
            com_icon2.transform.localScale = Vector3(0.5, 0.5, 1)
            com_icon2.transform.localPosition = Vector3.zero
            local cur_num = GameSys.GetAssetCount(value.mat[i].type, value.mat[i].value1)
            local num_content = GameSys.MatEnoughColor(GameSys.unit_conversion(cur_num), (cur_num >= value.mat[i].value2))
            num_content = string.format("%s/%s", num_content, GameSys.unit_conversion(value.mat[i].value2))
            local need_obj = com_icon2.transform:Find("generic")
            need_obj:GetComponent("LocalizationText").fontSize = 26
            need_obj:GetComponent("LocalizationText").text = num_content
            need_obj.gameObject:SetActive(true)
            com_icon2.gameObject:SetActive(true)
            local player_mat_num = GameSys.GetAssetCount(value.mat[i].type, value.mat[i].value1)
            table.insert(can_forge_min, math.floor(player_mat_num / value.mat[i].value2))
        end
        table.insert(can_forge_min, math.floor(PlayerData.player.gold / value.gold))
        go.transform:Find("back_image/can_forge_num"):GetComponent("LocalizationText").text = string.format("(可锻造: %s)", GameSys.unit_conversion(ForgePanel.MinForge(can_forge_min)))
        if value.type == 3 then
            local t_equip = Config.get_config_value("t_equip", value.value1)
            ForgePanel.SetRed(go.transform:Find("back_image/click_obj/red_point"), PlayerData.player.level >= t_equip.min_level and PlayerData.player.map == value.unlock_param and ForgePanel.MinForge(can_forge_min) > 0)
        else
            ForgePanel.SetRed(go.transform:Find("back_image/click_obj/red_point"), false)
        end
        go.gameObject:SetActive(true)
    end
    this.superlist_:Init()
    this.superlist_:SetData(0)
end

function ForgePanel.CheckEquipRed()
    local red = GameSys.HasCurLevelForge()
    ForgePanel.SetRed(this.forge_botton_btn[1].transform:Find("red_point"), red)
end

function ForgePanel.SetRed(red_point, show)
    if show then
        if not red_point.gameObject.activeSelf then
            red_point.gameObject:SetActive(true)
        end
    else
        if red_point.gameObject.activeSelf then
            red_point.gameObject:SetActive(false)
        end
    end
end

function ForgePanel.MinForge(table)
    local min = nil
    for _, v in pairs(table) do
        if min == nil then
            min = v
        end
        if min > v then
            min = v
        end
    end
    return min
end

function ForgePanel.ToggleClick(obj,check)
    if check  then
        local num = 0
        if obj.name == "forge_btn_equip_nol" then
            this.cur_page_type_ = 1
            num = #this.forge_equip_data_
            this.superlist_:SetData(num)
        elseif obj.name == "forge_btn_rune_nol" then
            this.cur_page_type_ = 3
            num = #this.forge_rune_data_
            this.superlist_:SetData(num)
        elseif obj.name == "forge_btn_other_nol" then
            this.cur_page_type_ = 2
            num = #this.forge_item_data_
            this.superlist_:SetData(num)
        end
        if num > 0 then
            this.nul_show_.gameObject:SetActive(false)
        else
            this.nul_show_.gameObject:SetActive(false)
        end
        this.name_text_.text = this.page_text[this.cur_page_type_]
    end
end

function ForgePanel.Textdeal(text)
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

function ForgePanel.GetEquipList()
    local t_forge = {}
    for _, v in pairs(Config.t_forge) do
        if v.type == 3 and ForgePanel.CanShow(v) then
            table.insert(t_forge, v)
        end
    end
    return t_forge
end

function ForgePanel.GetItemList()
    local forge_t = {}
    for _, v in pairs(Config.t_forge) do
        if v.type == 2 and ForgePanel.CanShow(v) then
            table.insert(forge_t, v)
        end
    end
    return forge_t
end

function ForgePanel.GetRuneList()
    local rune_t = {}
    for _, v in pairs(Config.t_forge) do
        if v.type == 5 and ForgePanel.CanShow(v) then
            table.insert(rune_t, v)
        end
    end
    return rune_t
end

function ForgePanel.CanShow(forge)
    if forge.unlock_type == 1 and PlayerData.player.level >= forge.unlock_param then
        return true
    elseif forge.unlock_type == 2 and PlayerData.player.map >= forge.unlock_param then
        return true
    elseif forge.unlock_type == 0 then
        return true
    end

    return false
end

function ForgePanel.SortForge(a, b)
    local map_a = tonumber(a.unlock_param)
    local map_b = tonumber(b.unlock_param)
    local a_id = tonumber(a.id)
    local b_id = tonumber(b.id)
    if map_a == map_b then
        return a_id < b_id
    else
        return map_a < map_b
    end
end

function ForgePanel.GetAllForgeConfig()
    this.forge_equip_data_ = ForgePanel.GetEquipList()
    this.forge_rune_data_ = ForgePanel.GetRuneList()
    this.forge_item_data_ = ForgePanel.GetItemList()
    ForgePanel.CanForgetSort()
    if #this.forge_equip_data_ <= 0 then
        this.nul_show_.gameObject:SetActive(true)
    end
end

function ForgePanel.CanForgetSort()
    if #this.forge_equip_data_ > 1 then
        table.sort(this.forge_equip_data_, ForgePanel.SortForge)
    end

    if #this.forge_rune_data_ > 1 then
        table.sort(this.forge_rune_data_, ForgePanel.SortForge)
    end

    if #this.forge_item_data_ > 1 then
        table.sort(this.forge_item_data_, ForgePanel.SortForge)
    end
end

function ForgePanel.OpenForgeWin(obj, param)
    this.forge_id_ = param[1]
    param[2] = ForgePanel.SMSG_FORGE
    GUIRoot.ShowPanel("ForgeSurePanel", param)
end

function ForgePanel.GetLevel(asset)
    local level_text = ""
    if asset.type == 3 then
        local forge_equip = Config.get_config_value("t_equip", asset.value1)
        if forge_equip ~= nil then
            level_text = string.format("Lv %s", forge_equip.level)
        end
    end
    return level_text
end

function ForgePanel.GetReserved(asset)
    local reserved_text = ""
    if asset.type == 3 then
        local forge_equip = Config.get_config_value("t_equip", asset.value1)
        if forge_equip ~= nil then
            reserved_text = string.format("%s\n\n(加0-%s条随机属性)", GameSys.TextDealPlaceholder(GameSys.GetAttributeText(forge_equip.attr), forge_equip.value),
                    forge_equip.max_q)
        end
    elseif asset.type == 5 then
        local forge_rune = Config.get_config_value("t_rune", asset.value1)
        if forge_rune ~= nil then
            reserved_text = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(forge_rune.attr_id), forge_rune.attr_value)
        end
    elseif asset.type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        for i = 0, #t_artifact.attrs do
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

function ForgePanel.HidePanel()
    GUIRoot.ClosePanel("ForgePanel")
    if this.bag_type_ ~= 0 then
        GUIRoot.ShowPanel("BagPanel", {this.bag_type_})
    end
end

function ForgePanel.GetWillForge()
    local t_forge_data = Config.get_config_value("t_forge", this.forge_id_)
    if t_forge_data then
        return t_forge_data
    else
        return nil
    end
end

function ForgePanel.GetDataNum()
    ForgePanel.CanForgetSort()
    if this.cur_page_type_ == 1 then
        return #this.forge_equip_data_
    elseif this.cur_page_type_ == 3 then
        return #this.forge_rune_data_
    elseif this.cur_page_type_ == 2 then
        return #this.forge_item_data_
    else
        return 0
    end
end


function ForgePanel.SMSG_FORGE()
    this.superlist_:SetData(ForgePanel.GetDataNum())
end