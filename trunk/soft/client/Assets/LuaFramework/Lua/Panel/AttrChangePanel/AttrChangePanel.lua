AttrChangePanel = {}

AttrChangePanel.Control = {}
local this = AttrChangePanel.Control

function AttrChangePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.background_ = this.transform_:Find("background")
    this.power_res_ = this.transform_:Find("power_res")
    this.m_time_ = 0
end

function AttrChangePanel.OnEnable()
    this.transform_:SetAsLastSibling()
    UpdateBeat:Add(AttrChangePanel.Update, AttrChangePanel)
end

function AttrChangePanel.OnDisable()
    UpdateBeat:Remove(AttrChangePanel.Update, AttrChangePanel)
end

function AttrChangePanel.OnDestroy()
    this = {}
end

function AttrChangePanel.OnParam(param)
    this.m_time_ = 0
    this.attr_data_ = param[1]
    AttrChangePanel.Init(this.attr_data_)
end

function AttrChangePanel.OnReParam(param)
    AttrChangePanel.OnParam(param)
end

function AttrChangePanel.Init(attr_data_)
    local temp = {}
    local temp_data = attr_data_
    for k, v in pairs(temp_data) do
        if PlayerData.cur_attr[k] ~= temp_data[k] then
            local attr_p = Config.get_config_value("t_attr", k)
            if attr_p.scale == 1 then
                if math.abs(temp_data[k] - PlayerData.cur_attr[k] ) >= 1 then
                    temp[k] = temp_data[k] - PlayerData.cur_attr[k]
                end
            else
                temp[k] = temp_data[k] - PlayerData.cur_attr[k]
            end
        end
    end
    GameSys.ClearChild(this.background_)
    for k, v in pairs(temp) do
        local attr_text = GameObject.Instantiate(this.power_res_.gameObject)
        local attr_d = Config.get_config_value("t_attr", k)
        local str = ""
        local str_num = ""
        if attr_d.scale == 1 then
            str_num = tostring(toInt(v))
        else
            str_num = string.format("%.1f", v)
        end

        if v >= 0 then
            str = GameSys.TextDealPlaceholder(attr_d.desc, str_num)
        else
            str = GameSys.TextDealPlaceholder(string.gsub(attr_d.desc, '+', ''), str_num)
        end
        attr_text:GetComponent("LocalizationText").text = GameSys.MatEnoughColor(str, v > 0)
        attr_text.transform:SetParent(this.background_, false)
        attr_text.transform.localPosition = Vector3.zero
        attr_text.transform.localScale = Vector3.one
        attr_text.gameObject:SetActive(true)
    end
end

function AttrChangePanel.Close()
    GUIRoot.ClosePanel("AttrChangePanel")
end

function AttrChangePanel.Update()
    if this.m_time_ < 2 then
        this.m_time_ = this.m_time_ + Time.deltaTime
        if this.m_time_ > 2 then
            AttrChangePanel.Close()
        end
    end
end
