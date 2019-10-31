GameSys = {}

----------------------------icon相关----------------------------
function GameSys.GetCommonAtlas()
    return resMgr.LoadCommonAtlas()
end

function GameSys.get_quality(type)
    local t_color = Config.get_config_value("t_color", type)
    return t_color.icon
end

function GameSys.get_quality_2(type)
    local t_color = Config.get_config_value("t_color", type)
    return t_color.icon2
end

function GameSys.get_quality_effect(type)
    local t_color = Config.get_config_value("t_color", type)
    return t_color.effect
end

function GameSys.GetEquipSlotQuality(type)
    local t_color = Config.get_config_value("t_color", type)
    return t_color.icon3
end

---取得宝石的小图标
function GameSys.GetRuneAlias(rune_id)
    local t_rune = Config.get_config_value("t_rune", rune_id)
    return t_rune.icon1
end

---获取资源的图标 （不能点击）
function GameSys.GetAssetIcon(assets, lua_script)
    local icon_res = nil
    icon_res = CommonPanel.GetIcon2type(assets, {}, lua_script)
    return icon_res
end

---获取未解锁按钮icon_alias
function GameSys.GetLockBtnIconAlias()
    return "gjrui_011_f"
end

---取得解锁按钮icon_alias
function GameSys.GetUnlockBtnIconAlias()
    return "gjrui_007"
end

---取得升级按钮icon_alias
function GameSys.GetUpgradekBtnIconAlias()
    return "gjrui_009"
end

---???
function GameSys.ShowAssets(assets, lua_script)
    local assets_ = {}
    for i = 1, #assets.assets do
        if assets.assets[i].type == 1 then
            -- 资源图标
            local item_config = Config.get_config_value("t_resource", assets.assets[i].value1)
            local icon_res = CommonPanel.GetIcon("icon_res", "resource", { "icon", item_config.id }, item_config.icon, item_config.color, assets.assets[i].value2, lua_script)
            table.insert(assets_, icon_res)
        elseif assets.assets[i].type == 2 then
            local item_config = Config.get_config_value("t_item", assets.assets[i].value1)
            local icon_res = CommonPanel.GetIcon("icon_res", "item", { "icon", item_config.id }, item_config.icon, item_config.color, assets.assets[i].value2, lua_script)
            table.insert(assets_, icon_res)
        elseif assets.assets[i].type == 3 then
            local item_config = Config.get_config_value("t_equip", assets.assets[i].value1)
            local icon_res = CommonPanel.GetIcon("icon_res", "equip", { "icon", item_config.id }, item_config.icon, item_config.max_q, 0, lua_script)
            table.insert(assets_, icon_res)
        end
    end
    return assets_
end

---取得需要材料的图标
function GameSys.GetMatIcon(item_id, item_count, need_count, icon_btn_name, lua_script)
    local asset = {
        ["type"] = 2,
        ["value1"] = item_id,
        ["value2"] = 0,
        ["value3"] = 0
    }
    local mat_icon = CommonPanel.GetIcon2type(asset, { icon_btn_name }, lua_script)
    local item_desc = mat_icon.transform:Find("generic")
    item_desc.gameObject:SetActive(true)
    local is_enough = item_count >= need_count
    item_desc.transform:GetComponent("Text").text = GameSys.MatEnoughColor(item_count .. "/" .. need_count, is_enough)
    return mat_icon
end

----------------------------文字相关----------------------------

---设置字体颜色，与t_color 对应
function GameSys.set_color(types, text)
    local t_color = Config.get_config_value("t_color", types)
    if t_color then
        --return string.gsub(t_color.color, "{n}", text)        
        return string.format(t_color.color, text)
    end
end

---分割字符串
function GameSys.split(s, p)
    local strs = {}
    string.gsub(s, '[^' .. p .. ']+', function(w)
        table.insert(strs, w)
    end)
    return strs
end

---是否以xx字符串开头
function GameSys.StringStart(str, start_str)
    return string.sub(str, 1, string.len(start_str)) == start_str
end

---是否以xx字符串结尾
function GameSys.StringEnd(str, end_str)
    return end_str == '' or string.sub(str, -string.len(end_str)) == end_str
end

---准确获取文字的数量
function GameSys.WidthSingle(inputstr)
    local temp = {}
    for uchar in string.gmatch(inputstr, "[%z\1-\127\194-\244][\128-\191]*") do
        temp[#temp + 1] = uchar
    end
    return temp
end
--- 获取汉子和字母个数
function GameSys.Utf8Len(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = GameSys.Charsize(char)
        currentIndex = currentIndex + cs
        len = len + 1
        if cs == 1 then
            aNum = aNum + 1
        elseif cs >= 2 then
            hNum = hNum + 1
        end
    end
    return aNum, hNum
end

function GameSys.Charsize(ch)
    if not ch then
        return 0
    elseif ch >= 252 then
        return 6
    elseif ch >= 248 and ch < 252 then
        return 5
    elseif ch >= 240 and ch < 248 then
        return 4
    elseif ch >= 224 and ch < 240 then
        return 3
    elseif ch >= 192 and ch < 224 then
        return 2
    elseif ch < 192 then
        return 1
    end
end

---材料 满足 与 不满足的字体颜色
function GameSys.MatEnoughColor(content, is_enough)
    if is_enough then
        return GameSys.SetTextColor("#33ff24", content)
    else
        return GameSys.SetTextColor("#ff0026", content)
    end
end

---金币或钻石 满足 与 不满足的字体颜色
function GameSys.PriceEnoughColor(content, is_enough)
    if is_enough then
        return GameSys.SetTextColor("#FFFFFF", content)
    else
        return GameSys.SetTextColor("#ff0026", content)
    end
end

---对lang表内的 {n} 进行文字替换
function GameSys.TextDealPlaceholder(lang, text)
    local re = {
        ["{n}"] = text
    }
    return string.gsub(lang, "{n}", re)
end

---设置文字颜色
function GameSys.SetTextColor(color, content)
    local c = "<color={n}>" .. content .. "</color>"
    return GameSys.TextDealPlaceholder(c, color)
end

---取得按钮解锁文字颜色
function GameSys.GetUnlockBtnColor()
    return "#B6D5FC"
end

---取得按钮升级文字颜色
function GameSys.GetUpgradeBtnColor()
    return "#FCDFB6"
end

---设置按钮文字成解锁颜色
function GameSys.SetBtnUnlockColor(content)
    return GameSys.SetTextColor(GameSys.GetUnlockBtnColor(), content)
end

---取得按钮未解锁文字颜色
function GameSys.GetlockBtnColor()
    return "#FFFFFF"
end

---设置按钮文字成未解锁颜色
function GameSys.SetBtnlockColor(content)
    return GameSys.SetTextColor(GameSys.GetlockBtnColor(), content)
end

---取得未解锁文字颜色
function GameSys.GetLockColor()
    return "#625A5A"
end

---设置文字成未解锁颜色
function GameSys.SetTextLockColor(content)
    return GameSys.SetTextColor(GameSys.GetLockColor(), content)
end

---取得正常文字颜色
function GameSys.GetNormalColor()
    return "#DACDCD"
end

---设置文字成正常颜色
function GameSys.SetTextNormalColor(content)
    return GameSys.SetTextColor(GameSys.GetNormalColor(), content)
end

---设置文字大小
function GameSys.SetTextSize(size, content)
    local c = "<size={n}>" .. content .. "</size>"
    return GameSys.TextDealPlaceholder(c, size)
end

---返回文字 资源 x 数量
function GameSys.GetResInfo(type, value1, value2, value3)
    local info = ""
    if (type == 1) then
        local res = Config.get_config_value("t_resource", value1)
        if (res ~= nil) then
            info = string.format("%s x %s", res.name, value2)
        end
    end
    return info
end

---计量单位转换 大于1w 的数字会转换成以k显示, 大于1000w的以M 显示
function GameSys.unit_conversion(num)
    local unit_c = tostring(num)
    local temp_num = num
    if temp_num >= 10000000 then
        temp_num = math.modf(temp_num / 1000000)
        unit_c = string.format("%dM", temp_num)
    elseif temp_num >= 10000 then
        temp_num = math.modf(temp_num / 1000)
        unit_c = string.format("%dK", temp_num)
    end
    return unit_c
end

---监测邮箱格式
function GameSys.CheckMail(str)
    if str == "" then
        GUIRoot.ShowPanel("MessagePanel", { '邮箱不能为空' })
        return false
    elseif (string.match(str, "[a-zA-Z0-9_%.%-]+@[a-zA-Z0-9%-]+%.%w%w%w?%w?")) ~= str then
        GUIRoot.ShowPanel("MessagePanel", { '请输入有效的电子邮箱地址' })
        return false
    end
    return true
end

---监测密码格式
function GameSys.CheckPassWord(str)
    if (str == '') then
        GUIRoot.ShowPanel("MessagePanel", { '密码不能为空' })
        return false
    elseif (string.len(str) < 8) then
        GUIRoot.ShowPanel("MessagePanel", { '密码不能小于8位字符' })
        return false
    elseif (string.len(str) > 18) then
        GUIRoot.ShowPanel("MessagePanel", { '密码不能大于18位字符' })
        return false
        --elseif (string.match(str, '^[a-zA-Z0-9]+$') ~= str) then
        --GUIRoot.ShowPanel("MessagePanel", { '密码中包含特殊字符' })
        --return false
    end
    return true
end

---取得asset的名字
function GameSys.GetAssetName(asset)
    local name = ""
    local type = asset.type
    if type == 1 then
        local t_resource = Config.get_config_value("t_resource", asset.value1)
        if t_resource ~= nil then
            name = GameSys.set_color(t_resource.color, t_resource.name)
        end
    elseif type == 2 then
        local t_item = Config.get_config_value("t_item", asset.value1)
        if t_item ~= nil then
            name = GameSys.set_color(t_item.color, t_item.name)
        end
    elseif type == 3 then
        local t_equip = Config.get_config_value("t_equip", asset.value1)
        if t_equip ~= nil then
            name = t_equip.name
        end
    elseif type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        if t_artifact ~= nil then
            name = GameSys.set_color(t_artifact.color, t_artifact.name)
        end
    elseif type == 5 then
        local t_rune = Config.get_config_value("t_rune", asset.value1)
        if t_rune ~= nil then
            name = GameSys.set_color(t_rune.color, t_rune.name)
        end
    elseif type == 6 then
        local t_pet = Config.get_config_value("t_pet", asset.value1)
        if t_pet ~= nil then
            name = GameSys.set_color(t_pet.color, t_pet.name)
        end
    end
    return name
end

function GameSys.GetAssetColor(asset)
    local color = 1
    local type = asset.type
    if type == 1 then
        local t_resource = Config.get_config_value("t_resource", asset.value1)
        if t_resource ~= nil then
            color = t_resource.color
        end
    elseif type == 2 then
        local t_item = Config.get_config_value("t_item", asset.value1)
        if t_item ~= nil then
            color = t_item.color
        end
    elseif type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        if t_artifact ~= nil then
            color = t_artifact.color
        end
    elseif type == 5 then
        local t_rune = Config.get_config_value("t_rune", asset.value1)
        if t_rune ~= nil then
            color = t_rune.color
        end
    elseif type == 6 then
        local t_pet = Config.get_config_value("t_pet", asset.value1)
        if t_pet ~= nil then
            color = t_pet.color
        end
    end
    return color
end

---取得asset的描述
function GameSys.GetAssetDesc(asset)
    local desc = ""
    local type = asset.type
    if type == 1 then
        local t_resource = Config.get_config_value("t_resource", asset.value1)
        if t_resource.desc ~= nil then
            desc = t_resource.desc
        end
    elseif type == 2 then
        local t_item = Config.get_config_value("t_item", asset.value1)
        if t_item.desc ~= nil then
            desc = t_item.desc
        end
    elseif type == 3 then
        local t_equip = Config.get_config_value("t_equip", asset.value1)
        if t_equip.desc ~= nil then
            desc = t_equip.desc
        end
    elseif type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        if t_artifact.desc ~= nil then
            desc = t_artifact.desc
        end

    elseif type == 5 then
        local t_rune = Config.get_config_value("t_rune", asset.value1)
        if t_rune.desc ~= nil then
            desc = t_rune.desc
        end
    elseif type == 6 then
        local t_pet = Config.get_config_value("t_pet", asset.value1)
        if t_pet.desc ~= nil then
            desc = t_pet.desc
        end
    end
    return desc
end

----------------------------table相关----------------------------

---判断值是否存在于表格内
function GameSys.hasInTable(tables, value)
    for k, v in ipairs(tables) do
        if v == value then
            return true, k
        end
    end
    return false, nil
end

---获取数据在表格内的下标
function GameSys.getIndex(tables, value)
    for k, v in ipairs(tables) do
        if v == value then
            return k
        end
    end
    return nil
end

---统一的按照id 排序
function GameSys.SortConfig_Id(conf_table)
    local temp = {}
    for k, v in pairs(conf_table) do
        table.insert(temp, v)
    end
    if #temp > 1 then
        table.sort(temp, function(a, b)
            local aid = a.id
            local bid = b.id
            return aid < bid
        end)
    end
    return temp
end

function GameSys.TableEqual(table1, table2)
    local result = true
    if table1 == nil and table2 == nil then
        return result
    elseif table1 ~= nil and table ~= nil then
        for k, v in pairs(table1) do
            if table2[k] == nil then
                result = false
                break
            end
            if table2[k] ~= v then
                result = false
                break
            end
        end
    else
        result = false
    end
    return result
end

----------------------------工具相关----------------------------

---清楚对象的子物体
function GameSys.ClearChild(obj)
    if (obj.childCount > 0) then
        for i = 0, obj.childCount - 1 do
            GameObject.Destroy(obj:GetChild(i).gameObject)
        end
    end
end

----------------------------属性相关----------------------------

---取得属性描述
function GameSys.GetAttributeText(att_id)
    local att = Config.get_config_value("t_attr", att_id)
    return att.desc
end

---取得属性名字
function GameSys.GetAttrNameText(attr_id)
    local att = Config.get_config_value("t_attr", attr_id)
    if att == nil then
        return ""
    end
    return att.name
end
---取得属性值string
function GameSys.GetAttrValueText(attr_id, attr_value)
    local value = GameSys.ConversionAttr(attr_id, attr_value)
    local t_attr = Config.get_config_value("t_attr", attr_id)
    local scale = t_attr.scale
    value = tostring(value)
    if scale == 10 then
        value = string.format("%s%%", value)
    end
    return value
end

---没有缩放取整  百分比取.1f
function GameSys.ConversionAttr(attr_id, value)
    local t_attr = Config.get_config_value("t_attr", attr_id)
    local scale = t_attr.scale
    if scale == 1 then
        return toInt(value)
    elseif scale == 10 then
        value = value / 10
        if math.floor(value) < value then
            value = tonumber(string.format("%.1f", value))
        end
        return value
    else
        return toInt(value)
    end
end

---是否是百分比属性
function GameSys.IsPerAttr(attr_id)
    local t_attr = Config.get_config_value("t_attr", attr_id)
    return t_attr.scale == 10
end

---取得属性战力
function GameSys.GetAttrPower(attr_id, attr_value)
    local t_attr = Config.get_config_value("t_attr", attr_id)
    local power = t_attr.power
    return toInt(attr_value * power)
end
----------------------------数量相关----------------------------

---获取物品数量
function GameSys.GetItemCount(item_id)
    for i = 1, #PlayerData.player.item_ids do
        if PlayerData.player.item_ids[i] == item_id then
            return PlayerData.player.item_nums[i]
        end
    end
    return 0
end

---通过宝石id 获取拥有的数量
function GameSys.GetRuneCount(runeId)
    local rune_ids = PlayerData.player.rune_ids
    local index = 0
    for i = 1, #rune_ids do
        if rune_ids[i] == runeId then
            index = i
            break
        end
    end
    if index == 0 then
        return 0
    else
        return PlayerData.player.rune_nums[index]
    end
end

---通过神器id 获取神器拥有的数量
function GameSys.GetArtifactCount(artifact_id)
    for i = 1, #PlayerData.player.artifact_ids do
        if PlayerData.player.artifact_ids[i] == artifact_id then
            if PlayerData.player.artifact_nums[i] == 1 then
                return 1
            else
                return 0
            end
        end
    end
    return 0
end

---与asset内对应，通过id 获取数量
function GameSys.GetAssetCount(type, assetid)
    if type == 1 then
        return GameSys.GetResourceCount(assetid)
    elseif type == 2 then
        return GameSys.GetItemCount(assetid)
    elseif type == 3 then
        return GameSys.GetBagEquipCount(assetid)
    elseif type == 4 then
        return GameSys.GetArtifactCount(assetid)
    elseif type == 5 then
        return GameSys.GetRuneCount(assetid)
    elseif type == 6 then
        return GameSys.GetPetCount(assetid)
    end
end

---取得resource数量
function GameSys.GetResourceCount(resource_id)
    if resource_id == 1 then
        return PlayerData.player.gold
    elseif resource_id == 2 then
        return PlayerData.player.jewel
    elseif resource_id == 3 then
        return PlayerData.player.exp
    elseif resource_id == 4 then
        return PlayerData.player.honor
    elseif resource_id == 5 then
        return PlayerData.player.reputation
    elseif resource_id == 6 then
        return PlayerData.player.progress
    end
end

---取得装备数量
function GameSys.GetEquipCount(equip_id)
    local count = 0
    for _, equip_info in pairs(PlayerData.equips) do
        if equip_info.template_id == equip_id then
            count = count + 1
        end
    end
end

---取得宠物的数量
function GameSys.GetPetCount(pet_id)
    return GameSys.HadPet(pet_id) and 1 or 0
end

---获取背包内装备数量
function GameSys.GetBagEquipCount()
    local equip_num = 0
    for k in pairs(PlayerData.equips) do
        equip_num = equip_num + 1
    end
    local slot_num = 0
    for i = 1, #PlayerData.player.equip_slots do
        if PlayerData.player.equip_slots[i] ~= "0" then
            slot_num = slot_num + 1
        end
    end
    return equip_num - slot_num
end

----------------------------装备相关----------------------------

---通过服务器的唯一标识获取装备的表格id
function GameSys.GetEquipId(guid)
    return PlayerData.equips[guid].template_id
end

---判断装备背包是否满
function GameSys.IsEquipFull()
    local max_equip_bag = Config.get_config_value("t_const", "max_equip_bag")
    if GameSys.GetBagEquipCount() < max_equip_bag.value then
        return false
    else
        return true
    end
end

---获取可获得的装备数
function GameSys.CanGetEquipNum()
    local max_equip_bag = Config.get_config_value("t_const", "max_equip_bag")
    local num = GameSys.GetBagEquipCount()
    return max_equip_bag.value - num
end

---判断是否拥有该装备
function GameSys.HadEquip(equip_guid)
    for guid in pairs(PlayerData.equips) do
        if equip_guid == guid then
            return true
        end
    end
    return false
end

---判断装备是否佩戴
function GameSys.IsEquipWeared(equip_info)
    if equip_info == nil then
        return false
    end
    if not GameSys.HadEquip(equip_info.guid) then
        return false
    end
    local equip_type = Config.get_config_value("t_equip", equip_info.template_id).type
    return (equip_info.guid == PlayerData.player.equip_slots[equip_type])
end

---判断槽子是否有装备可以佩戴
function GameSys.CanSlotWearEquip(slot_index)
    for k in pairs(PlayerData.equips) do
        local t_equip = Config.get_config_value("t_equip", PlayerData.equips[k].template_id)
        local min_level = t_equip.min_level
        local type = t_equip.type
        if type == slot_index and PlayerData.player.level >= min_level then
            return true
        end
    end
    return false
end

---判断时装槽子时候有时装可以穿戴
function GameSys.CanDressSlotWear(slot_index)
    for i = 1, #PlayerData.player.equip_dresses do
        local id = PlayerData.player.equip_dresses[i]
        local t_equip = Config.get_config_value("t_equip", id)
        local equip_type = t_equip.type
        if equip_type == slot_index then
            return true
        end
    end
    return false
end

---判断是否有可以带装备的空槽子
function GameSys.IsCanWearNullSlot()
    for i = 1, #PlayerData.player.equip_slots do
        local slot = PlayerData.player.equip_slots[i]
        if slot == "0" and GameSys.CanSlotWearEquip(i) then
            return true
        end
    end
    return false
end

---取得装备的强化上限
function GameSys.GetEquipEnhanceLimit(equip_id)
    local t_equip = Config.get_config_value("t_equip", equip_id)
    return t_equip.enhance_limit
end

---取得槽子的強化值
function GameSys.GetSlotEnhance(index)
    return PlayerData.player.equip_enhances[index]
end

---取得装备的强化值
function GameSys.GetEquipEnhance(equip_info)
    if GameSys.IsEquipWeared(equip_info) then
        local equip_type = GameSys.GetEquipType(equip_info)
        local slot_enhance = GameSys.GetSlotEnhance(equip_type)
        local enhance_limit = GameSys.GetEquipEnhanceLimit(equip_info.template_id)
        local enhance = slot_enhance >= enhance_limit and enhance_limit or slot_enhance
        return enhance
    else
        return 0
    end
end

---取得装备的强化的属性值
function GameSys.GetAttrEnhanceValue(attr_value, enhance)
    local t_equip_enhance = Config.get_config_value("t_equip_enhance", enhance)
    if t_equip_enhance ~= nil then
        local total_value = t_equip_enhance.total_value
        attr_value = attr_value * total_value / 100
        return attr_value
    else
        return 0
    end
end

---获取装备主属性
function GameSys.GetEquipBaseAttr(equip_info, enhance_level)
    local attr_id = equip_info.attr
    local attr_value = equip_info.value
    local t_attr = Config.get_config_value("t_attr", attr_id)
    if enhance_level == nil then
        enhance_level = GameSys.GetEquipEnhance(equip_info)
    end
    local enhance_value = GameSys.GetAttrEnhanceValue(attr_value, enhance_level)
    local attr = {
        ["t_attr"] = t_attr,
        ["value"] = attr_value,
        ["enhance_value"] = enhance_value,
        ["total_value"] = attr_value + enhance_value
    }
    return attr
end

---获取装备附魔属性
function GameSys.GetEquipEnchantValue(equip_info)
    local enchant_id = equip_info.enchant_id
    local attr = nil
    if enchant_id == 0 then
        return attr
    else
        local t_enchant = Config.get_config_value("t_equip_enchant", enchant_id)
        local enchant_attr_id = t_enchant.attr
        local t_attr = Config.get_config_value("t_attr", enchant_attr_id)
        attr = {
            ["t_attr"] = t_attr,
            ["value"] = equip_info.enchant_value
        }
        return attr
    end
end

---获取装备重铸属性
function GameSys.GetEquipReforgeValue(equip_info, enhance_level)
    local attr_ids = equip_info.attr_ids
    local attr_types = equip_info.attr_types
    local attr_values = equip_info.attr_values
    local attr_pers = equip_info.attr_pers
    local attr_colors = equip_info.attr_colors
    local attr = {}
    if enhance_level == nil then
        enhance_level = GameSys.GetEquipEnhance(equip_info)
    end
    for i = 1, #attr_ids do
        local enhance_value = 0
        local total_value = 0
        local attr_type = attr_types[i]
        if attr_type == 1 then
            if not GameSys.IsPerAttr(attr_ids[i]) then
                enhance_value = GameSys.GetAttrEnhanceValue(attr_values[i], enhance_level)
            end
            total_value = attr_values[i] + enhance_value
        end
        local t_attr = nil
        local spell_id = 0
        if attr_type == 1 then
            t_attr = Config.get_config_value("t_attr", attr_ids[i])
        elseif attr_type == 2 then
            spell_id = attr_ids[i]
        end
        table.insert(attr, {
            ["attr_type"] = attr_type,
            ["t_attr"] = t_attr,
            ["spell_id"] = spell_id,
            ["value"] = attr_values[i],
            ["enhance_value"] = enhance_value,
            ["total_value"] = total_value,
            ["per"] = attr_pers[i],
            ["color"] = attr_colors[i]
        })
    end
    table.sort(attr, function(a, b)
        if a.color < b.color then
            return true
        elseif a.color > b.color then
            return false
        else
            if a.attr_type == 1 and b.attr_type == 1 then
                return a.t_attr.id < b.t_attr.id
            elseif a.attr_type == 2 and b.attr_type == 2 then
                return a.spell_id > b.spell_id
            end
        end
    end)
    return attr
end

---获取装备基础战斗力
function GameSys.GetEquipBasePower(equip_info)
    local base_value = GameSys.GetEquipBaseAttr(equip_info).value
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    local attr_index = t_equip.attr
    local t_attr = Config.get_config_value("t_attr", attr_index)
    local power = t_attr.power
    return base_value * power, t_equip
end

---传入装备唯一标识符，获取装备的战斗力
function GameSys.GetEquipPower(equip_info)
    local base_attr = GameSys.GetEquipBaseAttr(equip_info)
    local reforge_attr = GameSys.GetEquipReforgeValue(equip_info)
    local power_1 = GameSys.GetAttrPower(base_attr.t_attr.id, base_attr.total_value)
    local power_2 = 0
    for i = 1, #reforge_attr do
        local attr = reforge_attr[i]
        if attr.attr_type == 1 then
            power_2 = power_2 + GameSys.GetAttrPower(attr.t_attr.id, attr.total_value)
        end
    end
    return power_1 + power_2
end

---可佩戴的装备是否 战力最高
function GameSys.IsMaxPowerEquip(equip_info)
    if equip_info == nil then
        return false
    end
    local power = GameSys.GetEquipPower(equip_info)
    local equip_type = GameSys.GetEquipType(equip_info)
    local is_max = true
    for _, equip in pairs(PlayerData.equips) do
        if equip.guid ~= equip_info.guid and GameSys.EquipCanWear(equip) and GameSys.GetEquipType(equip) == equip_type and GameSys.GetEquipPower(equip) > power then
            is_max = false
            break
        end
    end
    return is_max
end

---玩家是否可以传上这件装备
function GameSys.EquipCanWear(equip_info)
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    return PlayerData.player.level >= t_equip.min_level
end

--- 槽子是否有镶嵌
function GameSys.IsInlay(slot)
    local inlay_1 = (PlayerData.player.rune_slot1s[slot] ~= 0)
    local inlay_2 = (PlayerData.player.rune_slot2s[slot] ~= 0)
    local inlay_3 = (PlayerData.player.rune_slot3s[slot] ~= 0)
    return { (inlay_1 or inlay_2 or inlay_3), inlay_1, inlay_2, inlay_3 }
end

---取得槽子的镶嵌情况
function GameSys.GetSlotRunes(index)
    local rune1_id = PlayerData.player.rune_slot1s[index]
    local rune2_id = PlayerData.player.rune_slot2s[index]
    local rune3_id = PlayerData.player.rune_slot3s[index]
    return { rune1_id, rune2_id, rune3_id }
end

--- 取得槽子具体位置的镶嵌宝石id
function GameSys.GetInlayId(slot, inlay_site)
    local cur_rune_slot = {}
    if inlay_site == 1 then
        cur_rune_slot = PlayerData.player.rune_slot1s
    elseif inlay_site == 2 then
        cur_rune_slot = PlayerData.player.rune_slot2s
    elseif inlay_site == 3 then
        cur_rune_slot = PlayerData.player.rune_slot3s
    end
    return cur_rune_slot[slot]
end

---取得自己拥有的装备颜色
function GameSys.GetMyEquipColor(guid)
    if not GameSys.HadEquip(guid) then
        return 1
    end
    local equip_info = PlayerData.equips[guid]
    return equip_info.color
end

---取得装备的类型
function GameSys.GetEquipType(equip_info)
    local equip_type = Config.get_config_value("t_equip", equip_info.template_id).type
    return equip_type
end

---通过id取得装备类型
function GameSys.GetEquipTypeById(equip_id)
    local equip_type = Config.get_config_value("t_equip", equip_id).type
    return equip_type
end

---取的穿戴的装备id
function GameSys.GetSlotEquipIds()
    local equips = {}
    for i = 1, #PlayerData.player.equip_slots do
        local equip_guid = PlayerData.player.equip_slots[i]
        local equip_info = PlayerData.equips[equip_guid]
        if equip_info ~= nil then
            table.insert(equips, equip_info.template_id)
        else
            table.insert(equips, 0)
        end
    end
    return equips
end

---取得穿戴的外观装备id数组
function GameSys.GetEquipAvatarIds(equip_ids, dress_ids)
    local avatar_ids = {}
    for i = 1, #dress_ids do
        local id = 0
        if dress_ids[i] ~= 0 then
            id = dress_ids[i]
        else
            id = equip_ids[i]
        end
        avatar_ids[i] = id
    end
    return avatar_ids
end

function GameSys.GetSelfEquipAvatarIds()
    local equip_ids = GameSys.GetSlotEquipIds()
    local dress_ids = PlayerData.player.equip_shows
    return GameSys.GetEquipAvatarIds(equip_ids, dress_ids)
end

---装备类型转部位
function GameSys.GetEquipPart(etype)
    if etype == 1 then
        return "weapon"
    elseif etype == 3 then
        return "helmet"
    elseif etype == 4 then
        return "shoulder"
    elseif etype == 5 then
        return "glove"
    elseif etype == 6 then
        return "body"
    elseif etype == 8 then
        return "shoes"
    end
    return nil
end

---装备可能的最小 最大 品质
function GameSys.GetEquipColorRange()
    local equip_random_config = Config.get_config_value("t_equip_random_rate")
    local t = {}
    for _, v in pairs(equip_random_config) do
        table.insert(t, v)
    end
    table.sort(t, function(a, b)
        return a.color < b.color
    end)
    return t[1].color, t[#t].color
end

---是否拥有外观,声望是否可以领取,声望是否领取过了
function GameSys.GetDressState(equip_id)
    local had_avatar = false
    local can_get = false
    local had_get = false
    for i = 1, #PlayerData.player.equip_dresses do
        if equip_id == PlayerData.player.equip_dresses[i] then
            had_avatar = true
            can_get = PlayerData.player.equip_dresses_unlock[i] == 0
            had_get = PlayerData.player.equip_dresses_unlock[i] == 1
            break
        end
    end
    return had_avatar, can_get, had_get
end
---是否有装备可以领声望
function GameSys.CanGetDressReputation()
    for i = 1, #PlayerData.player.equip_dresses do
        if PlayerData.player.equip_dresses_unlock[i] == 0 then
            return true
        end
    end
    return false
end
---取得装备佩戴描述
function GameSys.GetEquipWearDesc(t_equip)
    local min_level = t_equip.min_level
    local desc = string.format("%d级可装备", min_level)
    desc = GameSys.MatEnoughColor(desc, (PlayerData.player.level >= min_level))
    return desc
end
---取得装备的等级名字
function GameSys.GetEquipLevelName(equip_info)
    local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
    local index = 10
    if equip_info.level < 10 then
        index = equip_info.level
    else
        index = equip_info.level % 10
    end
    local t_level_name = Config.get_config_value("t_equip_level_name", index)
    local name = t_level_name.name .. t_equip.name
    return name
end
----------------------------宠物相关----------------------------

---获取宠物的属性
function GameSys.GetPetAttrs(level, pet_id)
    local attr_ids = { 1, 2, 3, 4 }
    local t_pet = Config.get_config_value("t_pet", pet_id)
    local t_values = t_pet.attrs
    local t_level = Config.get_config_value("t_level", level)
    local attr = {}
    if t_level == nil then
        return attr
    end
    for i = 1, #attr_ids do
        local t_attr = Config.get_config_value("t_attr", attr_ids[i])
        local attr_value = t_level.std_attr * t_values[i].value / 100 * t_attr.value
        table.insert(attr, {
            ["t_attr"] = Config.get_config_value("t_attr", attr_ids[i]),
            ["value"] = attr_value
        })
    end
    return attr
end

---获取玩家宠物数量
function GameSys.GetPlayerPetCount()
    local count = 0
    for _ in pairs(PlayerData.pets) do
        count = count + 1
    end
    return count
end

---返回是否有宠物 有则返回宠物的guid
function GameSys.HadPet(pet_id)
    for _, v in pairs(PlayerData.pets) do
        if v.template_id == pet_id then
            return true, v.guid
        end
    end
    return false, "0"
end

---宠物是否上阵
function GameSys.IsPetWeared(pet_guid)
    for i = 1, #PlayerData.player.pet_slots do
        if pet_guid == PlayerData.player.pet_slots[i] then
            return true
        end
    end
    return false
end

---宠物达到进阶
function GameSys.PetNeedEnhance(level, enhance)
    local t_pet_enhance = Config.get_config_value("t_pet_enhance", enhance + 1)
    if t_pet_enhance == nil then
        return false
    else
        return level >= t_pet_enhance.level
    end
end

---宠物达到满级
function GameSys.PetMaxLevel(level)
    local t_pet_level = Config.get_config_value("t_level", level + 1)
    return t_pet_level == nil
end

---取得宠物等级
function GameSys.GetPetLevel(pet_id)
    local had, guid = GameSys.HadPet(pet_id)
    if not had then
        return 0
    else
        return PlayerData.pets[guid].level
    end
end

---取得一个宠物的天赋
function GameSys.GetPetTalents(pet_id, enhance)
    local t_pet = Config.get_config_value("t_pet", pet_id)
    local talents = t_pet.talent
    if enhance == nil then
        enhance = 0
    end
    local talent_tables = {}
    for i = 1, #talents do
        local talent_id = talents[i].id
        local t_pet_talent = Config.get_config_value("t_pet_talent", talent_id)
        local t_attr = Config.get_config_value("t_attr", t_pet_talent.attr_id)
        local attr_value = t_pet_talent.attr_value + enhance * t_pet_talent.attr_value_add
        local t = {
            ["t_pet_talent"] = t_pet_talent,
            ["t_attr"] = t_attr,
            ["value"] = attr_value
        }
        table.insert(talent_tables, t)
    end
    return talent_tables
end

function GameSys.GetPetTalentDesc(talent_id, enhance)
    local t_talent = Config.get_config_value("t_pet_talent", talent_id)
    local desc = t_talent.desc
    local value = t_talent.attr_value
    if enhance == nil then
        enhance = 0
    end
    local enhacne_value = t_talent.attr_value_add * enhance
    local total_value = value + enhacne_value
    local content = GameSys.ConversionAttr(t_talent.attr_id, total_value)
    return string.gsub(desc, "{N1}", content)
end
---宠物的声望是否可以领取 是否已经领取
function GameSys.GetPetReputationState(pet_id)
    if not GameSys.HadPet(pet_id) then
        return false, false
    end
    for i = 1, #PlayerData.player.pet_ids do
        if PlayerData.player.pet_ids[i] == pet_id then
            return PlayerData.player.pet_unlocks[i] == 0, PlayerData.player.pet_unlocks[i] == 1
        end
    end
    return false, false
end
---是否有宠物的声望可以领取
function GameSys.CanGetPetReputation()
    for i = 1, #PlayerData.player.pet_unlocks do
        if PlayerData.player.pet_unlocks[i] == 0 then
            return true
        end
    end
    return false
end
---是否有宠物可以合成
function GameSys.CanSyntPet()
    local all_pet = {}
    for k, v in pairs(Config.t_pet) do
        all_pet[k] = v
    end
    for i = 1, #PlayerData.player.pet_ids do
        all_pet[PlayerData.player.pet_ids[i]] = nil
    end
    for _, v in pairs(all_pet) do
        local shard_id = v.shard_id
        if GameSys.GetItemCount(shard_id) >= v.shard_num then
            return true
        end
    end
    return false
end

----------------------------技能相关----------------------------

function GameSys.IsBaseSpell(spell_id)
    local level = GameSys.GetSpellLevel(spell_id)
    return level == 1
end

function GameSys.IsBasePassive(passive_id)
    local t_passive = Config.get_config_value("t_spell_passive", passive_id)
    return t_passive.basic == 1
end

---被动是否佩戴
function GameSys.IsPassiveWeared(passive_id)
    for i = 1, #PlayerData.player.spell_passive_ids do
        if PlayerData.player.spell_passive_slots[i] == passive_id then
            return true
        end
    end
    return false
end

---取得被动的描述
function GameSys.GetPassiveDesc(passive_id)
    local t_passive = Config.get_config_value("t_spell_passive", passive_id)
    local desc = t_passive.desc
    local str_itor = string.gmatch(desc, "{%w+}")
    for word in str_itor do
        local index = tonumber(string.sub(word, 3, 3))
        local effect = t_passive.effect[index]
        local param_index = tonumber(string.sub(word, 4, 4))
        local value = effect["param" .. param_index]
        if param_index % 2 == 0 then
            value = value / 10
        end
        value = math.abs(value)
        value = GameSys.SetTextColor("#33FF24", value)
        desc = string.gsub(desc, word, value)
    end
    return desc
end

---取得技能的操作描述
function GameSys.GetSpellOperateDesc(spell_id)
    local t_spell = Config.get_config_value("t_spell", spell_id)
    local desc = t_spell.desc
    return desc
end

---取得技能的描述
function GameSys.GetSpellDesc(spell_id, level)
    local t_spell = Config.get_config_value("t_spell", spell_id)
    local desc = t_spell.desc1
    local str_itor = string.gmatch(desc, "{%w+}")
    for word in str_itor do
        local alias = string.sub(word, 2, 2)
        if alias == "N" then
            local dif = tonumber(string.sub(word, 3, 3))
            if dif == 1 then
                local index = tonumber(string.sub(word, 4, 4))
                local damg = 0
                if index == 1 then
                    damg = t_spell.dmg_param1 + t_spell.dmg_param1_add * (level - 1)
                elseif index == 2 then
                    damg = t_spell.dmg_param2 + t_spell.dmg_param2_add * (level - 1)
                end
                damg = damg / 10
                damg = math.abs(damg)
                damg = GameSys.SetTextColor("#33FF24", damg)
                desc = string.gsub(desc, word, damg)
            elseif dif == 2 then
                local buff_id = t_spell.buff[tonumber(string.sub(word, 4, 4))].id
                local t_buff = Config.get_config_value("t_spell_buff", buff_id)
                if t_buff then
                    local index = tonumber(string.sub(word, 5, 5))
                    local buff_param = t_buff.buff[index]
                    local buff = buff_param.value + buff_param.add * (level - 1)
                    buff = buff / 10
                    buff = math.abs(buff)
                    buff = GameSys.SetTextColor("#33FF24", buff)
                    desc = string.gsub(desc, word, buff)
                end
            end
        elseif alias == "T" then
            local time = t_spell.buff[1].time / 1000
            time = GameSys.SetTextColor("#33FF24", time)
            desc = string.gsub(desc, word, time)
        end
    end
    return desc
end

---取得buff描述
function GameSys.GetBuffDesc(buff_id, buff_level)
    local t_buff = Config.get_config_value("t_spell_buff", buff_id)
    local desc = t_buff.desc
    local str_itor = string.gmatch(desc, "{%w+}")
    for word in str_itor do
        local index = tonumber(string.sub(word, 3, 3))
        local content = t_buff.buff[index].value + t_buff.buff[index].add * (buff_level - 1)
        content = content / 10
        content = math.abs(content)
        content = GameSys.SetTextColor("#33FF24", content)
        desc = string.gsub(desc, word, content)
    end
    return desc
end

----取得技能等级
function GameSys.GetSpellLevel(spell_id)
    for i = 1, #PlayerData.player.spell_ids do
        if PlayerData.player.spell_ids[i] == spell_id then
            local level = PlayerData.player.spell_levels[i]
            level = level and level or 0
            return level
        end
    end
    return 0
end

---取得装备的技能等级
function GameSys.GetSlotSpellLevels()
    local levels = {}
    for i = 1, #PlayerData.player.spell_slots do
        local spell_id = PlayerData.player.spell_slots[i]
        levels[i] = GameSys.GetSpellLevel(spell_id)
    end
    return levels
end

---是否有技能可以解锁或者升级
function GameSys.IsCanAdvanceSpell()
    local result = false
    for spell_id, t_spell in pairs(Config.t_spell) do
        if t_spell.type == 1 then
            local level = GameSys.GetSpellLevel(spell_id)
            if level == 0 then
                result = PlayerData.player.level >= t_spell.unlock_level
            else
                local t_spell_level = Config.get_config_value("t_spell_level", level + 1)
                if t_spell_level == nil then
                    result = false
                else
                    local spell_item = Config.get_config_value("t_const", "spell_item").value
                    result = GameSys.GetItemCount(spell_item) >= t_spell_level.num
                end
            end
            if result then
                return result
            end
        end
    end
    return result
end

---取得被动的一级id
function GameSys.GetBasePassiveById(passive_id)
    local t_passive = Config.get_config_value("t_spell_passive", passive_id)
    if t_passive.class ~= 1 then
        return 0
    end
    local temp = {}
    for k, v in pairs(Config.t_spell_passive) do
        if v.next_spell ~= 0 and v.class == 1 then
            temp[v.next_spell] = k
        end
    end
    while temp[passive_id] ~= nil do
        passive_id = temp[passive_id]
    end
    return passive_id
end

---取得被动的所有一级id
function GameSys.GetAllBasePassive()
    local all_passive = {}
    for k, v in pairs(Config.t_spell_passive) do
        if v.class == 1 then
            table.insert(all_passive, k)
        end
    end
    local temp = {}
    for k, v in pairs(Config.t_spell_passive) do
        if v.next_spell ~= 0 and v.class == 1 then
            temp[v.next_spell] = k
        end
    end
    local base = {}
    for i = 1, #all_passive do
        if temp[all_passive[i]] == nil then
            table.insert(base, all_passive[i])
        end
    end
    table.sort(base, function(a, b)
        return a < b
    end)
    return base
end

---取得未解锁的被动
function GameSys.GetLockPassive()
    local has_bases = {}
    for i = 1, #PlayerData.player.spell_passive_ids do
        local passive_id = PlayerData.player.spell_passive_ids[i]
        local base_id = GameSys.GetBasePassiveById(passive_id)
        has_bases[base_id] = 1
    end
    local all_bases = GameSys.GetAllBasePassive()
    local lock_base_ids = {}
    for i = 1, #all_bases do
        if has_bases[all_bases[i]] == nil then
            table.insert(lock_base_ids, all_bases[i])
        end
    end
    for i = 1, #PlayerData.player.spell_passive_ids do
        local passive_id = PlayerData.player.spell_passive_ids[i]
        local t_spell_passive = Config.get_config_value("t_spell_passive", passive_id)
        if t_spell_passive.next_spell ~= 0 then
            table.insert(lock_base_ids, t_spell_passive.next_spell)
        end
    end
    table.sort(lock_base_ids, function(a, b)
        return a < b
    end)
    return lock_base_ids
end

---是否有被动可以解锁或者升级
function GameSys.IsCanAdvancePassive()
    local result = false
    local locks = GameSys.GetLockPassive()
    for i = 1, #locks do
        local t_spell_passive = Config.get_config_value("t_spell_passive", locks[i])
        local b = true
        for j = 1, #t_spell_passive.unlock do
            if GameSys.GetPetLevel(t_spell_passive.unlock[j].param1) < t_spell_passive.unlock[j].param2 then
                b = false
                break
            end
        end
        result = b
        if result then
            return result
        end
    end
    return result
end

----------------------------玩家相关----------------------------

---获取玩家等级所需经验，如果没有，则返回自己的经验
function GameSys.GetPlayerLevelExp(level)
    local t_level = Config.get_config_value("t_level", level)
    if t_level ~= nil then
        return t_level.exp
    end
    return PlayerData.player.exp
end

---获取vip等级所需经验，如果没有，则返回自己的经验
function GameSys.GetVipExp(vip_level)
    local t_vip = Config.get_config_value("t_vip", vip_level)
    if t_vip ~= nil then
        return t_vip.exp
    end
    return PlayerData.player.vip_exp
end

---取得玩家拥有的宝石
function GameSys.GetPlayerRunes()
    local assets_ = {}
    for i = 1, #PlayerData.player.rune_ids do
        if Config.get_config_value("t_rune", PlayerData.player.rune_ids[i]) then
            table.insert(assets_, PlayerData.player.rune_ids[i])
        end
    end
    return assets_
end

---角色是否满级
function GameSys.PlayerMaxLevel()
    local level = PlayerData.player.level
    local t_level = Config.get_config_value("t_level", level + 1)
    return t_level == nil, t_level
end

---是否是游客
function GameSys.IsTour(username)
    if (string.len(username) == 18) then
        if (string.match(username, "tour[0-9]+")) == username then
            return true
        end
    end
    return false
end

----------------------------神器相关----------------------------
---取得神器此时的状态 0有图纸 1已拥有 -1不拥有且没有图纸
function GameSys.GetArtifactState(artifact_id)
    for i = 1, #PlayerData.player.artifact_ids do
        if PlayerData.player.artifact_ids[i] == artifact_id then
            return PlayerData.player.artifact_nums[i]
        end
    end
    return -1
end
---是否有神器可以锻造
function GameSys.CanForgeArtifact()
    for i = 1, #PlayerData.player.artifact_ids do
        if PlayerData.player.artifact_nums[i] == 0 then
            local t_forge = GameSys.GetArtifactForgeConfig(PlayerData.player.artifact_ids[i])
            local result = GameSys.Forge_Mat_E(t_forge)
            if result then
                return result
            end
        end
    end
    return false
end
---神器是否可以锻造
function GameSys.EnoughArtifactForge(artifac_id)
    for i = 1, #PlayerData.player.artifact_ids do
        if artifac_id == PlayerData.player.artifact_ids[i] then
            if PlayerData.player.artifact_nums[i] ~= 0 then
                return false
            end
            local t_forge = GameSys.GetArtifactForgeConfig(artifac_id)
            return GameSys.Forge_Mat_E(t_forge)
        end
    end
    return false
end
---取得神器的锻造config
function GameSys.GetArtifactForgeConfig(artifact_id)
    for _, v in pairs(Config.t_forge) do
        if v.type == 4 and v.value1 == artifact_id then
            return v
        end
    end
    return nil
end
---锻造的条件是否满足

function GameSys.HasCurLevelForge()
    for _, v in pairs(Config.t_forge) do
        if v.type == 3 and PlayerData.player.map >= v.unlock_param then
            local t_equip = Config.get_config_value("t_equip", v.value1)
            if GameSys.Forge_Mat_E(v) and (t_equip.min_level <= PlayerData.player.level and PlayerData.player.map == v.unlock_param) then
                return true
            end
        end
    end
    return false
end

function GameSys.Forge_Mat_E(t_forge)
    if t_forge == nil then
        return false
    end
    local is_can = true
    if t_forge.gold > PlayerData.player.gold then
        return false
    end
    for i = 1, #t_forge.mat do
        local player_mat_num = GameSys.GetAssetCount(t_forge.mat[i].type, t_forge.mat[i].value1)
        if player_mat_num < t_forge.mat[i].value2 then
            is_can = false
        end
    end
    return is_can
end
---神器解锁和锻造的声望是否领取
function GameSys.GetArtifactReputationState(artifact_id)
    local unlock = { can_get = false, had_get = false }
    local forge = { can_get = false, had_get = false }
    for i = 1, #PlayerData.player.artifact_ids do
        if PlayerData.player.artifact_ids[i] == artifact_id then
            local artifact_state = PlayerData.player.artifact_nums[i]
            local reputation_unlock = PlayerData.player.artifact_unlocks[i]
            if artifact_state == 0 then
                unlock.can_get = reputation_unlock == 0
                unlock.had_get = reputation_unlock == 1
                return unlock, forge
            elseif artifact_state == 1 then
                unlock.can_get = false
                unlock.had_get = true
                forge.can_get = reputation_unlock == 1
                forge.had_get = reputation_unlock == 2
                return unlock, forge
            end
        end
    end
    return unlock, forge
end
---是否有神器的声望可以领取
function GameSys.CanGetArtifactReputation()
    for i = 1, #PlayerData.player.artifact_nums do
        local state = PlayerData.player.artifact_nums[i]
        if state == 0 and PlayerData.player.artifact_unlocks[i] == 0 then
            return true
        end
        if state == 1 and PlayerData.player.artifact_unlocks[i] == 1 then
            return true
        end
    end
    return false
end

----------------------------获取相关----------------------------
function GameSys.GetGetInfo(asset_type, id)
    local info = nil
    if asset_type == 2 then
        local t_item = Config.get_config_value("t_item", id)
        info = t_item.get
    elseif asset_type == 3 then
        local t_equip = Config.get_config_value("t_equip", id)
        info = t_equip.get
    elseif asset_type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", id)
        info = t_artifact.get
    elseif asset_type == 5 then
        local t_rune = Config.get_config_value("t_rune", id)
        info = t_rune.get
    elseif asset_type == 6 then
        local t_pet = Config.get_config_value("t_pet", id)
        info = t_pet.get
    end
    if info == nil then
        return nil
    else
        local gets = GameSys.split(info, "|")
        return gets
    end
end

----------------------------npc相关----------------------------
function GameSys.GetNpcList(map)
    local npc_list = {}
    for k, v in pairs(Config.t_npc) do
        if v.map == map then
            if GameSys.NpcShow(v) then
                table.insert(npc_list, v)
            end
        end
    end
    if #npc_list > 1 then
        table.sort(npc_list, function(a, b)
            return a.id < b.id
        end)
    end
    return npc_list
end

function GameSys.NpcShow(npc)
    if npc.exit == 0 and (QuestManger.NeedOverCondition(npc.appear) or npc.appear == 0) and (QuestManger.NeedOverCondition(npc.appear2) or npc.appear2 == 0) then
        return true
    elseif npc.exit ~= 0 and (QuestManger.NeedOverCondition(npc.appear) or npc.appear == 0) and (QuestManger.NeedOverCondition(npc.appear2) or npc.appear2 == 0) and not QuestManger.NeedOverCondition(npc.exit) then
        return true
    end

    return false
end

----------------------------怪物相关----------------------------

function GameSys.GetMonsterReputationState(mission_id, role_id)
    local reputation_state = {
        ["had_unlock"] = false,
        ["cur_kill_num"] = 0,
        ["cur_unlock_level"] = 0,
        ["is_max_unlock"] = false,
        ["next_unlock_kill_num"] = 0,
        ["next_unlock_reputation"] = 0,
        ["can_get_reputation"] = false,
    }
    local had_unlock = false
    local index = 0
    for i = 1, #PlayerData.player.monsters do
        if mission_id == PlayerData.player.monsters[i] then
            index = i
            had_unlock = true
            break
        end
    end
    reputation_state.had_unlock = had_unlock
    if not had_unlock then
        return reputation_state
    end
    reputation_state.cur_kill_num = PlayerData.player.monster_nums[index]
    local unlock_level = PlayerData.player.monster_unlocks[index]
    reputation_state.cur_unlock_level = unlock_level
    local t_role = Config.get_config_value("t_role", role_id)
    local reputation_type = t_role.reputation
    local t_role_reputation = Config.get_config_value("t_role_reputation", reputation_type)
    local next_unlock_level = t_role_reputation.kill[unlock_level + 1]
    reputation_state.is_max_unlock = next_unlock_level == nil
    if not reputation_state.is_max_unlock then
        reputation_state.next_unlock_kill_num = next_unlock_level.num
        reputation_state.next_unlock_reputation = next_unlock_level.reputation
        reputation_state.can_get_reputation = reputation_state.cur_kill_num >= next_unlock_level.num
    end
    return reputation_state
end
---是否有怪物的声望可以领取
function GameSys.CanGetMonsterReputation()
    for i = 1, #PlayerData.player.monsters do
        local mission_id = PlayerData.player.monsters[i]
        local monster_id = Config.get_config_value("t_mission", mission_id).monsterid
        local role_id = Config.get_config_value("t_monster", monster_id).role_id
        local t_role = Config.get_config_value("t_role", role_id)
        local t_role_reputation = Config.get_config_value("t_role_reputation", t_role.reputation)
        local cur_unlock_level = PlayerData.player.monster_unlocks[i]
        local next_kill = t_role_reputation.kill[cur_unlock_level + 1]
        if next_kill ~= nil then
            local cur_kill_num = PlayerData.player.monster_nums[i]
            if cur_kill_num >= next_kill.num then
                return true
            end
        end
    end
    return false
end
---取得怪物颜色区间
function GameSys.GetMonsterColorRange()
    local config = Config.t_mission_random
    local temp = {}
    for _, v in pairs(config) do
        table.insert(temp, v.color)
    end
    table.sort(temp, function(a, b)
        return a < b
    end)
    return temp[1], temp[#temp]
end
----------------------------解锁相关----------------------------

function GameSys.PlayerNameUnlock()
    return PlayerData.player.name ~= ""
end

function GameSys.PlayerBtnIsLock()
    return UnlockManger.LockCheck(4002)
end

function GameSys.SpellIsLock()
    return UnlockManger.LockCheck(3001)
end

function GameSys.PetIsLock()
    return UnlockManger.LockCheck(3002)
end

function GameSys.BagIsLock()
    return UnlockManger.LockCheck(4001)
end

function GameSys.BookIsLock()
    return UnlockManger.LockCheck(4003)
end

function GameSys.BasicBtnUnlock()
    if not GameSys.PlayerNameUnlock() then
        return false
    else
        return not UnlockManger.LockCheck(4001) or not UnlockManger.LockCheck(4002) or not UnlockManger.LockCheck(4003) or not UnlockManger.LockCheck(4006)
    end
end

----------------------------界面工具----------------------------
---取得asset配置
function GameSys.GetAssetConfig(asset)
    local type = asset.type
    local id = asset.value1
    if type == 1 then
        return Config.get_config_value("t_resource", id)
    elseif type == 2 then
        return Config.get_config_value("t_item", id)
    elseif type == 3 then
        return Config.get_config_value("t_equip", id)
    elseif type == 4 then
        return Config.get_config_value("t_artifact", id)
    elseif type == 5 then
        return Config.get_config_value("t_rune", id)
    elseif type == 6 then
        return Config.get_config_value("t_pet", id)
    end
end
---取得asset图集 图片 是不是碎片
function GameSys.GetAssetIconState(asset)
    if asset.type == 1 then
        local t_resource = Config.get_config_value("t_resource", asset.value1)
        return "resource", t_resource.icon
    elseif asset.type == 2 then
        local t_item = Config.get_config_value("t_item", asset.value1)
        if t_item.type == 7001 then
            local t_pet = Config.get_config_value("t_pet", t_item.res[1].value)
            return "pet", t_pet.icon, true
        else
            return "item", t_item.icon
        end
    elseif asset.type == 3 then
        local t_equip = Config.get_config_value("t_equip", asset.value1)
        return "equip", t_equip.icon
    elseif asset.type == 4 then
        local t_artifact = Config.get_config_value("t_artifact", asset.value1)
        return "artifact", t_artifact.icon
    elseif asset.type == 5 then
        local t_rune = Config.get_config_value("t_rune", asset.value1)
        return "rune", t_rune.icon
    elseif asset.type == 6 then
        local t_pet = Config.get_config_value("t_pet", asset.value1)
        return "pet", t_pet.icon
    end
end

---自适应
function GameSys.ScreenSca(trans)
    local screen_resolution = {
        x = Screen.width,
        y = Screen.height
    }

    local canvas_base_size = {
        x = 640,
        y = 1136
    }
    local size = GUIRoot.UICamera.orthographicSize
    local camera_size = {
        x = size * 2 * 100 * (screen_resolution.x / screen_resolution.y),
        y = size * 2 * 100
    }
    local base_scale = math.min(camera_size.x / canvas_base_size.x, camera_size.y / canvas_base_size.y)
    local scale_x = camera_size.x / canvas_base_size.x
    local old_scale = trans.localScale
    local new_scale = Vector3(old_scale.x / base_scale * scale_x, old_scale.y / base_scale * scale_x, 1)
    trans.localScale = new_scale
end

---自适应描述类文本的高度
function GameSys.AdjustDescTextHeight(text_rect)
    local per_height = LayoutUtility.GetPreferredHeight(text_rect)
    local y = text_rect.sizeDelta.y
    if per_height > y then
        text_rect.sizeDelta = Vector2(text_rect.sizeDelta.x, per_height)
        return per_height
    end
    return y
end

---可滑动的详情界面的高度自适应设置
function GameSys.AdjustDetailBack(content, detail, among, back)
    LayoutRebuilder.ForceRebuildLayoutImmediate(content)
    local h =  LayoutUtility.GetPreferredHeight(content)
    detail.sizeDelta = Vector2(detail.sizeDelta.x, h + 20)

    LayoutRebuilder.ForceRebuildLayoutImmediate(among)
    local h =  LayoutUtility.GetPreferredHeight(among)
    if h > 940 then
        local sub = h - 940
        detail.sizeDelta = Vector2(detail.sizeDelta.x,  detail.sizeDelta.y - sub)
        LayoutRebuilder.ForceRebuildLayoutImmediate(among)
        h = 940
    end
    back.sizeDelta = Vector2(back.sizeDelta.x, h)
end

---button toggle 注册
function GameSys.ButtonRegister(lua_, obj, type, fun_, param, event_trigger)
    if event_trigger == nil then
        event_trigger = true
    end
    if type == "click" then
        lua_:AddButtonEvent(obj.gameObject, type, function (obj, param)
            fun_(obj, param)
            GUIRoot.ShowPanel("TouchPanel", { Input.mousePosition })
        end, param)
        if event_trigger then
            lua_:AddCustomButtonEvent(obj.gameObject, "down", function(obj1, param1, event_data)
                soundMgr:play_sound("button")
                obj1:GetComponent("RectTransform"):DOScale(Vector3(1.1, 1.1, 1.1), 0.1)
                end)
            lua_:AddCustomButtonEvent(obj.gameObject, "up", function(obj1, param1, event_data)
                obj1:GetComponent("RectTransform"):DOScale(Vector3(1, 1, 1), 0.1)
            end)
        end
    elseif type == "toggle" then
        lua_:AddButtonEvent(obj.gameObject, type, function (obj,bool, param)
            fun_(obj,bool, param)
            GUIRoot.ShowPanel("TouchPanel", { Input.mousePosition })
        end, param)
        lua_:AddDownEvent(obj.gameObject, function(obj1, param1)
            soundMgr:play_sound("button")
        end)
    end
end

---scrollRect 提示箭头按钮设置
function GameSys.SetScrollArrow(scroll_rect, arrow_btn, lua_script)
    local view_rect = scroll_rect.viewport
    local content_rect = scroll_rect.content
    LayoutRebuilder.ForceRebuildLayoutImmediate(content_rect)
    local content_height_ = LayoutUtility.GetPreferredHeight(content_rect)
    local view_height = view_rect:GetComponent("RectTransform").rect.height
    local need_scroll_arrow = content_height_ > view_height
    arrow_btn.gameObject:SetActive(need_scroll_arrow)
    if need_scroll_arrow then
        arrow_btn.transform.localScale = Vector3.one
    end
    GameSys.ButtonRegister(lua_script, arrow_btn.gameObject, "click", function(obj, params)
        if not need_scroll_arrow then
            return
        end
        local y = arrow_btn.transform.localScale.y
        if y > 0 then
            scroll_rect.verticalNormalizedPosition = 0
            arrow_btn.transform.localScale = Vector3(1, -1, 1)
        else
            scroll_rect.verticalNormalizedPosition = 1
            arrow_btn.transform.localScale = Vector3(1, 1, 1)
        end
    end, nil, false)
    lua_script:AddScrollViewEvent(scroll_rect.gameObject, function(obj, changed, params)
        if changed.y <= 0.1 then
            arrow_btn.transform.localScale = Vector3(1, -1, 1)
        elseif changed.y >= 0.9 then
            arrow_btn.transform.localScale = Vector3(1, 1, 1)
        end
    end, nil)
    return need_scroll_arrow
end
---设置recttransform的高
function GameSys.SetRectHeight(rect, height)
    rect.sizeDelta = Vector2(rect.sizeDelta.x, height)
end
---设置父节点下所有text的颜色
function GameSys.SetSubTextColor(root, color_str)
    local texts = root:GetComponentsInChildren(typeof(UnityEngine.UI.Text), true)
    local count = texts.Length
    local b, color = ColorUtility.TryParseHtmlString(color_str, nil)
    for i = 0, count - 1 do
        texts[i].color = color
    end
end
---设置text组件的颜色
function GameSys.SetTextControlColor(text_control, color_str)
    local text = text_control:GetComponent("Text")
    local b, color = ColorUtility.TryParseHtmlString(color_str, nil)
    text.color = color
end
----------------------------数据相关----------------------------

function GameSys.GetCheckData()
    local check_data = PlayerData.player:SerializeToString()
    local temp_equips = GameSys.re_data(PlayerData.equips)
    for i = 1, #temp_equips do
        check_data = check_data .. PlayerData.equips[temp_equips[i]]:SerializeToString()
    end
    local temp_pets = GameSys.re_data(PlayerData.pets)
    for i = 1, #temp_pets do
        check_data = check_data .. PlayerData.pets[temp_pets[i]]:SerializeToString()
    end
    return check_data
end

function GameSys.Check_data_Sort_(a, b)
    return a < b
end

function GameSys.re_data(table_)
    local table_temp = {}
    for k, v in pairs(table_) do
        table.insert(table_temp, k)
    end
    if #table_temp > 1 then
        table.sort(table_temp, GameSys.Check_data_Sort_)
    end
    return table_temp
end

function GameSys.DailyRed()
    for _, v in pairs(Config.t_daily) do
        if v.unlock_type == 1 then
            if PlayerData.player.level >= v.unlock_param then
                if not GameSys.isTaskGet(v.id) and GameSys.isTaskComplete(v.id, v.num) then
                    return true
                end
            end
        elseif v.unlock_type == 2 then
            if QuestManger.NeedOverCondition(v.unlock_param) then
                if not GameSys.isTaskGet(v.id) and GameSys.isTaskComplete(v.id, v.num) then
                    return true
                end
            end
        elseif v.unlock_type == 3 then
            if QuestManger.NeedHasCondition(v.unlock_param) then
                if not GameSys.isTaskGet(v.id) and GameSys.isTaskComplete(v.id, v.num) then
                    return true
                end
            end
        end
    end

    for k, v in pairs(Config.t_daily_reward) do
        if GameSys.hasInTable(PlayerData.player.daily_rewards, k) then

        elseif k <= GameSys.GetDayRewardPoint() then
            return true
        else

        end
    end
    return false
end

function GameSys.GetDayRewardPoint()
    local point_t = 0
    for k,v in pairs(Config.t_daily) do
        local index = GameSys.getIndex(PlayerData.player.daily_ids, v.id)
        if index ~= nil then
            if PlayerData.player.daily_reaches[index] == 1 then
                if v.num <= PlayerData.player.daily_nums[index] then
                    point_t = point_t + v.point
                end
            end
        end
    end
    return point_t
end

function GameSys.isTaskGet(id)
    for i = 1, #PlayerData.player.daily_ids do
        if PlayerData.player.daily_ids[i] == id then
            if PlayerData.player.daily_reaches[i] >= 1 then
                return true
            end
        end
    end
    return false
end

function GameSys.isTaskComplete(id, num)
    for i = 1, #PlayerData.player.daily_ids do
        if PlayerData.player.daily_ids[i] == id then
            if PlayerData.player.daily_nums[i] >= num then
                return true
            end
        end
    end
    return false
end

---------------------权重随机-------------------------------------------

function GameSys.RandomWeight(param)
    local temp = param
    for i = 2, #temp do
        temp[i] = temp[i] + temp[i - 1]
    end
    local random_num = math.random(temp[#temp])
    local temp_sum = 0
    for i = 1, #temp do
        temp_sum = temp_sum + temp[i]
        if random_num <= temp_sum then
            return i
        end
    end
    return 1
end

function GameSys.QyRandom()
    local qiyu_rate = Config.get_config_value("t_const", "qiyu_rate").value
    local random_qiyu = { qiyu_rate, 100 - qiyu_rate }
    local meed_qiyu = GameSys.RandomWeight(random_qiyu)
    if meed_qiyu == 1 then
        return true
    end
    return false
end

function GameSys.Rotation(a, b, p)
    local c = { b[1] - a[1], b[2] - a[2] }
    local rad = math.atan2(c[2], c[1])
    local angle = rad / math.pi * 180
    return math.floor(angle) + p
end


-----跳转控制器-----

GameSys.jump_info = {
    ["can_jump"] = true,
    ["use_count"] = 0
}

function GameSys.SwitchJump(can_jump)
    if can_jump then
        GameSys.jump_info.use_count = GameSys.jump_info.use_count - 1
        if GameSys.jump_info.use_count <= 0 then
            GameSys.jump_info.use_count = 0
            GameSys.jump_info.can_jump = true
        end
    else
        GameSys.jump_info.use_count = GameSys.jump_info.use_count + 1
        if GameSys.jump_info.use_count > 0 then
            GameSys.jump_info.can_jump = false
        end
    end
end

function GameSys.PanelJump(get_id)
    if not GameSys.jump_info.can_jump then
        return
    end
    local t_get = Config.get_config_value("t_get", get_id)
    if (t_get.get_unlock == 1 and PlayerData.player.level < t_get.get_param) or (t_get.get_unlock == 2 and not QuestManger.NeedOverCondition(t_get.get_param)) or (t_get.get_unlock == 3 and not QuestManger.NeedHasCondition(t_get.get_param)) then
        GUIRoot.ShowPanel("MessagePanel", {"未解锁"})
    else
        if t_get.outside == 1 or t_get.outside == -1 then
            if PlayerData.player.in_map == 0 then

            else
                GUIRoot.ShowPanel("MessagePanel", {"请回到城堡"})
                return
            end
        end
        for k in pairsByKeys(GUIRoot.game_guis) do
            if k == t_get.panel then
                GUIRoot.ShowPanel("MessagePanel", {"已经打开界面"})
                return
            end
        end

        if t_get.panel == "PortalPanel" then
            timerMgr:AddTimer("Yc_daily", function ()
                for k in pairsByKeys(GUIRoot.game_guis) do
                    if k ~= "TopResPanel" and k ~= "BasicUIPanel" then
                        GUIRoot.ClosePanel(k)
                    end
                end
            end , {}, 0.7)
            GUIRoot.ShowPanel("LoadingPanel", {function (params)
                GUIRoot.ShowPanel(t_get.panel)
            end, nil})
        else
            for k in pairsByKeys(GUIRoot.game_guis) do
                if k ~= "TopResPanel" and k ~= "BasicUIPanel" then
                    GUIRoot.ClosePanel(k)
                end
            end

            if t_get.panel_param ~= -1 then
                GUIRoot.ShowPanel(t_get.panel, {t_get.panel_param})
            else
                GUIRoot.ShowPanel(t_get.panel)
            end
        end
    end
end

function GameSys.GoodPrice(goods_table, add_num)
    if goods_table.price_table ~= 0 then
        local t_price = Config.get_config_value("t_price", goods_table.price_table)
        if t_price ~= nil then
            local price = 0
            for i = 1, #PlayerData.player.shop_ids do
                if PlayerData.player.shop_ids[i] == goods_table.id then
                    local begin_num = PlayerData.player.shop_nums[i]
                    for j = begin_num + 1, begin_num + add_num do
                        if t_price.price[j] ~= nil then
                            price = price + t_price.price[j].value
                        else
                            price = price + t_price.price[#t_price.price].value
                        end
                    end
                    return price
                end
            end
            if price == 0 then
                for j = 1, add_num do
                    if t_price.price[j] ~= nil then
                        price = price + t_price.price[j].value
                    else
                        price = price + t_price.price[#t_price.price].value
                    end
                end
                return price
            end
        end
    end
    return goods_table.price_value2 * add_num
end
