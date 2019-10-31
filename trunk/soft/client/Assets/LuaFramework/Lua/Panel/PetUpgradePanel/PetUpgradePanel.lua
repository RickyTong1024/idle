PetUpgradePanel = {}

PetUpgradePanel.Control = {}
local this = PetUpgradePanel.Control

PetUpgradePanel.start_press_beat_ = 1
PetUpgradePanel.end_press_beat_ = 0.2
PetUpgradePanel.change_time_ = 2

function PetUpgradePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.attrs_root_ = this.transform_:Find("back_ground/panel_among/attr_back_image/attrs_root")
    this.attr_text_ = this.transform_:Find("back_ground/panel_among/attr_back_image/attr_text")
    this.mats_root_ = this.transform_:Find("back_ground/panel_among/mat_detail/mats_root")
    this.feed_btn_ = this.transform_:Find("back_ground/panel_among/feed_btn")
    this.feed_tip_text_ = this.transform_:Find("back_ground/panel_among/feed_tip_text")
    this.exp_slider_ = nil
    this.level_text_ = nil

    this.pet_guid_ = "0"
    this.pet_id_ = 0
    this.attr_inss_ = {}
    this.food_texts_ = {}
    this.level_state_ = {}

    this.press_beat_ = 1
    this.is_pressed_ =false
    this.press_count_ = 0
    this.press_timer_ = 0
    this.cur_press_index_ = 0
    this.feed_to_enhance_ = false

    UpdateBeat:Add(PetUpgradePanel.Update, PetUpgradePanel)

    PetUpgradePanel.RegisterBtnListers()
    PetUpgradePanel.RegisterMessage()
end

function PetUpgradePanel.OnDestroy()
    UpdateBeat:Remove(PetUpgradePanel.Update, PetUpgradePanel)
    PetUpgradePanel.RemoveMessage()
    this = {}
end


function PetUpgradePanel.OnParam(params)
    this.pet_guid_ = params[1]
    this.pet_id_ = params[2]
end

function PetUpgradePanel.Update()
    if this.is_pressed_ then
        this.press_timer_ = this.press_timer_ + Time.deltaTime
        if this.press_timer_ >= this.press_beat_ then
            PetUpgradePanel.OnFeed(this.cur_press_index_)
            this.press_count_ = this.press_count_ + 1
            this.press_timer_ = 0
        end
        if this.press_beat_ > PetUpgradePanel.end_press_beat_ then
            this.press_beat_ = this.press_beat_ - (PetUpgradePanel.start_press_beat_ - PetUpgradePanel.end_press_beat_) / PetUpgradePanel.change_time_  * Time.deltaTime
            if this.press_beat_ <= PetUpgradePanel.end_press_beat_ then
                this.press_beat_ = PetUpgradePanel.end_press_beat_
            end
        end
    end
end

function PetUpgradePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PetUpgradePanel.OnCloseBtnClick, nil)
end

function PetUpgradePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_PET_FEED, PetUpgradePanel.FeedDone)
end

function PetUpgradePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_PET_FEED, PetUpgradePanel.FeedDone)
end

function PetUpgradePanel.Start(obj)
    PetUpgradePanel.RefreshPanel()
end

function PetUpgradePanel.RefreshPanel()
    PetUpgradePanel.SetDate()
    local info_ins = CommonPanel.SetPetInfoPanel(PlayerData.pets[this.pet_guid_], this.pet_id_, this.lua_script_, this.info_root_)
    this.exp_slider_ = info_ins.transform:Find("exp_slider")
    this.level_text_ = Util.FindSub(info_ins.transform, "desc_text"):GetComponent("Text")
    PetUpgradePanel.CreateAttrs()
    PetUpgradePanel.CreateFeedBtns()
end

function PetUpgradePanel.SetDate()
    this.attr_inss_ = {}
    this.food_texts_ = {}
    this.level_state_ = {
        ["cur_level"] = 0,
        ["cur_exp"] = 0,
        ["is_max_level"] = false,
        ["next_level"] = 0,
        ["need_exp"] = 0,
        ["attrs"] = {},
        ["feeds"] = {},
        ["enhance"] = 0,
        ["need_enhance"] = false
    }
    local cur_level = PlayerData.pets[this.pet_guid_].level
    local cur_exp = PlayerData.pets[this.pet_guid_].exp
    local enhance = PlayerData.pets[this.pet_guid_].enhance
    local need_enhance = GameSys.PetNeedEnhance(cur_level, enhance)
    local next_level = cur_level + 1
    local t_next_pet_level = Config.get_config_value("t_level", next_level)
    local is_max_level = t_next_pet_level == nil
    local t_pet = Config.get_config_value("t_pet", this.pet_id_)
    local attrs = PetUpgradePanel.SetPetAttrs(t_pet, cur_level, is_max_level)
    local need_exp = 0
    if not is_max_level then
        need_exp = t_next_pet_level.pet_exp
    end
    local feeds = {}
    local item_config = Config.t_item
    for k, v in pairs(item_config) do
        if v.type == 3003 then
            local t = {
                ["item_id"] = k,
                ["num"] = GameSys.GetItemCount(k),
                ["exp"] = v.res[1].value,
                ["feed_count"] = 0,
            }
            table.insert(feeds, t)
        end
    end
    table.sort(feeds, function(a, b)
        return a.item_id < b.item_id
    end)

    this.level_state_.cur_level = cur_level
    this.level_state_.cur_exp = cur_exp
    this.level_state_.is_max_level = is_max_level
    this.level_state_.next_level = next_level
    this.level_state_.need_exp = need_exp
    this.level_state_.attrs = attrs
    this.level_state_.feeds = feeds
    this.level_state_.enhance = enhance
    this.level_state_.need_enhance = need_enhance
end

function PetUpgradePanel.SetPetAttrs(t_pet, cur_level, is_max_level)
    local attrs = {}
    local cur_attrs = GameSys.GetPetAttrs(cur_level, t_pet.id)
    local next_attrs = {}
    if not is_max_level then
        next_attrs = GameSys.GetPetAttrs(cur_level + 1, t_pet.id)
    end
    for i = 1, #cur_attrs do
        local next_v = 0
        if not is_max_level then
            next_v = next_attrs[i].value
        end
        local next_v = 0
        if not is_max_level then
            next_v = GameSys.ConversionAttr(next_attrs[i].t_attr.id, next_attrs[i].value)
        end
        local t = {
            attr_id = cur_attrs[i].t_attr.id,
            cur_value = GameSys.ConversionAttr(cur_attrs[i].t_attr.id, cur_attrs[i].value),
            next_value = next_v
        }
        table.insert(attrs, t)
    end
    return attrs
end

function PetUpgradePanel.SetSlider(is_max_level, cur_exp, next_exp)
    local slider = this.exp_slider_.transform:GetComponent("Slider")
    if is_max_level then
        slider.maxValue = 1
        slider.value = 1
        this.exp_slider_:Find("exp_text"):GetComponent("Text").text = "Max"
    else
        slider.maxValue = next_exp
        slider.value = cur_exp
        this.exp_slider_:Find("exp_text"):GetComponent("Text").text = string.format("%s/%s", GameSys.unit_conversion(cur_exp), GameSys.unit_conversion(next_exp))
    end
end

function PetUpgradePanel.SetLevelText(level, enhance)
    local t_pet_enhance = Config.get_config_value("t_pet_enhance", enhance + 1)
    if this.level_text_ == nil then
        return
    end
    if t_pet_enhance == nil then
        this.level_text_.text = string.format("LV %d", level)
    else
        this.level_text_.text = string.format("LV %d/%d", level, t_pet_enhance.level)
    end
end

function PetUpgradePanel.CreateAttrs()
    Util.ClearChild(this.attrs_root_)
    for i = 1, #this.level_state_.attrs do
        local attr_ins = GameObject.Instantiate(this.attr_text_.gameObject)
        attr_ins:SetActive(true)
        attr_ins.transform:SetParent(this.attrs_root_)
        attr_ins.transform.localScale = Vector3.one
        this.attr_inss_[i] = attr_ins
    end
    PetUpgradePanel.SetAttrIns(this.level_state_.attrs, this.attr_inss_)
end

function PetUpgradePanel.SetAttrIns(attrs, attr_inss)
    for i = 1, #attrs do
        local attr_ins = attr_inss[i]
        local attr_title = attr_ins.transform:Find("attr_title")
        local attr_value = attr_ins.transform:Find("attr_value")
        local next_attr_value = attr_ins.transform:Find("next_attr_value")
        attr_title:GetComponent("Text").text = GameSys.GetAttrNameText(attrs[i].attr_id)
        attr_value:GetComponent("Text").text = attrs[i].cur_value
        if this.level_state_.is_max_level then
            next_attr_value:GetComponent("Text").text = "Max"
        else
            next_attr_value:GetComponent("Text").text = this.level_state_.attrs[i].next_value
        end

    end
end

function PetUpgradePanel.SetFoodNum(index, num)
    local text = this.food_texts_[index]
    if text == nil then
        return
    end
    text:GetComponent("Text").text = num
end

function PetUpgradePanel.CreateFeedBtns()
    Util.ClearChild(this.mats_root_)
    if this.level_state_.is_max_level then
        return
    end
    for i = 1, #this.level_state_.feeds do
        local feed_ins = GameObject.Instantiate(this.feed_btn_.gameObject)
        feed_ins:SetActive(true)
        feed_ins.transform:SetParent(this.mats_root_)
        feed_ins.transform.localScale = Vector3.one
        local icon_root = feed_ins.transform:Find("icon_root")
        local asset = {
            type = 2,
            value1 = this.level_state_.feeds[i].item_id,
            value2 = 0,
            value3 = 0
        }
        Util.ClearChild(icon_root)
        local icon_ins = GameSys.GetAssetIcon(asset, this.lua_script_)
        Util.SetRoot(icon_ins.transform, icon_root)
        this.lua_script_:AddDownEvent(icon_ins, PetUpgradePanel.OnFeedBtnDown, {i})
        this.lua_script_:AddUpEvent(icon_ins, PetUpgradePanel.OnFeedBtnUp, {i})
        local num_text = icon_ins.transform:Find("num")
        num_text.gameObject:SetActive(true)
        this.food_texts_[i] = num_text
        local exp_text = feed_ins.transform:Find("exp_text")
        local exp_value = GameSys.unit_conversion(this.level_state_.feeds[i].exp)
        exp_text:GetComponent("Text").text = string.format("exp+%s", exp_value)
        PetUpgradePanel.SetFoodNum(i, this.level_state_.feeds[i].num)
    end
end

function PetUpgradePanel.OnFeedBtnDown(obj, eventdate, params)
    this.is_pressed_ = true
    this.press_count_ = 0
    this.press_timer_ = 0
    this.press_beat_ = PetUpgradePanel.start_press_beat_
    this.cur_press_index_ = params[1]
    this.is_pressed_ = true
end

function PetUpgradePanel.OnFeedBtnUp(obj, eventdate, params)
    this.is_pressed_ = false
    if this.press_count_ <= 0 then
        PetUpgradePanel.OnFeed(this.cur_press_index_)
    end
    this.press_count_ = 0
    this.cur_press_index_ = 0
    this.press_timer_ = 0
end

function PetUpgradePanel.OnFeed(index)
    if this.level_state_.need_enhance then
        GUIRoot.ShowPanel("MessagePanel", { "进阶后可继续喂养" })
        return
    end
    if this.level_state_.is_max_level then
        GUIRoot.ShowPanel("MessagePanel", { "达到最大等级,不能喂食" })
        return
    end
    if this.level_state_.feeds[index].num <= 0 then
        GUIRoot.ShowPanel("MessagePanel", { "饲料不足" })
        return
    end
    this.level_state_.feeds[index].num = this.level_state_.feeds[index].num - 1
    this.level_state_.feeds[index].feed_count = this.level_state_.feeds[index].feed_count + 1
    PetUpgradePanel.SetFoodNum(index, this.level_state_.feeds[index].num)
    PetUpgradePanel.SetExp(this.level_state_.feeds[index].exp)
end

function PetUpgradePanel.SetExp(exp)
    this.level_state_.cur_exp = this.level_state_.cur_exp + exp
    while this.level_state_.cur_exp >= this.level_state_.need_exp and this.level_state_.need_exp > 0 do
        this.level_state_.cur_level = this.level_state_.cur_level + 1
        this.level_state_.need_enhance = GameSys.PetNeedEnhance(this.level_state_.cur_level, this.level_state_.enhance)
        local t_next_level = Config.get_config_value("t_level", this.level_state_.cur_level + 1)
        this.level_state_.is_max_level = t_next_level == nil
        if this.level_state_.need_enhance then
            this.level_state_.cur_exp = 0
            if this.level_state_.is_max_level then
                this.level_state_.need_exp = 0
            else
                this.level_state_.need_exp = t_next_level.pet_exp
            end
        else
            if this.level_state_.is_max_level then
                this.level_state_.cur_exp = 0
                this.level_state_.need_exp = 0
            else
                this.level_state_.cur_exp = this.level_state_.cur_exp - this.level_state_.need_exp
                this.level_state_.need_exp = t_next_level.pet_exp
            end
        end
    end
    local attrs = PetUpgradePanel.SetPetAttrs(Config.get_config_value("t_pet", this.pet_id_), this.level_state_.cur_level, this.level_state_.is_max_level)
    this.level_state_.attrs = attrs
    PetUpgradePanel.SetAttrIns(this.level_state_.attrs, this.attr_inss_)
    PetUpgradePanel.SetLevelText(this.level_state_.cur_level, this.level_state_.enhance)
    PetUpgradePanel.SetSlider(this.level_state_.is_max_level, this.level_state_.cur_exp, this.level_state_.need_exp)
    if this.level_state_.need_enhance then
        this.feed_to_enhance_ = true
        PetUpgradePanel.SendFeedMessage()
        return
    end
end

function PetUpgradePanel.OnCloseBtnClick(obj, params)
    PetUpgradePanel.SendFeedMessage()
end

function PetUpgradePanel.SendFeedMessage()
    local msg = player_msg_pb.cmsg_pet_feed()
    msg.pet_guid = this.pet_guid_
    local sure_send = false
    for i = 1, #this.level_state_.feeds do
        if this.level_state_.feeds[i].feed_count > 0 then
            sure_send = true
            break
        end
    end
    for i = 1, #this.level_state_.feeds do
        msg.pet_food_id:append(this.level_state_.feeds[i].item_id)
        msg.pet_food_num:append(this.level_state_.feeds[i].feed_count)
    end
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_PET_FEED, data, { opcodes.SMSG_PET_FEED })
end

function PetUpgradePanel.FeedDone(message)
    local pet = PlayerData.pets[this.pet_guid_]
    for i = 1, #this.level_state_.feeds do
        PlayerData.remove_item(this.level_state_.feeds[i].item_id, this.level_state_.feeds[i].feed_count)
        PlayerData.pet_add_exp(pet, this.level_state_.feeds[i].exp * this.level_state_.feeds[i].feed_count)
    end
    local common_msg = CommonMessage()
    common_msg.name = "pet_feed_sucess"
    messMgr:AddCommonMessage(common_msg)
    if this.feed_to_enhance_ then
        this.feed_to_enhance_ = false
        GUIRoot.ClosePanel("PetUpgradePanel")
        GUIRoot.ShowPanel("PetEnhancePanel", { this.pet_guid_, this.pet_id_ })
    else
        GUIRoot.ClosePanel("PetUpgradePanel")
    end
end
