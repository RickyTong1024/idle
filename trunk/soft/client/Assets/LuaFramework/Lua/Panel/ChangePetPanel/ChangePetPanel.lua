ChangePetPanel = {}
ChangePetPanel.Control = {}
local this = ChangePetPanel.Control

function ChangePetPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_image/close_btn")
    this.content_root_ = this.transform_:Find("back_image/panel_among/scroll_rect/content_root")
    this.ui_scroll_grid_ = this.content_root_:GetComponent("UIScrollGrid")
    this.null_pet_desc_ = this.transform_:Find("back_image/panel_among/null_pet_desc")
    this.pet_slot_ = this.transform_:Find("back_image/panel_among/pet_slot")

    this.cur_slot_index_ = 0
    this.cur_pet_slot_ = 0
    this.pet_states_ = {}
    this.cur_wear_guid_ = "0"

    ChangePetPanel.RegisterBtnListers()
    ChangePetPanel.RegisterMessage()
    ChangePetPanel.InitUIScroll()
end

function ChangePetPanel.OnDestroy(obj)
    ChangePetPanel.RemoveMessage()
    this = {}
end

function ChangePetPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", ChangePetPanel.Close)
end

function ChangePetPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_PET_ON, ChangePetPanel.WearPetDone)
end

function ChangePetPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_PET_ON, ChangePetPanel.WearPetDone)
end

function ChangePetPanel.OnParam(params)
    this.cur_slot_index_ = params[1]
end

function ChangePetPanel.InitUIScroll()
    Util.ClearChild(this.content_root_)
    this.ui_scroll_grid_.prefab = this.pet_slot_.gameObject
    this.ui_scroll_grid_.SetDataHandle = function(go, index)
        ChangePetPanel.SetPetSlots(go, index + 1)
        go:SetActive(true)
    end
    this.ui_scroll_grid_:Init()
    this.ui_scroll_grid_:SetData(0)
end

function ChangePetPanel.Start(obj)
    ChangePetPanel.RefreshPanel()
end

function ChangePetPanel.RefreshPanel()
    ChangePetPanel.SetData()
    this.null_pet_desc_.gameObject:SetActive(next(this.pet_states_) == nil)
    this.ui_scroll_grid_:SetData(#this.pet_states_)
end

local function WearPetSlotSort(a, b)
    if a.is_weared then
        return true
    elseif b.is_weared then
        return false
    elseif a.is_weared == b.is_weared then
        if a.t_pet.color > b.t_pet.color then
            return true
        elseif a.t_pet.color < b.t_pet.color then
            return false
        elseif a.t_pet.color == b.t_pet.color then
            if a.pet_info.level > b.pet_info.level then
                return true
            elseif a.pet_info.level < b.pet_info.level then
                return false
            elseif a.pet_info.level == b.pet_info.level then
                return (a.t_pet.id > b.t_pet.id)
            end
        end
    end
end

function ChangePetPanel.SetData()
    this.cur_pet_slot_ = PlayerData.player.pet_slots[this.cur_slot_index_]
    this.pet_states_ = {}
    for k, v in pairs(PlayerData.pets) do
        local t = {
            ["is_weared"] = false,
            ["t_pet"] = nil,
            ["pet_info"] = nil,
        }
        t.is_weared = v.guid == this.cur_pet_slot_
        local pet_id = v.template_id
        t.t_pet = Config.get_config_value("t_pet", pet_id)
        t.pet_info = v
        if not GameSys.IsPetWeared(v.guid) then
            table.insert(this.pet_states_, t)
        else
            if t.is_weared then
                table.insert(this.pet_states_, t)
            end
        end
    end
    table.sort(this.pet_states_, WearPetSlotSort)
end

function ChangePetPanel.SetPetSlots(go, sort)
    local pet_state = this.pet_states_[sort]
    local slot_ins = CommonPanel.GetPetChangeSlot(pet_state.pet_info, this.lua_script_, { pet_state.is_weared, ChangePetPanel.OnPetBtnClick, { sort }, "change_pet_btn_" .. sort })
    Util.ClearChild(go.transform)
    slot_ins.transform:SetParent(go.transform, false)
    slot_ins:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
end

function ChangePetPanel.OnPetBtnClick(obj, params)
    local index = params[1]
    local pet_state = this.pet_states_[index]
    ChangePetPanel.SendWearPetMsg(pet_state.pet_info.guid, this.cur_slot_index_)
end

function ChangePetPanel.SendWearPetMsg(guid, slot)
    local msg = player_msg_pb.cmsg_pet_on()
    this.cur_wear_guid_ = guid
    msg.pet_guid = this.cur_wear_guid_
    msg.slot = slot
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_PET_ON, data, { opcodes.SMSG_PET_ON })
end

function ChangePetPanel.WearPetDone(message)
    local ori_slot = PlayerData.player.pet_slots[this.cur_slot_index_]
    if ori_slot == this.cur_wear_guid_ then
        PlayerData.player.pet_slots[this.cur_slot_index_] = "0"
    else
        for i = 1, #PlayerData.player.pet_slots do
            if PlayerData.player.pet_slots[i] == this.cur_wear_guid_ then
                PlayerData.player.pet_slots[i] = "0"
                break
            end
        end
        PlayerData.player.pet_slots[this.cur_slot_index_] = this.cur_wear_guid_
    end
    ChangePetPanel.RefreshPanel()
    local msg = CommonMessage()
    msg.name = "wear_pet_success"
    messMgr:AddCommonMessage(msg)

    local common_msg = CommonMessage()
    common_msg.name = "check_power"
    messMgr:AddCommonMessage(common_msg)
    ChangePetPanel.Close()
end

function ChangePetPanel.Close()
    GUIRoot.ClosePanel("ChangePetPanel")
end