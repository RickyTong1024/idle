Config = {}
Config = {}

Config.t_arena_reward = {}
Config.t_artifact = {}
Config.t_attr = {}
Config.t_avatar = {}
Config.t_class = {}
Config.t_color = {}
Config.t_const = {}
Config.t_daily = {}
Config.t_daily_reward = {}
Config.t_director = {}
Config.t_dungeon = {}
Config.t_dungeon_dialog = {}
Config.t_dungeon_event = {}
Config.t_dungeon_passive = {}
Config.t_equip = {}
Config.t_equip_enhance = {}
Config.t_equip_enchant = {}
Config.t_equip_discompose = {}
Config.t_equip_draw = {}
Config.t_equip_random = {}
Config.t_equip_random_rate = {}
Config.t_equip_level_name = {}
Config.t_error = {}
Config.t_item = {}
Config.t_forge = {}
Config.t_get = {}
Config.t_lang = {}
Config.t_level = {}
Config.t_localization = {}
Config.t_map = {}
Config.t_map_port = {}
Config.t_map_build = {}
Config.t_mission = {}
Config.t_mission_mine = {}
Config.t_mission_random = {}
Config.t_monster = {}
Config.t_npc = {}
Config.t_name = {}
Config.t_narrator = {}
Config.t_pet = {}
Config.t_pet_level = {}
Config.t_pet_talent = {}
Config.t_pet_enhance = {}
Config.t_price = {}
Config.t_quest_sub = {}
Config.t_quest = {}
Config.t_role = {}
Config.t_role_reputation = {}
Config.t_resource = {}
Config.t_recharge = {}
Config.t_rune = {}
Config.t_rune_num = {}
Config.t_tower = {}
Config.t_sign = {}
Config.t_shop = {}
Config.t_spell = {}
Config.t_spell_level = {}
Config.t_spell_buff = {}
Config.t_spell_passive = {}
Config.t_unlock = {}

function Config.Init()
    Config.parse_config(Config.t_lang, "t_lang")
    Config.parse_config(Config.t_lang, "t_lang_director")
    Config.parse_config(Config.t_error, "t_error")
    Config.parse_config(Config.t_localization, "t_localization")

    Config.parse_config(Config.t_arena_reward, "t_arena_reward")
    Config.parse_config(Config.t_artifact, "t_artifact")
    Config.parse_config(Config.t_attr, "t_attr")
    Config.parse_config(Config.t_avatar, "t_avatar")
    Config.parse_config(Config.t_class, "t_class")
    Config.parse_config(Config.t_color, "t_color")
    Config.parse_config(Config.t_const, "t_const")
    Config.parse_config(Config.t_daily, "t_daily")
    Config.parse_config(Config.t_daily_reward, "t_daily_reward")
    Config.parse_config(Config.t_director, "t_director")
    Config.parse_config(Config.t_dungeon, "t_dungeon")
    Config.parse_config(Config.t_dungeon_event, "t_dungeon_event")
    Config.parse_config(Config.t_dungeon_dialog, "t_dungeon_dialog")
    Config.parse_config(Config.t_dungeon_passive, "t_dungeon_passive")
    Config.parse_config(Config.t_equip, "t_equip")
    Config.parse_config(Config.t_equip_discompose, "t_equip_discompose")
    Config.parse_config(Config.t_equip_draw, "t_equip_draw")
    Config.parse_config(Config.t_equip_enchant, "t_equip_enchant")
    Config.parse_config(Config.t_equip_enhance, "t_equip_enhance")
    Config.parse_config(Config.t_equip_random, "t_equip_random")
    Config.parse_config(Config.t_equip_random_rate, "t_equip_random_rate")
    Config.parse_config(Config.t_equip_level_name, "t_equip_level_name")
    Config.parse_config(Config.t_forge, "t_forge")
    Config.parse_config(Config.t_get, "t_get")
    Config.parse_config(Config.t_item, "t_item")
    Config.parse_config(Config.t_level, "t_level")
    Config.parse_config(Config.t_map, "t_map")
    Config.parse_config(Config.t_map_build, "t_map_build")
    Config.parse_config(Config.t_map_port, "t_map_port")
    Config.parse_config(Config.t_mission, "t_mission")
    Config.parse_config(Config.t_mission_mine, "t_mission_mine")
    Config.parse_config(Config.t_mission_random, "t_mission_random")
    Config.parse_config(Config.t_monster, "t_monster")
    Config.parse_config(Config.t_npc, "t_npc")
    Config.parse_config(Config.t_name, "t_name")
    Config.parse_config(Config.t_narrator, "t_narrator")
    Config.parse_config(Config.t_pet, "t_pet")
    Config.parse_config(Config.t_pet_enhance, "t_pet_enhance")
    Config.parse_config(Config.t_pet_talent, "t_pet_talent")
    Config.parse_config(Config.t_price, "t_price")
    Config.parse_config(Config.t_quest, "t_quest")
    Config.parse_config(Config.t_quest_sub, "t_quest_sub")
    Config.parse_config(Config.t_recharge, "t_recharge")
    Config.parse_config(Config.t_resource, "t_resource")
    Config.parse_config(Config.t_role, "t_role")
    Config.parse_config(Config.t_role_reputation, "t_role_reputation")
    Config.parse_config(Config.t_rune, "t_rune")
    Config.parse_config(Config.t_rune_num, "t_rune_num")
    Config.parse_config(Config.t_shop, "t_shop")
    Config.parse_config(Config.t_sign, "t_sign")
    Config.parse_config(Config.t_spell, "t_spell")
    Config.parse_config(Config.t_spell_buff, "t_spell_buff")
    Config.parse_config(Config.t_spell_level, "t_spell_level")
    Config.parse_config(Config.t_spell_passive, "t_spell_passive")
    Config.parse_config(Config.t_tower, "t_tower")
    Config.parse_config(Config.t_unlock, "t_unlock")
end
-------------- t_parse_config --------------
function Config.parse_config(t_datas, text)
    local dbc_config = dbc.New()
    local txt_data = resMgr.LoadTxt(text);
    dbc_config:load_txt(txt_data)
    local indexs = {}
    for j = 0, dbc_config:get_x() - 1 do
        local aname = dbc_config:get_string(j, -1)
        if aname ~= "" then
            if string.find(aname, "%*") ~= nil then
                aname = string.sub(aname, 2, -1)
                table.insert(indexs, aname)
            end
        end
    end

    for i = 0, dbc_config:get_y() - 1 do
        local t_data = {}
        for j = 0, dbc_config:get_x() - 1 do
            local tp = dbc_config:get_string(j, -2)
            local aname = dbc_config:get_string(j, -1)
            local data
            if aname ~= "" then
                local is_none, data = Config.get_value(tp, j, i, dbc_config)
                if string.find(aname, "%*") ~= nil then
                    aname = string.sub(aname, 2, -1)
                end
                if string.find(aname, "#") ~= nil then
                    aname = string.sub(aname, 2, -1)
                    data = Config.get_t_lang(data)
                end
                if string.find(aname, "%.") ~= nil then
                    local names = GameSys.split(aname, "%.")
                    aname = names[1]
                    if t_data[aname] == nil then
                        t_data[aname] = {}
                        t_data[aname]["indexes"] = {}
                    end
                    local index = tonumber(names[2])
                    local t_sub = t_data[aname]
                    local tindex = -1
                    for k = 1, #t_sub["indexes"] do
                        if t_sub["indexes"][k] == index then
                            tindex = k
                        end
                    end
                    if tindex == -1 and not is_none then
                        table.insert(t_sub["indexes"], index)
                        table.insert(t_sub, {})
                        tindex = #t_sub["indexes"]
                    end
                    if tindex ~= -1 then
                        t_sub[tindex][names[3]] = data
                    end
                else
                    t_data[aname] = data
                end
            end
        end

        local datas = t_datas
        for j = 1, #indexs do
            local idata = t_data[indexs[j]]
            if j < #indexs then
                if datas[idata] == nil then
                    datas[idata] = {}
                end
                datas = datas[idata]
            else
                datas[idata] = t_data
            end
        end
        if #indexs == 0 then
            table.insert(t_datas, t_data)
        end
    end
end

function Config.get_value(_tyep, x, y, dbc_conf)
    if _tyep == "STRING" then
        if dbc_conf:get_string(x, y) == "" then
            return true, ""
        end
        return false, dbc_conf:get_string(x, y)
    else
        if dbc_conf:get_string(x, y) == "" then
            return true, 0
        end
        return false, tonumber(dbc_conf:get_string(x, y))
    end


end

------------- 通用获取数据 ---------------------------
function Config.get_config_value(t, ...)
    local conf = Config[t]
    for i = 1, select('#', ...) do
        local b = conf[select(i, ...)]
        if b == nil then
            return nil
        else
            conf = b
        end
    end
    return conf
end
--------------------------------------------------------
-----------特殊-----------------
------------------- lang ----------------

function Config.get_t_lang(id)
    if Config.t_lang[id] == nil then
        return ""
    else
        local lang_type = platform_config_common.lang
        if lang_type == 1 then
            return Config.t_lang[id].c0
        elseif lang_type == 3 then
            return Config.t_lang[id].c1
        else
            return Config.t_lang[id].c0
        end
    end
end

function Config.get_Text_lang(id)
    if Config.t_localization[id] == nil then
        return ""
    else
        return Config.t_localization[id].c0
    end
end