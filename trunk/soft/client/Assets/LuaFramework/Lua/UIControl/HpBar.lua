HpBar = Object:subclass("HpBar")
HpBar.hight_time = 0.1
HpBar.hight_dtime = 0.2
HpBar.max_reduce_time = 1
HpBar.min_reduce_time = 0.5
HpBar.max_reduce_num = 2
HpBar.min_reduce_num = 0.2
HpBar.max_add_time = 1
HpBar.min_add_time = 0.5
HpBar.max_add_num = 2
HpBar.min_add_num = 0.2

HpBar.prototype.raw_image = nil
HpBar.prototype.hp_text = nil
HpBar.prototype.layer_text = nil
HpBar.prototype.w = 0
HpBar.prototype.h = 0
HpBar.prototype.texture = nil
HpBar.prototype.bottom_color = nil
HpBar.prototype.colors = nil
HpBar.prototype.dcolors = nil
HpBar.prototype.hight_color = nil

HpBar.prototype.max_hp = 0
HpBar.prototype.cur_hp = 0
HpBar.prototype.cur_add_hp = 0
HpBar.prototype.single_hp = 0
HpBar.prototype.reduce_speed = 0
HpBar.prototype.add_speed = 0
HpBar.prototype.reduces = nil

HpBar.prototype.can_refresh = false

function HpBar.CreateHpBar(rawImage, hp_text, layer_text ,w, h)
    local hp_bar = HpBar()
    hp_bar.raw_image = rawImage
    hp_bar.hp_text = hp_text
    hp_bar.layer_text = layer_text
    hp_bar.w = w
    hp_bar.h = h
    hp_bar.texture = Texture2D(w, h)
	hp_bar.texture:Apply()
    hp_bar.raw_image.texture = hp_bar.texture
    local b, color_bottom = ColorUtility.TryParseHtmlString("#000000", nil)
    hp_bar.bottom_color = color_bottom
    local b, color_1 = ColorUtility.TryParseHtmlString("#E62208", nil)
    local b, color_2 = ColorUtility.TryParseHtmlString("#FF9B16", nil)
    local b, color_3 = ColorUtility.TryParseHtmlString("#8BB400", nil)
    local b, color_4 = ColorUtility.TryParseHtmlString("#0075C3", nil)
    local b, color_5 = ColorUtility.TryParseHtmlString("#A5A5FF", nil)
    hp_bar.colors = { color_1, color_2, color_3, color_4, color_5 }
	local b, color_1 = ColorUtility.TryParseHtmlString("#96332E", nil)
    local b, color_2 = ColorUtility.TryParseHtmlString("#9E8244", nil)
    local b, color_3 = ColorUtility.TryParseHtmlString("#6B7720", nil)
    local b, color_4 = ColorUtility.TryParseHtmlString("#0E4EBE", nil)
    local b, color_5 = ColorUtility.TryParseHtmlString("#6B6BA1", nil)
    hp_bar.dcolors = { color_1, color_2, color_3, color_4, color_5 }
    local b, hight_color = ColorUtility.TryParseHtmlString("#FFFFFF", nil)
    hp_bar.hight_color = hight_color
	hp_bar.can_refresh = false
    UpdateBeat:Add(hp_bar.Update, hp_bar, hp_bar)

    return hp_bar
end

function HpBar.prototype:Destroy()
	UpdateBeat:Remove(self.Update, self, self)
end

function HpBar.prototype:Init(total_hp, single_hp)
    self.max_hp = total_hp
    self.cur_hp = total_hp
	self.cur_add_hp = total_hp
	self.single_hp = single_hp
	self.layer_text.gameObject:SetActive((total_hp / single_hp) > 1)
    self.reduce_speed = HpBar.reduce_speed
    self.add_speed = HpBar.add_speed
	self.reduces = {}
	if not self.can_refresh then
		self.can_refresh = true
	end
end

function HpBar.prototype:SetHp(hp)
    if hp < 0 then
        hp = 0
    end
    if hp > self.max_hp then
        hp = self.max_hp
    end
    if hp == self.cur_hp then
        return
    end
    if hp < self.cur_hp then
		if self.cur_add_hp <= hp then
			self.cur_hp = hp
		else
			self:Reduce(hp, self.cur_add_hp)
			self.cur_hp = hp
			self.cur_add_hp = hp
		end
    else
		self.cur_hp = hp
		--计算加血速度
		local n = (self.cur_hp - self.cur_add_hp) / self.single_hp
		if n < HpBar.min_add_num then
			n = HpBar.min_add_num
		elseif n > HpBar.max_add_num then
			n = HpBar.max_add_num
		end
		local m = HpBar.max_add_time - (HpBar.max_add_time - HpBar.min_add_time) * (n - HpBar.min_add_num) / (HpBar.max_add_num - HpBar.min_add_num)
		self.add_speed = (self.cur_hp - self.cur_add_hp) / m
    end
end

function HpBar.prototype:Reduce(target_hp, current_hp)
	local reduce = {}
	reduce["target_hp"] = target_hp
	reduce["current_hp"] = current_hp
	reduce["time"] = 0
	reduce["state"] = 0
	--计算减血速度
	local c = current_hp
	if #self.reduces > 0 then
		c = self.reduces[1].current_hp
	end
	local n = (c - target_hp) / self.single_hp
	if n < HpBar.min_reduce_num then
		n = HpBar.min_reduce_num
	elseif n > HpBar.max_reduce_num then
		n = HpBar.max_reduce_num
	end
	local m = HpBar.max_reduce_time - (HpBar.max_reduce_time - HpBar.min_reduce_time) * (n - HpBar.min_reduce_num) / (HpBar.max_reduce_num - HpBar.min_reduce_num)
	self.reduce_speed = (c - target_hp) / m
	table.insert(self.reduces, reduce)
end

function HpBar.prototype:Update()
	if not self.can_refresh then
		return
	end
	if self.cur_hp > self.cur_add_hp then
		local aspeed = Time.deltaTime * self.add_speed
		self.cur_add_hp = self.cur_add_hp + aspeed
		if self.cur_add_hp > self.cur_hp then
			self.cur_add_hp = self.cur_hp
		end
		for i = #self.reduces, 1, -1 do
			local reduce = self.reduces[i]
			if self.cur_add_hp >= reduce.current_hp then
				table.remove(self.reduces, i)
			elseif self.cur_add_hp > reduce.target_hp then
				reduce.target_hp = self.cur_add_hp
				break
			else
				break
			end
		end
	end
	for i = 1, #self.reduces do
		local reduce = self.reduces[i]
		reduce.time = reduce.time + Time.deltaTime
		if reduce.state == 0 and reduce.time > HpBar.hight_time then
			reduce.state = 1
			reduce.time = 0
		elseif reduce.state == 1 and reduce.time > HpBar.hight_dtime then
			reduce.state = 2
			reduce.time = 0
		end
	end
	
	local rspeed = Time.deltaTime * self.reduce_speed
	while rspeed > 0 and #self.reduces > 0 do
		local reduce = self.reduces[1]
		local length = reduce.current_hp - reduce.target_hp
		if rspeed >= length then
			table.remove(self.reduces, 1)
			rspeed = rspeed - length
		else
			reduce.current_hp = reduce.current_hp - rspeed
			rspeed = 0
		end
	end
	self:Refresh()
end

function HpBar.prototype:Refresh()
	local top_right = self.cur_add_hp
	if #self.reduces > 0 then
		top_right = self.reduces[1].current_hp
	end
	local top_layer = self:GetLayer(top_right)
	-- 底版
	if top_layer <= 1 then
		self:BrushColor(1, self.w, self.bottom_color)
	end
	-- -1正常条
	local layer_zc = self:GetLayer(self.cur_add_hp)
	if layer_zc == top_layer and layer_zc >= 2 then
		self:BrushColor(1, self.w, self:GetLayerColor(layer_zc - 1))
	elseif layer_zc == top_layer - 1 and layer_zc >= 1 then
		local w = self:GetPos(self.cur_add_hp, layer_zc)
		self:BrushColor(1, w, self:GetLayerColor(layer_zc))
	end
	-- -1减血条
	for i = 1, #self.reduces do
		local reduce = self.reduces[i]
		local layer1 = self:GetLayer(reduce.current_hp)
		local layer2 = self:GetLayer(reduce.target_hp)
		if layer1 > top_layer - 1 and layer2 < top_layer - 1 then
			self:BrushColor(1, self.w, self:GetReduceColor(reduce, top_layer - 1))
		elseif layer1 > top_layer - 1 and layer2 == top_layer - 1 and layer2 >= 1 then
			local l = self:GetPos(reduce.target_hp, layer2)
			local r = self.w
			self:BrushColor(l, r, self:GetReduceColor(reduce, layer2))
		elseif layer1 == top_layer - 1 and layer2 < top_layer - 1 and layer1 >= 1  then
			local l = 1
			local r = self:GetPos(reduce.current_hp, layer1)
			self:BrushColor(l, r, self:GetReduceColor(reduce, layer1))
		elseif layer1 == top_layer - 1 and layer2 == top_layer - 1 and layer1 >= 1  then
			local l = self:GetPos(reduce.target_hp, layer1)
			local r = self:GetPos(reduce.current_hp, layer1)
			self:BrushColor(l, r, self:GetReduceColor(reduce, layer1))
		end
	end
	-- 正常条
	if layer_zc == top_layer and layer_zc >= 1 then
		local w = self:GetPos(self.cur_add_hp, layer_zc)
		self:BrushColor(1, w, self:GetLayerColor(layer_zc))
	end
	-- 减血条
	for i = 1, #self.reduces do
		local reduce = self.reduces[i]
		local layer1 = self:GetLayer(reduce.current_hp)
		local layer2 = self:GetLayer(reduce.target_hp)
		if layer1 == top_layer and layer1 >= 1 then
			local l = 1
			if layer2 == layer1 then
				l = self:GetPos(reduce.target_hp, layer1)
			end
			local r = self:GetPos(reduce.current_hp, layer1)
			self:BrushColor(l, r, self:GetReduceColor(reduce, layer1))
		end
	end
	
    self.hp_text.text = self.cur_hp .. "/" ..  self.max_hp
	if self.layer_text.gameObject.activeSelf then
		self.layer_text.text = "x"..top_layer
		if top_layer <= 1 then
			self.layer_text.gameObject:SetActive(false)
		end
	end
end

function HpBar.prototype:GetLayer(hp)
	return math.floor((hp + self.single_hp - 0.0001) / self.single_hp)
end

function HpBar.prototype:GetPos(hp, layer)
	local m = hp - (layer - 1) * self.single_hp
	return m / self.single_hp * self.w
end

function HpBar.prototype:GetReduceColor(reduce, layer)
	if reduce.state == 0 then
		return self.hight_color
	elseif reduce.state == 1 then
		return Color.Lerp(self.hight_color, self:GetLayerDColor(layer), reduce.time / HpBar.hight_dtime)
	else
		return self:GetLayerDColor(layer)
	end
end

function HpBar.prototype:GetLayerColor(layer)
    local index = layer % (#self.colors)
    if index == 0 then
        index = #self.colors
    end
    local color = self.colors[index]
    return color
end

function HpBar.prototype:GetLayerDColor(layer)
    local index = layer % (#self.dcolors)
    if index == 0 then
        index = #self.dcolors
    end
    local color = self.dcolors[index]
    return color
end

function HpBar.prototype:BrushColor(start_pos, end_pos, color)
    Util.RefreshTexture(self.texture, start_pos, end_pos, color.r, color.g, color.b, color.a)
end
