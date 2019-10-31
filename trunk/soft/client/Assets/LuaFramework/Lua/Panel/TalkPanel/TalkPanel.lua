TalkPanel = {}

TalkPanel.Control = {}
local this = TalkPanel.Control

function TalkPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent("LuaUIBehaviour")


    this.content_root_ = this.transform_:Find("back/dir_root/view_root/content_root")
    this.name_text_ = this.transform_:Find("back/npc_name")
    this.select_item_ = this.transform_:Find("back/select_item")
    this.npc_icon_ = this.transform_:Find("back/npc_icon_back/npc_icon")
    this.talk_text_ = this.transform_:Find("back/talk_text")
    this.next_ = this.transform_:Find("back/next")
    this.dungeon_btn_ = this.transform_:Find("dungeon_btn")
    this.spell_queue = nil
    this.t_director_ = nil
    this.t_quest_ = nil
    this.t_quest_obj = nil
    this.btn_func_ = nil
    this.close_func_ = nil
    this.click_index_ = 0
    this.role_id_ = nil
    this.other_params_ = nil
    TalkPanel.RegisterBtnListers()
end

function TalkPanel.OnParam(params)
    this.spell_queue = nil
    this.btn_func_ = nil
    this.close_func_ = nil
    this.t_quest_ = nil
    this.spell_queue = params[1]
    local date2 = params[2]
    this.btn_func_ = date2[1]
    this.close_func_ = date2[2]
    this.t_quest_ = date2[3]
    this.role_id_ = date2[4]
    if this.role_id_ == nil then
        this.role_id_ = -1
    end
    this.other_params_ = params[3]
end

function TalkPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.gameObject_, "click", TalkPanel.ClickBack, nil, false)
    Message.register_handle("name_end", TalkPanel.NameEnd)
    Message.register_handle("close_dungeon", TalkPanel.Close)

end

function TalkPanel.OnDestroy()
    Message.remove_handle("name_end", TalkPanel.NameEnd)
    Message.remove_handle("close_dungeon", TalkPanel.Close)
    this = {}
end

function TalkPanel.Start(obj)
    if State.cur_state == State.state.ss_battle then
        this.gameObject_:GetComponent("Image").color = Color.clear
    end
    this.click_index_ = 0
    this.t_director_ = nil
    this.t_quest_obj = nil
    if this.spell_queue ~= nil then
        this.t_director_ = Config.get_config_value("t_director", tonumber(this.spell_queue))
    end
    if this.t_director_ == nil then
        GUIRoot.ClosePanel("TalkPanel")
        return
    end
    if this.t_director_.options[1].type == 5 and PlayerData.player.name ~= "" then
        this.t_director_ = Config.get_config_value("t_director", tonumber(this.t_director_.options[1].param1))
    end
    TalkPanel.RefreshPanel(this.t_director_)
    this.next_:GetComponent("RectTransform"):DOLocalMoveY(5, 0.5):SetRelative(true):SetLoops(-1, DG.Tweening.LoopType.Yoyo)
end

function TalkPanel.RefreshPanel(t_director)
    if t_director.options[1].type == 5 and PlayerData.player.name ~= "" then
        this.t_director_ = Config.get_config_value("t_director", tonumber(t_director.options[1].param1))
    end
    local talk_sprite = nil
    if this.role_id_ == -1 then
        if t_director.npc_id ~= 0 then
            local t_npc = Config.get_config_value("t_npc", t_director.npc_id)
            if t_npc ~= nil then
                talk_sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "npc"):GetSprite(t_npc.icon)
            end
        else
            talk_sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite("zjdt_ic002")
        end

    else
        local t_role = Config.get_config_value("t_role", tonumber(this.role_id_))
        talk_sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "monster"):GetSprite(t_role.icon)
    end
    this.npc_icon_:GetComponent("Image").sprite = talk_sprite
    this.click_index_ = 0
    this.name_text_:GetComponent("LocalizationText").text = t_director.title
    local fun = function(text)
        if PlayerData.player.name ~= "" then
            return string.gsub(text, "{P}", PlayerData.player.name)
        else
            return string.gsub(text, "{P}", "朋友")
        end
    end
    this.talk_text_:GetComponent("LocalizationText").text = string.format("「%s」", fun(t_director.dialog))
    Util.ClearChild(this.content_root_)
    local has_daily_task = false
    if this.t_quest_ ~= nil then
        for i = 1, #this.t_quest_ do
            local quest = Config.get_config_value("t_quest", this.t_quest_[i])
            if quest.type == 3 then
                has_daily_task = true
            else
                local slot_ins = GameObject.Instantiate(this.select_item_.gameObject)
                slot_ins.transform:SetParent(this.content_root_, false)
                slot_ins.transform.localScale = Vector3.one
                slot_ins.transform.localPosition = Vector3.zero
                slot_ins.transform:Find("select_text"):GetComponent("LocalizationText").text = quest.name
                slot_ins.transform.name = string.format("%s_dir_quest" , quest.id)
                GameSys.ButtonRegister(this.lua_script, slot_ins.gameObject, "click", TalkPanel.QuestSubClick, {quest.id})
                slot_ins.gameObject:SetActive(true)
            end
        end
    end
    local type3 = false
    local cot = 0
    for i = 1, #t_director.options do
        if t_director.options[i].type ~= 0 then
            if t_director.options[i].type ~= 3 then
                local slot_ins = GameObject.Instantiate(this.select_item_.gameObject)
                cot = cot + 1
                slot_ins.transform:SetParent(this.content_root_, false)
                slot_ins.transform.localScale = Vector3.one
                slot_ins.transform.localPosition = Vector3.zero
                slot_ins.transform:Find("select_text"):GetComponent("LocalizationText").text = t_director.options[i].name
                if t_director.options[i].type == 6 then
                    this.click_index_ = i
                end
                if t_director.options[i].param1 ~= 0 or t_director.options[i].type ~= 0 then
                    slot_ins.transform.name = string.format("%s_%s" , t_director.id, tostring(i))
                    GameSys.ButtonRegister(this.lua_script, slot_ins.gameObject, "click", TalkPanel.ClickOptions, {i})
                end
                slot_ins.gameObject:SetActive(true)
            else
                type3 = true
                GameSys.ButtonRegister(this.lua_script, this.dungeon_btn_.gameObject, "click", TalkPanel.DungeonBox, {i}, false)
            end
        end
    end

    if type3 then
        this.dungeon_btn_.gameObject:SetActive(true)
    else
        this.dungeon_btn_.gameObject:SetActive(false)
    end

    if this.other_params_ ~= nil then
        local slot_ins = GameObject.Instantiate(this.select_item_.gameObject)
        slot_ins.transform:SetParent(this.content_root_, false)
        slot_ins.transform.localScale = Vector3.one
        slot_ins.transform.localPosition = Vector3.zero
        slot_ins.transform:Find("select_text"):GetComponent("LocalizationText").text = this.other_params_[2]
        if this.other_params_[1] ~= nil then
            GameSys.ButtonRegister(this.lua_script, slot_ins.gameObject, "click", TalkPanel.Other_func)
        end
        slot_ins.gameObject:SetActive(true)
    end
    if cot == 0 then
        this.click_index_ = 1
    end
end

function TalkPanel.DungeonBox(obj, params)
    TalkPanel.ClickOptions(obj, params)
end

function TalkPanel.Other_func()
    TalkPanel.Close()
    if this.other_params_ ~= nil then
        this.other_params_[1]()
    end
end

function TalkPanel.ClickBack(obj)
    if this.click_index_ ~= 0 then
        TalkPanel.ClickOptions(obj, {this.click_index_})
    end
end

function TalkPanel.QuestSubClick(obj, param)
    local quest_id = param[1]
    TalkPanel.Close()
    QuestManger.DirClick(quest_id)
end

function TalkPanel.ClickOptions(obj, param)
    local index = param[1]
    local t_options = this.t_director_.options[index]
    if t_options ~= nil then
        if t_options.type == 0 or t_options.type == 6 then
            this.t_director_ = nil
            this.spell_queue = t_options.param1
            this.t_director_ = Config.get_config_value("t_director", t_options.param1)
            if this.t_director_ ~= nil then
                TalkPanel.RefreshPanel(this.t_director_)
            else
                if this.close_func_ ~= nil then
                    this.close_func_()
                end
                GUIRoot.ClosePanel("TalkPanel")
            end
        elseif t_options.type == 5 then
            GUIRoot.ShowPanel("NamePanel")
            this.t_director_ = nil
            this.spell_queue = t_options.param1
            this.t_director_ = Config.get_config_value("t_director", t_options.param1)
        elseif t_options.type == 1 or t_options.type == 2 then
            GUIRoot.ClosePanel("TalkPanel")
            if this.btn_func_ ~= nil then
                local msg = {}
                msg.id = this.spell_queue
                msg.index = index
                this.btn_func_(msg)
            end
        elseif t_options.type == 3 or t_options.type == 4 then
            if this.btn_func_ ~= nil then
                local msg = {}
                msg.id = this.spell_queue
                msg.index = index
                this.btn_func_(msg)
            end
        end
    end
end

function TalkPanel.Close()
    if this.close_func_ ~= nil then
        this.close_func_()
    end
    GUIRoot.ClosePanel("TalkPanel")
end

function TalkPanel.NameEnd()
    TalkPanel.RefreshPanel(this.t_director_)
end
