ShopPanel = {}
ShopPanel.Control = {}
local this = ShopPanel.Control

function ShopPanel.Awake(obj)

    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")


    this.close_btn = this.transform_:Find("back_ground/close_btn")
    this.shop_panel = this.transform_:Find("back_ground/panel_among/shop_panel")
    this.good_content = this.transform_:Find("back_ground/panel_among/shop_panel/back_ground/goods_scroll_rect/view/good_content")
    this.view = this.transform_:Find("back_ground/panel_among/shop_panel/back_ground/goods_scroll_rect/view")
    this.goods_slot = this.transform_:Find("back_ground/panel_among/shop_panel/goods_slot")
    this.good = this.transform_:Find("back_ground/panel_among/shop_panel/goods")
    this.draw_panel = this.transform_:Find("back_ground/panel_among/draw_panel")
    this.title_text_ = this.transform_:Find("back_ground/panel_top/title_image/title_text"):GetComponent("LocalizationText")
    this.page_btn_res_ = this.transform_:Find("back_ground/panel_down/page_btn_res")
    this.page_btn_res_group_ = this.transform_:Find("back_ground/panel_down/page_btn_res_group")

    ---抽卡对象
    this.rune_resource_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_resource_only")
    this.rune_resource_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_resource_ten")

    this.rune_item_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_item_only")
    this.rune_item_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_item_ten")

    this.rune_resource_only_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_resource_only/rune_resource_only_text")
    this.rune_resource_ten_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns/rune_resource_ten/rune_resource_ten_text")

    this.pet_item_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_item_ten")
    this.pet_item_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_item_only")
    this.pet_resource_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_resource_only")
    this.pet_resource_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_resource_ten")
    this.pet_resource_only_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_resource_only/pet_resource_only_text")
    this.pet_resource_ten_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns/pet_resource_ten/pet_resource_ten_text")

    this.equip_resource_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_resource_only")
    this.equip_resource_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_resource_ten")
    this.equip_item_only_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_item_only")
    this.equip_item_ten_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_item_ten")
    this.equip_item_only_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_item_only/equip_item_only_text")
    this.equip_item_ten_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_item_ten/equip_item_ten_text")
    this.equip_resource_only_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_resource_only/equip_resource_only_text")
    this.equip_resource_ten_text_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns/equip_resource_ten/equip_resource_ten_text")
    this.settlement_panel = this.transform_:Find("back_ground/settlement_panel")
    this.settlement_group = this.transform_:Find("back_ground/settlement_panel/settlement_scroll/draw_card_view")
    this.close_settlement_but = this.transform_:Find("back_ground/settlement_panel/settlement_scroll/close_settlement_btn")
    this.pet_chouka_lock_ = this.transform_:Find("back_ground/panel_among/draw_panel/chouka_pages/pet_chouka_lock")
    this.rune_chouka_lock_ = this.transform_:Find("back_ground/panel_among/draw_panel/chouka_pages/rune_chouka_lock")

    this.rune_btns_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/rune_btns")
    this.pet_btns_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/pet_btns")
    this.equip_btns_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/equip_btns")
    this.pet_page_ = this.transform_:Find("back_ground/panel_among/draw_panel/chouka_pages/pet_page")
    this.equip_page_ = this.transform_:Find("back_ground/panel_among/draw_panel/chouka_pages/equip_page")
    this.rune_page_ = this.transform_:Find("back_ground/panel_among/draw_panel/chouka_pages/rune_page")
    this.ck_desc_close_btn_ = this.transform_:Find("ck_desc_panel/back/ck_desc_close_btn")
    this.item_desc_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/item_draw_back/item_desc_back/item_desc"):GetComponent("LocalizationText")
    this.res_desc_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/res_draw_back/res_desc_back/res_desc"):GetComponent("LocalizationText")
    this.ck_desc_panel_ = this.transform_:Find("ck_desc_panel")
    this.ck_desc_btn_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/ck_desc_btn")
    this.xg_shop_panel_ = this.transform_:Find("back_ground/panel_among/xg_shop_panel")
    this.xg_goods_slot_ = this.transform_:Find("back_ground/panel_among/xg_shop_panel/xg_goods_slot")
    this.xg_good_content_ = this.transform_:Find("back_ground/panel_among/xg_shop_panel/back_ground/goods_scroll_rect/view/xg_good_content")
    this.chouka_image_ = this.transform_:Find("back_ground/panel_among/draw_panel/groud/top_layer/chouka_image"):GetComponent("RawImage")
    this.ck_fp_ = this.transform_:Find("back_ground/settlement_panel/settlement_scroll/ck_fp")
    this.chouka_image_.texture = UIEffect.Camera.targetTexture
    this.jvneng_image_ = this.transform_:Find("back_ground/jvneng_image"):GetComponent("RawImage")
    this.jvneng_image_.texture = UIEffect.Camera.targetTexture
    this.btn_name = {"shop_gold_nol", "shop_rep_nol",  "shop_jewel_nol", "shop_lucky_nol"}
    this.ten_draw_pos = {{0, -189}, {-183, -315}, {183, -315}, {0, -442}, {-183, -568}, {183, -568}, {0, -695}, {-183, -821}, {183, -821}, {0, -948}}
    this.shop_botton_btn = {}
    this.page_text = {}
    this.good_states = {}
    this.cur_good_state = nil
    this.cur_cost = 0
    this.draw_server_data = nil
    this.cur_page_type = 1
    this.draw_obj = {}
    table.insert(this.page_text, "限购商店")
    table.insert(this.page_text, "声望商店")
    table.insert(this.page_text, "钻石商店")
    table.insert(this.page_text, "幸运商店")

    this.pet_page_:GetComponent("Toggle").isOn = false
    this.equip_page_:GetComponent("Toggle").isOn = false
    this.rune_page_:GetComponent("Toggle").isOn = false

    this.item_size_ = Vector3(0.728, 0.728, 0.728)
    ShopPanel.RegisterBtnListers()
    ShopPanel.RegisterMessage()
    ShopPanel.RegisterUnlockBtnListers()
end

function ShopPanel.RegisterUnlockBtnListers()
    UnlockManger.RegisterFunBtn({3005, this.pet_chouka_lock_ , "click", nil, nil, this.lua_script, true})
    UnlockManger.RegisterFunBtn({3006, this.rune_chouka_lock_ , "click", nil, nil, this.lua_script, true})
end

function ShopPanel.OnDestroy()
    this.cur_page_type = 1
    this.shop_botton_btn ={}
    this.page_text = {}
    UIEffect.Hide("cs_ld01")
    UnlockManger.RemoveFunBtn({3005, 3006})
    ShopPanel.RemoveMessage()
    this = {}
end

function ShopPanel.OnParam(params)
    if params ~= nil then
        this.cur_page_type = params[1]
    else
        this.cur_page_type = 1
    end
end

function ShopPanel.Start(obj)
    this.rune_resource_only_text_:GetComponent("LocalizationText").text = Config.get_config_value("t_const", "rune_draw_crystal").value
    this.rune_resource_ten_text_:GetComponent("LocalizationText").text = Config.get_config_value("t_const", "rune_draw_crystal_10").value
    this.pet_resource_only_text_:GetComponent("LocalizationText").text = Config.get_config_value("t_const", "pet_draw_crystal").value
    this.pet_resource_ten_text_:GetComponent("LocalizationText").text = Config.get_config_value("t_const", "pet_draw_crystal_10").value
    local t_equip_draw = Config.get_config_value("t_equip_draw", PlayerData.player.map == 0 and 1 or (PlayerData.player.map))
    this.equip_item_only_text_:GetComponent("LocalizationText").text = t_equip_draw.item
    this.equip_item_ten_text_:GetComponent("LocalizationText").text = t_equip_draw.item10
    this.equip_resource_only_text_:GetComponent("LocalizationText").text = t_equip_draw.jewel
    this.equip_resource_ten_text_:GetComponent("LocalizationText").text = t_equip_draw.jewel10
    this.rune_item_only_.transform:Find("rune_item_only_text/rune_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "rune_draw_item").value))
    this.rune_item_ten_.transform:Find("rune_item_ten_text/rune_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "rune_draw_item").value))
    this.pet_item_only_.transform:Find("pet_item_only_text/pet_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "pet_draw_item").value))
    this.pet_item_ten_.transform:Find("pet_item_ten_text/pet_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "pet_draw_item").value))
    this.equip_item_only_.transform:Find("equip_item_only_text/equip_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "equip_draw_item").value))
    this.equip_item_ten_.transform:Find("equip_item_ten_text/equip_item"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "item"):GetSprite(tostring(Config.get_config_value("t_const", "equip_draw_item").value))

    ShopPanel.RefreshShopPanel()
    this.item_count_ = 1
    this.title_text_.text = this.page_text[this.cur_page_type]
    this.shop_botton_btn[this.cur_page_type].gameObject:GetComponent("Toggle").isOn = true
    this.draw_panel.gameObject:SetActive(false)
    this.shop_panel.gameObject:SetActive(false)
    this.xg_shop_panel_.gameObject:SetActive(true)
end

function ShopPanel.RegisterBtnListers()
    local shop_btn_num = #this.btn_name
    for i = 1, shop_btn_num do
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
        table.insert(this.shop_botton_btn, btn_t.transform)
    end
    this.shop_botton_btn[this.cur_page_type].gameObject:GetComponent("Toggle").isOn = true
    for i = 1, #this.shop_botton_btn do
        GameSys.ButtonRegister(this.lua_script, this.shop_botton_btn[i].gameObject, "toggle", ShopPanel.ToggleClick)
    end

    GameSys.ButtonRegister(this.lua_script, this.close_btn.gameObject, "click", ShopPanel.OnCloseClick, nil)
    GameSys.ButtonRegister(this.lua_script, this.settlement_group.gameObject, "click", ShopPanel.CloseSettlementPanel, nil, false)

    GameSys.ButtonRegister(this.lua_script, this.rune_resource_only_.gameObject, "click", ShopPanel.RuneResourceDrawOne)
    GameSys.ButtonRegister(this.lua_script, this.rune_resource_ten_.gameObject, "click", ShopPanel.RuneResourceDrawTen)
    GameSys.ButtonRegister(this.lua_script, this.rune_item_only_.gameObject, "click", ShopPanel.RuneItemDraw, {1})
    GameSys.ButtonRegister(this.lua_script, this.rune_item_ten_.gameObject, "click", ShopPanel.RuneItemDraw, {10})

    GameSys.ButtonRegister(this.lua_script, this.pet_resource_only_.gameObject, "click", ShopPanel.PetResourceDrawOne)
    GameSys.ButtonRegister(this.lua_script, this.pet_resource_ten_.gameObject, "click", ShopPanel.PetResourceDrawTen)
    GameSys.ButtonRegister(this.lua_script, this.pet_item_only_.gameObject, "click", ShopPanel.PetItemDraw, {1})
    GameSys.ButtonRegister(this.lua_script, this.pet_item_ten_.gameObject, "click", ShopPanel.PetItemDraw, {10})

    GameSys.ButtonRegister(this.lua_script, this.equip_resource_only_.gameObject, "click", ShopPanel.EquipResourceDrawOne)
    GameSys.ButtonRegister(this.lua_script, this.equip_resource_ten_.gameObject, "click", ShopPanel.EquipResourceDrawTen)
    GameSys.ButtonRegister(this.lua_script, this.equip_item_only_.gameObject, "click", ShopPanel.EquipItemDraw, {1})
    GameSys.ButtonRegister(this.lua_script, this.equip_item_ten_.gameObject, "click", ShopPanel.EquipItemDraw, {10})

    GameSys.ButtonRegister(this.lua_script, this.pet_page_.gameObject, "toggle", ShopPanel.DrawPageClick )
    GameSys.ButtonRegister(this.lua_script, this.equip_page_.gameObject, "toggle", ShopPanel.DrawPageClick)
    GameSys.ButtonRegister(this.lua_script, this.rune_page_.gameObject, "toggle", ShopPanel.DrawPageClick)
    --UnlockManger.RegisterFunBtn({4010, this.pet_page_ , "toggle", ShopPanel.DrawPageClick, nil, this.lua_script, true})
    --UnlockManger.RegisterFunBtn({4011, this.rune_page_ , "toggle", ShopPanel.DrawPageClick, nil, this.lua_script, true})
    GameSys.ButtonRegister(this.lua_script, this.ck_desc_close_btn_.gameObject, "click", ShopPanel.DrawDescPanelClose)
    GameSys.ButtonRegister(this.lua_script, this.ck_desc_btn_.gameObject, "click", ShopPanel.OpenCkDescPanel)

    GameSys.ButtonRegister(this.lua_script, this.close_settlement_but.gameObject, "click", ShopPanel.FilpAllCard)

end

function ShopPanel.RegisterMessage()
    Message.register_handle("refresh_day", ShopPanel.RefreshDay)
    Message.register_net_handle(opcodes.SMSG_SHOP_BUY, ShopPanel.BuyDone)
    Message.register_net_handle(opcodes.SMSG_DRAW_CARD, ShopPanel.SMSG_DRAW_CARD)
end

function ShopPanel.RemoveMessage()
    Message.remove_handle("refresh_day", ShopPanel.RefreshDay)
    Message.remove_net_handle(opcodes.SMSG_SHOP_BUY, ShopPanel.BuyDone)
    Message.remove_net_handle(opcodes.SMSG_DRAW_CARD, ShopPanel.SMSG_DRAW_CARD)
end

function ShopPanel.OnShopPageClick(obj, is_on, params)
    local text = obj.transform:Find("sel/Text")
    text.gameObject:SetActive(is_on)
    if is_on then
        this.draw_panel.gameObject:SetActive(false)
        this.shop_panel.gameObject:SetActive(true)
        ShopPanel.RefreshShopPanel()
    end
end

function ShopPanel.OnDrawPageClick(obj, is_on, params)
    local text = obj.transform:Find("sel/Text")
    text.gameObject:SetActive(is_on)
    if is_on then
        this.draw_panel.gameObject:SetActive(true)
        this.shop_panel.gameObject:SetActive(false)
        ShopPanel.RefreshDrawPanel()
    end
end

function ShopPanel.ToggleClick(obj, is_on, params)
    if is_on then
        if obj.name == "shop_lucky_nol" then
            this.equip_page_:GetComponent("Toggle").isOn = true
            this.cur_page_type = 4
            local r = UIEffect.Show("cs_ld01")
            this.chouka_image_.uvRect = r
            this.title_text_.text = this.page_text[this.cur_page_type]
            ShopPanel.RefreshShopPanel()
            ShopPanel.PanelChange()
            return
        end

        UIEffect.Hide("ui_mine01")
        if obj.name == "shop_gold_nol" then
            this.cur_page_type = 1
        elseif obj.name == "shop_rep_nol" then
            this.cur_page_type = 2
        elseif obj.name == "shop_jewel_nol" then

            this.cur_page_type = 3
        end
        this.title_text_.text = this.page_text[this.cur_page_type]
        ShopPanel.RefreshShopPanel()
        ShopPanel.PanelChange()
    end
end

function ShopPanel.PanelChange()
    if this.cur_page_type == 1 then
        if this.draw_panel.gameObject.activeSelf then
            this.draw_panel.gameObject:SetActive(false)
        end
        if this.shop_panel.gameObject.activeSelf then
            this.shop_panel.gameObject:SetActive(false)
        end
        if not this.xg_shop_panel_.gameObject.activeSelf then
            this.xg_shop_panel_.gameObject:SetActive(true)
        end
    elseif this.cur_page_type == 2 or this.cur_page_type == 3 then
        if this.draw_panel.gameObject.activeSelf then
            this.draw_panel.gameObject:SetActive(false)
        end
        if not this.shop_panel.gameObject.activeSelf then
            this.shop_panel.gameObject:SetActive(true)
        end
        if this.xg_shop_panel_.gameObject.activeSelf then
            this.xg_shop_panel_.gameObject:SetActive(false)
        end
    elseif this.cur_page_type == 4 then
        if not this.draw_panel.gameObject.activeSelf then
            this.draw_panel.gameObject:SetActive(true)
        end
        if this.shop_panel.gameObject.activeSelf then
            this.shop_panel.gameObject:SetActive(false)
        end
        if this.xg_shop_panel_.gameObject.activeSelf then
            this.xg_shop_panel_.gameObject:SetActive(false)
        end
    end
end

function ShopPanel.DrawPageClick(obj, is_on, params)
    if is_on then
        if obj.name == "equip_page" then
            ShopPanel.RefreshDrawPanel(2)
        elseif obj.name == "rune_page" then
            ShopPanel.RefreshDrawPanel(1)
        elseif obj.name == "pet_page" then
            ShopPanel.RefreshDrawPanel(3)
        end
    end
end

function ShopPanel.OnCloseClick(obj, params)
    ShopPanel.Close()
end

function ShopPanel.Close()
    GUIRoot.ClosePanel("ShopPanel")
end

function ShopPanel.RefreshShopPanel()
    ShopPanel.SetShopData()
    ShopPanel.CreateGoods()
end

function ShopPanel.RefreshDrawPanel(select_type)
    if select_type == 1 then
        if not this.rune_btns_.gameObject.activeSelf then
            this.rune_btns_.gameObject:SetActive(true)
            this.pet_btns_.gameObject:SetActive(false)
            this.equip_btns_.gameObject:SetActive(false)
            this.item_desc_.text = "随机获得一个宝石"
            this.res_desc_.text = "随机获得一个宝石"
        end
    elseif select_type == 2 then
        if not this.equip_btns_.gameObject.activeSelf then
            this.rune_btns_.gameObject:SetActive(false)
            this.pet_btns_.gameObject:SetActive(false)
            this.equip_btns_.gameObject:SetActive(true)
            local t_equip_draw = Config.get_config_value("t_equip_draw", PlayerData.player.map == 0 and 1 or PlayerData.player.map)
            this.item_desc_.text = string.format("随机获得一件%s级可穿戴的稀有，卓越或传奇的装备", t_equip_draw.wear_level)
            this.res_desc_.text = string.format("随机获得一件%s级可穿戴的稀有，卓越或传奇的装备", t_equip_draw.wear_level)
        end
    elseif select_type == 3 then
        if not this.pet_btns_.gameObject.activeSelf then
            this.rune_btns_.gameObject:SetActive(false)
            this.pet_btns_.gameObject:SetActive(true)
            this.equip_btns_.gameObject:SetActive(false)
            this.item_desc_.text = "随机获得一个宠物用道具，甚至能开出宠物"
            this.res_desc_.text = "随机获得一个宠物用道具，甚至能开出宠物"
        end

    end
end

---商店界面
function ShopPanel.SetShopData()
    this.good_states = {}
    local shop_config = Config.t_shop
    for k, v in pairs(shop_config) do
        if v.shop_type == this.cur_page_type and (v.unlock_map == PlayerData.player.map or v.unlock_map == 0) then
            table.insert(this.good_states, v)
        end
    end
    table.sort(this.good_states, function(a, b)
        return a.id < b.id
    end)
end


function ShopPanel.GoodsXgNum(id)
    local t_shop = Config.get_config_value('t_shop', id)
    if t_shop.shop_type == 1 then
        local index = GameSys.getIndex(PlayerData.player.shop_ids, t_shop.id)
        if index == nil then
            return t_shop.buy_num
        else
            return t_shop.buy_num - PlayerData.player.shop_nums[index]
        end
    end
end

function ShopPanel.CreateGoods()
    if this.cur_page_type == 1 then
        Util.ClearChild(this.xg_good_content_)
        for i = 1, #this.good_states do
            local slot_ins = GameObject.Instantiate(this.xg_goods_slot_.gameObject)
            slot_ins.transform:SetParent(this.xg_good_content_, false)
            local asset = {}
            asset.type = this.good_states[i].type
            asset.value1 = this.good_states[i].value1
            asset.value2 = this.good_states[i].value2 == 1 and 0 or this.good_states[i].value2
            asset.value3 = this.good_states[i].value3
            local sprite = CommonPanel.GetIcon2type(asset, {"buy_icon"..this.good_states[i].id}, this.lua_script)
            if sprite ~= nil then
                sprite.transform:SetParent(slot_ins.transform:Find("icon_root"), false)
                sprite.transform.localScale = Vector3.one --this.item_size_
                sprite.transform.localPosition = Vector3.zero
            end
            local discount = slot_ins.transform:Find("icon_root/discount_text")
            if this.good_states[i].discount ~= 0 then
                discount:GetComponent("LocalizationText").text = string.format("%s折", platform_config_common.lang == 3 and (10 - this.good_states[i].discount) * 10  or this.good_states[i].discount)
                discount.transform:SetAsLastSibling()
            else
                discount.gameObject:SetActive(false)
            end
            if this.good_states[i].buy_num ~= 0 then
                slot_ins.transform:Find("xg_num_text"):GetComponent("LocalizationText").text = string.format("每日限购:%s/%s", ShopPanel.GoodsXgNum(this.good_states[i].id), this.good_states[i].buy_num)
            else
                slot_ins.transform:Find("xg_num_text").gameObject:SetActive(false)
            end
            slot_ins.transform:Find("asset_name"):GetComponent("Text").text = GameSys.GetAssetName(asset)
            slot_ins.transform:Find("price_icon/price_text"):GetComponent("Text").text = GameSys.GoodPrice(this.good_states[i], 1)
            local t_res = Config.get_config_value("t_resource", this.good_states[i].price_value1)
            slot_ins.transform:Find("price_icon"):GetComponent("Image").sprite = GameSys.GetCommonAtlas():GetSprite(t_res.small_icon)

            local click_obj = slot_ins.transform:Find("click_obj/target_btn_image")
            if ShopPanel.GoodsXgNum(this.good_states[i].id) ~= 0 or this.good_states[i].buy_num == 0 then
                click_obj:GetComponent("Button").interactable = true
            end
            click_obj.name = "xg_"..this.good_states[i].id
            GameSys.ButtonRegister(this.lua_script, click_obj, "click", ShopPanel.OnGoodClick, { i })
            slot_ins:SetActive(true)
        end
    else
        Util.ClearChild(this.good_content)
        local view_rect = this.view:GetComponent("RectTransform").rect
        local view_height = view_rect.height
        local slot_height = this.goods_slot:GetComponent("RectTransform").sizeDelta.y
        local base_slot_count = math.modf(view_height / slot_height)
        local good_count = #this.good_states
        local real_slot_count = math.ceil(good_count / 4)
        local slot_count = (real_slot_count >= base_slot_count) and real_slot_count or base_slot_count
        for i = 1, slot_count do
            local slot_ins = GameObject.Instantiate(this.goods_slot.gameObject)
            slot_ins:SetActive(true)
            slot_ins.transform:SetParent(this.good_content)
            slot_ins.transform.localScale = Vector3.one
            local index = (i - 1) * 4 + 1
            for j = index, i * 4 do
                if this.good_states[j] == nil then
                    break
                end
                local good_ins = GameObject.Instantiate(this.good.gameObject)
                good_ins:SetActive(true)
                good_ins.transform:SetParent(slot_ins.transform)
                good_ins.transform.localScale = Vector3.one
                local good_icon_ground = good_ins.transform:Find("good_icon_ground/content")
                local name_text = good_ins.transform:Find("good_icon_ground/good_name_text")
                local asset = {}
                asset.type = this.good_states[j].type
                asset.value1 = this.good_states[j].value1
                asset.value2 = this.good_states[j].value2 == 1 and 0 or this.good_states[j].value2
                asset.value3 = this.good_states[j].value3
                local sprite = CommonPanel.GetIcon2type(asset, {}, this.lua_script)
                if sprite ~= nil then
                    sprite.transform:SetParent(good_icon_ground, false)
                    sprite.transform.localScale = Vector3.one --this.item_size_
                    sprite.transform.localPosition = Vector3.zero
                end
                name_text:GetComponent("Text").text = GameSys.GetAssetName(asset)
                good_ins.transform:Find("price_text"):GetComponent("Text").text = GameSys.GoodPrice(this.good_states[j], 1)
                local t_res = Config.get_config_value("t_resource", this.good_states[j].price_value1)
                good_ins.transform:Find("price_text/price_icon"):GetComponent("Image").sprite = GameSys.GetCommonAtlas():GetSprite(t_res.small_icon)
                good_ins.name = "good_" .. j
                GameSys.ButtonRegister(this.lua_script, good_ins, "click", ShopPanel.OnGoodClick, { j })
            end
        end
    end

end

function ShopPanel.OnGoodClick(obj, params)
    local index = params[1]
    this.cur_good_state = this.good_states[index]
    local asset = {}
    asset.type = this.good_states[index].type
    asset.value1 = this.good_states[index].value1
    asset.value2 = this.good_states[index].value2
    asset.value3 = this.good_states[index].value3

    local resource = {}
    resource.type = 1
    resource.value1 = this.good_states[index].price_value1
    resource.value2 = GameSys.GoodPrice(this.good_states[index], 1)
    resource.value3 = this.good_states[index].buy_num ~= 0 and ShopPanel.GoodsXgNum(this.good_states[index].id) or 100
    resource.value4 = this.good_states[index]
    local params = {BuyPanel.Type.buy ,asset, resource, ShopPanel.SureBuy}
    GUIRoot.ShowPanel("BuyPanel", params)
end

function ShopPanel.SureBuy(count)
    this.item_count_ = count
    this.cur_cost = this.cur_good_state.price_table ~= 0 and GameSys.GoodPrice(this.cur_good_state, count) or this.cur_good_state.price_value2 * count
    local money_enough = this.cur_cost <= GameSys.GetAssetCount(1, this.cur_good_state.price_value1)
    if not money_enough then
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
        return
    end
    if this.cur_good_state.type == 3 then
        local can_buy_count = GameSys.CanGetEquipNum()
        if count > can_buy_count then
            GUIRoot.ShowPanel("MessagePanel",  { "背包容量不足" })
            return
        end
    end

    local msg = promotion_msg_pb.cmsg_shop_buy()
    msg.id = this.cur_good_state.id
    msg.num = count
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_SHOP_BUY, data, { opcodes.SMSG_SHOP_BUY })
end

function ShopPanel.OnLottery(lottery_type, lottery_asset_type, lottery_num)
    --[[required int32 type                     = 1;
       tp 抽卡类型
       3 装备
       5 宝石
       6 宠物
   required int32 asset_type               = 2;
    asset_type 抽卡所用资源类型
       1 钻石
       2 相应的资源
   required int32 num                      = 3;
        num是数量
        只有1和10
    ]]--
    if lottery_type == 3 and GameSys.CanGetEquipNum() - lottery_num < 0 then
        GUIRoot.ShowPanel("MessagePanel", {"装备背包放不下了"})
        return
    end
    local msg = item_msg_pb.cmsg_draw_card()
    msg.type = lottery_type
    msg.asset_type = lottery_asset_type
    msg.num = lottery_num
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_DRAW_CARD, data, {opcodes.SMSG_DRAW_CARD}, "抽卡", 60)
end

function ShopPanel.RuneResourceDrawOne()
    if PlayerData.player.jewel >= Config.get_config_value("t_const", "rune_draw_crystal").value then
        this.draw_server_data = {5, 1, 1}
        ShopPanel.OnLottery(5,1, 1)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.RuneResourceDrawTen()
    if PlayerData.player.jewel >= Config.get_config_value("t_const", "rune_draw_crystal_10").value then
        this.draw_server_data = {5, 1, 10}
        ShopPanel.OnLottery(5,1, 10)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.RuneItemDraw(obj, params)
    local num = params[1]
    local draw_item_id = Config.get_config_value("t_const", "rune_draw_item").value
    if GameSys.GetAssetCount(2, draw_item_id) >= num then
        this.draw_server_data = {5, Config.get_config_value("t_const", "rune_draw_item").value, num}
        ShopPanel.OnLottery(5, 2, num)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.PetResourceDrawOne()
    if PlayerData.player.jewel >= Config.get_config_value("t_const", "pet_draw_crystal").value then
        this.draw_server_data = {6, 1, 1}
        ShopPanel.OnLottery(6,1, 1)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.PetResourceDrawTen()
    if PlayerData.player.jewel >= Config.get_config_value("t_const", "pet_draw_crystal_10").value then
        this.draw_server_data = {6, 1, 10}
        ShopPanel.OnLottery(6,1, 10)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.PetItemDraw(obj, params)
    local num = params[1]
    if GameSys.GetAssetCount(2, Config.get_config_value("t_const", "pet_draw_item").value) >= num then
        this.draw_server_data = {6, Config.get_config_value("t_const", "pet_draw_item").value, num}
        ShopPanel.OnLottery(6, 2, num)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.EquipResourceDrawOne()
    local t_equip_draw = Config.get_config_value("t_equip_draw", PlayerData.player.map == 0 and 1 or (PlayerData.player.map))
    if PlayerData.player.jewel >= t_equip_draw.jewel then
        this.draw_server_data = {3, 1, 1}
        ShopPanel.OnLottery(3,1, 1)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.EquipResourceDrawTen()
    local t_equip_draw = Config.get_config_value("t_equip_draw", PlayerData.player.map == 0 and 1 or (PlayerData.player.map))
    if PlayerData.player.jewel >= t_equip_draw.jewel10 then
        this.draw_server_data = {3, 1, 10}
        ShopPanel.OnLottery(3,1, 10)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.EquipItemDraw(obj, params)
    local num = params[1]
    local item_num = 0
    local t_equip_draw = Config.get_config_value("t_equip_draw", PlayerData.player.map == 0 and 1 or (PlayerData.player.map))
    if num == 1 then
        item_num = t_equip_draw.item
    else
        item_num = t_equip_draw.item10
    end
    if GameSys.GetAssetCount(2, Config.get_config_value("t_const", "equip_draw_item").value) >= item_num then
        this.draw_server_data = {3, Config.get_config_value("t_const", "equip_draw_item").value, num}
        ShopPanel.OnLottery(3, 2, num)
    else
        GUIRoot.ShowPanel("MessagePanel",  { "资源不足" })
    end
end

function ShopPanel.DrawDescPanelClose()
    this.ck_desc_panel_.gameObject:SetActive(false)
end

function ShopPanel.OpenCkDescPanel()
    this.ck_desc_panel_.gameObject:SetActive(true)
end

function ShopPanel.OnPetClick(obj, params)
    GUIRoot.ShowPanel("PetDetailPanel", {params[1], params[2]})
end

function ShopPanel.EquipSelect(obj)
    local equip = Config.get_config_value("t_equip", GameSys.GetEquipId(obj.name))
    local equip_info = PlayerData.equips[obj.name]
    GUIRoot.ShowPanel("EquipDetailPanel", {equip_info, equip.type, false})
end

function ShopPanel.FilpAllCard(obj)
    for i = 1, #this.draw_obj do
        if this.draw_obj[i].show == 0 then
            ShopPanel.FilpCard(this.draw_obj[i].obj.transform:Find("card_fz").gameObject, 0.5 + (i - 1) * 0.5, i)
        end
    end
end

function ShopPanel.OnFlipCardClick(obj, params)
    local parent = obj.transform.parent
    this.draw_obj[params[1]].show = 1
    ShopPanel.FilpCard(parent.gameObject, 0, params[1])
end

function ShopPanel.CloseSettlementPanel(obj)
    GameSys.ClearChild(this.settlement_group)
    UIEffect.Hide("card_god")
    UIEffect.Hide("card_bule")
    UIEffect.Hide("card_green")
    UIEffect.Hide("card_god_loop")
    UIEffect.Hide("card_blue_loop")
    UIEffect.Hide("card_green_loop")
    UIEffect.Hide("card_purple_loop")
    this.settlement_panel.gameObject:SetActive(false)
end

function ShopPanel.FilpCard(obj, time, index)
    timerMgr:AddTimer("ck_effect"..time, function ()
        local rawImage = nil
        if this.draw_obj[index].color > 1 then
            rawImage = this.draw_obj[index].obj.transform:Find("fp_effect"):GetComponent("RawImage")
            rawImage.texture = UIEffect.Camera.targetTexture
        end
        if rawImage ~= nil then
            local r = nil
            if this.draw_obj[index].color == 2 then
                r = UIEffect.Show("card_green")
            elseif this.draw_obj[index].color == 3 then
                r = UIEffect.Show("card_bule")
            elseif this.draw_obj[index].color == 4 then
                r = UIEffect.Show("card_purple")
            elseif this.draw_obj[index].color == 5 then
                r = UIEffect.Show("card_god")
            end
            if r ~= nil then
                rawImage.uvRect = r
                rawImage.gameObject:SetActive(true)
            end
        end
        obj:GetComponent("RectTransform"):DORotate(Vector3(0, 90, 0), 0.5):OnComplete(function ()
            obj.transform:GetChild(1).gameObject:SetActive(false)
            obj:GetComponent("RectTransform"):DORotate(Vector3(0, 0, 0), 0.5):OnComplete(function ()
                local r = nil
                if this.draw_obj[index].color == 2 then
                    UIEffect.Hide("card_green")
                    r = UIEffect.Show("card_green_loop")
                elseif this.draw_obj[index].color == 3 then
                    UIEffect.Hide("card_bule")
                    r = UIEffect.Show("card_blue_loop")
                elseif this.draw_obj[index].color == 4 then
                    UIEffect.Hide("card_purple")
                    r = UIEffect.Show("card_purple_loop")
                elseif this.draw_obj[index].color == 5 then
                    UIEffect.Hide("card_god")
                    r = UIEffect.Show("card_god_loop")
                end
                if r ~= nil then
                    rawImage.uvRect = r
                    rawImage.transform:SetSiblingIndex(0)
                end
            end)
            this.draw_obj[index].show = 1
            timerMgr:AddTimer("ck_effect_close", function ()
                ShopPanel.CheckClose()
            end, nil, 0.2)
        end)
    end, nil, time)
end

function ShopPanel.CheckClose()
    local show = true
    for i = 1, #this.draw_obj do
        if this.draw_obj[i].show == 0 then
            show = false
            break
        end
    end
    if show then
        this.settlement_group:GetComponent("Button").interactable = true
    end
end

function ShopPanel.SMSG_DRAW_CARD(message)
    local msg = item_msg_pb.smsg_draw_card()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets, false)
    --[[
     this.draw_server_data[1] = 抽卡类型
     this.draw_server_data[2] = 抽卡资源类型1 为钻石 其他为物品id
     this.draw_server_data[3] = 抽卡次数 1 和 10
    ]]--
    if this.draw_server_data[1] == 3 then
        local t_equip_draw = Config.get_config_value('t_equip_draw', PlayerData.player.map == 0 and 1 or PlayerData.player.map)
        local item_num
        if this.draw_server_data[2] ~= 1 then
            if this.draw_server_data[3] == 1 then
                item_num = t_equip_draw.item
            else
                item_num = t_equip_draw.item10
            end
            PlayerData.remove_item(this.draw_server_data[2], item_num)
        else
            local equip_draw_crystal
            if this.draw_server_data[3] == 1 then
                equip_draw_crystal = t_equip_draw.jewel
            else
                equip_draw_crystal = t_equip_draw.jewel10
            end
            PlayerData.add_resource(2, -equip_draw_crystal)

        end
    elseif this.draw_server_data[1] == 5 then
        if this.draw_server_data[2] ~= 1 then
            PlayerData.remove_item(this.draw_server_data[2], this.draw_server_data[3])
        else
            if this.draw_server_data[3] == 1 then
                PlayerData.add_resource(2, -Config.get_config_value("t_const", "rune_draw_crystal").value)
            else
                PlayerData.add_resource(2, -Config.get_config_value("t_const", "rune_draw_crystal_10").value)
            end
        end
    elseif this.draw_server_data[1] == 6 then
        if this.draw_server_data[2] ~= 1 then
            PlayerData.remove_item(this.draw_server_data[2], this.draw_server_data[3])
        else
            if this.draw_server_data[3] == 1 then
                PlayerData.add_resource(2, -Config.get_config_value("t_const", "pet_draw_crystal").value)
            else
                PlayerData.add_resource(2, -Config.get_config_value("t_const", "pet_draw_crystal_10").value)
            end
        end
    end

    local r = UIEffect.Show("cs_cf01")
    this.jvneng_image_.uvRect = r
    this.jvneng_image_.gameObject:SetActive(true)
    GUIRoot.ShowPanel("MaskPanel")
    timerMgr:AddTimer("ck_effect", function ()
        local show_index = 1
        this.settlement_group:GetComponent("Button").interactable = false
        Util.ClearChild(this.settlement_group)
        this.draw_obj = {}
        for i = 1, #msg.assets.pets do
            local asset = {
                ["type"] = 6,
                ["value1"] = msg.assets.pets[i].template_id,
                ["value2"] = 0,
                ["value3"] = 0
            }
            local t_pet = Config.get_config_value("t_pet", msg.assets.pets[i].template_id)
            local draw_fp = GameObject.Instantiate(this.ck_fp_.gameObject)
            draw_fp.transform:SetParent(this.settlement_group, true)
            draw_fp.transform:GetComponent("RectTransform").anchoredPosition = Vector2(0, -390)
            draw_fp:GetComponent("RectTransform"):DOLocalMoveX(this.ten_draw_pos[show_index][1] , 0.5 );
            draw_fp:GetComponent("RectTransform"):DOLocalMoveY(this.ten_draw_pos[show_index][2] + 586, 0.5 );
            draw_fp.transform:Find("card_fz/positive_image"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("cwck_fp_00"..t_pet.color)
            draw_fp.transform.localScale = Vector3.one
            local draw_sub = {}
            draw_sub.obj = draw_fp
            draw_sub.show = 0
            draw_sub.color = t_pet.color
            this.draw_obj[show_index] = draw_sub
            local click_obj = draw_fp.transform:Find("card_fz/back_image")
            click_obj.name = "ck_click"..show_index
            GameSys.ButtonRegister(this.lua_script, click_obj, "click", ShopPanel.OnFlipCardClick, {show_index})
            draw_fp.gameObject:SetActive(true)
            local item_t = CommonPanel.GetIcon2type(asset, { "pet_icon_btn" .. i, ShopPanel.OnPetClick, {msg.assets.pets[i].guid, asset.value1}}, this.lua_script)
            --local item_t = CommonPanel.GetIcon2type(msg.assets.pets[i], {}, this.lua_script)
            item_t.transform:SetParent(draw_fp.transform:Find("card_fz/positive_image/icon_root"), false)
            item_t.transform.localScale = Vector3.one
            item_t.transform.name = tostring(msg.assets.pets[i].value1)
            item_t.transform:Find("generic"):GetComponent("LocalizationText").text = GameSys.GetAssetName(asset)
            item_t.transform:Find("generic").gameObject:SetActive(true)
            show_index = show_index + 1
            item_t.gameObject:SetActive(true)
        end
        for i = 1, #msg.assets.assets do
            local draw_fp = GameObject.Instantiate(this.ck_fp_.gameObject)
            local color = GameSys.GetAssetColor(msg.assets.assets[i])
            draw_fp.transform:SetParent(this.settlement_group, true)
            draw_fp.transform:GetComponent("RectTransform").anchoredPosition = Vector2(0, -390)
            draw_fp:GetComponent("RectTransform"):DOLocalMoveX(this.ten_draw_pos[show_index][1] , 0.5 );
            draw_fp:GetComponent("RectTransform"):DOLocalMoveY(this.ten_draw_pos[show_index][2] + 586, 0.5 );
            draw_fp.transform:Find("card_fz/positive_image"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("cwck_fp_00"..color)
            draw_fp.transform.localScale = Vector3.one
            local draw_sub = {}
            draw_sub.obj = draw_fp
            draw_sub.show = 0
            draw_sub.color = color
            this.draw_obj[show_index] = draw_sub
            local click_obj = draw_fp.transform:Find("card_fz/back_image")
            click_obj.name = "ck_click"..show_index
            GameSys.ButtonRegister(this.lua_script, click_obj, "click", ShopPanel.OnFlipCardClick, {show_index})
            draw_fp.gameObject:SetActive(true)
            local item_t = CommonPanel.GetIcon2type(msg.assets.assets[i], {}, this.lua_script)
            item_t.transform:SetParent(draw_fp.transform:Find("card_fz/positive_image/icon_root"), false)
            item_t.transform.localScale = Vector3.one
            item_t.transform.name = tostring(msg.assets.assets[i].value1)
            item_t.transform:Find("generic"):GetComponent("LocalizationText").text = GameSys.GetAssetName(msg.assets.assets[i])
            item_t.transform:Find("generic").gameObject:SetActive(true)
            show_index = show_index + 1
            item_t.gameObject:SetActive(true)
        end

        for i = 1, #msg.assets.equips do
            local draw_fp = GameObject.Instantiate(this.ck_fp_.gameObject)
            draw_fp.transform:SetParent(this.settlement_group, true)
            draw_fp.transform:GetComponent("RectTransform").anchoredPosition = Vector2(0, -390)
            draw_fp:GetComponent("RectTransform"):DOLocalMoveX(this.ten_draw_pos[show_index][1] , 0.5 );
            draw_fp:GetComponent("RectTransform"):DOLocalMoveY(this.ten_draw_pos[show_index][2] + 586, 0.5 );
            draw_fp.transform:Find("card_fz/positive_image"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("cwck_fp_00"..msg.assets.equips[i].color)
            draw_fp.transform.localScale = Vector3.one
            local draw_sub = {}
            draw_sub.obj = draw_fp
            draw_sub.show = 0
            draw_sub.color = msg.assets.equips[i].color
            this.draw_obj[show_index] = draw_sub
            local click_obj = draw_fp.transform:Find("card_fz/back_image")
            click_obj.name = "ck_click"..show_index
            GameSys.ButtonRegister(this.lua_script, click_obj, "click", ShopPanel.OnFlipCardClick, {show_index})
            show_index = show_index + 1
            draw_fp.gameObject:SetActive(true)
            local t_equip = Config.get_config_value("t_equip", msg.assets.equips[i].template_id)
            local reward_ins = CommonPanel.GetEquipIcon(msg.assets.equips[i],{msg.assets.equips[i].guid, ShopPanel.EquipSelect, {3, t_equip.id}}, this.lua_script)
            reward_ins.transform:SetParent(draw_fp.transform:Find("card_fz/positive_image/icon_root"), false)
            reward_ins.transform.localScale = Vector3.one
            reward_ins.transform:Find("generic"):GetComponent("LocalizationText").text = GameSys.set_color(msg.assets.equips[i].color, GameSys.GetEquipLevelName(msg.assets.equips[i]))
            reward_ins.transform:Find("generic").gameObject:SetActive(true)
            reward_ins.gameObject:SetActive(true)
        end
        this.settlement_panel.gameObject:SetActive(true)
        GUIRoot.ClosePanel("MaskPanel")
        timerMgr:AddTimer("ck_effect_hide", function()
            UIEffect.Hide("cs_cf01")
            this.jvneng_image_.gameObject:SetActive(false)
        end, {} , 1)
    end , {}, 2.1)
end

function ShopPanel.BuyDone(message)
    local msg = promotion_msg_pb.smsg_shop_buy()
    msg:ParseFromString(message.luabuff)

    local t_shop = Config.get_config_value('t_shop', this.cur_good_state.id)
    if t_shop.shop_type == 1 or t_shop.price_table == 2 then
        local index = GameSys.getIndex(PlayerData.player.shop_ids, this.cur_good_state.id)
        if index == nil then
            table.insert(PlayerData.player.shop_ids, this.cur_good_state.id)
            table.insert(PlayerData.player.shop_nums, this.item_count_)
        else
            PlayerData.player.shop_nums[index] = PlayerData.player.shop_nums[index] + this.item_count_
        end
    end

    PlayerData.add_assets(msg.assets)
    PlayerData.add_resource(this.cur_good_state.price_value1, -this.cur_cost)
    ShopPanel.RefreshShopPanel()
end

function ShopPanel.RefreshDay()
    ShopPanel.RefreshShopPanel()
end

