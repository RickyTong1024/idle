EquipPanel = {}
EquipPanel.Control = {}
local this = EquipPanel.Control

function EquipPanel.Awake(obj, lua_script)
    this = {}
    this.gameObject_ = obj
    this.lua_script_ = lua_script
    this.transform_ = obj.transform
    this.content_root_ = this.transform_:Find("equip_scroll/content")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.equip_rect_ = this.transform_:Find("equip_rect")
    this.equip_icon_= this.transform_:Find("equip_icon")

    this.equip_queues_ = {}
    this.cur_select_ = {}
    this.cur_get_equip_id_ = {}
    
    EquipPanel.RegisterBtnListers()
    EquipPanel.RegisterMessage()
    EquipPanel.InitUIScroll()
end

function EquipPanel.OnDestroy(obj)
    EquipPanel.RemoveMessage()
    this = {}
end

function EquipPanel.RegisterBtnListers()
   
end

function EquipPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_DRAWS_UNLOCK, EquipPanel.OnGetReputation)
end

function EquipPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_DRAWS_UNLOCK, EquipPanel.OnGetReputation)
end

function EquipPanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab = this.equip_rect_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function(go, index)
        EquipPanel.SetEquipRect(go, index + 1)
        if not go.activeSelf then
            go:SetActive(true)
        end
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function EquipPanel.Start(obj)
    EquipPanel.RefreshPanel()
end

function EquipPanel.RefreshPanel()
    EquipPanel.SetData()
    this.ui_scroll_grid_:SetData(#this.equip_queues_)
end

function EquipPanel.SetData()
    this.equip_queues_ = {}
    local equip_config = Config.t_equip
    for equip_id, t_equip in pairs(equip_config) do
        local max_level = t_equip.max_level
        local index = (max_level + 1) / 10
        if this.equip_queues_[index] == nil then
            this.equip_queues_[index] = {}
        end
        local had_avatar, can_get, had_get = GameSys.GetDressState(equip_id)
        table.insert(this.equip_queues_[index], {
            ["t_equip"] = t_equip,
            ["had_avatar"] = had_avatar,
            ["can_get"] = can_get,
            ["had_get"] = had_get,
        })
    end
    for i = 1, #this.equip_queues_ do
        local equip_states = this.equip_queues_[i]
        table.sort(equip_states, function(a, b)
            return a.t_equip.type < b.t_equip.type
        end)
    end
end

function EquipPanel.SetEquipRect(go, sort)
    local equip_states = this.equip_queues_[sort]
    local title = go.transform:Find("line/title")
    local content = go.transform:Find("content")
    local equip_counts = #equip_states
    local min_level = sort * 10 - 10
    local max_level = sort * 10 - 1
    title:GetComponent("Text").text = string.format("%d-%d级装备", min_level, max_level)
    local child_count = content.childCount
    local sub = equip_counts - child_count
    if sub > 0 then
        for i = 1, sub do
            local icon_ins = GameObject.Instantiate(this.equip_icon_.gameObject)
            icon_ins.transform:SetParent(content, false)
            icon_ins:SetActive(true)
        end
    else
        for i = equip_counts, math.abs(sub) do
            local icon = content:GetChild(i)
            if icon ~= nil then
                icon.gameObject:SetActive(false)
            end
        end
    end
    for i = 0, equip_counts - 1 do
        local index = i + 1
        local icon = content:GetChild(i)
        EquipPanel.SetIcon(icon.gameObject, sort, index)
    end
end

function EquipPanel.SetIcon(icon_ins, avatar_index, index)
    local equip_state = this.equip_queues_[avatar_index][index]
    local t_equip = equip_state.t_equip
    local quality_back = icon_ins.transform:Find("quality_back")
    local equip_icon = icon_ins.transform:Find("equip_icon")
    local mask = icon_ins.transform:Find("mask")
    local add_image = icon_ins.transform:Find("add_image")
    add_image.gameObject:SetActive(equip_state.can_get)
    this.lua_script_:RemoveButtonEvent(icon_ins, "click")
    icon_ins.name = "this.equip_icon_"..avatar_index.."_"..index
    local min, color = GameSys.GetEquipColorRange()
    GameSys.ButtonRegister(this.lua_script_, icon_ins, "click", EquipPanel.OnEquipIconClick, {avatar_index, index, icon_ins, color})
    local quality_icon_alias = GameSys.get_quality(color)
    local equip_icon_alias = t_equip.icon
    quality_back:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "quality"):GetSprite(quality_icon_alias)
    equip_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "equip"):GetSprite(equip_icon_alias)
    mask.gameObject:SetActive(not equip_state.had_avatar)
end

function EquipPanel.OnEquipIconClick(obj, params)
    local sort = params[1]
    local index = params[2]
    local icon = params[3]
    local color = params[4]
    this.cur_select_ = {
        sort, index, icon
    }
    local equip_state = this.equip_queues_[sort][index]
    if equip_state.can_get then
        local equip_id = equip_state.t_equip.id
        this.cur_get_equip_id_ = equip_id
        BookPanel.cur_unlock_type_ = 3
        local msg = item_msg_pb.cmsg_draws_unlock()
        msg.type = BookPanel.cur_unlock_type_
        msg.draw_id = this.cur_get_equip_id_
        msg.param = 0
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_DRAWS_UNLOCK ,data, {opcodes.SMSG_DRAWS_UNLOCK})
    else
        GUIRoot.ShowPanel("DressDetailPanel", {equip_state.t_equip, color})
    end
end

function EquipPanel.OnGetReputation(message)
    if BookPanel.cur_unlock_type_ ~= 3 then
        return
    end
    local t_equip = Config.get_config_value('t_equip', this.cur_get_equip_id_)
    local index = GameSys.getIndex(PlayerData.player.equip_dresses, this.cur_get_equip_id_)
    PlayerData.player.equip_dresses_unlock[index] = 1
    PlayerData.add_resource(5, t_equip.reputation)
    --刷新
    local sort = this.cur_select_[1]
    local index = this.cur_select_[2]
    local icon_ins = this.cur_select_[3]
    local equip_state = this.equip_queues_[sort][index]
    local had_avatar, can_get, had_get = GameSys.GetDressState(this.cur_get_equip_id_)
    equip_state.had_avatar = had_avatar
    equip_state.can_get = can_get
    equip_state.had_get = had_get
    if icon_ins ~= nil then
        EquipPanel.SetIcon(icon_ins, sort, index)
    end

    local msg = CommonMessage()
    msg.name = "get_dress_reputation_success"
    messMgr:AddCommonMessage(msg)
end
