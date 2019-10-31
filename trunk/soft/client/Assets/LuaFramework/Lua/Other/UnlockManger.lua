UnlockManger = {}
local fun_btn_ = {}
local fun_config_ = {}

function UnlockManger.Init()
    UnlockManger.RegisterMessage()
    fun_config_ = UnlockManger.GetFunConfig()
end

function UnlockManger.GetFunConfig()
    local need_unlock_config = {}
    for _, v in pairs(Config.t_unlock) do
        if v.unlock_type == 1 and v.unlock_param > PlayerData.player.level then
            need_unlock_config[#need_unlock_config + 1] = v
        end

        if v.unlock_type == 2 and not QuestManger.NeedOverCondition(v.unlock_param) then
            need_unlock_config[#need_unlock_config + 1] = v
        end
        if v.unlock_type == 3 and not QuestManger.NeedHasCondition(v.unlock_param) then
            need_unlock_config[#need_unlock_config + 1] = v
        end
    end
    return need_unlock_config
end

function UnlockManger.RegisterMessage()
    Message.register_handle("check_unlock_quest_get", UnlockManger.UnlockQuestCheckGet)
    Message.register_handle("check_unlock_quest", UnlockManger.UnlockQuestCheck)
    Message.register_handle("level_up", UnlockManger.UnlockLevelCheck)
end

function UnlockManger.RemoveMessage()
    Message.remove_handle("check_unlock_quest_get", UnlockManger.UnlockQuestCheckGet)
    Message.remove_handle("check_unlock_quest", UnlockManger.UnlockQuestCheck)
    Message.remove_handle("level_up", UnlockManger.UnlockLevelCheck)
end

function UnlockManger.RegisterFunBtn(param)
    local unlock_fun = {}
    unlock_fun.regis_id = param[1]
    unlock_fun.regis_obj = param[2]
    unlock_fun.btn_type = param[3]
    unlock_fun.regis_fun = param[4]
    unlock_fun.regis_fun_param = param[5]
    unlock_fun.regis_fun_luascript = param[6]
    unlock_fun.btn_effect = param[7]
    if fun_btn_[param[1]] == nil then
        fun_btn_[param[1]] = unlock_fun
        UnlockManger.RegisterFunBtn_Ex(unlock_fun)
    end
    UnlockManger.ObjDeal({unlock_fun.regis_id}, false)
end

function UnlockManger.RegisterFunBtn_Ex(unlock_fun)
    local unlock = Config.get_config_value("t_unlock", unlock_fun.regis_id)
    if unlock ~= nil then
        if unlock_fun.btn_type == "click" then
            GameSys.ButtonRegister(unlock_fun.regis_fun_luascript, unlock_fun.regis_obj.gameObject, unlock_fun.btn_type , UnlockManger.UnlockObjClick, {unlock, unlock_fun.regis_fun ,unlock_fun.regis_fun_param}, unlock_fun.btn_effect)
        else
            GameSys.ButtonRegister(unlock_fun.regis_fun_luascript, unlock_fun.regis_obj.gameObject, unlock_fun.btn_type , UnlockManger.UnlockObjToggle, {unlock, unlock_fun.regis_fun ,unlock_fun.regis_fun_param}, unlock_fun.btn_effect)
        end
    end
end

function UnlockManger.RemoveFunBtn(param)
    for i = 1, #param do
        fun_btn_[param[i]] = nil
    end
end

function UnlockPanel.UnlockF(js, state, unlock_type)
    UnlockManger.RemoveConfig(state, unlock_type)
    UnlockManger.ObjDeal(js, true)
end

function UnlockManger.UnlockQuestCheck(message)
    local quest_sub_id = tonumber(message.m_object[0])
    local unlock_type = tonumber(message.m_object[1])
    if unlock_type == 2 then
        local js = {}
        for i = 1, #fun_config_ do
            if fun_config_[i].unlock_type == 2 and fun_config_[i].unlock_param == quest_sub_id then
                js[#js + 1] = fun_config_[i].id
            end
        end
        UnlockPanel.UnlockF(js, quest_sub_id, 2)
    end
end

function UnlockManger.UnlockQuestCheckGet(message)
    local quest_sub_id = tonumber(message.m_object[0])
    local unlock_type = tonumber(message.m_object[1])
    if unlock_type == 3 then
        local js = {}
        for i = 1, #fun_config_ do
            if fun_config_[i].unlock_type == 3 and fun_config_[i].unlock_param == quest_sub_id and QuestManger.NeedHasCondition(quest_sub_id) then
                js[#js + 1] = fun_config_[i].id
            end
        end
        UnlockPanel.UnlockF(js, quest_sub_id, 3)
    end
end

function UnlockManger.UnlockLevelCheck()
    local js = {}
    for i = 1, #fun_config_ do
        if fun_config_[i].unlock_type == 1 and fun_config_[i].unlock_param <= PlayerData.player.level then
            js[#js + 1] = fun_config_[i].id
        end
    end
    UnlockPanel.UnlockF(js, 0, 1)
end

function UnlockManger.RemoveConfig(state,u_type)
    if state == 0 then
        for i = #fun_config_, 1, -1  do
            if fun_config_[i].unlock_type == 1 and fun_config_[i].unlock_param <= PlayerData.player.level then
                table.remove(fun_config_, i)
            end
        end
    else
        if u_type == 2 then
            for i = #fun_config_, 1, -1 do
                if fun_config_[i].unlock_type == 2 and fun_config_[i].unlock_param == state then
                    table.remove(fun_config_, i)
                end
            end
        elseif u_type == 3 then
            for i = #fun_config_, 1, -1 do
                if fun_config_[i].unlock_type == 3 and fun_config_[i].unlock_param == state then
                    table.remove(fun_config_, i)
                end
            end
        end
    end
end

function UnlockManger.CheckUnlock(unlock_id)
    local unlock = Config.get_config_value("t_unlock", unlock_id)
    if unlock == nil then
        return true, ""
    else
        if unlock.unlock_type == 1 then
            if PlayerData.player.level >= unlock.unlock_param then
                return true,""
            end
        elseif unlock.unlock_type == 2 then
            if QuestManger.NeedOverCondition(unlock.unlock_param) then
                return true, ""
            end
        elseif unlock.unlock_type == 3 then
            if QuestManger.NeedHasCondition(unlock.unlock_param) then
                return true, ""
            end
        end
        return false , unlock.condition
    end
end

function UnlockManger.ObjDeal(unlock_id, reg)
    local show_ids = {}
    for i = 1, #unlock_id do
        local unlock_type = UnlockManger.GetNum(unlock_id[i])
        local obj_show = false
        local unlock = Config.get_config_value("t_unlock", unlock_id[i])
        if unlock.unlock_type == 1 then
            if PlayerData.player.level >= unlock.unlock_param then
                obj_show = true
            end
            if unlock.need_tip == 1 then
                show_ids[#show_ids + 1] = unlock.id
            end
        elseif unlock.unlock_type == 2 then
            if QuestManger.NeedOverCondition(unlock.unlock_param) then
                obj_show = true
            end
            if unlock.need_tip == 1 then
                show_ids[#show_ids + 1] = unlock.id
            end
        elseif unlock.unlock_type == 3 then
            if QuestManger.NeedHasCondition(unlock.unlock_param) then
                obj_show = true
            end
            if unlock.need_tip == 1 then
                show_ids[#show_ids + 1] = unlock.id
            end
        end
        if unlock_type == 1 then
            if fun_btn_[unlock_id[i]] ~= nil then
                fun_btn_[unlock_id[i]].regis_obj.transform:GetChild(0).gameObject:SetActive(obj_show)
            end
        elseif unlock_type == 4 then
            if fun_btn_[unlock_id[i]] ~= nil then
                fun_btn_[unlock_id[i]].regis_obj.gameObject:SetActive(obj_show)
            end
        elseif unlock_type == 3 then
            if fun_btn_[unlock_id[i]] ~= nil then
                fun_btn_[unlock_id[i]].regis_obj.gameObject:SetActive(not obj_show)
            end
        end
    end
    if #show_ids > 0 and reg then
        GUIRoot.ShowPanel("UnlockPanel", {show_ids, UnlockPanel.SHOW_TYPE.unlock_nol})
        for i = 1, #unlock_id do
            local common_msg = CommonMessage()
            common_msg.name = "unlock_success"
            common_msg.m_object:Add(unlock_id[i])
            messMgr:AddCommonMessage(common_msg)
        end
    end
end

function UnlockManger.GetNum(unlock_id)
    local un_num = unlock_id
    while(un_num >= 10) do
        un_num = math.modf(un_num / 10)
    end
    return un_num
end

function UnlockManger.UnlockObjToggle(obj, check, param)
    UnlockManger.Click(obj, check, param)
end

function UnlockManger.UnlockObjClick(obj, param)
    UnlockManger.Click(obj, nil, param)
end

function UnlockManger.Click(obj, check, param)
    local unlock = param[1]
    local fun_btn = param[2]
    local fun_param = param[3]
    local fun_click = UnlockManger.LockCheck(unlock.id)
    if fun_click then
        local unlock = Config.get_config_value("t_unlock", unlock.id)
        if check == nil then
            GUIRoot.ShowPanel("MessagePanel", {unlock.condition})
        elseif check ~= nil then
            if check then
                GUIRoot.ShowPanel("MessagePanel", {unlock.condition})
            end
        end
    else
        if check ~= nil then
            fun_btn(obj, check, fun_param)
        else
            fun_btn(obj, fun_param)
        end
    end
end

function UnlockManger.LockCheck(unlock_id)
    for i = 1, #fun_config_ do
        if fun_config_[i].id == unlock_id then
            return true
        end
    end
    return false
end
