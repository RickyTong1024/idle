MessagePanel = {}
MessagePanel.Control = {}
local this = MessagePanel.Control

function MessagePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.layout_ = this.transform_:Find("layout")
    this.message_ = this.transform_:Find("message")
    this.asset_message_ = this.transform_:Find("asset_message")

    this.message_infos_ = {}

    this.time_ = 0.8
    this.dis_time_ = 0.5
    this.max_mes_count_ = 4
end

function MessagePanel.OnEnable()
    this.transform_:SetAsLastSibling()
    UpdateBeat:Add(MessagePanel.Update, MessagePanel)
end

function MessagePanel.OnDisable()
    UpdateBeat:Remove(MessagePanel.Update, MessagePanel)
end

function MessagePanel.OnDestroy(obj)
    this = {}
end

function MessagePanel.OnParam(params)
    if State.cur_state == State.state.ss_battle and not (#params == 1 and type(params[1]) == "string") then
        return
    end
    MessagePanel.SetParams(params)
end

function MessagePanel.OnReParam(params)
    if State.cur_state == State.state.ss_battle and not (#params == 1 and type(params[1]) == "string") then
        return
    end
    MessagePanel.SetParams(params)
    if #this.message_infos_ > this.max_mes_count_ then
        MessagePanel.RmoveMessageIns(1)
    end
end

function MessagePanel.SetParams(params)
    local content = params[1]
    if #params == 1 and type(params[1]) == "string" then
        MessagePanel.RefreshPanel(content, "text")
    elseif #params == 2 and params[1] == "asset" then
        MessagePanel.RefreshPanel(params[2], "asset")
    elseif #params == 2 and params[1] == "equip" then
        MessagePanel.RefreshPanel(params[2], "equip")
    elseif #params == 2 and params[1] == "pet" then
        MessagePanel.RefreshPanel(params[2], "pet")
    end
end

function MessagePanel.Update()
    for i = #this.message_infos_, 1, -1 do
        local message_info = this.message_infos_[i]
        if message_info.can_timer then
            message_info.timer = message_info.timer + Time.deltaTime
            if message_info.timer >= this.time_ then
                message_info.can_timer = false
                message_info.dis = true
            end
        end
        if message_info.dis then
            message_info.dis_timer = message_info.dis_timer + Time.deltaTime
            message_info.canvas_group.alpha = message_info.canvas_group.alpha - (1 / this.dis_time_) * Time.deltaTime
            if message_info.dis_timer >= this.dis_time_ then
                MessagePanel.RmoveMessageIns(i)
            end
        end
    end
    if next(this.message_infos_) == nil then
        GUIRoot.ClosePanel("MessagePanel")
    end
end

function MessagePanel.RefreshPanel(content, type)
    soundMgr:play_sound("tips")
    local t = {
        ["can_timer"] = true,
        ["timer"] = 0,
        ["mes_ins"] = nil,
        ["dis"] = false,
        ["dis_timer"] = 0,
        ["canvas_group"] = nil
    }
    local message_ins = nil
    if type == "text" then
        message_ins = GameObject.Instantiate(this.message_.gameObject)
        message_ins:SetActive(true)
        local text = message_ins.transform:Find("message_text")
        text:GetComponent("Text").text = content
    else
        message_ins = GameObject.Instantiate(this.asset_message_.gameObject)
        message_ins:SetActive(true)
        local get_text = message_ins.transform:Find("content/get_text")
        local icon_root = message_ins.transform:Find("content/icon_root")
        local desc = message_ins.transform:Find("content/desc")
        local icon = nil
        local desc_text = ""
        if type == "asset" then
            local asset = content
            local num = asset.value2
            local icon_asset = {
                type = asset.type,
                value1 = asset.value1,
                value2 = 0,
                value3 = 0
            }
            icon = GameSys.GetAssetIcon(icon_asset, this.lua_script_)
            local t_config = GameSys.GetAssetConfig(asset)
            desc_text = GameSys.set_color(t_config.color, t_config.name) .. " x" .. GameSys.unit_conversion(num)
        elseif type == "equip" then
            local equip_info = content
            icon = CommonPanel.GetEquipIcon(equip_info, nil, this.lua_script_)
            local t_equip = Config.get_config_value("t_equip", equip_info.template_id)
            desc_text = GameSys.set_color(equip_info.color, t_equip.name) .. " x" .. 1
        elseif type == "pet" then
            local pet_info = content
            local t_pet = Config.get_config_value("t_pet", pet_info.template_id)
            icon = CommonPanel.GetPetIcon(pet_info, this.lua_script_)
            desc_text = GameSys.set_color(t_pet.color, t_pet.name) .. " x" .. 1
        end
        icon.transform:Find("quality").gameObject:SetActive(false)
        icon.transform:SetParent(icon_root, false)
        icon.transform.localScale = Vector3(0.37, 0.37, 0)
        icon:GetComponent("RectTransform").anchoredPosition = Vector2(0, 0)
        desc:GetComponent("Text").text = desc_text
        local get_text_rect = get_text:GetComponent("RectTransform")
        local get_text_w = LayoutUtility.GetPreferredWidth(get_text_rect)
        local desc_rect = desc:GetComponent("RectTransform")
        local desc_text_w = LayoutUtility.GetPreferredWidth(desc_rect)
        local total = get_text_w + 10 + 30 + 10 + desc_text_w
        local offset_1 = (620 - total) / 2
        get_text_rect.anchoredPosition = Vector2(offset_1, 0)
        icon_root:GetComponent("RectTransform").anchoredPosition = Vector2(offset_1 + get_text_w + 10, 0)
        desc_rect.anchoredPosition = Vector2(offset_1 + get_text_w + 10 + 30 + 10, 0)
    end
    message_ins.transform:SetParent(this.layout_, false)
    t.mes_ins = message_ins
    t.canvas_group = message_ins:GetComponent("CanvasGroup")
    table.insert(this.message_infos_, t)
end

function MessagePanel.RmoveMessageIns(sort)
    GameObject.Destroy(this.message_infos_[sort].mes_ins)
    table.remove(this.message_infos_, sort)
end
