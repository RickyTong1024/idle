NarratorPanel = {}
NarratorPanel.Control = {}
local this = NarratorPanel.Control

function NarratorPanel.Awake(obj)

    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")

    this.map_desc_panel_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel")
    this.temp_image_effect_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel/temp_image_effect")
    this.image_root_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel/temp_content/image_root")
    this.desc_text_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel/desc_text"):GetComponent("LocalizationText")
	this.effect_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel/temp_content/effect"):GetComponent("RawImage")
    this.temp_content_ = this.transform_:Find("back_ground/basic_panel_centent/map_desc_panel/temp_content")
    this.index_ = 1
	this.effect_.texture = UIEffect.Camera.targetTexture
	local r = UIEffect.Show("ui_effa01")
    this.effect_.uvRect = r
    this.cur_image = nil
    this.params_data_ = nil
    this.params_fun_ = nil
    this.narrator_data_ = nil
    NarratorPanel.AdjustSelf()
    this.transform_:SetAsLastSibling()
end

function NarratorPanel.OnDestroy()
    for i = 1, #this.narrator_data_.narrator do
        resMgr.UnloadStory(this.narrator_data_.narrator[i].icon)
    end
	UIEffect.Hide("ui_effa01")
    this = {}
end

function NarratorPanel.OnParam(params)
    this.params_data_ = params[1]
    this.params_fun_ = params[2]
    this.narrator_data_ = Config.get_config_value("t_narrator", this.params_data_)
    this.index_ = 1
    NarratorPanel.TextEffect()
    this.map_desc_panel_.gameObject:SetActive(true)
end

function NarratorPanel.AdjustSelf()
    GameSys.ScreenSca(this.temp_content_)
end

function NarratorPanel.CreateImage()
    if this.narrator_data_.narrator[this.index_].img_effec ~= "" then
        local image_ins = this.temp_image_effect_.transform:Find(this.narrator_data_.narrator[this.index_].img_effect)
        local image_obj = GameObject.Instantiate(image_ins.gameObject)
        image_obj.transform:SetParent(this.image_root_, false)
        image_obj.transform:SetSiblingIndex(0)
        image_obj:GetComponent("RawImage").texture = resMgr.LoadStory(this.narrator_data_.narrator[this.index_].icon)
        this.cur_image = image_obj
    end
end

function NarratorPanel.TextEffect()
    if this.narrator_data_.narrator[this.index_] ~= nil then
        NarratorPanel.CreateImage()
        this.desc_text_.text = ""
        this.desc_text_:DOText(this.narrator_data_.narrator[this.index_].str, this.narrator_data_.narrator[this.index_].speed):OnComplete(function ()
            timerMgr:AddTimer("next_time", function (param)
                this.index_ = this.index_ + 1
                if this.narrator_data_.narrator[this.index_] ~= nil then
                    this.cur_image:GetComponent("UITransitionEffect"):Hide()
                    NarratorPanel.TextEffect()
                else
                    GUIRoot.ShowPanel("LoadingPanel", {function ()
                        if this.params_fun_ ~= nil then
                            this.params_fun_()
                        end
                        local common_msg = CommonMessage()
                        common_msg.name = "NarratorEnd"
                        messMgr:AddCommonMessage(common_msg)
                        GUIRoot.ClosePanel("NarratorPanel")
                    end, nil})
                end
            end , {nil}, 1.5)
        end)
    end
end

function NarratorPanel.ClosePanel()
    GUIRoot.ClosePanel("NarratorPanel")
end

