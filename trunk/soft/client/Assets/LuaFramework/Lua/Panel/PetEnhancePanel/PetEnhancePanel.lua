PetEnhancePanel = {}
PetEnhancePanel.Control = {}
local this = PetEnhancePanel.Control

function PetEnhancePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.transform = this.transform_:GetComponent('LuaUIBehaviour')
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.back_ground_ = this.transform_:Find("back_ground")
    this.panel_among_ = this.transform_:Find("back_ground/panel_among")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.attr_back_image_ = this.transform_:Find("back_ground/panel_among/attr_back_image")
    this.enhance_text_ = this.transform_:Find("back_ground/panel_among/attr_back_image/enhance_text")
    this.attr_title_ = this.transform_:Find("back_ground/panel_among/attr_back_image/attr_title")
    this.talent_text_1_ = this.transform_:Find("back_ground/panel_among/attr_back_image/talent_text_1")
    this.talent_text_2_ = this.transform_:Find("back_ground/panel_among/attr_back_image/talent_text_2")
    this.talent_text_3_ = this.transform_:Find("back_ground/panel_among/attr_back_image/talent_text_3")
    this.mats_root_ = this.transform_:Find("back_ground/panel_among/mat_detail/mats_root")
    this.enhance_btn_ = this.transform_:Find("back_ground/panel_among/enhance_btn")

    this.cur_pet_guid_ = "0"
    this.cur_pet_id_ = 0
    this.cur_t_pet_ = nil
    this.cur_enhance_ = 0
    this.cur_shard_ = 0
    this.need_shard_ = 0
    this.shard_enough_ = false
    this.is_max_enhance_ = false
    this.enhance_require_level_ = 0
    this.level_enough_ = false

    PetEnhancePanel.RegisterBtnListers()
    PetEnhancePanel.RegisterMessage()
end

function PetEnhancePanel.OnDestroy(obj)
    PetEnhancePanel.RemoveMessage()
    this = {}
end

function PetEnhancePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.transform, this.enhance_btn_.gameObject, "click", PetEnhancePanel.OnEnhanceBtnClick)
    GameSys.ButtonRegister(this.transform, this.close_btn_.gameObject, "click", PetEnhancePanel.OnCloseClick)
end

function PetEnhancePanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_PET_ENHANCE, PetEnhancePanel.OnEnhanceSuccess)
end

function PetEnhancePanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_PET_ENHANCE, PetEnhancePanel.OnEnhanceSuccess)
end

function PetEnhancePanel.OnParam(params)
    this.cur_pet_guid_ = params[1]
    this.cur_pet_id_ = params[2]
end

function PetEnhancePanel.Start(obj)
    PetEnhancePanel.RefreshPanel()
end

function PetEnhancePanel.RefreshPanel()
    PetEnhancePanel.SetData()
    CommonPanel.SetPetInfoPanel(PlayerData.pets[this.cur_pet_guid_], this.cur_pet_id_, this.transform, this.info_root_)
    local rect_h = 10
    if this.is_max_enhance_ then
        PetEnhancePanel.SetTextSlot(this.enhance_text_, "进化", "Lv" .. this.cur_enhance_, "Max")
    else
        PetEnhancePanel.SetTextSlot(this.enhance_text_, "进化", "Lv" .. this.cur_enhance_, "Lv" .. (this.cur_enhance_ + 1))
    end
    rect_h = rect_h + 30 * 2 + 10
    local talents = GameSys.GetPetTalents(this.cur_pet_id_, this.cur_enhance_)
    local had_talent = next(talents) ~= nil
    this.attr_title_.gameObject:SetActive(had_talent)
    if had_talent then
        rect_h = rect_h + 30
        local text_trs = { this.talent_text_1_, this.talent_text_2_, this.talent_text_3_ }
        for i = 1, #text_trs do
            local talent = talents[i]
            if talent == nil then
                text_trs[i].gameObject:SetActive(false)
            else
                text_trs[i].gameObject:SetActive(true)
                local title = GameSys.GetAttrNameText(talent.t_attr.id)
                local value1 = GameSys.GetAttrValueText(talent.t_pet_talent.attr_id, talent.value)
                local value2 = ""
                if this.is_max_enhance_ then
                    value2 = "Max"
                else
                    value2 =  GameSys.GetAttrValueText(talent.t_pet_talent.attr_id, talent.value + talent.t_pet_talent.attr_value_add)
                end
                PetEnhancePanel.SetTextSlot(text_trs[i], title, value1, value2)
                rect_h = rect_h + 30
            end
        end
        rect_h = rect_h + 10
    end
    GameSys.SetRectHeight(this.attr_back_image_, rect_h)
    Util.ClearChild(this.mats_root_)
    if not this.is_max_enhance_ then
        local mat_icon = GameSys.GetMatIcon(this.cur_t_pet_.shard_id, GameSys.GetItemCount(this.cur_t_pet_.shard_id), this.need_shard_, "pet_shard_mat_btn", this.transform)
        mat_icon.transform:SetParent(this.mats_root_)
        mat_icon.transform.localScale = Vector3.one
    end
    --设置下总高度
    LayoutRebuilder.ForceRebuildLayoutImmediate(this.panel_among_)
    local total_h =  LayoutUtility.GetPreferredHeight(this.panel_among_)
    GameSys.SetRectHeight(this.back_ground_, total_h)
end

function PetEnhancePanel.SetTextSlot(text_tr, title, value1, value2)
    local attr_title = text_tr:Find("attr_title")
    local attr_value = text_tr:Find("attr_value")
    local next_attr_value = text_tr:Find("next_attr_value")
    attr_title:GetComponent("Text").text = title
    attr_value:GetComponent("Text").text = value1
    next_attr_value:GetComponent("Text").text = value2
end

function PetEnhancePanel.SetData()
    this.cur_t_pet_ = Config.get_config_value("t_pet", this.cur_pet_id_)
    this.cur_enhance_ = PlayerData.pets[this.cur_pet_guid_].enhance
    local next_t_enhance = Config.get_config_value("t_pet_enhance", this.cur_enhance_ + 1)
    if next_t_enhance ~= nil then
        this.is_max_enhance_ = false
        this.enhance_require_level_ = next_t_enhance.level
        this.level_enough_ = (PlayerData.pets[this.cur_pet_guid_].level >= this.enhance_require_level_)
        this.need_shard_ = next_t_enhance.shard
        local shard_id = this.cur_t_pet_.shard_id
        this.cur_shard_ = GameSys.GetItemCount(shard_id)
        this.shard_enough_ = (this.cur_shard_ >= this.need_shard_)
    else
        this.is_max_enhance_ = true
    end
end

function PetEnhancePanel.OnEnhanceBtnClick(obj)
    if this.is_max_enhance_ then
        GUIRoot.ShowPanel("MessagePanel", { "达到进阶上限" })
        return
    end
    if not this.level_enough_ then
        GUIRoot.ShowPanel("MessagePanel", { string.format("宠物达到%d级可进阶", this.enhance_require_level_) })
        return
    end
    if not this.shard_enough_ then
        GUIRoot.ShowPanel("MessagePanel", { "碎片不足" })
        return
    end
    local msg = player_msg_pb.cmsg_pet_enhance()
    msg.pet_guid = this.cur_pet_guid_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_PET_ENHANCE, data, { opcodes.SMSG_PET_ENHANCE })
end

function PetEnhancePanel.OnEnhanceSuccess(message)
    PlayerData.remove_item(this.cur_t_pet_.shard_id, Config.get_config_value("t_pet_enhance", this.cur_enhance_ + 1).shard)
    PlayerData.pets[this.cur_pet_guid_].enhance = this.cur_enhance_ + 1
    GUIRoot.ShowPanel("MessagePanel", { "进阶成功" })
    PetEnhancePanel.Close()
end

function PetEnhancePanel.Close()
    GUIRoot.ClosePanel("PetEnhancePanel")
    GUIRoot.ShowPanel("PetUpgradePanel", { this.cur_pet_guid_, this.cur_pet_id_ })
end

function PetEnhancePanel.OnCloseClick(obj, param)
    GUIRoot.ClosePanel("PetEnhancePanel")
end