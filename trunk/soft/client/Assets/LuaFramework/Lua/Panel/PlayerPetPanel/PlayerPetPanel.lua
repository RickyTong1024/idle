PlayerPetPanel = {}
PlayerPetPanel.Control = {}
local this = PlayerPetPanel.Control

function PlayerPetPanel.Awake(obj, lua_script)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = lua_script
    this.pet_slot_root_ = this.transform_:Find("panel_among/pet_slot_root")
    this.pet_slot_ = this.transform_:Find("panel_among/pet_slot")

    this.is_self_ = true
    this.pets_ = {}
    this.pet_states_ = {}
end

function PlayerPetPanel.OnParam(params)
    this.is_self_ = params[1]
    PlayerPetPanel.RegisterMessage()
end

function PlayerPetPanel.OnDestroy(obj)
    PlayerPetPanel.RemoveMessage()
    this = {}
end

function PlayerPetPanel.RegisterMessage()
    if this.is_self_ then
        Message.register_handle("wear_pet_success", PlayerPetPanel.OnWearPetSuccess)
        Message.register_handle("pet_feed_sucess", PlayerPetPanel.RefreshPanel)
    end
end

function PlayerPetPanel.RemoveMessage()
    if this.is_self_ then
        Message.remove_handle("wear_pet_success", PlayerPetPanel.OnWearPetSuccess)
        Message.remove_handle("pet_feed_sucess", PlayerPetPanel.RefreshPanel)
    end
end

function PlayerPetPanel.RefreshPanel()
    PlayerPetPanel.SetData()
    PlayerPetPanel.CreateSlotPrefab()
end

function PlayerPetPanel.SetData()
    this.pets_ = {}
    if this.is_self_ then
        for i = 1, #PlayerData.player.pet_slots do
            local pet_guid = PlayerData.player.pet_slots[i]
            this.pets_[i] = PlayerData.pets[pet_guid]
        end
    else
        for i = 1, 4 do
            this.pets_[i] = PlayerPanel.otherDate.player_pets[i]
        end
    end
    this.pet_states_ = {}
    for i = 1, 4 do
        local t = {
            ["sort"] = i,
            ["is_on"] = false,
            ["pet_info"] = nil,
            ["t_pet"] = nil,
        }
        if this.pets_[i] ~= nil then
            if not this.is_self_ then
                t.is_on = true
            else
                t.is_on = GameSys.IsPetWeared(this.pets_[i].guid)
            end
            t.pet_info = this.pets_[i]
            local pet_id = t.pet_info.template_id
            t.t_pet = Config.get_config_value("t_pet", pet_id)
        else
            t.is_on = false
        end
        table.insert(this.pet_states_, t)
    end
end

function PlayerPetPanel.CreateSlotPrefab()
    Util.ClearChild(this.pet_slot_root_)
    for i = 1, #this.pet_states_ do
        local pet_state = this.pet_states_[i]
        local slot_ins = GameObject.Instantiate(this.pet_slot_.gameObject)
        slot_ins:SetActive(true)
        slot_ins.transform:SetParent(this.pet_slot_root_)
        slot_ins.transform.localScale = Vector3.one
        local add_btn = slot_ins.transform:Find("add_btn")
        local change_slot_root = slot_ins.transform:Find("change_slot_root")
        local detail_btn = slot_ins.transform:Find("detail_btn")
        local had_line = slot_ins.transform:Find("had_line")
        local no_line = slot_ins.transform:Find("no_line")
        had_line.gameObject:SetActive(pet_state.is_on)
        no_line.gameObject:SetActive(not pet_state.is_on)
        add_btn.gameObject:SetActive(not pet_state.is_on)
        change_slot_root.gameObject:SetActive(pet_state.is_on)
        detail_btn.gameObject:SetActive(pet_state.is_on and this.is_self_)
        if pet_state.is_on then
            Util.ClearChild(change_slot_root)
            local pet_slot = nil
            if this.is_self_ then
                pet_slot = CommonPanel.GetPetChangeSlot(pet_state.pet_info, this.lua_script_, {false, PlayerPetPanel.OnPetChangeClick, {pet_state.sort}, "change_pet_btn_"..i})
            else
                pet_slot = CommonPanel.GetPetChangeSlot(pet_state.pet_info, this.lua_script_, nil)
            end
            Util.SetRoot(pet_slot.transform, change_slot_root)
            pet_slot.transform:Find("change_pet_slot_root"):GetChild(0):Find("back_image").gameObject:SetActive(false)
        end
        if this.is_self_ then
            add_btn.gameObject.name = "change_pet_add_btn_"..i
            GameSys.ButtonRegister(this.lua_script_, add_btn.gameObject, "click", PlayerPetPanel.OnPetChangeClick, {pet_state.sort})
            detail_btn.gameObject.name = "pet_detail_btn_"..i
            GameSys.ButtonRegister(this.lua_script_, detail_btn.gameObject, "click", PlayerPetPanel.OnPetDetailClick, {pet_state.sort})
        end
    end
end

function PlayerPetPanel.OnPetDetailClick(obj, params)
    local index = params[1]
    local pet_info = this.pet_states_[index].pet_info
    local need_enhance = GameSys.PetNeedEnhance(pet_info.level, pet_info.enhance)
    if need_enhance then
        GUIRoot.ShowPanel("PetEnhancePanel", {pet_info.guid, this.pet_states_[index].t_pet.id})
    else
        GUIRoot.ShowPanel("PetUpgradePanel", {pet_info.guid, this.pet_states_[index].t_pet.id})
    end
end

function PlayerPetPanel.OnPetChangeClick(obj, params)
    local slot_index = params[1]
    GUIRoot.ShowPanel("ChangePetPanel", { slot_index })
end

function PlayerPetPanel.OnWearPetSuccess(message)
    PlayerPetPanel.RefreshPanel()
end
