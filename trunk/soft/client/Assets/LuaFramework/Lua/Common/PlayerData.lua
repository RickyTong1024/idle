PlayerData = {}

PlayerData.last_time = 0
PlayerData.login_info = nil
PlayerData.re_connect_code = nil
PlayerData.player = nil
PlayerData.equips = {}
PlayerData.pets = {}
PlayerData.mails = {}
PlayerData.cur_power = 0
PlayerData.cur_attr = nil

function PlayerData.Init(message)
    local msg
    if PlayerData.re_connect_code == nil then
        msg = player_msg_pb.smsg_login_player()
        msg:ParseFromString(message.luabuff)
        PlayerData.re_connect_code = msg.code
    else
        msg = player_msg_pb.smsg_reconnection()
        msg:ParseFromString(message.luabuff)
    end

    timerMgr:set_server_time(msg.time_now)
    PlayerData.last_time = timerMgr:now()
    PlayerData.player = msg.player
    for i = 1, #msg.equips do
        PlayerData.equips[msg.equips[i].guid] = msg.equips[i]
    end
    for i = 1, #msg.pets do
        PlayerData.pets[msg.pets[i].guid] = msg.pets[i]
    end
    QuestManger.Init()
    RechargeManger.Init()
    LRandom.Seed(PlayerData.player.seed)
    PlayerData.cur_power = PlayerData.get_fight_power()
    PlayerData.cur_attr = PlayerData.get_attr()
end

function PlayerData.player_refresh(msg)
    PlayerData.add_assets(msg.assets)
    PlayerData.player.last_refresh_time = msg.refresh_time
    PlayerData.player.is_checked = 0
    PlayerData.player.task_num = 0
    for i = #PlayerData.player.daily_ids, 1, -1 do
        table.remove(PlayerData.player.daily_ids, i)
        table.remove(PlayerData.player.daily_nums, i)
        table.remove(PlayerData.player.daily_reaches, i)
    end
    for i = #PlayerData.player.daily_rewards, 1, -1 do
        table.remove(PlayerData.player.daily_rewards, i)
    end
    for i = #PlayerData.player.shop_ids, 1, -1 do
        table.remove(PlayerData.player.shop_ids, i)
        table.remove(PlayerData.player.shop_nums, i)
    end

    -- 刷新竞技场
    local t_arena_reward = Config.get_config_value('t_arena_reward', PlayerData.player.arena_segment)
    if PlayerData.player.arena_integral > t_arena_reward.score then
        PlayerData.arena_refresh(t_arena_reward.next)
    else
        PlayerData.arena_refresh(PlayerData.player.arena_segment)
    end

    local common_msg = CommonMessage()
    common_msg.name = "refresh_day"
    messMgr:AddCommonMessage(common_msg)
end

function PlayerData.player_refresh_week()
    PlayerData.player.last_refresh_week_time = timerMgr:now()

    -- 刷新竞技场
    local t_arena_reward = Config.get_config_value('t_arena_reward', PlayerData.player.arena_segment)
    PlayerData.arena_refresh(t_arena_reward.season_end_segment)
end

function PlayerData.player_refresh_month()
    PlayerData.player.last_refresh_month_time = timerMgr:now()
end

function PlayerData.add_assets(assets, show)
    for i = 1, #assets.assets do
        PlayerData.add_asset(assets.assets[i], show)
    end

    for i = 1, #assets.equips do
        PlayerData.add_equip(assets.equips[i], show)
    end
    for i = 1, #assets.pets do
        PlayerData.add_pet(assets.pets[i], show)
    end
    for i = 1, #assets.mails do
        PlayerData.add_mail(assets.mails[i], show)
    end
end

function PlayerData.remove_assets(assets)
    for i = 1, #assets.assets do
        PlayerData.remove_asset(assets.assets[i])
    end
    for i = 1, #assets.equips do
        PlayerData.remove_equip(assets.equips[i])
    end
    for i = 1, #assets.pets do
        PlayerData.remove_pet(assets.pets[i])
    end
    for i = 1, #assets.mails do
        PlayerData.remove_mail(assets.mails[i])
    end
end

function PlayerData.add_asset(asset, show)
    if asset.type == 1 then
        PlayerData.add_resource(asset.value1, asset.value2, show)
    elseif asset.type == 2 then
        PlayerData.add_item(asset.value1, asset.value2, show)
    elseif asset.type == 4 then
        PlayerData.add_artifact(asset.value1, asset.value2, show)
    elseif asset.type == 5 then
        PlayerData.add_rune(asset.value1, asset.value2, show)
    end
end

function PlayerData.remove_asset(asset)
    if asset.type == 1 then
        PlayerData.add_resource(asset.value1, -asset.value2)
    elseif asset.type == 2 then
        PlayerData.remove_item(asset.value1, asset.value2)
    elseif asset.type == 4 then
        PlayerData.remove_artifact(asset.value1, asset.value2)
    elseif asset.type == 5 then
        PlayerData.remove_rune(asset.value1, asset.value2)
    end
end

function PlayerData.add_resource(resource_id, num, show)
    if resource_id == 1 then
        PlayerData.player.gold = PlayerData.player.gold + num
        AssetsChangeControl.OnGoldChanged()
    elseif resource_id == 2 then
        PlayerData.player.jewel = PlayerData.player.jewel + num
        AssetsChangeControl.OnJewelChanged()
    elseif resource_id == 3 then
        PlayerData.player.exp = PlayerData.player.exp + num
        PlayerData.upgrade()
    elseif resource_id == 4 then
        PlayerData.player.honor = PlayerData.player.honor + num
        AssetsChangeControl.OnHonorChanged()
    elseif resource_id == 5 then
        PlayerData.player.reputation = PlayerData.player.reputation + num
        AssetsChangeControl.OnReputationChanged()
    end
    if num > 0 and show == nil then
        GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 1, value1 = resource_id, value2 = num, value3 = 0}})
    end
end

function PlayerData.add_item(item_id, num, show)
    for i = 1, #PlayerData.player.item_ids do
        if PlayerData.player.item_ids[i] == item_id then
            PlayerData.player.item_nums[i] = PlayerData.player.item_nums[i] + num
            AssetsChangeControl.OnItemChanged(item_id, num)
            if show == nil then
                GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 2, value1 = item_id, value2 = num, value3 = 0}})
            end
            return
        end
    end
    table.insert(PlayerData.player.item_ids, item_id)
    table.insert(PlayerData.player.item_nums, num)
    AssetsChangeControl.OnItemChanged(item_id, num)
    if show == nil then
        GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 2, value1 = item_id, value2 = num, value3 = 0}})
    end
end

function PlayerData.remove_item(item_id, num)
    for i = 1, #PlayerData.player.item_ids do
        if PlayerData.player.item_ids[i] == item_id then
            if PlayerData.player.item_nums[i] == num then
                -- PlayerData.player.item_ids[i] = PlayerData.player.item_ids[#PlayerData.player.item_ids]
                table.remove(PlayerData.player.item_ids, i)
                -- PlayerData.player.item_nums[i] = PlayerData.player.item_nums[#PlayerData.player.item_nums]
                table.remove(PlayerData.player.item_nums, i)
                AssetsChangeControl.OnItemChanged(item_id, num)
            else
                PlayerData.player.item_nums[i] = PlayerData.player.item_nums[i] - num
                AssetsChangeControl.OnItemChanged(item_id, num)
            end
            return
        end
    end
end

function PlayerData.add_equip(equip, show)
    PlayerData.equips[equip.guid] = equip
    local min_color, max_color = GameSys.GetEquipColorRange()
    if equip.color == max_color and not GameSys.hasInTable(PlayerData.player.equip_dresses, equip.template_id) then
        GUIRoot.ShowPanel("UnlockPanel", { { equip.template_id }, UnlockPanel.SHOW_TYPE.unlock_equip_book })
        table.insert(PlayerData.player.equip_dresses, equip.template_id)
        table.insert(PlayerData.player.equip_dresses_unlock, 0)
        AssetsChangeControl.OnDressChanged(equip.template_id)
    end
    local can_get_equip = GameSys.CanGetEquipNum()
    if can_get_equip <= 5 and can_get_equip > 0  then
        GUIRoot.ShowPanel("MessagePanel", {"背包内装备数量即将达到上限,请及时清理"})
    end
    AssetsChangeControl.OnEquipChanged(equip, 1)
    if show == nil then
        GUIRoot.ShowPanel("MessagePanel", {"equip", equip})
    end
end


function PlayerData.remove_equip(equip)
    PlayerData.equips[equip.guid] = nil
    AssetsChangeControl.OnEquipChanged(equip, 0)
end

function PlayerData.add_artifact(artifact_id, num, show)
    if num == 1 then
        -- 已拥有
        for i = 1, #PlayerData.player.artifact_ids do
            if PlayerData.player.artifact_ids[i] == artifact_id then
                if PlayerData.player.artifact_nums[i] == 0 then
                    PlayerData.player.artifact_nums[i] = 1
                    if PlayerData.player.artifact_nums[i] == 1 then

                        AssetsChangeControl.OnArtifactChanged(artifact_id, 1)
                        if show == nil then
                            GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 4, value1 = artifact_id, value2 = 1, value3 = 0}})
                        end

                    end
                end
                return
            end
        end
    elseif num == 0 then
        -- 可以打造
        if not GameSys.hasInTable(PlayerData.player.artifact_ids, artifact_id) then
            table.insert(PlayerData.player.artifact_ids, artifact_id)
            table.insert(PlayerData.player.artifact_nums, num)
            table.insert(PlayerData.player.artifact_unlocks, 0)
            AssetsChangeControl.OnArtifactChanged(artifact_id, 0)
            GUIRoot.ShowPanel("UnlockPanel", { { artifact_id }, UnlockPanel.SHOW_TYPE.unlock_artifact_book })
            if show == nil then
                GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 4, value1 = artifact_id, value2 = 1, value3 = 0}})
            end
        end
    end
end

function PlayerData.remove_artifact(artifact_id, num)
    for i = 1, #PlayerData.player.artifact_ids do
        if PlayerData.player.artifact_ids[i] == artifact_id then
            if PlayerData.player.artifact_nums[i] == num then
                PlayerData.player.artifact_ids[i] = PlayerData.player.artifact_ids[#PlayerData.player.artifact_ids]
                table.remove(PlayerData.player.artifact_ids)
                PlayerData.player.artifact_nums[i] = PlayerData.player.artifact_nums[#PlayerData.player.artifact_nums]
                table.remove(PlayerData.player.artifact_nums)
                AssetsChangeControl.OnArtifactChanged(artifact_id, -1)
            end
            return
        end
    end
end

function PlayerData.add_rune(rune_id, num, show)
    for i = 1, #PlayerData.player.rune_ids do
        if PlayerData.player.rune_ids[i] == rune_id then
            PlayerData.player.rune_nums[i] = PlayerData.player.rune_nums[i] + num
            AssetsChangeControl.OnRuneChanged(rune_id, num)
            if show == nil then
                GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 5, value1 = rune_id, value2 = num, value3 = 0}})
            end
            return
        end
    end
    table.insert(PlayerData.player.rune_ids, rune_id)
    table.insert(PlayerData.player.rune_nums, num)
    AssetsChangeControl.OnRuneChanged(rune_id, num)
    if show == nil then
        GUIRoot.ShowPanel("MessagePanel", {"asset", {type = 5, value1 = rune_id, value2 = num, value3 = 0}})
    end
end

function PlayerData.remove_rune(rune_id, num)
    for i = 1, #PlayerData.player.rune_ids do
        if PlayerData.player.rune_ids[i] == rune_id then
            if PlayerData.player.rune_nums[i] == num then
                PlayerData.player.rune_ids[i] = PlayerData.player.rune_ids[#PlayerData.player.rune_ids]
                table.remove(PlayerData.player.rune_ids)
                PlayerData.player.rune_nums[i] = PlayerData.player.rune_nums[#PlayerData.player.rune_nums]
                table.remove(PlayerData.player.rune_nums)
                AssetsChangeControl.OnRuneChanged(rune_id, -num)
            else
                PlayerData.player.rune_nums[i] = PlayerData.player.rune_nums[i] - num
                AssetsChangeControl.OnRuneChanged(rune_id, -num)
            end
            return
        end
    end

end

function PlayerData.add_pet(pet, show)
    table.insert(PlayerData.player.pet_ids, pet.template_id)
    table.insert(PlayerData.player.pet_unlocks, 0)
    PlayerData.pets[pet.guid] = pet
    AssetsChangeControl.OnPetChanged(pet, 1)
    if show == nil then
        GUIRoot.ShowPanel("MessagePanel", {"pet", pet})
    end
end

function PlayerData.remove_pet(pet)
    PlayerData.pets[pet.guid] = nil
    AssetsChangeControl.OnPetChanged(pet, 0)
end

function PlayerData.add_mail(mail)
    PlayerData.mails[mail.guid] = mail
    AssetsChangeControl.OnMailChanged()
end

function PlayerData.remove_mail(mail)
    PlayerData.mails[mail.guid] = nil
    AssetsChangeControl.OnMailChanged()
end

function PlayerData.upgrade()
    local up = false
    while true do
        local t_level = Config.get_config_value("t_level", PlayerData.player.level + 1)
        if t_level == nil then
            return
        end

        if PlayerData.player.exp >= t_level.exp then
            up = true
            PlayerData.player.level = PlayerData.player.level + 1
            PlayerData.player.exp = PlayerData.player.exp - t_level.exp

        else
            if up then
                PlayerData.upgrade_operating()

                local common_msg = CommonMessage()
                common_msg.name = "check_power"
                messMgr:AddCommonMessage(common_msg)

                local common_msg3 = CommonMessage()
                common_msg3.name = "level_up"
                messMgr:AddCommonMessage(common_msg3)

                AssetsChangeControl.OnLevelChanged(PlayerData.player.level)
            end
            AssetsChangeControl.OnExpChanged()
            return
        end
    end
end

-- 扣除经验
function PlayerData.ReduceExp()
    local die_reduce_exp = Config.get_config_value('t_const', 'die_reduce_exp').value
    local t_level = Config.get_config_value('t_level', PlayerData.player.level + 1)
    if t_level ~= nil then
        local exp = toInt(t_level.exp * die_reduce_exp / 100)
        if exp > PlayerData.player.exp then
            exp = PlayerData.player.exp
        end
        PlayerData.add_resource(3, -exp)
        return exp
    end
    return 0
end

function PlayerData.pet_add_exp(pet, exp)
    pet.exp = pet.exp + exp
    PlayerData.pet_upgrade(pet)
end

function PlayerData.pet_upgrade(pet)
    local is_up = false
    while true do
        local t_level = Config.get_config_value("t_level", pet.level + 1)
        local t_pet_enhance = Config.get_config_value("t_pet_enhance", pet.enhance + 1)
        if t_pet_enhance ~= nil then
            if pet.level >= t_pet_enhance.level then
                pet.level = t_pet_enhance.level
                pet.exp = 0
                return
            end
        end
        if t_level == nil then
            pet.exp = 0
            return
        end
        if pet.exp >= t_level.pet_exp then
            pet.level = pet.level + 1
            is_up = true
            pet.exp = pet.exp - t_level.pet_exp
        else
            if is_up then
                AssetsChangeControl.OnPetLevelChanged(pet)
            end
            return
        end
    end
end

function PlayerData.upgrade_operating()
end

-- 获取玩家属性
function PlayerData.get_attr()
    local attr = {}
    for attr_id in pairs(Config.t_attr) do
        attr[attr_id] = 0
    end
    -- local t_class = Config.get_config_value("t_class", 1)

    for i = 1, 4 do
        attr[i] = PlayerData.get_level_value(PlayerData.player.level, i) * 5
    end
    for i = 11, 16 do
        attr[i] = PlayerData.get_level_value(PlayerData.player.level, i)
    end

    for i = 1, #PlayerData.player.equip_slots do
        if PlayerData.player.equip_slots[i] ~= '0' then
            local equip = PlayerData.equips[PlayerData.player.equip_slots[i]]
            local enhance = PlayerData.player.equip_enhances[i]
            if equip == nil then
                PlayerData.player.equip_slots[i] = '0'
            else
                -- 主属性
                local t_equip = Config.get_config_value('t_equip', equip.template_id)
                if enhance > t_equip.enhance_limit then
                    enhance = t_equip.enhance_limit
                end
                local t_attr = Config.get_config_value("t_attr", t_equip.attr)
                local base_value = PlayerData.get_equip_enhance_value(equip.value, enhance)
                attr[t_equip.attr] = attr[t_equip.attr] + base_value


                -- 附魔属性
                local t_equip_enchant = Config.get_config_value('t_equip_enchant', equip.enchant_id)
                if t_equip_enchant ~= nil then
                    t_attr = Config.get_config_value('t_attr', t_equip_enchant.attr)
                    if t_attr ~= nil then
                        attr[t_equip_enchant.attr] = attr[t_equip_enchant.attr] + GameSys.GetEquipEnchantValue(equip).value
                    end
                end

                -- 重铸属性
                for j = 1, #equip.attr_ids do
                    if equip.attr_types[j] == 1 then
                        attr[equip.attr_ids[j]] = attr[equip.attr_ids[j]] + PlayerData.get_equip_enhance_value(equip.attr_values[j], enhance)
                    end
                end

                -- 宝石属性
                if PlayerData.player.rune_slot1s[i] ~= 0 then
                    local t_rune = Config.get_config_value('t_rune', PlayerData.player.rune_slot1s[i])
                    if t_rune ~= nil then
                        attr[t_rune.attr_id] = attr[t_rune.attr_id] + t_rune.attr_value
                    end
                end
                if PlayerData.player.rune_slot2s[i] ~= 0 then
                    local t_rune = Config.get_config_value('t_rune', PlayerData.player.rune_slot2s[i])
                    if t_rune ~= nil then
                        attr[t_rune.attr_id] = attr[t_rune.attr_id] + t_rune.attr_value
                    end
                end
                if PlayerData.player.rune_slot3s[i] ~= 0 then
                    local t_rune = Config.get_config_value('t_rune', PlayerData.player.rune_slot3s[i])
                    if t_rune ~= nil then
                        attr[t_rune.attr_id] = attr[t_rune.attr_id] + t_rune.attr_value
                    end
                end
            end
        end
    end

    --[[
    for i = 1, #PlayerData.player.artifact_ids do
        local t_artifact = Config.get_config_value("t_artifact", PlayerData.player.artifact_ids[i])
        if t_artifact ~= nil and PlayerData.player.artifact_nums[i] > 0 then
            for k = 1, #t_artifact.attrs do
                local t_attr = Config.get_config_value("t_attr", t_artifact.attrs[k].id)
                if t_attr ~= nil then
                    attr[t_artifact.attrs[k].id] = attr[t_artifact.attrs[k].id] + (t_artifact.attrs[k].value)
                end
            end
        end
    end
    ]]--
    return attr
end

function PlayerData.get_equip_enhance_value(attr_value, enhance)
    local t_equip_enhance = Config.get_config_value("t_equip_enhance", enhance)
    if t_equip_enhance ~= nil then
        local total_value = t_equip_enhance.total_value
        if total_value ~= 0 then
            return attr_value + attr_value * total_value / 100
        else
            return attr_value
        end
    else
        return attr_value
    end
end

function PlayerData.get_base_attr(attr)
    local base_attr = {}
    base_attr[1] = toInt(attr[1] * (1000 + attr[21]) / 1000)
    base_attr[2] = toInt(attr[2] * (1000 + attr[22]) / 1000)
    base_attr[3] = toInt((attr[3] + attr[17]) * (1000 + attr[23] + attr[37]) / 1000)
    base_attr[4] = toInt((attr[4] + attr[17]) * (1000 + attr[24] + attr[37]) / 1000)
    return base_attr
end


-- 属性显示
function PlayerData.get_display_attr()
    local attr = PlayerData.get_attr()
    for _, v in pairs(attr) do
        v = toInt(v)
    end

    return attr
end

-- 战斗力计算
function PlayerData.get_fight_power()
    local attr = PlayerData.get_attr()
    local base_attr = PlayerData.get_base_attr(attr)
    local fp = 0
    for i = 1, 4 do
        local t_attr = Config.get_config_value("t_attr", i)
        fp = fp + t_attr.power * base_attr[i]
    end
    for i = 11, 16 do
        local t_attr = Config.get_config_value("t_attr", i)
        fp = fp + t_attr.power * attr[i]
    end
    return toInt(fp)
end

-- 根据战斗力获取属性值
function PlayerData.get_power_value(power, attr_id)
    local t_attr = Config.get_config_value("t_attr", attr_id)
    if t_attr == nil then
        return 0
    end
    return power / 100 * t_attr.value
end

-- 根据等级获取属性值
function PlayerData.get_level_value(level, attr_id)
    local t_level = Config.get_config_value("t_level", level)
    if t_level == nil then
        return 0
    end
    return PlayerData.get_power_value(t_level.std_attr, attr_id)
end

-- 日常任务解锁判定
function PlayerData.daily_unlock( daily_id)
    local t_daily = Config.get_config_value("t_daily", daily_id)
    if t_daily.unlock_type == 1 then
        if t_daily.unlock_param > PlayerData.player.level then
            return false
        end
    elseif t_daily.unlock_type == 2 then
        return QuestManger.NeedOverCondition(t_daily.unlock_param)
    elseif t_daily.unlock_type == 3 then
        return QuestManger.NeedHasCondition(t_daily.unlock_param)
    end
    return true
end


-- 日常任务
function PlayerData.daily_schedule(daily_id, num)
    if PlayerData.daily_unlock(daily_id) then
        for i = 1, #PlayerData.player.daily_ids do
            if PlayerData.player.daily_ids[i] == daily_id then
                PlayerData.player.daily_nums[i] = PlayerData.player.daily_nums[i] + num
                return
            end
        end
        table.insert(PlayerData.player.daily_ids, daily_id)
        table.insert(PlayerData.player.daily_nums, num)
        table.insert(PlayerData.player.daily_reaches, 0)
    end
end


-- 日常任务完成
function PlayerData.daily_reached(daily_id)
    for i = 1, #PlayerData.player.daily_ids do
        if PlayerData.player.daily_ids[i] == daily_id then
            PlayerData.player.daily_reaches[i] = PlayerData.player.daily_reaches[i] + 1
            return
        end
    end
end

-- 获取任务线
function PlayerData.get_task_line(quest_id)
    local task_line = {}
    for _, v in pairs(Config.t_quest_sub) do
        if v.quest == quest_id then
            task_line[v.pre_sub] = v.id
        end
    end
    return task_line
end

-- 完成任务进度 mission相关
function PlayerData.task_reached(t_mission, count)
    for i = 1, #PlayerData.player.task_ids do
        if PlayerData.player.task_reaches[i] ~= -1 then
            local t_quest_sub = Config.get_config_value('t_quest_sub', PlayerData.player.task_ids[i])
            for j = 1, #count do
                if PlayerData.player.task_ids[i] == count[j] then
                    if t_quest_sub.event_type ~= 5 then
                        log('t_quest_sub.event_type error')
                    end
                    PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                end
            end

            if t_quest_sub.event_type == 2 then
                if t_quest_sub.event_param1 == t_mission.monsterid or t_quest_sub.event_param1 == 0 then
                    PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                end
            elseif t_quest_sub.event_type == 12 and t_mission.type == 2 then
                if t_quest_sub.map == t_mission.chapter then
                    local t_monster = Config.get_config_value('t_monster', t_mission.monsterid)
                    local index = GameSys.getIndex(PlayerData.player.monsters, t_monster.role_id)
                    if PlayerData.player.monster_tasks[index] == 0 then
                         PlayerData.player.monster_tasks[index] = 1
                         PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                    end
                end
            elseif t_quest_sub.event_type == 13 and t_mission.type == 2 then
                if t_quest_sub.event_param1 == t_mission.id then
                    PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                end
            end

            if PlayerData.player.task_reaches[i] >= t_quest_sub.event_param2 and (t_quest_sub.event_type == 5 or t_quest_sub.event_type == 2 or t_quest_sub.event_type == 13) then
                QuestManger.QuestEnd(PlayerData.player.task_ids[i])
            end

            if t_quest_sub.event_type == 12 and QuestManger.Type12Quest(t_quest_sub.map) <=  PlayerData.player.task_reaches[i] then
                QuestManger.QuestEnd(PlayerData.player.task_ids[i])
            end
        end
    end
end

-- 完成任务进度 mission无关
function PlayerData.task_reached_other(event_type, param)
    for i = 1, #PlayerData.player.task_ids do
        if PlayerData.player.task_reaches[i] ~= -1 then
            local t_quest_sub = Config.get_config_value('t_quest_sub', PlayerData.player.task_ids[i])
            if t_quest_sub.event_type == 11 and event_type == 11 then
                if param == t_quest_sub.event_param1 then
                    PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                    QuestManger.QuestEnd(PlayerData.player.task_ids[i])
                end
            elseif t_quest_sub.event_type == 14 and event_type == 14 then
                PlayerData.player.task_reaches[i] = 1
                QuestManger.QuestEnd(PlayerData.player.task_ids[i])
            elseif t_quest_sub.event_type == 15 and event_type == 15 then
                PlayerData.player.task_reaches[i] = 1
                QuestManger.QuestEnd(PlayerData.player.task_ids[i])
            elseif t_quest_sub.event_type == 16 and event_type == 16 then
                if param == t_quest_sub.event_param1 then
                    PlayerData.player.task_reaches[i] = PlayerData.player.task_reaches[i] + 1
                    QuestManger.QuestEnd(PlayerData.player.task_ids[i])
                end
            end
        end
    end
end


function PlayerData.task_operation(event_type, param)
    for i = 1, #PlayerData.player.task_ids do
        if PlayerData.player.task_reaches[i] ~= -1 then
            local t_quest_sub = Config.get_config_value('t_quest_sub', PlayerData.player.task_ids[i])
            if t_quest_sub.event_type == event_type then
                if param ~= nil then
                    if t_quest_sub.event_param1 == param then
                        QuestManger.QuestEnd(PlayerData.player.task_ids[i])
                    end
                else
                    QuestManger.QuestEnd(PlayerData.player.task_ids[i])
                end
            end
        end
    end
end


-- 怪物图鉴
function PlayerData.make_monsters_set(mission_id)
    for i = 1, #PlayerData.player.monsters do
        if PlayerData.player.monsters[i] == mission_id then
            PlayerData.player.monster_nums[i] = PlayerData.player.monster_nums[i] + 1
            AssetsChangeControl.OnKillNumChanged(PlayerData.player.monster_nums[i])
            return
        end
    end
    table.insert(PlayerData.player.monsters, mission_id)
    table.insert(PlayerData.player.monster_tasks, 0)
    table.insert(PlayerData.player.monster_nums, 1)
    table.insert(PlayerData.player.monster_unlocks, 0)
    AssetsChangeControl.OnKillNumChanged(1)
end


-- 获取副本事件
function PlayerData.get_dungeon_line(event_id)
    local dungeon_line = {}
    for _, v in pairs(Config.t_dungeon_event) do
        if v.event_id == event_id then
            dungeon_line[v.pre_dungeon] = v.id
        end
    end
    return dungeon_line
end

function PlayerData.arena_refresh(arena_segment)
    PlayerData.player.arena_room = 0
    PlayerData.player.arena_segment = arena_segment
    PlayerData.player.arena_integral = 0
    PlayerData.player.arena_win = 0
    PlayerData.player.arena_num = 0
end
