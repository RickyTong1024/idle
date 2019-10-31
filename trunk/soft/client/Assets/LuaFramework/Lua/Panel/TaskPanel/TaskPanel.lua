TaskPanel = {}

TaskPanel.Control = {}
local this = TaskPanel.Control

function TaskPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.back_btn = this.transform_:Find("root_panel/top_layer/back_btn")
    this.task_rect = this.transform_:Find("root_panel/task_center_layer/task_main_panel/task_rect")
    this.down_layer = this.transform_:Find("root_panel/task_center_layer/bottom")
    this.icon_res = this.transform_:Find("root_panel/down_layer/icon_res")
    this.reward_icon = this.transform_:Find("root_panel/task_center_layer/bottom/reward_icon")
    this.accumulate_point_show = this.transform_:Find("root_panel/task_center_layer/bottom/accumulate_point_show")
    this.reward_grouds = this.transform_:Find("root_panel/task_center_layer/bottom/accumulate_point_show/reward_grouds")
    this.reward_close = this.transform_:Find("dayreward_panel/back/reward_close")
    this.reward_view_content = this.transform_:Find("dayreward_panel/back/day_rewards/reward_root")
    this.dayreward_panel = this.transform_:Find("dayreward_panel")
    this.get_btn = this.transform_:Find("dayreward_panel/back/get_btn")
    this.dayreward_num = this.transform_:Find("root_panel/task_center_layer/bottom/accumulate_point_show/dayreward_num"):GetComponent("LocalizationText")
    this.reward_points_num = 0
    this.daily_serverUse_id = 0
    this.superlist_ = nil
    this.daily_reward_obj_ = {}
    TaskPanel.RigisterButton()
    TaskPanel.RegisterMessage()
end

function TaskPanel.Start()
    TaskPanel.Init()
end

function TaskPanel.Init()
    TaskPanel.InitSuperList()
    TaskPanel.ShowTaskDayView()
end

function TaskPanel.InitSuperList()
    GameSys.ClearChild(this.task_rect)
    this.task_day = TaskPanel.GetTaskConfig()
    this.superlist_ = this.task_rect:GetComponent("UIScrollGrid")
    this.superlist_.prefab = this.icon_res.gameObject
    this.superlist_.SetDataHandle = function(go, index)
        local value = this.task_day[index + 1]
        local asset = {}
        asset.type = value.type
        asset.value1 = value.value1
        asset.value2 = value.value2
        asset.value3 = value.value3
        go.transform:Find("back_image/big_icon_root/daily_image"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "get"):GetSprite(value.icon)
        go.transform:Find("back_image/task_name_text"):GetComponent("LocalizationText").text = value.name
        go.transform:Find("back_image/task_desc_text"):GetComponent("LocalizationText").text = value.desc
        go.transform:Find("back_image/task_desc_text/task_reward_text"):GetComponent("LocalizationText").text = string.format("奖励：%sx%s,积分x%s", GameSys.GetAssetName(asset), asset.value2, value.point)
        local click_obj = go.transform:Find("back_image/click_obj").transform:GetChild(0).gameObject
        if GameSys.isTaskGet(value.id) then
            go.transform:Find("back_image/task_progress_text"):GetComponent("LocalizationText").text = "已领取"
        else
            go.transform:Find("back_image/task_progress_text"):GetComponent("LocalizationText").text = string.format("%s/%s", TaskPanel.GetTaskCompleteNum(value.id, value.num), value.num)
        end
        click_obj.gameObject:GetComponent("Button").interactable = false
        local red_point = click_obj.transform:Find("red_point")
        if not GameSys.isTaskGet(value.id) and GameSys.isTaskComplete(value.id, value.num) then
            TaskPanel.SetRedPonit(red_point, true)
            click_obj.transform:Find("target_btn_text"):GetComponent("LocalizationText").text = "领取"
            click_obj:GetComponent("Button").interactable = true
        elseif GameSys.isTaskGet(value.id) then
            TaskPanel.SetRedPonit(red_point, false)
            click_obj.transform:Find("target_btn_text"):GetComponent("LocalizationText").text = "已完成"
        elseif not GameSys.isTaskComplete(value.id, value.num) then
            TaskPanel.SetRedPonit(red_point, false)
            click_obj.transform:Find("target_btn_text"):GetComponent("LocalizationText").text = "前往"
            click_obj:GetComponent("Button").interactable = true
        end
        click_obj.name = "task"..value.id
        GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", TaskPanel.TaskRewardClick, {value.id})
        go.gameObject:SetActive(true)
    end
    this.superlist_:Init()
    this.superlist_:SetData(#this.task_day)
end

function TaskPanel.SetRedPonit(red_point, show)
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

function TaskPanel.RigisterButton()
    GameSys.ButtonRegister(this.lua_script_, this.back_btn.gameObject, "click", TaskPanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.reward_close.gameObject, "click", TaskPanel.ButtonClick)
    GameSys.ButtonRegister(this.lua_script_, this.get_btn.gameObject, "click", TaskPanel.ButtonClick)
end

function TaskPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_DAILY_DRAW, TaskPanel.SMSG_DAILY_DRAW)
    Message.register_net_handle(opcodes.SMSG_DAILY_REWARD_DRAW, TaskPanel.SMSG_DAILY_REWARD_DRAW)
end

function TaskPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_DAILY_DRAW, TaskPanel.SMSG_DAILY_DRAW)
    Message.remove_net_handle(opcodes.SMSG_DAILY_REWARD_DRAW, TaskPanel.SMSG_DAILY_REWARD_DRAW)
end

function TaskPanel.ButtonClick(obj)
    if obj.name == "back_btn" then
        GUIRoot.ClosePanel("TaskPanel")
    elseif obj.name == "reward_close" then
        this.dayreward_panel.gameObject:SetActive(false)
    elseif obj.name == "get_btn" then
        TaskPanel.DayRewardSendServerMessage()
    end
end

function TaskPanel.DayRewardSendServerMessage()
    this.daily_serverUse_id = this.reward_points_num
    local msg = promotion_msg_pb.cmsg_daily_reward_draw()
    msg.daily_reward_id = this.reward_points_num
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_DAILY_REWARD_DRAW, data, {opcodes.SMSG_DAILY_REWARD_DRAW}, "换取积分奖励中", 60)
end

function TaskPanel.ShowTaskDayView()
    this.daily_reward_obj_ = {}
    this.accumulate_point_show:GetComponent("Slider").value = GameSys.GetDayRewardPoint() / TaskPanel.GetAllPoint()
    GameSys.ClearChild(this.reward_grouds)
    local dayRewaed = TaskPanel.GetDayReward()
    for i = 1, #dayRewaed do
        local day_res = GameObject.Instantiate(this.reward_icon.gameObject)
        day_res.transform:SetParent(this.reward_grouds, false)
        day_res.transform.localScale = Vector3.one
        day_res.transform.localPosition = Vector3(552 * (dayRewaed[i].progress / TaskPanel.GetAllPoint()) - 30, 0, 0)
        day_res.name = dayRewaed[i].progress
        if GameSys.hasInTable(PlayerData.player.daily_rewards, dayRewaed[i].progress) then
            day_res.transform:Find("red_point").gameObject:SetActive(false)
        elseif dayRewaed[i].progress <= GameSys.GetDayRewardPoint() then
            day_res.transform:Find("red_point").gameObject:SetActive(true)
        else
            day_res.transform:Find("red_point").gameObject:SetActive(false)
        end
        local red_obj = {}
        red_obj.obj = day_res
        red_obj.config = dayRewaed[i]
        table.insert(this.daily_reward_obj_, red_obj)
        day_res.transform:Find("point"):GetComponent("LocalizationText").text = dayRewaed[i].progress
        GameSys.ButtonRegister(this.lua_script_, day_res.gameObject, "click", TaskPanel.DayRewardClick)
        day_res.gameObject:SetActive(true)
    end
    this.dayreward_num.text = string.format("积分: %s", GameSys.GetDayRewardPoint())
    this.down_layer.gameObject:SetActive(true)
end

function TaskPanel.DayRewardClick(obj)
    this.reward_points_num = tonumber(obj.name)
    local day_reward = Config.get_config_value("t_daily_reward", this.reward_points_num)
    GameSys.ClearChild(this.reward_view_content)
    if(day_reward ~= nil) then
        for i = 1, #day_reward.reward do
            local asset = {}
            asset.type = day_reward.reward[i].type
            asset.value1 = day_reward.reward[i].value1
            asset.value2 = day_reward.reward[i].value2
            asset.value3 = day_reward.reward[i].value3
            local reward_obj = CommonPanel.GetIcon2type(asset, {"jf_icon"..asset.value2..i}, this.lua_script_)
            local name = reward_obj.transform:Find("generic")
            name:GetComponent("LocalizationText").text = GameSys.GetAssetName(asset)
            name.gameObject:SetActive(true)
            reward_obj.transform:SetParent(this.reward_view_content, false)
            reward_obj.transform.localScale = Vector3.one
            reward_obj.transform.localPosition = Vector3.zero
            reward_obj.gameObject:SetActive(true)
        end
    end
    if GameSys.hasInTable(PlayerData.player.daily_rewards, this.reward_points_num) then
        this.get_btn.gameObject:SetActive(false)
    elseif this.reward_points_num <= GameSys.GetDayRewardPoint() then
        this.get_btn.gameObject:SetActive(true)
        this.get_btn:GetComponent("Button").interactable = true
    else
        this.get_btn.gameObject:SetActive(true)
        this.get_btn:GetComponent("Button").interactable = false
    end

    this.dayreward_panel.gameObject:SetActive(true)
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

function TaskPanel.GetDayReward()
    local point_reward = {}
    for k,v in pairs(Config.t_daily_reward) do
        table.insert(point_reward, v)
    end

    if #point_reward > 1 then
        table.sort(point_reward, TaskPanel.DayRewaedSort)
    end
    return point_reward
end

function TaskPanel.DayRewaedSort(a, b)
    local aid = a.progress
    local bid = b.progress
    return aid < bid
end

function TaskPanel.GetAllPoint()
    local point_ = 0
    for k,v in pairs(Config.t_daily) do
        point_ = point_ + v.point
    end
    return point_
end

function TaskPanel.TaskRewardClick(obj, param)
    local t_daily = Config.get_config_value("t_daily", param[1])
    if not GameSys.isTaskGet(t_daily.id) and GameSys.isTaskComplete(t_daily.id, t_daily.num) then
        this.daily_serverUse_id = param[1]
        local msg = promotion_msg_pb.cmsg_daily_draw()
        msg.daily_id = this.daily_serverUse_id
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_DAILY_DRAW, data, {opcodes.SMSG_DAILY_DRAW}, "日常验收中", 60)
    elseif not GameSys.isTaskComplete(t_daily.id, t_daily.num) then
       GameSys.PanelJump(t_daily.get)
    else
        GUIRoot.ShowPanel("MessagePanel", {"错误的日常任务"})
    end
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

function TaskPanel.GetTaskCompleteNum(id, num)
    for i = 1, #PlayerData.player.daily_ids do
        if PlayerData.player.daily_ids[i] == id then
            if PlayerData.player.daily_nums[i] >= num then
                return num
            else
                return PlayerData.player.daily_nums[i]
            end
        end
    end
    return 0
end

function TaskPanel.GetTaskConfig()
    local task_ = {}
    for k,v in pairs(Config.t_daily) do
        if v.unlock_type == 1 then
            if PlayerData.player.level >= v.unlock_param then
                table.insert(task_, v)
            end
        elseif v.unlock_type == 2 then
            if QuestManger.NeedOverCondition(v.unlock_param) then
                table.insert(task_, v)
            end
        elseif v.unlock_type == 3 then
            if QuestManger.NeedHasCondition(v.unlock_param) then
                table.insert(task_, v)
            end
        end
    end
    if #task_ > 1 then
        table.sort(task_, TaskPanel.TaskDaySort)
    end
    return task_
end

function TaskPanel.TaskDaySort(a, b)
    local a_id = tonumber(a.id)
    local b_id = tonumber(b.id)
    local a_num = tonumber(a.num)
    local b_num = tonumber(b.num)
    local a_s
    local b_s
    if GameSys.isTaskGet(a_id) then
        a_s = -1
    elseif not GameSys.isTaskGet(a_id) and GameSys.isTaskComplete(a_id, a_num) then
        a_s = 1
    elseif not GameSys.isTaskGet(a_id) and not GameSys.isTaskComplete(a_id, a_num) then
        a_s = 0
    end

    if GameSys.isTaskGet(b_id) then
        b_s = -1
    elseif not GameSys.isTaskGet(b_id) and GameSys.isTaskComplete(b_id, b_num) then
        b_s = 1
    elseif not GameSys.isTaskGet(b_id) and not GameSys.isTaskComplete(b_id, b_num) then
        b_s = 0
    end
    if a_s == b_s then
        return a_id < b_id
    end

    return a_s > b_s
end

function TaskPanel.ShowTargetView()
    this.down_layer.gameObject:SetActive(false)
end

function TaskPanel.ShowAchievementView()
    this.down_layer.gameObject:SetActive(false)
end

function TaskPanel.RefreshPointRed()
    for i = 1, #this.daily_reward_obj_ do
        local red_obj = this.daily_reward_obj_[i]
        if GameSys.hasInTable(PlayerData.player.daily_rewards, red_obj.config.progress) then
            TaskPanel.SetRedPonit(red_obj.obj.transform:Find("red_point"), false)
        elseif red_obj.config.progress <= GameSys.GetDayRewardPoint() then
            TaskPanel.SetRedPonit(red_obj.obj.transform:Find("red_point"), true)
        else
            TaskPanel.SetRedPonit(red_obj.obj.transform:Find("red_point"), false)
        end
    end
end

function TaskPanel.OnDestroy()
    TaskPanel.RemoveMessage()
    this.lua_script_:ClearClick()
    this = {}
end
-------net message --------

function TaskPanel.SMSG_DAILY_DRAW(message)
    --this.daily_serverUse_id 为日常表id
    local msg = promotion_msg_pb.smsg_daily_draw()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets)
    PlayerData.daily_reached(this.daily_serverUse_id)
    AssetsChangeControl.OnDailyChanged()
    this.task_day = TaskPanel.GetTaskConfig()
    this.superlist_:UpdateItemAll()
    TaskPanel.ShowTaskDayView()
    TaskPanel.RefreshPointRed()

end

function TaskPanel.SMSG_DAILY_REWARD_DRAW(message)
    local msg = promotion_msg_pb.smsg_daily_reward_draw()
    msg:ParseFromString(message.luabuff)
    --this.daily_serverUse_id 在这边为日常奖励表积分id
    PlayerData.add_assets(msg.assets)
    this.dayreward_panel.gameObject:SetActive(false)
    table.insert(PlayerData.player.daily_rewards, this.daily_serverUse_id)
    TaskPanel.ShowTaskDayView()
    TaskPanel.RefreshPointRed()
    AssetsChangeControl.OnDailyChanged()
end
