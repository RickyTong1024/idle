CommonPanel = {}
CommonPanel.Control = {}
local this = CommonPanel.Control

function CommonPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.icon_prefab_root_ = this.transform_:Find("icon_prefab_root")
    this.panel_prefab_root_ = this.transform_:Find("panel_prefab_root")
    this.icon_list_ = {}
    this.panel_list_ = {}
    if (this.icon_prefab_root_.childCount > 0) then
        for i = 0, this.icon_prefab_root_.childCount - 1 do
            this.icon_list_[this.icon_prefab_root_:GetChild(i).name] = this.icon_prefab_root_:GetChild(i).gameObject
        end
    end
    if (this.panel_prefab_root_.childCount > 0) then
        for i = 0, this.panel_prefab_root_.childCount - 1 do
            this.panel_list_[this.panel_prefab_root_:GetChild(i).name] = this.panel_prefab_root_:GetChild(i).gameObject
        end
    end
    obj:SetActive(false)
end

function CommonPanel.OnDestroy()
    this = {}
end

function CommonPanel.GetIcon(icon_name, types, click_parm, icon, frame, num, lua_script_)
    if (this.icon_list_[icon_name] ~= nil) then
        local icon_res = GameObject.Instantiate(this.icon_list_[icon_name])
        local res_click = icon_res.transform:Find(click_parm[1])
        if types == "equip" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "equip"):GetSprite(icon)
            end
            icon_res.transform:Find("quality").gameObject:SetActive(false)
        elseif types == "item" or types == "resource" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "item"):GetSprite(icon)
            end
            if (num > 0) then
                icon_res.transform:Find("num"):GetComponent("Text").text = GameSys.unit_conversion(num)
                icon_res.transform:Find("num").gameObject:SetActive(true)
            end
            if (frame > 0) then
                icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(frame))
                icon_res.transform:Find("quality").gameObject:SetActive(true)
            end
        elseif types == "rune" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "rune"):GetSprite(icon)
            end
            if (num > 0) then
                icon_res.transform:Find("num"):GetComponent("Text").text = GameSys.unit_conversion(num)
                icon_res.transform:Find("num").gameObject:SetActive(true)
            end
            if (frame > 0) then
                icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(frame))
                icon_res.transform:Find("quality").gameObject:SetActive(true)
            end
        elseif types == "artifact" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "artifact"):GetSprite(icon)
            end
            icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(frame))
            icon_res.transform:Find("quality").gameObject:SetActive(true)
        elseif types == "pet" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "pet"):GetSprite(icon)
            end
            icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(frame))
            icon_res.transform:Find("quality").gameObject:SetActive(true)
        elseif types == "role" then
            res_click.name = click_parm[2]
            if icon ~= nil and icon ~= "" then
                res_click:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "monster"):GetSprite(icon)
            end
        end

        if #click_parm > 2 then
            res_click:GetComponent("Button").enabled = true
            GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", click_parm[3])
        else
            res_click:GetComponent("Button").enabled = false
        end
        icon_res:SetActive(true)
        return icon_res
    end
end

function CommonPanel.GetIcon2type(asset, click_parm, lua_script_)
    if (this.icon_list_["icon_res"] ~= nil) then
        local icon_res = GameObject.Instantiate(this.icon_list_["icon_res"])
        local res_click = icon_res.transform:Find("icon")
        if asset.type == 3 then
            local config_ = Config.get_config_value("t_equip", asset.value1)
            if config_ ~= nil then
                if config_.icon ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "equip"):GetSprite(config_.icon)
                    if sprite ~= nil then
                        res_click:GetComponent("Image").sprite = sprite
                    end
                end
                icon_res.transform:Find("quality").gameObject:SetActive(false)
                icon_res.transform:Find("no_quality").gameObject:SetActive(true)
            end
        elseif asset.type == 2 then
            local config_ = Config.get_config_value("t_item", asset.value1)
            if config_ ~= nil then
                if config_.type == 7001 then
                    icon_res.transform:Find("shard_image").gameObject:SetActive(true)
                    if config_.type == 7001 then
                        local pet_id = config_.res[1].value
                        local t_pet = Config.get_config_value("t_pet", pet_id)
                        local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "pet"):GetSprite(t_pet.icon)
                        if sprite ~= nil then
                            res_click:GetComponent("Image").sprite = sprite
                        end
                    end
                else
                    if config_.icon ~= "" then
                        local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "item"):GetSprite(config_.icon)
                        if sprite ~= nil then
                            res_click:GetComponent("Image").sprite = sprite
                        end
                    end
                end
                if (asset.value2 > 0) then
                    icon_res.transform:Find("num"):GetComponent("Text").text = tostring(GameSys.unit_conversion(asset.value2))
                    icon_res.transform:Find("num").gameObject:SetActive(true)
                end
                icon_res.transform:Find("quality").gameObject:SetActive(config_.color > 0)
                icon_res.transform:Find("no_quality").gameObject:SetActive(config_.color <= 0)
                if (config_.color > 0) then
                    icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(config_.color))
                end
            end
        elseif asset.type == 1 then
            local config_ = Config.get_config_value("t_resource", asset.value1)
            if config_ ~= nil then
                if config_.icon ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "resource"):GetSprite(config_.icon)
                    if sprite ~= nil then
                        res_click:GetComponent("Image").sprite = sprite
                    end
                end
                if (asset.value2 > 0) then
                    icon_res.transform:Find("num"):GetComponent("Text").text = tostring(GameSys.unit_conversion(asset.value2))
                    icon_res.transform:Find("num").gameObject:SetActive(true)
                end
                icon_res.transform:Find("quality").gameObject:SetActive(config_.color > 0)
                icon_res.transform:Find("no_quality").gameObject:SetActive(config_.color <= 0)
                if (config_.color > 0) then
                    icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(config_.color))
                end
            end
        elseif asset.type == 4 then
            local config_ = Config.get_config_value("t_artifact", asset.value1)
            if config_ ~= nil then
                if config_.icon ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "artifact"):GetSprite(config_.icon)
                    if sprite ~= nil then
                        res_click:GetComponent("Image").sprite = sprite
                    end
                end
                icon_res.transform:Find("quality").gameObject:SetActive(config_.color > 0)
                icon_res.transform:Find("no_quality").gameObject:SetActive(config_.color <= 0)
                if (config_.color > 0) then
                    icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(config_.color))
                end
            end
        elseif asset.type == 5 then
            local config_ = Config.get_config_value("t_rune", asset.value1)
            if config_ ~= nil then
                if config_.icon ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "rune"):GetSprite(config_.icon)
                    if sprite ~= nil then
                        res_click:GetComponent("Image").sprite = sprite
                    end
                end
                if (asset.value2 > 0) then
                    icon_res.transform:Find("num"):GetComponent("Text").text = tostring(asset.value2)
                    icon_res.transform:Find("num").gameObject:SetActive(true)
                end
                icon_res.transform:Find("quality").gameObject:SetActive(config_.color > 0)
                icon_res.transform:Find("no_quality").gameObject:SetActive(config_.color <= 0)
                if (config_.color > 0) then
                    icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(config_.color))
                end
            end
        elseif asset.type == 6 then
            local config_ = Config.get_config_value("t_pet", asset.value1)
            if config_ ~= nil then
                if config_.icon ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "pet"):GetSprite(config_.icon)
                    if sprite ~= nil then
                        res_click:GetComponent("Image").sprite = sprite
                    end
                end
                if (asset.value2 > 0) then
                    icon_res.transform:Find("num"):GetComponent("Text").text = tostring(GameSys.unit_conversion(asset.value2))
                    icon_res.transform:Find("num").gameObject:SetActive(true)
                end
                icon_res.transform:Find("quality").gameObject:SetActive(config_.color > 0)
                icon_res.transform:Find("no_quality").gameObject:SetActive(config_.color <= 0)
                if (config_.color > 0) then
                    icon_res.transform:Find("quality"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script_.gameObject.name, "quality"):GetSprite(GameSys.get_quality(config_.color))
                end
            end
        end
        if res_click == nil then
            res_click:GetComponent("Button").enabled = false
        end
        if click_parm == nil then
            click_parm = {}
        end
        if #click_parm >= 1 then
            res_click:GetComponent("Button").enabled = true
            res_click.name = click_parm[1]
            if click_parm[2] ~= nil then
                GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", click_parm[2], click_parm[3])
            else
                res_click.name = click_parm[1]
                if asset.type == 3 then
                    GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", CommonPanel.ShowCommonEquip, { asset.value1 })
                elseif asset.type == 4 then
                    GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", CommonPanel.ShowCommonArtifact, { asset.value1 })
                elseif asset.type == 6 then
                    GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", CommonPanel.ShowCommonPet, { asset.value1 })
                else
                    GameSys.ButtonRegister(lua_script_, res_click.gameObject, "click", CommonPanel.ShowCommonWindow, { asset })
                end
            end
        else
            res_click:GetComponent("Button").enabled = false
        end
        icon_res:SetActive(true)
        return icon_res
    end
end

---取得技能图标
function CommonPanel.GetSpellIcon(id, level, lua_script, click_params)
    local t_spell = Config.get_config_value("t_spell", id)
    local t_spell_level = Config.get_config_value("t_spell_level", level)
    return CommonPanel.GetTypeSpellICon(t_spell_level.color, t_spell.icon, lua_script, click_params)
end
---取得buff图标
function CommonPanel.GetBuffIcon(buff_id, level, lua_script, click_params)
    local t_buff = Config.get_config_value("t_spell_buff", buff_id)
    local t_spell_level = Config.get_config_value("t_spell_level", level)
    return CommonPanel.GetTypeSpellICon(t_spell_level.color, t_buff.icon, lua_script, click_params)
end
---取得被动图标
function CommonPanel.GetPassiveIcon(id, lua_script, click_params)
    local t_passive = Config.get_config_value("t_spell_passive", id)
    return CommonPanel.GetTypeSpellICon(t_passive.color, t_passive.icon, lua_script, click_params)
end

function CommonPanel.GetTypeSpellICon(color, icon_alias, lua_script, click_params)
    local icon_ins = GameObject.Instantiate(this.icon_list_["icon_res"])
    local icon = icon_ins.transform:Find("icon")
    local quality_icon = icon_ins.transform:Find("quality")

    quality_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "quality"):GetSprite(GameSys.get_quality(color))
    if icon_alias ~= "" then
        local sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "spell"):GetSprite(icon_alias)
        if sprite ~= nil then
            icon:GetComponent("Image").sprite = sprite
        end
    end
    if click_params == nil then
        icon:GetComponent("Button").enabled = false
    elseif next(click_params) ~= nil then
        icon:GetComponent("Button").enabled = true
        local btn_name = click_params[1]
        local func = click_params[2]
        local func_params = click_params[3]
        icon.gameObject.name = btn_name
        GameSys.ButtonRegister(lua_script, icon.gameObject, "click", func, func_params)
    end
    icon_ins:SetActive(true)
    return icon_ins
end

---取得技能碎片图标
function CommonPanel.GetSpellShardIcon(spell_id, lua_script)
    local t_spell = Config.get_config_value("t_spell", spell_id)
    if t_spell.unlock_type ~= 2 then
        return nil
    end
    local shard_id = t_spell.unlock[0].param1
    local asset = {
        type = 2,
        value1 = shard_id,
        value2 = 0,
        value3 = 0
    }
    local icon_ins = GameSys.GetAssetIcon(asset, lua_script)
    return icon_ins
end

---取得宠物天赋图标
function CommonPanel.GetPetTalentIcon(talent_id, lua_script, click_params)
    local t_talent = Config.get_config_value("t_pet_talent", talent_id)
    local color = t_talent.color
    local icon_alias = t_talent.icon

    local icon_ins = GameObject.Instantiate(this.icon_list_["icon_res"])
    local icon = icon_ins.transform:Find("icon")
    local quality_icon = icon_ins.transform:Find("quality")

    quality_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "quality"):GetSprite(GameSys.get_quality(color))
    if icon_alias ~= "" then
        local sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "talent"):GetSprite(icon_alias)
        if sprite ~= nil then
            icon:GetComponent("Image").sprite = sprite
        end
    end
    if click_params == nil then
        icon:GetComponent("Button").enabled = false
    elseif next(click_params) ~= nil then
        icon:GetComponent("Button").enabled = true
        local btn_name = click_params[1]
        local func = click_params[2]
        local func_params = click_params[3]
        icon.gameObject.name = btn_name
        GameSys.ButtonRegister(lua_script, icon.gameObject, "click", func, func_params)
    end
    icon_ins:SetActive(true)
    return icon_ins
end

---取得装备图标
function CommonPanel.GetEquipIcon(equip_info, click_params, lua_script)
    local asset = {
        type = 3,
        value1 = equip_info.template_id,
        value2 = 0,
        value3 = 0
    }
    local icon_ins = CommonPanel.GetIcon2type(asset, click_params, lua_script)
    local quality_icon = icon_ins.transform:Find("quality")
    quality_icon.gameObject:SetActive(true)
    local quality = equip_info.color
    quality_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "quality"):GetSprite(GameSys.get_quality(quality))
    if equip_info.enchant_id ~= 0 then
        local t_enchant = Config.get_config_value("t_equip_enchant", equip_info.enchant_id)
        local enchant_icon_alias = t_enchant.icon
        local enchant_image = icon_ins.transform:Find("enchant")
        enchant_image.gameObject:SetActive(true)
        if enchant_icon_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "equip"):GetSprite(enchant_icon_alias)
            if sprite ~= nil then
                enchant_image:GetComponent("Image").sprite = sprite
            end
        end
    end
    return icon_ins
end

---取得装备时装图标
function CommonPanel.GetDressEquipIcon(dress_id, color, click_params, lua_script)
    local asset = {
        type = 3,
        value1 = dress_id,
        value2 = 0,
        value3 = 0
    }
    local icon_ins = CommonPanel.GetIcon2type(asset, click_params, lua_script)
    local no_quality = icon_ins.transform:Find("no_quality")
    local quality_icon = icon_ins.transform:Find("quality")
    quality_icon.gameObject:SetActive(color > 0)
    no_quality.gameObject:SetActive(color <= 0)
    if color > 0 then
        local quality = color
        quality_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "quality"):GetSprite(GameSys.get_quality(quality))
    end
    return icon_ins
end

---取得附加槽子属性的装备图标
function CommonPanel.GetSlotEquipIcon(equip_info, enhance, runes, click_params, lua_script)
    local icon_ins = CommonPanel.GetEquipIcon(equip_info, click_params, lua_script)
    local runes_root = icon_ins.transform:Find("runes")
    local count = 0
    if runes ~= nil then
        for i = 1, #runes do
            local rune_id = runes[i]
            local icon = runes_root:GetChild(i - 1):GetComponent("Image")
            icon.gameObject:SetActive((rune_id ~= 0))
            if rune_id ~= 0 then
                local icon_alias = GameSys.GetRuneAlias(rune_id)
                if icon_alias ~= "" then
                    local sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "rune"):GetSprite(icon_alias)
                    if sprite ~= nil then
                        icon.sprite = sprite
                    end
                end
                count = count + 1
            end
        end
        runes_root.gameObject:SetActive((count > 0))
    end
    if enhance > 0 then
        local enhance_text = icon_ins.transform:Find("enhance")
        if enhance > 0 then
            enhance_text.gameObject:SetActive(true)
            enhance_text:GetComponent("Text").text = "+" .. enhance
        end
    end
    return icon_ins
end

---取得已有的宠物图标
function CommonPanel.GetPetIcon(pet_info, lua_script)
    local t_pet = Config.get_config_value("t_pet", pet_info.template_id)
    local asset = {
        type = 6,
        value1 = t_pet.id,
        value2 = 0,
        value3 = 0,
    }
    local icon_ins = GameSys.GetAssetIcon(asset, lua_script)
    local level_text = icon_ins.transform:Find("num")
    level_text:GetComponent("Text").text = "LV " .. pet_info.level
    icon_ins:SetActive(true)
    return icon_ins
end

---取得怪物的图标
function CommonPanel.GetMonsterIcon(lua_script, role_id, color)
    local icon_res = GameObject.Instantiate(this.icon_list_["icon_res"])
    icon_res:SetActive(true)
    local quality_icon = icon_res.transform:Find("quality")
    local icon = icon_res.transform:Find("icon")
    quality_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "quality"):GetSprite(GameSys.get_quality(color))
    local t_role = Config.get_config_value("t_role", role_id)
    icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "monster"):GetSprite(t_role.icon)
    return icon_res
end

---取得获得途径图标
function CommonPanel.GetGetIcon(lua_script, get_id)
    get_id = tonumber(get_id)
    local icon_res = GameObject.Instantiate(this.icon_list_["get_res"])
    icon_res:SetActive(true)
    local icon = icon_res.transform:Find("icon")
    local t_get = Config.get_config_value("t_get", get_id)
    local icon_alias = t_get.icon
    icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "get"):GetSprite(icon_alias)
    local text = icon_res.transform:Find("name_text")
    text.gameObject:SetActive(true)
    text:GetComponent("Text").text = t_get.name
    icon_res.name = lua_script.gameObject.name.."_".. get_id
    GameSys.ButtonRegister(lua_script, icon_res, "click", function() GameSys.PanelJump(get_id) end)
    return icon_res
end

function CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    if this.icon_list_["detail_change_slot"] == nil then
        return nil
    end
    local slot_ins = GameObject.Instantiate(this.icon_list_["detail_change_slot"])
    local name_text = slot_ins.transform:Find("text_root/name_text")
    local generic_text = slot_ins.transform:Find("text_root/generic_text")
    local desc_text = slot_ins.transform:Find("text_root/desc_text")
    local change_btn = slot_ins.transform:Find("change_btn")
    local line = slot_ins.transform:Find("line")
    name_text.gameObject:SetActive(desc_params[1] ~= nil and desc_params[1] ~= "")
    generic_text.gameObject:SetActive(desc_params[2] ~= nil and desc_params[2] ~= "")
    desc_text.gameObject:SetActive(desc_params[3] ~= nil and desc_params[3] ~= "")
    name_text:GetComponent("Text").text = desc_params[1]
    generic_text:GetComponent("Text").text = desc_params[2]
    desc_text:GetComponent("Text").text = desc_params[3]
    if change_params == nil then
        desc_text:GetComponent("RectTransform").sizeDelta = Vector2(377, 52)
        line:GetComponent("RectTransform").sizeDelta = Vector2(377, 2)
        change_btn.gameObject:SetActive(false)
    else
        change_btn.gameObject:SetActive(true)
        desc_text:GetComponent("RectTransform").sizeDelta = Vector2(264, 52)
        line:GetComponent("RectTransform").sizeDelta = Vector2(264, 2)
        local had_click = next(change_params) ~= nil
        if had_click then
            local desc_text = change_btn:Find("desc_text")
            local is_weared = change_params[1]
            local click_func = change_params[2]
            local click_params = change_params[3]
            local btn_name = change_params[4]
            if is_weared ~= nil then
                local btn_icon_alias = is_weared and "gjrui_007" or "gjrui_009"
                change_btn:GetComponent("Image").sprite = GameSys.GetCommonAtlas():GetSprite(btn_icon_alias)
                desc_text:GetComponent("Text").text = is_weared and GameSys.SetTextColor("#B6D5FC", "卸下") or GameSys.SetTextColor("#FCDFB6", "更换")
            end
            change_btn.gameObject.name = btn_name
            GameSys.ButtonRegister(lua_script, change_btn.gameObject, "click", click_func, click_params)
        end
    end
    slot_ins:SetActive(true)
    return slot_ins
end

---取得 技能 详情/更换 槽
function CommonPanel.GetSpellSlot(id, level, lua_script, change_params)
    local t_spell = Config.get_config_value("t_spell", id)
    local name_content = t_spell.name .. " Lv" .. level
    local color = Config.get_config_value("t_spell_level", level).color
    name_content = GameSys.set_color(color, name_content)
    local desc_content = GameSys.GetSpellOperateDesc(id)
    local desc_params = {
        name_content,
        "",
        GameSys.SetTextSize(20, desc_content),
    }
    local slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    local icon_root = slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    local icon_ins = CommonPanel.GetSpellIcon(id, level, lua_script)
    Util.SetRoot(icon_ins.transform, icon_root)
    return slot_ins
end

---取得被动更换槽
function CommonPanel.GetPassiveSlot(id, lua_script, change_params)
    local t_passive = Config.get_config_value("t_spell_passive", id)
    local generic_text = ""
    local desc = GameSys.GetPassiveDesc(id)
    local name = GameSys.set_color(t_passive.color, t_passive.name)
    local desc_params = {
        name,
        generic_text,
        GameSys.SetTextSize(20, desc)
    }
    local slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    local icon_root = slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    local icon_ins = CommonPanel.GetPassiveIcon(id, lua_script)
    Util.SetRoot(icon_ins.transform, icon_root)
    return slot_ins
end

---取得宝石更换槽
function CommonPanel.GetRuneChangeSlot(id, lua_script, change_params)
    local t_rune = Config.get_config_value("t_rune", id)
    local rune_attr = t_rune.attr_id
    local rune_attr_value = GameSys.ConversionAttr(t_rune.attr_id, t_rune.attr_value)
    local attr_content = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(rune_attr), rune_attr_value)
    local name = GameSys.set_color(t_rune.color, t_rune.name)
    local desc_params = {
        name,
        attr_content
    }
    local slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    local icon_root = slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    local asset = {
        type = 5,
        value1 = id,
        value2 = 0,
        value3 = 0
    }
    local icon_ins = CommonPanel.GetIcon2type(asset, {}, lua_script)
    Util.SetRoot(icon_ins.transform, icon_root)
    return slot_ins
end

---取得宠物更换槽
function CommonPanel.GetPetChangeSlot(pet_info, lua_script, change_params)
    if this.icon_list_["change_pet_slot"] == nil then
        return nil
    end
    local t_pet = Config.get_config_value("t_pet", pet_info.template_id)
    if t_pet == nil then
        return nil
    end
    local slot_ins = GameObject.Instantiate(this.icon_list_["change_pet_slot"])
    local change_pet_slot_root = slot_ins.transform:Find("change_pet_slot_root")
    local exp_slider = slot_ins.transform:Find("exp_slider"):GetComponent("Slider")
    local exp_text = slot_ins.transform:Find("exp_slider/exp_text")
    Util.ClearChild(change_pet_slot_root)
    local name = GameSys.set_color(t_pet.color, t_pet.name)
    local desc_params = {
        name,
        "LV " .. pet_info.level
    }
    local change_slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    if change_slot_ins ~= nil then
        Util.SetRoot(change_slot_ins.transform, change_pet_slot_root)
    end
    local icon_root = change_slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    local icon_ins = CommonPanel.GetPetIcon(pet_info, lua_script)
    Util.SetRoot(icon_ins.transform, icon_root)
    local cur_exp = pet_info.exp
    local t_pet_level = Config.get_config_value("t_level", pet_info.level + 1)
    local is_max_level = t_pet_level == nil
    if is_max_level then
        exp_slider.maxValue = 1
        exp_slider.value = 1
        exp_text:GetComponent("Text").text = "Max"
    else
        local need_exp = t_pet_level.exp
        exp_slider.maxValue = need_exp
        exp_slider.value = cur_exp
        exp_text:GetComponent("Text").text = string.format("%d/%d", cur_exp, need_exp)
    end
    slot_ins:SetActive(true)
    return slot_ins
end

---取得装备更换槽
function CommonPanel.GetEquipChangeSlot(equip_info, lua_script, change_params)
    local icon_ins = CommonPanel.GetEquipIcon(equip_info, {}, lua_script, false)
    local name = GameSys.GetEquipLevelName(equip_info)
    local name_color = GameSys.set_color(equip_info.color, name)
    local base_attr = GameSys.GetEquipBaseAttr(equip_info, 0)
    local attr_name = GameSys.GetAttrNameText(base_attr.t_attr.id)
    local attr_value = GameSys.GetAttrValueText(base_attr.t_attr.id, base_attr.total_value)
    local desc_1 = attr_name .. " " .. attr_value
    desc_1 = GameSys.SetTextSize(20, desc_1)
    local base_power = GameSys.GetEquipPower(equip_info)
    local equip_type = GameSys.GetEquipType(equip_info)
    local slot_guid = PlayerData.player.equip_slots[equip_type]
    local slot_equip = PlayerData.equips[slot_guid]
    local over_power = true
    if slot_equip ~= nil then
        local power = GameSys.GetEquipPower(slot_equip)
        over_power = base_power > power
    else
        over_power = true
    end
    local red_point = icon_ins.transform:Find("red_point")
    red_point.gameObject:SetActive(over_power)
    local desc_2 = "强度 "..base_power
    desc_2 = GameSys.SetTextSize(20, desc_2)
    local desc_params = {
        name_color,
        desc_2,
        desc_1
    }
    local slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    local icon_root = slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    Util.SetRoot(icon_ins.transform, icon_root)
    return slot_ins
end

---取得时装更换槽
function CommonPanel.GetDressChangeSlot(dress_id, color, lua_script, change_params)
    local icon_ins = CommonPanel.GetDressEquipIcon(dress_id, color, {}, lua_script)
    local t_equip = Config.get_config_value("t_equip", dress_id)
    local name = GameSys.set_color(color, t_equip.name)
    local desc_params = {
        name
    }
    local slot_ins = CommonPanel.GetChangeSlot(lua_script, desc_params, change_params)
    local icon_root = slot_ins.transform:Find("icon_root")
    Util.ClearChild(icon_root)
    Util.SetRoot(icon_ins.transform, icon_root)
    return slot_ins
end

function CommonPanel.ShowCommonWindow(obj, params)
    local asset = params[1]
    GUIRoot.ShowPanel("AssetWindowPanel", { AssetWindowPanel.SHOW_TYPE.show, asset })
end

function CommonPanel.ShowCommonEquip(obj, params)
    local t_equip_id = params[1]
    local t_equip = Config.get_config_value("t_equip", t_equip_id)
    GUIRoot.ShowPanel("DressDetailPanel", { t_equip })
end

function CommonPanel.ShowCommonPet(obj, params)
    local pet_id = params[1]
    local had_pet, guid = GameSys.HadPet(pet_id)
    GUIRoot.ShowPanel("PetDetailPanel", { guid, pet_id })
end

function CommonPanel.ShowCommonArtifact(obj, params)
    local artifact_id = params[1]
    local t_artifact = Config.get_config_value("t_artifact", artifact_id)
    GUIRoot.ShowPanel("ArtifactDetailPanel", { t_artifact })
end

function CommonPanel.GetCommonPanel(panel_name)
    if this.panel_list_[panel_name] == nil then
        return nil
    end
    local panel_prefab = this.panel_list_[panel_name]
    return panel_prefab
end

function CommonPanel.GetInfoPanel(type, params, lua_script)
    if this.panel_list_.info == nil then
        return nil
    end
    local info = this.panel_list_.info
    local info_prefab = GameObject.Instantiate(info)
    info_prefab.gameObject:SetActive(true)
    local icon_root = info_prefab.transform:Find("icon_root")
    local name_text = info_prefab.transform:Find("name_text"):GetComponent("Text")
    local desc_text = info_prefab.transform:Find("desc_text"):GetComponent("Text")
    local weared_image = info_prefab.transform:Find("is_weared_image")
    local weared_text = info_prefab.transform:Find("is_weared_image/Text"):GetComponent("Text")
    local color = 1
    Util.ClearChild(icon_root)
    if type == "equip" then
        local equip_info = params[1]
        color = equip_info.color
        local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
        local icon_ins = CommonPanel.GetEquipIcon(equip_info, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local name = GameSys.GetEquipLevelName(equip_info)
        local name_color = GameSys.set_color(color, name)
        name_text.text = name_color
        desc_text.text = GameSys.GetEquipWearDesc(t_equip)
        weared_image.gameObject:SetActive(false)
    elseif type == "slot_equip" then
        local equip_info = params[1]
        local enhance = params[2]
        local runes = params[3]
        color = equip_info.color
        local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
        local icon_ins = CommonPanel.GetSlotEquipIcon(equip_info, enhance, runes, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local name = GameSys.GetEquipLevelName(equip_info)
        if enhance > 0 then
            name = string.format("%s+%d", name, enhance)
        end
        name = GameSys.set_color(color, name)
        name_text.text = name
        desc_text.text = GameSys.GetEquipWearDesc(t_equip)
        local is_self = GameSys.HadEquip(equip_info.guid)
        if is_self then
            weared_image.gameObject:SetActive(true)
            weared_text:GetComponent("Text").text = "已装备"
        else
            weared_image.gameObject:SetActive(false)
        end
    elseif type == "dress_equip" then
        local t_equip = params[1]
        local equip_color = params[2]
        color = equip_color
        local icon_ins = CommonPanel.GetDressEquipIcon(t_equip.id, color, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local name = t_equip.name
        name = GameSys.set_color(color, name)
        name_text.text = name
        desc_text.text = GameSys.GetEquipWearDesc(t_equip)
        weared_image.gameObject:SetActive(false)
    elseif type == "artifact" then
        local t_artifact = params[1]
        color = t_artifact.color
        local asset = {
            type = 4,
            value1 = t_artifact.id,
            value2 = 0,
            value3 = 0
        }
        local icon_ins = CommonPanel.GetIcon2type(asset, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local name = t_artifact.name
        name = GameSys.set_color(color, name)
        name_text.text = name
        desc_text.text = t_artifact.desc
        weared_image.gameObject:SetActive(false)
    elseif type == "pet" then
        local pet_info = params[1]
        local pet_id = params[2]
        local t_pet = Config.get_config_value("t_pet", pet_id)
        color = t_pet.color
        local asset = {
            type = 6,
            value1 = pet_id,
            value2 = 0,
            value3 = 0
        }
        local icon_ins = CommonPanel.GetIcon2type(asset, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local level = pet_info ~= nil and pet_info.level or 1
        local enhance = pet_info ~= nil and pet_info.enhance or 0
        local name = enhance == 0 and t_pet.name or t_pet.name .. "+" .. enhance
        name = GameSys.set_color(t_pet.color, t_pet.name)
        name_text.text = name
        local t_pet_enhance = Config.get_config_value("t_pet_enhance", enhance)
        local t_next_enhance = Config.get_config_value("t_pet_enhance", enhance + 1)
        local max_enhance = t_next_enhance == nil
        if not max_enhance then
            desc_text.text = string.format("LV %d/%d", level, t_next_enhance.level)
        else
            desc_text.text = string.format("LV %d/%d", level, t_pet_enhance.level)
        end
        if pet_info ~= nil then
            local had_weared = GameSys.IsPetWeared(pet_info.guid)
            weared_image.gameObject:SetActive(had_weared)
            if had_weared then
                weared_text:GetComponent("Text").text = "已上阵"
            end
        else
            weared_image.gameObject:SetActive(false)
        end
    elseif type == "monster" then
        local role_id = params[1]
        local level = params[2]
        color = params[3]
        local t_role = Config.get_config_value("t_role", role_id)
        local icon_ins = CommonPanel.GetMonsterIcon(lua_script, t_role.id, color)
        Util.SetRoot(icon_ins.transform, icon_root)
        local name = t_role.name
        name_text.text = GameSys.set_color(color, name)
        desc_text.text = string.format("LV %d", level)
        weared_image.gameObject:SetActive(false)
    elseif type == "asset" then
        local asset = params[1]
        if asset.type == 3 or asset.type == 4 then
            return info_prefab, 176
        end
        local icon_ins = CommonPanel.GetIcon2type(asset, nil, lua_script)
        Util.SetRoot(icon_ins.transform, icon_root)
        local config = GameSys.GetAssetConfig(asset)
        color = config.color
        name_text.text = GameSys.set_color(color, config.name)
        desc_text.text = ""
        weared_image.gameObject:SetActive(false)
    elseif type == "spell" then
        local t_spell = params[1]
        local level = params[2]
        local icon_ins = CommonPanel.GetSpellIcon(t_spell.id, level, lua_script, nil)
        Util.SetRoot(icon_ins.transform, icon_root)
        local t_spell_level = Config.get_config_value("t_spell_level", level)
        color = t_spell_level.color
        name_text.text = GameSys.set_color(color, t_spell.name)
        local sing_time = t_spell.sing_time / 1000
        local cd_time = t_spell.cold_time / 1000
        local sp = t_spell.sp
        local cd_content = ""
        if cd_time > 0 then
            cd_content = string.format("%s %s%s", "冷却时间", tostring(cd_time), "秒")
        else
            cd_content = string.format("%s %s", "冷却时间", "无")
        end
        local t_class = Config.get_config_value("t_class", PlayerData.player.role_id)
        local sing_content = ""
        if sing_time > 0 then
            sing_content = string.format("%s%s %s%s", t_class.sing, "时间", tostring(sing_time), "秒")
        else
            sing_content = string.format("%s%s %s", t_class.sing, "时间", "瞬发")
        end
        local sp_content = ""
        if sp ~= 0 then
            local pre = ""
            if sp < 0 then
                pre = "消耗"
            else
                pre = "产生"
            end
            sp_content = string.format("%s%s:%s%s", pre, t_class.sp, tostring(math.abs(sp)), "点")
        else
            sp_content = string.format("%s%s:%s%s", "产生", t_class.sp, tostring(math.abs(sp)), "点")
        end
        desc_text.text = "LV " .. level .. "\n" .. cd_content .. "\n" .. sing_content .. "\n" .. sp_content
        weared_image.gameObject:SetActive(true)
        weared_text:GetComponent("Text").text = "已掌握"
    elseif type == "passive" then
        local t_passive = params[1]
        color = t_passive.color
        local icon_ins = CommonPanel.GetPassiveIcon(t_passive.id, lua_script, nil)
        Util.SetRoot(icon_ins.transform, icon_root)
        name_text.text = GameSys.set_color(color, t_passive.name)
        desc_text.text = ""
        local is_weared = GameSys.IsPassiveWeared(t_passive.id)
        weared_image.gameObject:SetActive(is_weared)
        if is_weared then
            weared_text:GetComponent("Text").text = "已佩戴"
        end
    end
    if desc_text.text == "" then
        desc_text.gameObject:SetActive(false)
    end
    local total_height = 0
    local info_rect = info_prefab.transform:GetComponent("RectTransform")
    if desc_text.gameObject.activeSelf then
        local desc_rect = desc_text.transform:GetComponent("RectTransform")
        local desc_text_height = LayoutUtility.GetPreferredHeight(desc_rect)
        local point_y = desc_rect.anchoredPosition.y
        total_height = desc_text_height + math.abs(point_y)
    else
        local icon_height = icon_root.sizeDelta.y
        total_height = math.abs(icon_root.anchoredPosition.y) + icon_height / 2
    end
    info_rect.sizeDelta = Vector2(info_rect.sizeDelta.x, total_height)
    return info_prefab, total_height
end

function CommonPanel.SetInfoPos(info_ins, root, height)
    if root ~= nil then
        Util.ClearChild(root)
        root.sizeDelta = Vector2(root.sizeDelta.x, height)
        info_ins.transform:SetParent(root, false)
    end
end

---设置装备简介面板
function CommonPanel.SetEquipInfoPanel(equip_info, lua_script, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("equip", { equip_info }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置槽子上的装备的简介面板
function CommonPanel.SetSlotEquipInfoPanel(equip_info, enhance, runes, lua_script, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("slot_equip", { equip_info, enhance, runes }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置外观装备简介面板
function CommonPanel.SetDressEquipInfoPanel(t_equip, color, lua_script, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("dress_equip", { t_equip, color }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end
---设置神器简介面板
function CommonPanel.SetArtifactInfoPanel(t_artifact, lua_script, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("artifact", { t_artifact }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置 宠物简介面板
function CommonPanel.SetPetInfoPanel(pet_info, pet_id, lua_script, root)
    if this.panel_list_.pet_info == nil then
        return nil
    end
    local info = this.panel_list_.pet_info
    local info_prefab = GameObject.Instantiate(info)
    info_prefab.gameObject:SetActive(true)
    local info_root = info_prefab.transform:Find("info_root")
    local exp_slider = info_prefab.transform:Find("exp_slider")
    local panel_prefab, height = CommonPanel.GetInfoPanel("pet", { pet_info, pet_id }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, info_root, height)
    CommonPanel.SetPetInfoExpSlider(exp_slider, pet_info)
    exp_slider.anchoredPosition = Vector2(exp_slider.anchoredPosition.x, 0 - height - 15)
    CommonPanel.SetInfoPos(info_prefab, root, (height + 15 + exp_slider.sizeDelta.y))
    return info_prefab
end

function CommonPanel.SetPetInfoExpSlider(exp_slider, pet_info)
    local slider = exp_slider:GetComponent("Slider")
    local exp_text = exp_slider:Find("exp_text")
    local level = 1
    local cur_exp = 0
    local need_exp = 0
    if pet_info ~= nil then
        level = pet_info.level
        cur_exp = pet_info.exp
    end
    local t_next_level = Config.get_config_value("t_level", level + 1)
    local is_max_level = t_next_level == nil

    if is_max_level then
        need_exp = 1
        cur_exp = 1
        exp_text:GetComponent("Text").text = "Max"
    else
        need_exp = t_next_level.pet_exp
        exp_text:GetComponent("Text").text = string.format("%s/%s", GameSys.unit_conversion(cur_exp), GameSys.unit_conversion(need_exp))
    end
    slider.maxValue = need_exp
    slider.value = cur_exp
end

---设置怪物简介面板
function CommonPanel.SetMonsterInfoPanel(lua_script, role_id, level, color, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("monster", { role_id, level, color }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置Asset面板
function CommonPanel.SetAssetInfoPanel(lua_script, asset, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("asset", { asset }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置Spell面板
function CommonPanel.SetSpellInfoPanel(lua_script, t_spell, level, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("spell", { t_spell, level }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---设置Passive面板
function CommonPanel.SetPassiveInfoPanel(lua_script, t_passive, root)
    local panel_prefab, height = CommonPanel.GetInfoPanel("passive", { t_passive }, lua_script)
    CommonPanel.SetInfoPos(panel_prefab, root, height)
    return panel_prefab
end

---取得属性文本预设
function CommonPanel.GetAttrText(attr_id, attr_value, type, color)
    if this.icon_list_["attr_text"] == nil then
        return nil
    end
    local attr_text_ins = GameObject.Instantiate(this.icon_list_["attr_text"])
    attr_text_ins:SetActive(true)
    local text = attr_text_ins.transform:Find("attr_desc_text"):GetComponent("Text")
    local rect = text.transform:GetComponent("RectTransform")
    if type == 0 then
        rect.pivot = Vector2(0, 0.5)
        rect.anchoredPosition = Vector2(-100, 0)
    elseif type == 1 then
        rect.pivot = Vector2(0.5, 0.5)
        rect.anchoredPosition = Vector2(0, 0)
    end
    if attr_id ~= nil and attr_value ~= nil then
        local text = attr_text_ins.transform:Find("attr_desc_text"):GetComponent("Text")
        attr_value = GameSys.ConversionAttr(attr_id, attr_value)
        local content = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(attr_id), tostring(attr_value))
        if color ~= nil then
            content = GameSys.set_color(color, content)
        end
        text.text = content
    end
    return attr_text_ins
end

---取得装备主属性的文本
function CommonPanel.GetEquipBaseAttrText(attr, per, enhance, color, width)
    if this.icon_list_["equip_attr_text"] == nil then
        return nil
    end
    local attr_text_ins = GameObject.Instantiate(this.icon_list_["equip_attr_text"])
    attr_text_ins:SetActive(true)
    local attr_value_text = attr_text_ins.transform:Find("attr_value_text")
    local percent_text = attr_text_ins.transform:Find("percent_text")
    local attr_id = attr.t_attr.id
    local base_attr = attr.value
    local enhance_attr = attr.enhance_value
    local total_attr = attr.total_value
    local conversion_value = GameSys.ConversionAttr(attr_id, total_attr)
    local str1 = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(attr_id), conversion_value)
    local attr_content = ""
    if enhance > 0 then
        attr_content = string.format("%s(%s+%s)", str1, GameSys.GetAttrValueText(attr_id, base_attr), GameSys.GetAttrValueText(attr_id, enhance_attr))
    else
        attr_content = string.format("%s", str1)
    end
    if color ~= nil then
        attr_content = GameSys.set_color(color, attr_content)
    end
    attr_value_text:GetComponent("Text").text = attr_content
    if per ~= nil then
        local per_text = string.format("%d%%", math.ceil(per))
        local per_color = math.ceil(per / 20)
        percent_text:GetComponent("Text").text = GameSys.set_color(per_color, per_text)
    else
        percent_text:GetComponent("Text").text = ""
    end
    if width ~= nil then
        local rect = attr_text_ins.transform:GetComponent("RectTransform")
        rect.sizeDelta = Vector2(width, rect.sizeDelta.y)
    end
    return attr_text_ins
end

---取得装备随机属性文本
function CommonPanel.GetEquipRandomAttrText(reforge_state, per, enhance, color, width)
    if this.icon_list_["equip_attr_text"] == nil then
        return nil
    end
    local attr_text_ins = GameObject.Instantiate(this.icon_list_["equip_attr_text"])
    attr_text_ins:SetActive(true)
    local attr_value_text = attr_text_ins.transform:Find("attr_value_text")
    local percent_text = attr_text_ins.transform:Find("percent_text")
    local attr_type = reforge_state.attr_type
    local attr_id = 0
    if attr_type == 1 then
        attr_id = reforge_state.t_attr.id
    end
    local spell_id = reforge_state.spell_id
    local base_attr = reforge_state.value
    local enhance_attr = reforge_state.enhance_value
    local total_attr = reforge_state.total_value
    local attr_content = ""
    if attr_type == 1 then
        local conversion_value = GameSys.ConversionAttr(attr_id, total_attr)
        local str1 = GameSys.TextDealPlaceholder(GameSys.GetAttributeText(attr_id), conversion_value)
        if enhance > 0 and not GameSys.IsPerAttr(attr_id) then
            attr_content = string.format("%s(%s+%s)", str1, GameSys.GetAttrValueText(attr_id, base_attr), GameSys.GetAttrValueText(attr_id, enhance_attr))
        else
            attr_content = string.format("%s", str1)
        end
    else
        local t_spell = Config.get_config_value("t_spell", spell_id)
        local name = t_spell.name
        attr_content = string.format("%s 等级+%d", name, base_attr)
    end
    if color ~= nil then
        attr_content = GameSys.set_color(color, attr_content)
    end
    attr_value_text:GetComponent("Text").text = attr_content
    if per ~= nil then
        local per_text = string.format("%d%%", math.ceil(per))
        local per_color = math.ceil(per / 20)
        percent_text:GetComponent("Text").text = GameSys.set_color(per_color, per_text)
    else
        percent_text:GetComponent("Text").text = ""
    end
    if width ~= nil then
        local rect = attr_text_ins.transform:GetComponent("RectTransform")
        rect.sizeDelta = Vector2(width, rect.sizeDelta.y)
    end
    return attr_text_ins
end

---取得解锁材料图标
function CommonPanel.GetMatRect(asset, need_num, mat_icon_name, lua_script, is_self)
    if this.icon_list_["mat_rect"] == nil then
        return nil
    end
    if is_self == nil then
        is_self = true
    end
    local mat_rect_ins = GameObject.Instantiate(this.icon_list_["mat_rect"])
    mat_rect_ins:SetActive(true)

    local shard_icon_root = mat_rect_ins.transform:Find("shard_icon_root")
    local name_text = mat_rect_ins.transform:Find("name_text")
    local num_title = mat_rect_ins.transform:Find("num_title")
    local num_text = mat_rect_ins.transform:Find("num_title/num_text")

    local icon_ins = CommonPanel.GetIcon2type(asset, { mat_icon_name }, lua_script)
    Util.ClearChild(shard_icon_root)
    Util.SetRoot(icon_ins.transform, shard_icon_root)

    if asset.type == 2 then
        num_title:GetComponent("Text").text = "数量:"
        local t_item = Config.get_config_value("t_item", asset.value1)
        name_text:GetComponent("Text").text = t_item.name
        local num_content = ""
        if is_self then
            local cur_num = GameSys.GetItemCount(asset.value1)
            num_content = GameSys.MatEnoughColor(GameSys.unit_conversion(cur_num), (cur_num >= need_num))
            num_content = string.format("%s/%s", num_content, GameSys.unit_conversion(need_num))
        else
            num_content = GameSys.unit_conversion(need_num)
        end
        num_text:GetComponent("Text").text = num_content
    elseif asset.type == 5 then
        num_title:GetComponent("Text").text = "数量:"
        local t_rune = Config.get_config_value("t_rune", asset.value1)
        name_text:GetComponent("Text").text = t_rune.name
        local cur_num = GameSys.GetRuneCount(asset.value1)
        local num_content = GameSys.MatEnoughColor(GameSys.unit_conversion(cur_num), (cur_num >= need_num))
        num_content = string.format("%s/%s", num_content, GameSys.unit_conversion(need_num))
        num_text:GetComponent("Text").text = num_content
    elseif asset.type == 6 then
        num_title:GetComponent("Text").text = "需等级:"
        local t_pet = Config.get_config_value("t_pet", asset.value1)
        name_text:GetComponent("Text").text = t_pet.name
        local num_content = ""
        if is_self then
            local had, pet_guid = GameSys.HadPet(asset.value1)
            local level = 0
            if had then
                level = PlayerData.pets[pet_guid].level
            end
            num_content = GameSys.MatEnoughColor(GameSys.unit_conversion(level), (level >= need_num))
            num_content = string.format("%s/%s", num_content, GameSys.unit_conversion(need_num))
        else
            num_content = GameSys.unit_conversion(need_num)
        end
        num_text:GetComponent("Text").text = num_content
    end
    mat_rect_ins:SetActive(true)
    return mat_rect_ins
end
---取得玩家头像
function CommonPanel.GetPlayerIcon(avatar_id, lua_script, click_params)
    if this.icon_list_["player_icon"] == nil then
        return nil
    end
    local player_icon_ins = GameObject.Instantiate(this.icon_list_["player_icon"])
    player_icon_ins:SetActive(true)

    local player_icon = player_icon_ins.transform:Find("icon_back/icon")
    if avatar_id == 0 then
        avatar_id = 1
    end
    local t_avatar = Config.get_config_value("t_avatar", avatar_id)
    if t_avatar.res ~= "" then
        local sprite = GUIRoot.LoadAtlas(lua_script.gameObject.name, "avatar"):GetSprite(t_avatar.res)
        if sprite ~= nil then
            player_icon:GetComponent("Image").sprite = sprite
        end
    end
    local btn = player_icon_ins:GetComponent("Button")
    if click_params == nil then
        btn.interactable = false
    else
        btn.interactable = true
        player_icon_ins.name = click_params[1]
        GameSys.ButtonRegister(lua_script, player_icon_ins, "click", click_params[2], click_params[3])
    end
    return player_icon_ins
end
---声望解锁slot
function CommonPanel.GetReputationUnlockSlot(title, reputation_num, had_get)
    if this.icon_list_["reputation_unlock_slot"] == nil then
        return nil
    end
    local slot_ins = GameObject.Instantiate(this.icon_list_["reputation_unlock_slot"])
    slot_ins:SetActive(true)
    if title ~= nil and reputation_num ~= nil then
        CommonPanel.SetReputationUnlockSlot(slot_ins.transform, title, reputation_num, had_get)
    end
    return slot_ins
end

function CommonPanel.SetReputationUnlockSlot(slot, title, reputation_num, had_get)
    local header_text = slot:Find("header_text")
    local reputation_text = slot:Find("header_text/reputation_text")
    header_text:GetComponent("Text").text = title
    reputation_text:GetComponent("Text").text = " x" .. reputation_num
    local color_str = had_get and GameSys.GetNormalColor() or GameSys.GetLockColor()
    local b, color = ColorUtility.TryParseHtmlString(color_str, nil)
    header_text:GetComponent("Text").color = color
    reputation_text:GetComponent("Text").color = color
end
