ExpBar = Object:subclass("ExpBar")

ExpBar.hight_time = 0.5
ExpBar.one_bar_time = 3

ExpBar.prototype.level = 0
ExpBar.prototype.exp = 0
ExpBar.prototype.cur_level = 0
ExpBar.prototype.cur_exp = 0
ExpBar.prototype.is_max = false
ExpBar.prototype.speed = 0
ExpBar.prototype.hight_timer = 0
ExpBar.prototype.hight = false

ExpBar.prototype.exp_image = nil
ExpBar.prototype.hight_image = nil
ExpBar.prototype.hight_color = nil
ExpBar.prototype.exp_text = nil

function ExpBar.CreateExpBar(level, exp, exp_image, hight_image, exp_text)
    local exp_bar = ExpBar()
    exp_bar.level = level
    exp_bar.cur_level = level
    if exp < 0 then
        exp = 0
    end
    exp_bar.exp = exp
    exp_bar.cur_exp = exp
    exp_bar.exp_image = exp_image
    exp_bar.hight_image = hight_image
    exp_bar.hight_color = hight_image.transform:GetComponent("CanvasGroup")
    exp_bar.exp_text = exp_text
    local t_level = Config.get_config_value("t_level", level + 1)
    exp_bar.is_max = t_level == nil
    exp_bar.hight_image.gameObject:SetActive(false)
    exp_bar.hight = false
    exp_bar:Refresh()
    if not exp_bar.is_max then
        UpdateBeat:Add(exp_bar.Update, exp_bar, exp_bar)
    end

    return exp_bar
end

function ExpBar.prototype:Destroy()
    UpdateBeat:Remove(self.Update, self, self)
end

function ExpBar.prototype:SetExp(level, exp)
    if self.is_max then
        return
    end
    if exp < 0 then
        exp = 0
    end
    local t_next_level = Config.get_config_value("t_level", level + 1)
    if t_next_level == nil then
        self.cur_level = level
        self.cur_exp = Config.get_config_value("t_level", level).exp
    else
        self.cur_level = level
        self.cur_exp = exp
    end
    --算一下速度
    local sub_length = self:GetExpLength()
    local time = self:GetExpLengthPer()
    self.speed = sub_length / time
    --
    self.hight = true
    self.hight_timer = 0
    local fillAmount = self.exp_image.fillAmount
    self.hight_image.fillAmount = fillAmount
    self.hight_color.alpha = 1
    self.hight_image.gameObject:SetActive(true)
end

function ExpBar.prototype:Update()
    if self.hight then
        self.hight_timer = self.hight_timer + Time.deltaTime
        self.hight_color.alpha = 1 - (self.hight_timer / ExpBar.hight_time)
        if self.hight_timer >= ExpBar.hight_time then
            self.hight = false
            self.hight_time = 0
            self.hight_image.gameObject:SetActive(false)
        end
        return
    end
    if self.cur_level == self.level and self.cur_exp == self.exp then
        return
    end
    if self.speed == 0 then
        return
    end
    local sub_level = self.cur_level - self.level
    if sub_level == 0 then
        self.exp = self.exp + self.speed * Time.deltaTime
    elseif sub_level > 0 then
        local length = self.speed * Time.deltaTime
        self.exp = self.exp + length
        while true do
            local t_next_level = Config.get_config_value("t_level", self.level + 1)
            if t_next_level == nil then
                self.is_max = true
                self.exp = Config.get_config_value("t_level", self.level).exp
                break
            end

            if self.exp >= t_next_level.exp then
                self.level = self.level + 1
                self.exp = self.exp - t_next_level.exp
            else
                break
            end
        end
    else
        return
    end
    if self.level == self.cur_level then
        if self.speed > 0 and self.exp > self.cur_exp then
            self.exp = self.cur_exp
        end
        if self.speed < 0 and self.exp < self.cur_exp then
            self.exp = self.cur_exp
        end
    elseif self.level > self.cur_level then
        self.level = self.cur_level
        self.exp = self.cur_exp
    end

    self:Refresh()
end

function ExpBar.prototype:Refresh()
    if self.is_max then
        self.exp_image.fillAmount = 1
        self.exp_text = "Max"
    else
        local t_next_level = Config.get_config_value("t_level", self.level + 1)
        self.exp_image.fillAmount = self.exp / t_next_level.exp
        self.exp_text.text = GameSys.unit_conversion(math.floor(self.exp)) .. "/" .. GameSys.unit_conversion(t_next_level.exp)
    end
end

function ExpBar.prototype:GetExpLength()
    local sub = math.abs(self.cur_level - self.level)
    local sub_exp = self.cur_exp - self.exp
    local base_level = math.min(self.level, self.cur_level)
    if sub > 0 then
        for i = 1, sub do
            sub_exp = Config.get_config_value("t_level", base_level + i).exp + sub_exp
        end
    end
    local length = sub_exp
    return length
end

function ExpBar.prototype:GetExpLengthPer()
    local time = 0
    if self.cur_level == self.level then
        local sub_exp = math.abs(self.cur_exp - self.exp)
        local all_exp = Config.get_config_value("t_level", self.cur_level + 1).exp
        time = ExpBar.one_bar_time * (sub_exp / all_exp)
    elseif self.cur_level > self.level then
        local per = 0
        for i = self.level, self.cur_level do
            if i == self.level then
                local e = Config.get_config_value("t_level", self.level + 1).exp
                per = per + (e - self.exp) / e
            elseif i == self.cur_level then
                local e = Config.get_config_value("t_level", self.cur_level + 1).exp
                per = per + self.cur_exp / e
            else
                per = per + 1
            end
        end
        time = ExpBar.one_bar_time * per
    else
        time = 1
    end
    return time
end



