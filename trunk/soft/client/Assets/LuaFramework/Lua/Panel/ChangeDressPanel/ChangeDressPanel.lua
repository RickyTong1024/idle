ChangeDressPanel = {}
ChangeDressPanel.Control = {}
local this = ChangeDressPanel.Control

function ChangeDressPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.null_dress_desc_ = this.transform_:Find("back_image/panel_among/null_dress_desc")
    this.content_root_ = this.transform_:Find("back_image/panel_among/scroll_rect/content_root")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.dress_slot_ = this.transform_:Find("back_image/panel_among/dress_slot")

    this.wear_dress_id_ = 0
    this.dress_states_ = {}

    this.cur_dress_slot_index_ = 0
    this.cur_dress_slot_id_ = 0

    ChangeDressPanel.RegisterBtnListers()
    ChangeDressPanel.RegisterMessage()
    ChangeDressPanel.InitUIScroll()
end

function ChangeDressPanel.OnDestroy(obj)
    ChangeDressPanel.RemoveMessage()
    this = {}
end

function ChangeDressPanel.OnParam(params)
    this.cur_dress_slot_index_ = params[1]
    this.cur_dress_slot_id_ = params[2]
end

function ChangeDressPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ChangeDressPanel.OnCloseBtnClick)
end

function ChangeDressPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_EQUIP_SHOW_WEAR, ChangeDressPanel.WearDressSuccess)

end

function ChangeDressPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_EQUIP_SHOW_WEAR, ChangeDressPanel.WearDressSuccess)
end

function ChangeDressPanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab = this.dress_slot_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function (go, index)
        ChangeDressPanel.SetDressSlots(go, index + 1)
        go:SetActive(true)
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function ChangeDressPanel.Start(obj)
    ChangeDressPanel.RefreshPanel()
end

function ChangeDressPanel.RefreshPanel()
    ChangeDressPanel.SetData()
    this.ui_scroll_grid_:SetData(#this.dress_states_)
    this.null_dress_desc_.gameObject:SetActive(next(this.dress_states_) == nil)
end

function ChangeDressPanel.SetData()
    this.dress_states_ = {}
    for i = 1, #PlayerData.player.equip_dresses do
        local dress_id = PlayerData.player.equip_dresses[i]
        local equip_type = GameSys.GetEquipTypeById(dress_id)
        if equip_type == this.cur_dress_slot_index_ then
            table.insert(this.dress_states_, {
                ["dress_id"] = dress_id,
                ["had_wear"] = dress_id == this.cur_dress_slot_id_
            })
        end
    end
    table.sort(this.dress_states_, function(a, b)
        if a.had_wear then
            return true
        elseif b.had_wear then
            return false
        end
        if  not a.had_wear and not b.had_wear  then
            return a.dress_id < b.dress_id
        end
    end)
end

function ChangeDressPanel.SetDressSlots(go, sort)
    local dress_state = this.dress_states_[sort]
    if go.transform.childCount > 0 then
        local child = go.transform:GetChild(0)
        local btn = child:GetChild(3)
        this.lua_script_:RemoveButtonEvent(btn.gameObject, "click")
        Util.ClearChild(go.transform)
    end
    local min_color, max_color = GameSys.GetEquipColorRange()
    local slot_ins = CommonPanel.GetDressChangeSlot(dress_state.dress_id, max_color, this.lua_script_, {dress_state.had_wear, ChangeDressPanel.OnChangeBtnClick, {sort}, "change_dress_btn_"..sort})
    slot_ins.transform:SetParent(go.transform, false)
    slot_ins:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
end

function ChangeDressPanel.OnChangeBtnClick(obj, params)
    local index = params[1]
    local dress_state = this.dress_states_[index]
    this.wear_dress_id_ = dress_state.dress_id
    local msg = item_msg_pb.cmsg_equip_show_wear()
    msg.equip_template_id = this.wear_dress_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_EQUIP_SHOW_WEAR ,data, {opcodes.SMSG_EQUIP_SHOW_WEAR})
end

function ChangeDressPanel.WearDressSuccess(message)
    if PlayerData.player.equip_shows[this.cur_dress_slot_index_] == this.wear_dress_id_ then
        PlayerData.player.equip_shows[this.cur_dress_slot_index_] = 0
    else
        PlayerData.player.equip_shows[this.cur_dress_slot_index_] = this.wear_dress_id_
    end
    local msg = CommonMessage()
    msg.name = "change_dress_success"
    messMgr:AddCommonMessage(msg)
    ChangeDressPanel.Close()
end

function ChangeDressPanel.OnCloseBtnClick(obj)
    ChangeDressPanel.Close()
end

function ChangeDressPanel.Close()
    GUIRoot.ClosePanel("ChangeDressPanel")
end