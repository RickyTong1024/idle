PetPanel = {}
PetPanel.Control = {}
local this = PetPanel.Control

function PetPanel.Awake(obj, lua_script)
    this = {}
    this.gameObject_ = obj
    this.lua_script_ = lua_script
    this.transform_ = obj.transform
    this.content_ = this.transform_:Find("pet_scroll/view/content")
    this.had_pets_root_ = this.transform_:Find("pet_scroll/view/content/had_pets_root")
    this.line_ = this.transform_:Find("pet_scroll/view/content/line")
    this.no_had_pets_root_ = this.transform_:Find("pet_scroll/view/content/no_had_pets_root")
    this.pet_list_icon_ = this.transform_:Find("pet_list_icon")
    this.pet_inss_ = {}

    this.pet_total_count_ = 0
    this.pet_states_ = {}
    this.had_count_ = 0
    this.no_had_count_ = 0
    this.cur_get_pet_id_ = 0
    this.cur_click_index_ = 0
    
    PetPanel.RegisterBtnListers()
    PetPanel.RegisterMessage()
end

function PetPanel.OnDestroy(obj)
    PetPanel.RemoveMessage()
    this = {}
end

function PetPanel.RegisterBtnListers()

end

function PetPanel.RegisterMessage()
    Message.register_handle("pet_synt_success", PetPanel.OnPetSynt)
    Message.register_handle("pet_feed_sucess", PetPanel.RefreshPanel)
    Message.register_net_handle(opcodes.SMSG_DRAWS_UNLOCK, PetPanel.OnGetReputation)
end

function PetPanel.RemoveMessage()
    Message.remove_handle("pet_synt_success", PetPanel.OnPetSynt)
    Message.remove_handle("pet_feed_sucess", PetPanel.RefreshPanel)
    Message.remove_net_handle(opcodes.SMSG_DRAWS_UNLOCK, PetPanel.OnGetReputation)
end

function PetPanel.RefreshPanel()
    PetPanel.SetData()
    PetPanel.RefreshPets()
end

function PetPanel.SetData()
    this.pet_total_count_ = 0
    this.pet_states_ = {}
    this.had_count_ = 0
    this.no_had_count_ = 0
    local pet_config = Config.t_pet
    for k, v in pairs(pet_config) do
        local had_pet, pet_guid = GameSys.HadPet(k)
        local t = {
            ["had_pet"] = had_pet,
            ["t_pet"] = v,
            ["had_state"] = {},
            ["no_state "] = {}
        }
        if had_pet then
            local h = {
                ["pet_info"] = nil,
                ["is_max_level"] = false,
                ["need_exp"] = 1,
                ["cur_exp"] = 1,
                ["can_get_reputation"] = false
            }
            h.pet_info = PlayerData.pets[pet_guid]
            local level = h.pet_info.level
            local t_next_level = Config.get_config_value("t_level", level + 1)
            h.is_max_level = t_next_level == nil
            if not h.is_max_level then
                h.need_exp = t_next_level.pet_exp
                h.cur_exp = h.pet_info.exp
            end
            h.can_get_reputation = GameSys.GetPetReputationState(h.pet_info.template_id)
            t.had_state = h
            this.had_count_ = this.had_count_ +1
        else
            local n = {
                ["cur_shard"] = 0,
                ["need_shard"] = 0,
                ["shard_enough"] = false,
            }
            n.cur_shard = GameSys.GetItemCount(v.shard_id)
            n.need_shard = v.shard_num
            n.shard_enough = n.cur_shard >= n.need_shard
            t.no_state = n
            this.no_had_count_ = this.no_had_count_ + 1
        end
        this.pet_total_count_ = this.pet_total_count_ + 1
        table.insert(this.pet_states_, t)
    end
    table.sort(this.pet_states_, function (a, b)
        if a.had_pet and not b.had_pet then
            return true
        elseif not a.had_pet and b.had_pet  then
            return false
        else
            if a.t_pet.color > b.t_pet.color  then
                return true
            elseif a.t_pet.color < b.t_pet.color then
                return false
            else
                return a.t_pet.id > b.t_pet.id
            end
        end
    end)
end

function PetPanel.RefreshPets()
    if next(this.pet_inss_) == nil then
        for i = 1, this.pet_total_count_ do
            local ins = GameObject.Instantiate(this.pet_list_icon_.gameObject)
            ins:SetActive(true)
            table.insert(this.pet_inss_, ins)
        end
    end
    for i = 1, #this.pet_states_ do
        local state = this.pet_states_[i]
        local ins = this.pet_inss_[i]
        PetPanel.SetPetIcon(ins, state, i)
    end
    PetPanel.SetHeight()
end

function PetPanel.SetPetIcon(pet_ins, state, sort)
    local icon_root = pet_ins.transform:Find("icon_root")
    local shard_slider = pet_ins.transform:Find("shard_slider")
    local fill_blue = pet_ins.transform:Find("shard_slider/FillArea/Fill_blue")
    local fill_green = pet_ins.transform:Find("shard_slider/FillArea/Fill_green")
    local fill_red = pet_ins.transform:Find("shard_slider/FillArea/Fill_red")
    local shard_text = pet_ins.transform:Find("shard_slider/shard_text")
    local slider = shard_slider:GetComponent("Slider")
    local asset = {
        ["type"] = 6,
        ["value1"] = state.t_pet.id,
        ["value2"] = 0,
        ["value3"] = 0
    }
    Util.ClearChild(icon_root)
    local icon_ins = CommonPanel.GetIcon2type(asset, { "pet_icon_btn" .. sort, PetPanel.OnPetClick, { sort } }, this.lua_script_)
    Util.SetRoot(icon_ins.transform, icon_root)
    local add_image = pet_ins.transform:Find("add_image")
    local red_point = pet_ins.transform:Find("red_point")
    local level_text = icon_ins.transform:Find("num")
    local mask_image = icon_ins.transform:Find("mask_image")
    mask_image.gameObject:SetActive(not state.had_pet)
    level_text.gameObject:SetActive(state.had_pet)
    if state.had_pet then
        add_image.gameObject:SetActive(state.had_state.can_get_reputation)
        red_point.gameObject:SetActive(false)
        level_text:GetComponent("Text").text = "LV " .. state.had_state.pet_info.level
        fill_blue.gameObject:SetActive(true)
        fill_green.gameObject:SetActive(false)
        fill_red.gameObject:SetActive(false)
        slider.fillRect = fill_blue:GetComponent("RectTransform")
        if state.had_state.is_max_level then
            slider.maxValue = 1
            slider.value = 1
            shard_text:GetComponent("Text").text = "Max"
        else
            slider.maxValue = state.had_state.need_exp
            slider.value = state.had_state.cur_exp
            shard_text:GetComponent("Text").text = math.floor((slider.value / slider.maxValue) * 100) .. "%"
        end
        if pet_ins.transform.parent ~= this.had_pets_root_ then
            pet_ins.transform:SetParent(this.had_pets_root_, false)
        end
    else
        add_image.gameObject:SetActive(false)
        red_point.gameObject:SetActive(state.no_state.shard_enough)
        local maxValue = state.no_state.need_shard
        local value = state.no_state.cur_shard
        slider.maxValue = maxValue
        slider.value = value
        fill_green.gameObject:SetActive(state.no_state.shard_enough)
        fill_blue.gameObject:SetActive(false)
        fill_red.gameObject:SetActive(not state.no_state.shard_enough)
        if state.no_state.shard_enough then
            slider.fillRect = fill_green:GetComponent("RectTransform")
        else
            slider.fillRect = fill_red:GetComponent("RectTransform")
        end
        shard_text:GetComponent("Text").text = value .. "/" .. maxValue
        if pet_ins.transform.parent ~= this.no_had_pets_root_ then
            pet_ins.transform:SetParent(this.no_had_pets_root_, false)
        end
    end
end

function PetPanel.SetHeight()
    local row_1 = math.ceil(this.had_count_ / 5)
    local height_1 = row_1 * 112 + (row_1 - 1) * 10
    local row_2 = math.ceil(this.no_had_count_ / 5)
    local height_2 = row_2 * 112 + (row_2 - 1) * 10
    local rect_1 = this.had_pets_root_:GetComponent("RectTransform")
    rect_1.sizeDelta = Vector2(rect_1.sizeDelta.x, height_1)
    local rect_2 = this.no_had_pets_root_:GetComponent("RectTransform")
    rect_2.sizeDelta = Vector2(rect_2.sizeDelta.x, height_2)
end

function PetPanel.OnPetClick(obj, params)
    local index = params[1]
    this.cur_click_index_ = index
    local pet_guid = "0"
    local had_pet = this.pet_states_[index].had_pet
    local pet_id = this.pet_states_[index].t_pet.id
    if had_pet then
        local can_get_reputation = this.pet_states_[index].had_state.can_get_reputation
        if can_get_reputation then
            this.cur_get_pet_id_ = pet_id
            BookPanel.cur_unlock_type_ = 1
            local msg = item_msg_pb.cmsg_draws_unlock()
            msg.type = BookPanel.cur_unlock_type_
            msg.draw_id = pet_id
            msg.param = 0
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_DRAWS_UNLOCK ,data, {opcodes.SMSG_DRAWS_UNLOCK})
        else
            pet_guid = this.pet_states_[index].had_state.pet_info.guid
            GUIRoot.ShowPanel("PetDetailPanel", { pet_guid, this.pet_states_[index].t_pet.id })
        end
    else
        GUIRoot.ShowPanel("PetDetailPanel", { pet_guid, this.pet_states_[index].t_pet.id })
    end
end

function PetPanel.OnPetSynt(message)
    PetPanel.RefreshPanel()
end

function PetPanel.OnGetReputation(message)
    if BookPanel.cur_unlock_type_ ~= 1 then
        return
    end
    local t_pet = Config.get_config_value("t_pet", this.cur_get_pet_id_)
    local index = GameSys.getIndex(PlayerData.player.pet_ids, t_pet.id)
    PlayerData.player.pet_unlocks[index] = 1
    PlayerData.add_resource(5, t_pet.reputation)
    --刷新图标
    local pet_state = this.pet_states_[this.cur_click_index_]
    pet_state.had_state.can_get_reputation = false
    local ins = this.pet_inss_[this.cur_click_index_]
    PetPanel.SetPetIcon(ins, pet_state, this.cur_click_index_)

    local msg = CommonMessage()
    msg.name = "get_pet_reputation_success"
    messMgr:AddCommonMessage(msg)
end
