BagPanel = {}
BagPanel.Control = {}
local this = BagPanel.Control
function BagPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.btn_name = {"page_btn_equip_nol", "page_btn_material_nol", "page_btn_rune_nol"}
    this.page_text = {"装 备", "物 品", "宝 石"}
    this.deo_equip_list = {}
    this.page_botton_btn = {}
    this.item_sell_id = 0
    this.item_sell_num = 0
    this.cur_bag_page = 1
    this.is_alld_ = false
    this.root_panel = this.transform_:Find("pakege_panel")
    this.botton_btn_res = this.transform_:Find("pakege_panel/pakege_botton/page_btn_res")
    this.page_btn_res_group = this.transform_:Find("pakege_panel/pakege_botton/page_btn_res_group")
    this.bag_close = this.transform_:Find("pakege_panel/bag_close")
    this.nul_show_ = this.transform_:Find("pakege_panel/nul_show")
    --
    this.pakege_equip_panel = this.transform_:Find("pakege_panel/pakege_equip_panel")
    this.pakege_equip_num = this.pakege_equip_panel.transform:Find("equip_show/pakege_equip_num"):GetComponent("Text")
    this.pakege_top_text = this.transform_:Find("pakege_panel/panel_top/title_image/title_text")
    this.equip_show = this.pakege_equip_panel.transform:Find("equip_show")
    this.equip_resolve = this.transform_:Find("equip_resolve")
    this.equip_content = this.pakege_equip_panel.transform:Find("equip_show/equip_main_panel/equip_pakege_view/equip_pakege_view_content")
    this.decompose_btn_ = this.pakege_equip_panel.transform:Find("equip_show/decompose_btn")
    --
    this.equip_resolve_have_view_content = this.equip_resolve.transform:Find("equip_resolve_have_panel/equip_resolve_have")
    this.close_equip_resolve_btn_ = this.transform_:Find("equip_resolve/equip_resolve_have_panel/close_equip_resolve_btn")
    -- 宝石 材料 其他

    this.equip_resolve_sure_ = this.transform_:Find("equip_resolve/equip_resolve_have_panel/equip_resolve_sure")
    this.equip_pakege_btn = this.transform_:Find("pakege_panel/pakege_equip_panel/page_btns/equip_pakege_btn")
    this.deo_res_ = this.transform_:Find("equip_resolve/equip_resolve_have_panel/deo_res")
    this.max_equip_bag = Config.get_config_value("t_const", "max_equip_bag")
    this.ui_equip_scroll_ = this.transform_:Find("pakege_panel/pakege_equip_panel/equip_show/equip_main_panel/equip_pakege_view"):GetComponent("UIScrollGrid")
    this.equip_icon_back_ = this.transform_:Find("pakege_panel/pakege_botton/equip_icon_back")
    this.forge_btn_ = this.transform_:Find("pakege_panel/pakege_equip_panel/equip_show/forge_btn")
    this.forge_red_point_ = this.transform_:Find("pakege_panel/pakege_equip_panel/equip_show/forge_btn/forge_red_point")
    BagPanel.RegButton()
    BagPanel.SetView()
    BagPanel.RegisterMessage()
    BagPanel.InitScroll()
    BagPanel.CheckBagRed()
end

function BagPanel.RegButton()
    GameSys.ButtonRegister(this.lua_script_, this.bag_close.gameObject, "click", BagPanel.ButtonClick)
    UnlockManger.RegisterFunBtn({5007, this.decompose_btn_.gameObject, "click", BagPanel.ButtonClick, nil, this.lua_script_, true})
    GameSys.ButtonRegister(this.lua_script_, this.equip_resolve_sure_.gameObject, "click", BagPanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.close_equip_resolve_btn_.gameObject, "click", BagPanel.ButtonClick)
    UnlockManger.RegisterFunBtn({5005, this.forge_btn_.gameObject, "click", BagPanel.ButtonClick, nil, this.lua_script_, true})
    --GameSys.ButtonRegister(this.lua_script_, this.forge_btn_.gameObject, "click", BagPanel.ButtonClick)
    AssetsChangeControl.AddItemChanged(BagPanel.CheckBagRed)
    AssetsChangeControl.AddGoldChanged(BagPanel.CheckBagRed)
end

function BagPanel.RegisterMessage()
    Message.register_handle("wear_equip_success", BagPanel.WearEquipSuccess)
    Message.register_handle("enchant_equip_success", BagPanel.EnchantEquipSuccess)
    Message.register_handle("equip_reforge_success", BagPanel.ReforgeEquipSuccess)
    Message.register_net_handle(opcodes.SMSG_EQUIP_DECOMPOSE, BagPanel.SMSG_EQUIP_DECOMPOSE)
    Message.register_net_handle(opcodes.SMSG_ITEM_SELL, BagPanel.SMSG_ITEM_SELL)
    AssetsChangeControl.RemoveItemChanged(BagPanel.CheckBagRed)
    AssetsChangeControl.RemoveGoldChanged(BagPanel.CheckBagRed)
end

function BagPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_DECOMPOSE, BagPanel.SMSG_EQUIP_DECOMPOSE)
    Message.remove_net_handle(opcodes.SMSG_ITEM_SELL, BagPanel.SMSG_ITEM_SELL)
    Message.remove_handle("wear_equip_success", BagPanel.WearEquipSuccess)
    Message.remove_handle("enchant_equip_success", BagPanel.EnchantEquipSuccess)
    Message.remove_handle("equip_reforge_success", BagPanel.ReforgeEquipSuccess)
end

function BagPanel.OnDestroy()
    UnlockManger.RemoveFunBtn({5005, 5007})
    BagPanel.RemoveMessage()
    this = {}
end

function BagPanel.OnParam(param)
    if param ~= nil then
        this.cur_bag_page = param[1]
    end
    BagPanel.SelectBagPage(this.cur_bag_page)
end


function BagPanel.InitScroll()
    this.ui_equip_scroll_.prefab = this.equip_icon_back_.gameObject
    this.ui_equip_scroll_.SetDataHandle = function(go, index)
        BagPanel.SetDataRect(go, index + 1)
        if not go.activeSelf then
            go:SetActive(true)
        end
    end
    this.ui_equip_scroll_:Init()
    this.ui_equip_scroll_:SetData(0)
end

function BagPanel.GetEquip()
    local equip_sec = {}
    for _, v in pairs(PlayerData.equips) do
        if not GameSys.IsEquipWeared(v) then
            table.insert(equip_sec, v)
        end
    end
    if #equip_sec > 1 then
        table.sort(equip_sec, BagPanel.Sort_)
    end
    return equip_sec
end

function BagPanel.RefreshEquipPanel()
    this.equip_data_ = BagPanel.GetEquip()
    this.ui_equip_scroll_:SetData(#this.equip_data_)
end

function BagPanel.RefreshRunePanel()
    BagPanel.RuneGrid()
    this.ui_equip_scroll_:SetData(#this.rune_data_)
end

function BagPanel.RefreshItemPanel()
    BagPanel.ItemGrid()
    this.ui_equip_scroll_:SetData(#this.item_data_)
end

function BagPanel.GetItems()
    local item_ = {}
    if #item_ == 0 then
        for i = 1, #PlayerData.player.item_ids do
            table.insert(item_, PlayerData.player.item_ids[i])
        end
    end
    if #item_ > 1 then
        table.sort(item_, BagPanel.ItemSort_)
    end
    return item_
end

function BagPanel.GetRunes()
    local rune_ = {}
    if #rune_ == 0 then
        for i = 1, #GameSys.GetPlayerRunes() do
            if Config.get_config_value("t_rune", GameSys.GetPlayerRunes()[i]) ~= nil then
                table.insert(rune_, GameSys.GetPlayerRunes()[i])
            end
        end
    end
    if #rune_ > 1 then
        table.sort(rune_, BagPanel.RuneSort_)
    end
    return rune_
end

function BagPanel.SetDataRect(go, sort)
    if go.transform.childCount > 0 then
        local click_obj = go.transform:GetChild(0).gameObject.transform:GetChild(2).gameObject
        if click_obj ~= nil then
            this.lua_script_:RemoveClick(click_obj)
        end
        GameSys.ClearChild(go.transform)
    end
    if this.cur_bag_page == 1 then
        local equip_conf = Config.get_config_value("t_equip", this.equip_data_[sort].template_id)
        local asset = {}
        asset.type = 3
        asset.value1 = equip_conf.id
        local equip_t = CommonPanel.GetEquipIcon(this.equip_data_[sort],{this.equip_data_[sort].guid, BagPanel.EquipSelect, {3, equip_conf.id}}, this.lua_script_)
        equip_t.transform:SetParent(go.transform, false)
        equip_t.transform:GetComponent("RectTransform").anchoredPosition = Vector3(0, 0, 0)
        equip_t:SetActive(true)
    elseif this.cur_bag_page == 3 then
        local rune_config = Config.get_config_value("t_rune", this.rune_data_[sort])
        local asset = {}
        asset.type = 5
        asset.value1 = rune_config.id
        asset.value2 = GameSys.GetRuneCount(rune_config.id)
        asset.value3 = 0
        local item_t = CommonPanel.GetIcon2type(asset, {tostring(sort.."_rune_id_"..rune_config.id)}, this.lua_script_)
        item_t.transform:SetParent(go.transform, false)
        item_t.transform:GetComponent("RectTransform").anchoredPosition = Vector3(0, 0, 0)
        item_t:SetActive(true)
    elseif this.cur_bag_page == 2 then
        local item_config = Config.get_config_value("t_item", this.item_data_[sort])
        if item_config ~= nil then
            local asset = {}
            asset.type = 2
            asset.value1 = item_config.id
            asset.value2 = this.num_data_[sort]
            asset.value3 = 0
            local item_t = CommonPanel.GetIcon2type(asset, {"icon"..sort, BagPanel.ItemSelect, asset}, this.lua_script_)
            item_t.transform:SetParent(go.transform, false)
            item_t.transform:GetComponent("RectTransform").anchoredPosition = Vector3(0, 0, 0)
            item_t:SetActive(true)
            item_t.transform:Find("num"):GetComponent("Text").text = GameSys.GetItemCount(item_config.id)
            item_t.transform:Find("num").gameObject:SetActive(true)
            if GameSys.hasInTable(this.deo_equip_list, this.item_data_[sort]) then
                item_t.transform:Find(tostring(this.item_data_[sort]).."/select").gameObject:SetActive(true)
            end
            item_t:SetActive(true)
        end
    end

end

function BagPanel.ToggleClick(obj,check)
    if check  then
        if obj.name == "page_btn_equip_nol" then
            this.cur_bag_page = 1
        elseif obj.name == "page_btn_rune_nol" then
            this.cur_bag_page = 3
        elseif obj.name == "page_btn_material_nol" then
            this.cur_bag_page = 2
        end

        BagPanel.SelectBagPage(this.cur_bag_page)
    end
end

function BagPanel.ButtonClick(obj)
    if obj.name == "resolve_cancel" then
        this.page_deo_btn.gameObject:SetActive(true)
        this.equip_show.gameObject:SetActive(true)
        this.is_alld_ = false
        this.equip_resolve.gameObject:SetActive(false)
        this.deo_equip_list = {}
        BagPanel.SelectEquipSecPage()
    elseif obj.name == "bag_close" then
        GUIRoot.ClosePanel("BagPanel")
    elseif obj.name == "forge_btn" then
        GUIRoot.ClosePanel("BagPanel")
        GUIRoot.ShowPanel("ForgePanel", {this.cur_bag_page})
    elseif obj.name == "decompose_btn" then
        local deo_num = BagPanel.GetEquipAllDeo()
        if #deo_num <= 0 then
            local str = "没有可以批量分解的装备"
            GUIRoot.ShowPanel("MessagePanel", {str})
        else
            BagPanel.ShowEquipResolve()
        end
    elseif obj.name == "equip_resolve_sure" then
        if #this.deo_equip_list <= 0 then
            local str = "没有可以分解的装备"
            GUIRoot.ShowPanel("MessagePanel", {str})
        else
            BagPanel.EquipDecompose_ex()
        end
    elseif obj.name == "close_equip_resolve_btn" then
        this.equip_resolve.gameObject:SetActive(false)
        this.is_alld_ = false
        GameSys.ClearChild(this.equip_resolve_have_view_content)
    end
end

function BagPanel.SelectBagPage(page)
    this.nul_show_.gameObject:SetActive(false)
    if(page == 1) then
        this.forge_btn_:GetComponent("RectTransform").anchoredPosition = Vector2(-120, 17.5)
        if not UnlockManger.LockCheck(4009) then
            this.decompose_btn_.gameObject:SetActive(true)
        end
        BagPanel.SelectEquipSecPage()
     else
        this.forge_btn_:GetComponent("RectTransform").anchoredPosition = Vector2(2, 17.5)
        this.decompose_btn_.gameObject:SetActive(false)
        BagPanel.ShowOther(page)
     end
    this.page_botton_btn[this.cur_bag_page].gameObject:GetComponent("Toggle").isOn = true
    this.pakege_top_text:GetComponent("Text").text = this.page_text[this.cur_bag_page]
end

function BagPanel.ShowEquipResolve()
    this.equip_resolve.gameObject:SetActive(true)
    this.is_alld_ = true
    this.deo_equip_list = {}
    local deo_equip_list_temp = BagPanel.GetEquipAllDeo()
    GameSys.ClearChild(this.equip_resolve_have_view_content)
    for i = 1, 6 do
        local root_icon = GameObject.Instantiate(this.deo_res_.gameObject)
        root_icon.transform:SetParent(this.equip_resolve_have_view_content, false)
        root_icon.transform.localPosition = Vector3.zero
        root_icon.transform.localScale = Vector3.one
        if deo_equip_list_temp[i] ~= nil then
            local equip_conf = Config.get_config_value("t_equip",deo_equip_list_temp[i].template_id)
            local asset = {}
            asset.type = 3
            asset.value1 = equip_conf.id
            local equip_t = nil
            equip_t = CommonPanel.GetEquipIcon(deo_equip_list_temp[i],{deo_equip_list_temp[i].guid, BagPanel.EquipSelect,  {3, equip_conf.id}}, this.lua_script_)
            equip_t.transform:SetParent(root_icon.transform, false)
            equip_t.transform.localScale = Vector3.one
            equip_t.transform.localPosition = Vector3.zero
            if deo_equip_list_temp[i].color < 5 then
                table.insert(this.deo_equip_list, deo_equip_list_temp[i].guid)
            end
            equip_t:SetActive(true)
        end
        root_icon.gameObject:SetActive(true)
    end
end

function BagPanel.GetEquipAllDeo()
    local equip_sec = {}
    for _,v in pairs(PlayerData.equips) do
        if not GameSys.IsEquipWeared(v) and v.color < 5 then
            table.insert(equip_sec, v)
        end
    end
    local deo_sort = function(a, b)
        local a_level = a.level
        local b_level = b.level
        local a_color = a.color
        local b_color = b.color
        if a_color == b_color then
            return a_level < b_level
        else
            return a_color < b_color
        end
    end
    if #equip_sec > 1 then
        table.sort(equip_sec, deo_sort)
    end
    return equip_sec
end

function BagPanel.ShowOther(tps)
    this.deo_equip_list = {}
    this.pakege_equip_num.gameObject:SetActive(false)
    BagPanel.SelectOtherPage(tps)
end

function BagPanel.SelectOtherPage(other_type)
    if other_type == 3 then
        BagPanel.RefreshRunePanel()
    elseif other_type == 2 then
        BagPanel.RefreshItemPanel()
    end
end

function BagPanel.ItemGrid()
    this.item_data_ = BagPanel.GetItems()
    this.num_data_ = {}
    for i = 1,#PlayerData.player.item_ids do
        local table_k = GameSys.getIndex(this.item_data_, PlayerData.player.item_ids[i])
        this.num_data_[table_k] = PlayerData.player.item_nums[i]
    end
    if #this.num_data_ <= 0 then
        this.nul_show_.gameObject:SetActive(true)
    end
end

function BagPanel.RuneGrid()
    this.rune_data_ = BagPanel.GetRunes()
    this.num_data_ = {}
    for i = 1,#GameSys.GetPlayerRunes() do
        local table_k = GameSys.getIndex(this.rune_data_, GameSys.GetPlayerRunes()[i])
        this.num_data_[table_k] = PlayerData.player.rune_nums[i]
    end
    if #this.num_data_ <= 0 then
        this.nul_show_.gameObject:SetActive(true)
    end
end

function BagPanel.SelectEquipSecPage()
    this.pakege_equip_num.text = string.format("%s/%s", GameSys.GetBagEquipCount(), this.max_equip_bag.value)
    this.pakege_equip_num.gameObject:SetActive(true)
    this.pakege_equip_panel.gameObject:SetActive(true)
    BagPanel.RefreshEquipPanel()
    if #this.equip_data_ <= 0 then
        this.nul_show_.gameObject:SetActive(true)
    end
    this.equip_show.gameObject:SetActive(true)
    this.equip_resolve.gameObject:SetActive(false)
    this.is_alld_ = false
end

function BagPanel.RuneSort_(a, b)
    local tempa = Config.get_config_value("t_rune", a)
    local tempb = Config.get_config_value("t_rune", b)
    if(tempa and tempb) then
        local aid = tonumber(tempa.id)
        local bid = tonumber(tempb.id)
        local a_type = tonumber(tempa.type)
        local b_type = tonumber(tempb.type)
        if a_type == b_type then
            return aid > bid
        else
            return a_type > b_type
        end
    else
        return 1 > 0
    end
end

function BagPanel.ItemSort_(a, b)
    local tempa = Config.get_config_value("t_item", a)
    local tempb = Config.get_config_value("t_item", b)
    if tempa == nil or tempb == nil then
        return false
    end
    local aid = tonumber(tempa.id)
    local bid = tonumber(tempb.id)
    return aid < bid
end

function BagPanel.Sort_(a, b)
    local r
    local tempa = Config.get_config_value("t_equip", a.template_id)
    local tempb = Config.get_config_value("t_equip", b.template_id)
    local al = tonumber(tempa.level)
    local bl = tonumber(tempb.level)
    local aq = tonumber(tempa.max_q)
    local bq = tonumber(tempb.max_q)
    local aid = tonumber(tempa.id)
    local bid = tonumber(tempb.id)
    if  al == bl then
        if aq == bq then
            r = aid > bid
        else
            r = aq > bq
        end 
    else
        r = al > bl
    end
    return r
end

function BagPanel.SetView()
    for  i = 1, #this.btn_name do
        local btn_t = GameObject.Instantiate(this.botton_btn_res.gameObject)
        btn_t.transform:SetParent(this.page_btn_res_group, false)
        btn_t.transform.localPosition = Vector3(-195 + (i -1) * 195, 0, 0)
        btn_t.transform.localScale = Vector3.one
        btn_t.gameObject:GetComponent("Toggle").group = this.page_btn_res_group:GetComponent("ToggleGroup")
        btn_t.gameObject:GetComponent("Toggle").isOn = false
        btn_t.name = this.btn_name[i]
        btn_t.transform:Find("nol/Text"):GetComponent("Text").text = this.page_text[i]
        btn_t.transform:Find("sel/Text"):GetComponent("Text").text = this.page_text[i]
        btn_t:SetActive(true)
        table.insert(this.page_botton_btn, btn_t.transform)
    end
    this.page_botton_btn[1].gameObject:GetComponent("Toggle").isOn = true
    for i = 1, #this.page_botton_btn do
        GameSys.ButtonRegister(this.lua_script_, this.page_botton_btn[i].gameObject, "toggle", BagPanel.ToggleClick)
    end
    this.pakege_top_text:GetComponent("Text").text = this.page_text[this.cur_bag_page]
end

function BagPanel.EquipSelect(obj)
    local equip = Config.get_config_value("t_equip", GameSys.GetEquipId(obj.name))
    local equip_info = PlayerData.equips[obj.name]
    if not this.is_alld_ then
        this.deo_equip_list = {}
        table.insert( this.deo_equip_list, obj.name)
        GUIRoot.ShowPanel("EquipDetailPanel", {equip_info, equip.type, true})
    else
        GUIRoot.ShowPanel("EquipDetailPanel", {equip_info, equip.type, false})
    end
end

function BagPanel.ItemSelect(obj, parms)
    local asset = parms
    local config = GameSys.GetAssetConfig(asset)
    if config.sell ~= nil then
        GUIRoot.ShowPanel("AssetWindowPanel",{ AssetWindowPanel.SHOW_TYPE.sell, asset})
    else
        GUIRoot.ShowPanel("AssetWindowPanel",{ AssetWindowPanel.SHOW_TYPE.show, asset})
    end

end

function BagPanel.SellItem(item_ids, item_nums)
    this.item_sell_id = item_ids
    this.item_sell_num = item_nums
    local msg = item_msg_pb.cmsg_item_sell()
    msg.item_ids:append(item_ids)
    msg.item_nums:append(item_nums)
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_ITEM_SELL, data, {opcodes.SMSG_ITEM_SELL}, "出售中")
end

function BagPanel.EquipDecompose()
    local f_tag = false
    for i = 1, #this.deo_equip_list do
        if PlayerData.equips[this.deo_equip_list[i]].color > 4 then
            f_tag = true
            break
        end
    end

    if f_tag then
        GUIRoot.ShowPanel("SelectPanel",{"将要分解高级物品,是否继续?", function ()
            BagPanel.EquipDecompose_ex()
        end, nil, ""})
    else
        BagPanel.EquipDecompose_ex()
    end

end

function BagPanel.EquipDecompose_ex()
    local msg = item_msg_pb.cmsg_equip_decompose()
    for i = 1, #this.deo_equip_list do
        msg.equip_guids:append(this.deo_equip_list[i])
    end
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_DECOMPOSE, data, {opcodes.SMSG_EQUIP_DECOMPOSE}, "分解中", 60)
end

function BagPanel.CheckBagRed()
    local red = GameSys.HasCurLevelForge()
    BagPanel.SetRed(this.forge_red_point_, red)
end

function BagPanel.SetRed(red_point, show)
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

-----client message------
function BagPanel.WearEquipSuccess()
    BagPanel.SelectEquipSecPage()
end

function BagPanel.EnchantEquipSuccess()
    BagPanel.SelectEquipSecPage()
end

function BagPanel.ReforgeEquipSuccess()
    BagPanel.SelectEquipSecPage()
end
---
------net message-----
---分解---
function BagPanel.SMSG_EQUIP_DECOMPOSE(message)
    local assets = common_msg_pb.msg_assets()
    for i = 1, #this.deo_equip_list do
        local equip = PlayerData.equips[this.deo_equip_list[i]]
        local t_equip = Config.get_config_value("t_equip", equip.template_id)
        local t_equip_discompose = Config.get_config_value("t_equip_discompose", equip.color)
        local l_asset = {}
        l_asset.type = 1
        l_asset.value1 = 1
        l_asset.value2 = t_equip.fprice
        l_asset.value3 = 0
        table.insert(assets.assets, l_asset)
        if t_equip_discompose ~= nil then
            local l_asset2 = {}
            l_asset2.type = 2
            l_asset2.value1 = t_equip_discompose.item
            l_asset2.value2 = t_equip.fitem_num
            l_asset2.value3 = 0
            table.insert(assets.assets, l_asset2)
        end
        PlayerData.remove_equip(equip)
    end
    PlayerData.add_assets(assets)
    this.deo_equip_list = {}
    BagPanel.SelectEquipSecPage()
end

---出售---
function BagPanel.SMSG_ITEM_SELL(message)
    PlayerData.remove_item(this.item_sell_id, this.item_sell_num)
    local t_item = Config.get_config_value("t_item", this.item_sell_id)
    PlayerData.add_resource(1, this.item_sell_num * t_item.sell)
    BagPanel.SelectOtherPage(this.cur_bag_page)
end

