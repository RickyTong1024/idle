PowerChangePanel = {}
PowerChangePanel.Control = {}
local this = PowerChangePanel.Control
function PowerChangePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

    this.transform_ = this.transform_
    this.background_ = this.transform_:Find("background")
    this.background2_ = this.transform_:Find("background2")
    this.direction_ = this.transform_:Find("background/dt/direction")
    this.text_obj_ = this.transform_:Find("background/dt/text_obj")
    this.power_ = this.transform_:Find("background/dt/power")
    this.power_res_ = this.transform_:Find("power_res")
    this.background_image_ = {"gjrui_102", "gjrui_103"}
    this.dir_image_ = {"gjrui_102a", "gjrui_103a"}
    this.color_outline_ = {Color(192 / 255, 41 / 255, 1 / 255), Color(1 / 255 , 127 / 255, 192 / 255)}
    this.power_num_ = 0
    this.num_obj1_ = {}
    this.num_obj2_ = {}
    this.num_l1_ = {}
    this.num_l2_ = {}
    this.speed_ = {}
    this.m_index_ = 1
    this.m_cishu_ = 0
    this.m_finish_ = false
    this.m_time_ = 0
    PowerChangePanel.GetNumObj()
end

function PowerChangePanel.OnEnable()
    this.transform_:SetAsLastSibling()
    UpdateBeat:Add(PowerChangePanel.Update, PowerChangePanel)
end

function PowerChangePanel.OnDisable()
    UpdateBeat:Remove(PowerChangePanel.Update, PowerChangePanel)
end

function PowerChangePanel.GetNumObj()
    if this.text_obj_ ~= nil then
        for i = 1, 8 do
            local obj1 = this.text_obj_:Find("p"..i)
            table.insert(this.num_obj1_, obj1)
            local obj2 = this.text_obj_:Find("p"..i.."/p"..i.."ex")
            table.insert(this.num_obj2_, obj2)
        end
    end
end

function PowerChangePanel.OnDestroy()
    this = {}
end

function PowerChangePanel.OnParam(param)
    this.num_l1_ = {}
    this.num_l2_ = {}
    this.speed_ = {}
    this.m_index_ = 1
    this.m_cishu_ = 0
    this.m_finish_ = false
    this.m_time_ = 0
    this.power_num_ = param[1]
    PowerChangePanel.Init(this.power_num_)
end

function PowerChangePanel.OnReParam(param)
    PowerChangePanel.OnParam(param)
end

function PowerChangePanel.Init(power)
    local temp_num = math.abs(power)
    if temp_num ~= 0 then
        local color = Color.New(0, 0 ,0)
        if power < 0 then
            this.background_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.background_image_[1])
            this.direction_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.dir_image_[1])
            this.direction_.transform.localRotation = Vector3(0 , 0, 180)
            color = this.color_outline_[1]
        else
            this.background_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.background_image_[2])
            this.direction_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.dir_image_[2])
            this.direction_.transform.localRotation = Vector3(0 , 0, 0)
            color = this.color_outline_[2]
        end
        for i = 1, #this.num_obj1_ do
            this.num_obj1_[i]:GetComponent("Outline").effectColor = color
            this.num_obj2_[i]:GetComponent("Outline").effectColor = color
        end
        this.power_:GetComponent("Outline").effectColor = color
        this.num_l1_ = {}
        this.num_l2_ = {}
        this.speed_ = {}
        this.power_num_ = temp_num
        this.m_index_ = 1
        this.m_cishu_ = 0
        this.m_finish_ = false
        this.m_time_ = 0

        while (temp_num > 0 and #this.num_l1_ < #this.num_obj1_)
        do
            table.insert(this.num_l1_, math.floor(temp_num % 10))
            temp_num = math.floor(temp_num / 10)
        end

        for _ = 1, #this.num_l1_ do
            table.insert(this.num_l2_, math.floor(math.random(0, 10)))
            table.insert(this.speed_, math.random(600, 1000))
        end
        local w = #this.num_l1_ * 30
        this.text_obj_:GetComponent("RectTransform").sizeDelta = Vector2(w + 60, 30)
        this.power_.transform.localPosition = Vector3(-w - 60, 0, 0)
        for i = 1, #this.num_obj1_ do
            if i <= #this.num_l1_ then
                this.num_obj1_[i].transform.localPosition = Vector3(w / 2 -  i * 30 - 40, 0, 0)
                this.num_obj1_[i].gameObject:SetActive(true)
            else
                this.num_obj1_[i].gameObject:SetActive(false)
            end
        end

        for i = 1, #this.num_l1_ do
            PowerChangePanel.Set_num(this.num_obj1_[i], this.num_l2_[i])
            PowerChangePanel.Set_num(this.num_obj1_[i], this.num_l2_[i] + 1)
        end
        this.background_.gameObject:SetActive(true)
    else
        this.background_.gameObject:SetActive(false)
    end

    local temp = {}
    local temp_data = PlayerData.get_attr()
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
    GameSys.ClearChild(this.background2_)
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
        attr_text.transform:SetParent(this.background2_, false)
        attr_text.transform.localPosition = Vector3.zero
        attr_text.transform.localScale = Vector3.one
        attr_text.gameObject:SetActive(true)
    end
    QuestManger.Radio()
    PlayerData.cur_attr = PlayerData.get_attr()
end

function PowerChangePanel.Set_num(obj, num)
    obj:GetComponent("LocalizationText").text = tostring(num % 10)
end

function PowerChangePanel.Close()
    GUIRoot.ClosePanel("PowerChangePanel")
end

function PowerChangePanel.Update()
    for i = this.m_index_, #this.num_l1_ do
        local v = this.num_obj1_[i].transform.localPosition
        v.y = v.y + Time.deltaTime * this.speed_[i]
        while (v.y > 30)
        do
           v.y = v.y - 20
            this.num_l2_[i] = this.num_l2_[i] + 1
            if this.num_l2_[i] >= 10 then
                this.num_l2_[i] = 0
            end
            PowerChangePanel.Set_num(this.num_obj1_[i],  this.num_l2_[i])
            PowerChangePanel.Set_num(this.num_obj2_[i],  this.num_l2_[i] + 1)
            if i == this.m_index_ then
                this.m_cishu_ = this.m_cishu_ + 1
                local cs = 2
                if i == 1 then
                    cs = 7
                end
                if this.m_cishu_ > cs and this.num_l2_[i] == this.num_l1_[i] then
                    this.m_index_ = this.m_index_ + 1
                    this.m_cishu_ = 0
                    v.y = 0
                end
            end
        end
        this.num_obj1_[i].transform.localPosition = v
    end

    if this.m_index_ >= #this.num_l1_ then
        this.m_time_ = this.m_time_ + Time.deltaTime
        if not this.m_finish_ and this.m_time_ > 1 then
            this.m_finish_ = true
            PowerChangePanel.Close()
        end
    end
end
