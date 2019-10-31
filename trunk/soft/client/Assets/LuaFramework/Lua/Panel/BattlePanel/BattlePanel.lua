BattlePanel = {}
BattlePanel.Control = {}
local this = BattlePanel.Control

function BattlePanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.site_roots_ = {}
    this.name_texts_ = {}
    this.level_texts = {}
    this.hp_sliders_ = {}
    this.sp_sliders_ = {}
    this.sp_fill_images_ = {}
    this.sp_texts_ = {}
    this.spell_btns_ = {}
    this.spell_btn_inss_ = {}
    this.sing_sliders_ = {}
    this.buffs_roots_ = {}
    this.pets_roots_ = {}
    this.flow_points_ = {}
    this.site_roots_[0] = this.transform_:Find("mine")
    this.site_roots_[10] = this.transform_:Find("enemy")
    this.name_texts_[0] = this.transform_:Find("mine/my_name_text"):GetComponent("Text")
    this.name_texts_[10] = this.transform_:Find("enemy/enemy_name_text"):GetComponent("Text")
    this.level_texts[0] = this.transform_:Find("mine/my_name_text/my_level_text"):GetComponent("Text")
    this.level_texts[10] = this.transform_:Find("enemy/enemy_name_text/enemy_level_text"):GetComponent("Text")
    this.hp_sliders_[0] = this.transform_:Find("mine/my_hp_slider")
    this.hp_sliders_[10] = this.transform_:Find("enemy/enemy_hp_slider")
    this.sp_sliders_[0] = this.transform_:Find("mine/my_sp_slider"):GetComponent("Slider")
    this.sp_sliders_[10] = this.transform_:Find("enemy/enemy_sp_slider"):GetComponent("Slider")
    this.sp_fill_images_[0] = this.transform_:Find("mine/my_sp_slider/FillArea/my_fill"):GetComponent("Image")
    this.sp_fill_images_[10] = this.transform_:Find("enemy/enemy_sp_slider/FillArea/enemy_fill"):GetComponent("Image")
    this.sp_texts_[0] = this.transform_:Find("mine/my_sp_slider/my_sp_text"):GetComponent("Text")
    this.sp_texts_[10] = this.transform_:Find("enemy/enemy_sp_slider/enemy_sp_text"):GetComponent("Text")
    this.spell_btns_[1] = this.transform_:Find("mine/my_spell_btns/spell_1")
    this.spell_btns_[2] = this.transform_:Find("mine/my_spell_btns/spell_2")
    this.spell_btns_[3] = this.transform_:Find("mine/my_spell_btns/spell_3")
    this.spell_btns_[4] = this.transform_:Find("mine/my_spell_btns/spell_4")
    for i = 1, #this.spell_btns_ do
        this.spell_btn_inss_[i] = {
            ["ins"] = this.spell_btns_[i]:Find("spell").gameObject,
            ["spell_icon"] = this.spell_btns_[i]:Find("spell/mask/spell_icon"):GetComponent("Image"),
            ["lock_mask"] = this.spell_btns_[i]:Find("spell/mask/lock_mask"):GetComponent("Image"),
            ["cd_mask"] = this.spell_btns_[i]:Find("spell/mask/cd_mask"):GetComponent("Image"),
            ["ring"] = this.spell_btns_[i]:Find("spell/ring"),
            ["ui_effect"] = this.spell_btns_[i]:Find("ui_effect"):GetComponent("RawImage")
        }
        this.spell_btn_inss_[i].ui_effect.texture = UIEffect.Camera.targetTexture
    end
    this.sing_sliders_[0] = obj.transform:Find("mine/my_sing_slider"):GetComponent("Slider")
    this.sing_sliders_[10] = obj.transform:Find("enemy/enemy_sing_slider"):GetComponent("Slider")
    this.buffs_roots_[0] = obj.transform:Find("mine/my_buffs_root")
    this.buffs_roots_[10] = obj.transform:Find("enemy/enemy_buffs_root")
    this.pets_roots_[0] = obj.transform:Find("mine/my_pets_root")
    this.pets_roots_[10] = obj.transform:Find("enemy/enemy_pets_root")
    this.flow_points_[0] = obj.transform:Find("mine/my_flow_text_point")
    this.flow_points_[10] = obj.transform:Find("enemy/enemy_flow_text_point")
    this.sing_sliders_[0].gameObject:SetActive(false)
    this.sing_sliders_[10].gameObject:SetActive(false)

    this.reward_panel_ = obj.transform:Find("reward_panel")
    this.win_panel_ = obj.transform:Find("reward_panel/win")
    this.lose_panel_ = obj.transform:Find("reward_panel/lose")
    this.pet_ins_ = obj.transform:Find("pet")
    this.buff_ins_ = obj.transform:Find("buff")
    this.flow_text_ins_ = obj.transform:Find("flow_text")
    this.task_tip_text_ = obj.transform:Find("task_tip_text")
    this.escape_btn_ = obj.transform:Find("mine/escape_btn")
    this.auto_battle_btn_ = obj.transform:Find("mine/auto_battle_btn")
    this.no_auto_battle_btn_ = obj.transform:Find("mine/no_auto_battle_btn")
    this.teasure_btn_ = obj.transform:Find("mine/teasure_btn")
    this.timer_title_ = obj.transform:Find("mine/timer_title")
    this.timer_text_ = obj.transform:Find("mine/timer_title/timer_text"):GetComponent("Text")
    this.battle_tip_ = obj.transform:Find("mine/battle_tip"):GetComponent("CanvasGroup")
    this.tip_title_ = obj.transform:Find("tip_title"):GetComponent("CanvasGroup")
    this.tip_title_text_ = obj.transform:Find("tip_title/tip_title_text"):GetComponent("Text")
    this.monster_passive_ins_ = obj.transform:Find("monster_passive_ins")

    this.timer_title_.gameObject:SetActive(false)
    this.reward_panel_.gameObject:SetActive(false)

    this.drop_panels_ = {
        ["drops_root"] = this.transform_:Find("drops_root"),
        ["desc"] = this.transform_:Find("drop_desc"),
        ["container"] = resMgr.LoadEffect("drop_container"),
        ["normal"] = resMgr.LoadEffect("drop_normal"),
        ["gold"] = resMgr.LoadEffect("drop_gold"),
        ["light"] = {
            resMgr.LoadEffect("drop_light2"),
            resMgr.LoadEffect("drop_light3"),
            resMgr.LoadEffect("drop_light4"),
            resMgr.LoadEffect("drop_light5")
        }
    }
    this.drops_ = {}
    this.drop_panels_.const = { 0.35, 0, -0.85, -0.72, -0.42, -0.15, 0, 0 }
    this.DropEndCallBack_ = nil
    this.drop_buff_time_ = 0

    this.tip_title_ = {
        ["is_show"] = false,
        ["show_time"] = 2,
        ["timer"] = 0
    }

    this.hp_slider_controls = {}
    for site, slider in pairs(this.hp_sliders_) do
        local raw_iamge = slider:Find("hp_image"):GetComponent("RawImage")
        local hp_text = slider:Find("hp_text"):GetComponent("Text")
        local layer_text = slider:Find("layer_text"):GetComponent("Text")
        local w = 400
        if site == 10 then
            w = 440
        end
        this.hp_slider_controls[site] = HpBar.CreateHpBar(raw_iamge, hp_text, layer_text, w, 1)
    end


    local sec_rect, sec_effect = UIEffect.Show("aj_cg")
    local fail_rect, fail_effect = UIEffect.Show("aj_sb")
    this.spell_ui_effect = {
        ["success_rect"] = sec_rect,
        ["success_effects"] = sec_effect:GetComponentsInChildren(typeof(UnityEngine.ParticleSystem), true),
        ["fail_rect"] = fail_rect,
        ["fail_effects"] = fail_effect:GetComponentsInChildren(typeof(UnityEngine.ParticleSystem), true)
    }

    this.sing_states_ = {}
    this.sp_slider_colors_ = {}
    this.spell_states_ = {}
    this.buff_states_ = {}
    this.flow_prestates_ = {}
    this.flow_states_ = {}
    this.flow_delay_ = {}
    this.spell_lock_ = false

    this.win_ = false
    this.auto_exit_time_ = 3

    UpdateBeat:Add(BattlePanel.Update, BattlePanel)
    BattlePanel.RegisterBtnListers()
    this.transform_:SetAsLastSibling()
    this.is_showed_ = true
end

function BattlePanel.OnDestroy()
    this.is_showed_ = false
    UpdateBeat:Remove(BattlePanel.Update, BattlePanel)
    for _, hp_control in pairs(this.hp_slider_controls) do
        hp_control:Destroy()
    end
    resMgr.UnloadEffect("drop_container")
    resMgr.UnloadEffect("drop_normal")
    resMgr.UnloadEffect("drop_gold")
    resMgr.UnloadEffect("drop_light2")
    resMgr.UnloadEffect("drop_light3")
    resMgr.UnloadEffect("drop_light4")
    resMgr.UnloadEffect("drop_light5")
    UIEffect.Hide("aj_cg")
    UIEffect.Hide("aj_sb")
    this = {}
end

function BattlePanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.reward_panel_.gameObject, "click", BattlePanel.OnBackBtnClick, nil, false)
    GameSys.ButtonRegister(this.lua_script_, this.auto_battle_btn_.gameObject, "click", BattlePanel.AutoBattle, { false }, false)
    GameSys.ButtonRegister(this.lua_script_, this.no_auto_battle_btn_.gameObject, "click", BattlePanel.AutoBattle, { true }, false)
    GameSys.ButtonRegister(this.lua_script_, this.teasure_btn_.gameObject, "click", BattlePanel.OnTeasureBtnClick, nil, false)
    for i = 1, #this.spell_btns_ do
        local ins = this.spell_btns_[i].gameObject
        local common_down_func = function(obj, eventdata, params)
            local change_scale = Vector3.New(0.8, 0.8, 0.8)
            if i == 1 then
                change_scale = Vector3.New(1, 1, 1)
            end
            ins:GetComponent("RectTransform"):DOScale(change_scale, 0.1)
            soundMgr:play_sound("button")
        end
        local common_up_func = function(obj, eventdata, params)
            local change_scale = Vector3.New(1, 1, 1)
            if i == 1 then
                change_scale = Vector3.New(1.2, 1.2, 1.2)
            end
            ins:GetComponent("RectTransform"):DOScale(change_scale, 0.1)
        end
        local gd_down_func = function(obj, eventdata, params)
            common_down_func(obj, eventdata, params)
            if FightManger.fighter1 ~= nil then
                FightManger.fighter1:Gedang()
            end
        end
        local gd_up_func = function(obj, eventdata, params)
            common_up_func(obj, eventdata, params)
            if FightManger.fighter1 ~= nil then
                FightManger.fighter1:UnGedang()
            end
        end
        if i ~= 4 then
            this.lua_script_:AddDownEvent(ins, common_down_func)
            this.lua_script_:AddUpEvent(ins, common_up_func)
            this.lua_script_:AddClickEvent(ins, BattlePanel.OnSpellClick, { i })
        else
            this.lua_script_:AddDownEvent(ins, gd_down_func)
            this.lua_script_:AddUpEvent(ins, gd_up_func)
        end
    end
end

function BattlePanel.InitSitePanel(site, name, level, max_hp, pets, color, flow_world_pos, sing_world_point)
    if not this.is_showed_ then
        return
    end
    local fighter = FightManger.fighter1
    if site == 10 then
        fighter = FightManger.fighter2
    end
    this.site_roots_[site].gameObject:SetActive(fighter ~= nil)
    if fighter == nil then
        return
    end
    --初始化名字和等级
    local name_content = name
    if color ~= nil and color > 1 then
        local t_color = Config.get_config_value("t_color", color)
        name_content = string.format("%s(%s)", name_content, t_color.name)
        name_content = GameSys.set_color(color, name_content)
    end
    this.name_texts_[site].text = name_content
    this.level_texts[site].text = "Lv " .. level
    --初始化血条
    if fighter.fighter_type == 1 then
        this.hp_slider_controls[site]:Init(max_hp, max_hp)
    else
        local single_hp = PlayerData.get_level_value(level, 1)
        this.hp_slider_controls[site]:Init(max_hp, single_hp)
    end
    --初始化sp条
    this.sp_slider_colors_[site] = {}
    this.sp_slider_colors_[site].state = -1
    this.sp_slider_colors_[site].hight_state = 0
    this.sp_slider_colors_[site].timer = 0
    local fighter_type = FightManger.fighter1.fighter_type
    if site == 10 then
        fighter_type = FightManger.fighter2.fighter_type
    end
    if fighter_type == 1 then
        this.sp_sliders_[site].maxValue = 100
    elseif fighter_type == 2 then
        this.sp_sliders_[site].maxValue = 1
    end
    --初始化吟唱条 及其位置
    this.sing_sliders_[site].maxValue = 1
    this.sing_sliders_[site].value = 0
    local rect = this.site_roots_[site].transform:GetComponent("RectTransform")
    local sing_screen_pos = Scene.Camera:WorldToScreenPoint(sing_world_point)
    local sing_b, sing_ui_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, sing_screen_pos, GUIRoot.UICamera, nil)
    if sing_b then
        this.sing_sliders_[site]:GetComponent("RectTransform").anchoredPosition = sing_ui_pos
    end
    --初始化飘字位置
    local flow_screen_pos = Scene.Camera:WorldToScreenPoint(flow_world_pos)
    local flow_b, flow_ui_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, flow_screen_pos, GUIRoot.UICamera, nil)
    if flow_b then
        this.flow_points_[site]:GetComponent("RectTransform").anchoredPosition = flow_ui_pos
    end
    --设置宠物图标
    Util.ClearChild(this.pets_roots_[site])
    if pets ~= nil then
        for i = 1, #pets do
            local pet_id = pets[i]
            if pet_id ~= 0 then
                local pet = GameObject.Instantiate(this.pet_ins_.gameObject)
                pet:SetActive(true)
                pet.transform:SetParent(this.pets_roots_[site], false)
                local icon_alias = Config.get_config_value("t_pet", pet_id).icon
                if icon_alias ~= "" then
                    local pet_icon = pet.transform:Find("mask/pet_icon"):GetComponent("Image")
                    pet_icon.sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "pet"):GetSprite(icon_alias)
                end
            end
        end
    end
    --如果是玩家
    if site == 0 then
        GameSys.ButtonRegister(this.lua_script_, this.escape_btn_.gameObject, "click", BattlePanel.RunAway, nil, false)
        BattlePanel.SetAutoBattleBtn(FightManger.auto)
        BattlePanel.SetTeasureBtn(Battle.IsDungeonBattel())
        BattlePanel.SetEscapeBtn(Battle.IsDungeonBattel())
        --初始化技能状态
        this.spell_lock_ = false
        for i = 1, 4 do
            this.spell_states_[i] = {
                ["had"] = false,
                ["spell_id"] = 0,
                ["cd_time"] = nil,
                ["need_sp"] = nil,
            }
            this.spell_btn_inss_[i].lock_mask.gameObject:SetActive(false)
            this.spell_btn_inss_[i].cd_mask.fillAmount = 0
            this.spell_btn_inss_[i].ring.localScale = Vector3.New(0, 0, 0)
            this.spell_btn_inss_[i].ui_effect.gameObject:SetActive(false)
        end
    end
    --如果是怪物
    if site == 10 then
        --怪物特性
        local monster_passive_show = fighter.fighter_type == 2 and Battle.IsDungeonBattel()
        local monster_passive_root = this.transform_:Find("enemy/enemy_passive_root")
        monster_passive_root.gameObject:SetActive(monster_passive_show)
        if monster_passive_show then
            local passives = fighter.spell_passives
            Util.ClearChild(monster_passive_root)
            for i = 1, #passives do
                local ins = GameObject.Instantiate(this.monster_passive_ins_.gameObject)
                ins.transform:SetParent(monster_passive_root, false)
                ins:SetActive(true)
                local t_psssive = Config.get_config_value("t_spell_passive", passives[i])
                local color = t_psssive.color
                local quality_icon = ins.transform:Find("mask/quality_icon"):GetComponent("Image")
                local spell_icon = ins.transform:Find("mask/spell_icon"):GetComponent("Image")
                quality_icon.sprite = GUIRoot.LoadAtlas("BattlaPanel", "quality"):GetSprite(GameSys.get_quality(color))
                print(t_psssive.id)
                print(t_psssive.icon)
                if t_psssive.icon ~= "" then
                    spell_icon.sprite = GUIRoot.LoadAtlas("BattlaPanel", "spell"):GetSprite(t_psssive.icon)
                end
                local detail = ins.transform:Find("detail")
                local detail_desc = ins.transform:Find("detail/detail_desc")
                detail_desc:GetComponent("Text").text = GameSys.GetPassiveDesc(passives[i])
                LayoutRebuilder.ForceRebuildLayoutImmediate(detail_desc)
                local height = LayoutUtility.GetPreferredHeight(detail_desc)
                GameSys.SetRectHeight(detail, height + 6)
                detail.gameObject:SetActive(false)
                this.lua_script_:AddDownEvent(ins, BattlePanel.OnMonsterPassiveDown, { detail })
                this.lua_script_:AddUpEvent(ins, BattlePanel.OnMonsterPassiveUp, { detail })
            end
        end
    end
end

function BattlePanel.Update()
    -------- 吟唱
    for site, sing_state in pairs(this.sing_states_) do
        sing_state.cur_time = sing_state.cur_time + Time.deltaTime
        if sing_state.cur_time >= sing_state.sing_time then
            sing_state.cur_time = sing_state.sing_time
        end
        this.sing_sliders_[site].value = sing_state.cur_time
    end
    -------- buffs
    for _, buff_state in pairs(this.buff_states_) do
        for _, buff in pairs(buff_state) do
            buff.cur_time = buff.cur_time + Time.deltaTime
            if buff.cur_time >= buff.buff_time then
                buff.cur_time = buff.buff_time
            end
            local mask_image = buff.buff_ins.transform:Find("buff_icon/mask"):GetComponent("Image")
            mask_image.fillAmount = buff.cur_time / buff.buff_time
        end
    end
    -------- 飘字
    for site, flow_delay in pairs(this.flow_delay_) do
        if flow_delay ~= nil and flow_delay > 0 then
            flow_delay = flow_delay - Time.deltaTime
            if flow_delay <= 0 then
                flow_delay = 0
                if #this.flow_prestates_[site] > 0 then
                    BattlePanel.FlowText1(this.flow_prestates_[site][1][1], this.flow_prestates_[site][1][2], this.flow_prestates_[site][1][3], this.flow_prestates_[site][1][4], this.flow_prestates_[site][1][5], this.flow_prestates_[site][1][6])
                    table.remove(this.flow_prestates_[site], 1)
                end
            end
        end
    end
    local del_flows = {}
    for site, flow_state in pairs(this.flow_states_) do
        for i = 1, #flow_state do
            local state = flow_state[i]
            if state.delay ~= nil then
                state.delay = state.delay - Time.deltaTime
                if state.delay <= 0 then
                    state.delay = nil
                    state.flow_ins.gameObject:SetActive(true)
                    state.flow_ins:GetComponent("Animator"):Play(state.tp, 0, 0)
                end
            else
                state.life_time = state.life_time - Time.deltaTime
                if state.life_time <= 0 then
                    table.insert(del_flows, { site, i })
                end
            end
        end
    end
    for i = #del_flows, 1, -1 do
        local site = del_flows[i][1]
        local index = del_flows[i][2]
        GameObject.Destroy(this.flow_states_[site][index].flow_ins)
        table.remove(this.flow_states_[site], index)
    end
    -------- 掉落
    local dels = {}
    local num = 0
    for name in pairs(this.drops_) do
        num = num + 1
        local drop = this.drops_[name]
        drop.time = drop.time + Time.deltaTime
        if drop.type == 0 and drop.time >= drop.s_time then
            drop.ins:SetActive(true)
            drop.type = 1
            drop.time = 0
            if drop.light ~= nil then
                drop.light:SetActive(true)
            end
        elseif drop.type == 1 and drop.time >= 0.5 then
            drop.desc:SetActive(true)
            drop.type = 2
            drop.time = 0
            if drop.color == 5 then
                soundMgr:play_sound("drop_legendery")
            end
        elseif drop.type == 2 and drop.time >= this.auto_exit_time_ then
            drop.type = 3
            drop.desc:SetActive(false)
            drop.time = 0
            drop.can_click = false
            drop.obj:SetActive(false)
            drop.tail:SetActive(true)
            soundMgr:play_sound("pick_drop")
        elseif drop.type == 3 then
            local t = drop.time
            if t >= 0.8 then
                drop.type = 4
                drop.time = 0
                drop.tail:SetActive(false)
                this.drop_buff_time_ = this.drop_buff_time_ - Time.deltaTime
                if this.drop_buff_time_ <= 0 then
                    drop.buff:SetActive(true)
                    --this.drop_buff_time_ = 0.2
                end
                drop.ins.transform.localPosition = drop.v2
                BattlePanel.FlowText("flow_text", 0, drop.name)
            else
                local p = CubicBezierCurve(drop.v1, drop.v3, drop.v4, drop.v2, t)
                drop.ins.transform.localPosition = p
            end
        elseif drop.type == 4 and drop.time >= 1.6 then
            table.insert(dels, name)
        end
    end
    for i = 1, #dels do
        local name = dels[i]
        local drop = this.drops_[name]
        GameObject.Destroy(drop.ins)
        GameObject.Destroy(drop.desc)
        if drop.param ~= nil then
            resMgr.UnloadUnit(drop.param)
        end
        this.drops_[name] = nil
    end
    if num > 0 and num == #dels then
        if this.DropEndCallBack_ ~= nil then
            this.DropEndCallBack_()
        end
    end

    ---大提示框
    if this.tip_title_.is_show then
        this.tip_title_.timer = this.tip_title_.timer + Time.deltaTime
        this.tip_title_.alpha = this.tip_title_.alpha - (1 / this.tip_title_.show_time) * Time.deltaTime
        if this.tip_title_.timer >= this.tip_title_.show_time then
            this.tip_title_.timer = 0
            this.tip_title_.is_show = false
            this.tip_title_.gameObject:SetActive(false)
        end
    end

    ---技能
    if not this.spell_lock_ then
        for i = 1, #this.spell_states_ do
            local spell_ins = this.spell_btn_inss_[i]
            local spell_state = this.spell_states_[i]
            if i == 1 then
                local cur_had, cur_spell_id, cur_per = FightManger.GetContinueReleaseSpell(i)
                spell_state.had = cur_had
                spell_state.spell_id = cur_had and cur_spell_id or 0
                local scale = cur_per / 100
                spell_ins.ring.localScale = Vector3.New(scale, scale, scale)
            end
            if i == 2 or i == 3 then
                local cur_had, cur_spell_id, cur_per = FightManger.GetContinueReleaseSpell(i)
                spell_state.had = cur_had
                if spell_ins.ins.activeSelf ~= spell_state.had then
                    spell_ins.ins:SetActive(spell_state.had)
                end
                if spell_state.had then
                    if spell_state.spell_id ~= cur_spell_id then
                        local t_spell = Config.get_config_value("t_spell", cur_spell_id)
                        spell_ins.spell_icon.sprite = GUIRoot.LoadAtlas("BattlaPanel", "spell"):GetSprite(t_spell.icon)
                        spell_state.spell_id = cur_spell_id
                        spell_state.cd_time = t_spell.cold_time
                        spell_state.need_sp = -t_spell.sp
                    end
                    local scale = cur_per / 100
                    spell_ins.ring.localScale = Vector3.New(scale, scale, scale)
                    local cur_sp = FightManger.GetPlayerSp()
                    spell_ins.lock_mask.gameObject:SetActive(cur_sp < spell_state.need_sp)
                    local cur_cd = FightManger.GetSpellCd(spell_state.spell_id)
                    if spell_state.cd_time == 0 then
                        spell_ins.cd_mask.fillAmount = 0
                    else
                        spell_ins.cd_mask.fillAmount = cur_cd / spell_state.cd_time
                    end
                end
            end
            if i == 4 then
                --格挡
            end
        end
    end

    ---战斗提示
    if this.battle_tip_.gameObject.activeSelf then
        this.battle_tip_.alpha = this.battle_tip_.alpha - Time.deltaTime * 1
        if this.battle_tip_.alpha <= 0 then
            this.battle_tip_.gameObject:SetActive(false)
            this.battle_tip_.alpha = 1
        end
    end

    ---怒气槽 行为槽
    BattlePanel.RefreshSpSlider(FightManger.fighter1, Time.deltaTime)
    BattlePanel.RefreshSpSlider(FightManger.fighter2, Time.deltaTime)
end

---刷sp槽子
function BattlePanel.RefreshSpSlider(fighter, deltaTime)
    if fighter == nil then
        return
    end
    local site = fighter.site
    local sp_slider_color = this.sp_slider_colors_[site]
    local sp_slider = this.sp_sliders_[site]
    if fighter.fighter_type == 1 then
        --人物
        local sp_state, sp = fighter:Sp()
        if sp_state == 0 then
            ---普通模式
            if sp_slider_color.state ~= 0 then
                sp_slider_color.state = 0
                local b, color = ColorUtility.TryParseHtmlString("#F3CF2D", nil)
                this.sp_fill_images_[site].color = color
            end
            sp_slider.value = sp
        elseif sp_state == 1 then
            ---炸气模式
            if sp_slider_color.state ~= 1 then
                sp_slider_color.state = 1
                sp_slider_color.hight_state = 0
                sp_slider_color.timer = 0
                local b, color = ColorUtility.TryParseHtmlString("#B70032", nil)
                this.sp_fill_images_[site].color = color
            end
            sp_slider_color.timer = sp_slider_color.timer + deltaTime
            if sp_slider_color.timer >= 0.2 then
                sp_slider_color.timer = 0
                sp_slider_color.hight_state = math.abs(sp_slider_color.hight_state - 1)
                local b, color = nil, nil
                if sp_slider_color.hight_state == 0 then
                    b, color = ColorUtility.TryParseHtmlString("#B70032", nil)
                elseif sp_slider_color.hight_state == 1 then
                    b, color = ColorUtility.TryParseHtmlString("#FFE6ED", nil)
                end
                this.sp_fill_images_[site].color = color
            end
            sp_slider.value = sp
        end
        this.sp_texts_[site].text = string.format("%s/%s", sp, 100)
    elseif fighter.fighter_type == 2 then
        ---怪物
        local ai = fighter.ai
        local per_state, per = ai:GetPer()
        if per_state == 0 then
            ---普攻
            if sp_slider_color.state ~= 0 then
                sp_slider_color.state = 0
                local b, color = ColorUtility.TryParseHtmlString("#FFE9EF", nil)
                this.sp_fill_images_[site].color = color
            end
            sp_slider.value = per
        elseif per_state == 1 then
            ---技能
            if sp_slider_color.state ~= 1 then
                sp_slider_color.state = 1
                local b, color = ColorUtility.TryParseHtmlString("#C10941", nil)
                this.sp_fill_images_[site].color = color
            end
            sp_slider.value = per
        end
        this.sp_texts_[site].text = string.format("%s/%s", math.floor(per * 100) .. "%", "100%")
    end
end

--开始吟唱
function BattlePanel.StartSing(site, sing_time, sing_id)
    if not this.is_showed_ then
        return
    end
    local cur_sing_slider = this.sing_sliders_[site]
    if cur_sing_slider == nil then
        return
    end
    cur_sing_slider.maxValue = sing_time
    cur_sing_slider.value = 0
    local sing_text = cur_sing_slider.transform:Find("spell_text"):GetComponent("Text")
    sing_text.text = Config.get_config_value("t_spell", sing_id).name
    cur_sing_slider.gameObject:SetActive(true)
    this.sing_states_[site] = {
        ["sing_time"] = sing_time,
        ["cur_time"] = 0,
    }
end

--结束吟唱
function BattlePanel.EndSing(site)
    if not this.is_showed_ then
        return
    end
    local cur_sing_slider = this.sing_sliders_[site]
    if cur_sing_slider == nil then
        return
    end
    cur_sing_slider.gameObject:SetActive(false)
    this.sing_states_[site] = nil
end

--加buff
function BattlePanel.AddBuff(site, buff_id, buff_time, buff_level)
    if not this.is_showed_ then
        return
    end
    if this.buff_states_[site] == nil then
        this.buff_states_[site] = {}
    end
    if this.buff_states_[site][buff_id] ~= nil then
        ---buff 时间不叠加   重置
        this.buff_states_[site][buff_id].buff_time = buff_time
        this.buff_states_[site][buff_id].cur_time = 0
    else
        local cur_buff_root = this.buffs_roots_[site]
        local buff_ins = GameObject.Instantiate(this.buff_ins_.gameObject)
        buff_ins.gameObject:SetActive(true)
        buff_ins.transform:SetParent(cur_buff_root)
        buff_ins.transform.localScale = Vector3.New(1, 1, 1)
        buff_ins.name = "buff_icon_" .. buff_id
        local detail = buff_ins.transform:Find("detail")
        local detail_text = detail:Find("detail_desc")
        this.lua_script_:AddDownEvent(buff_ins, BattlePanel.OnBuffIconDown, { detail, detail_text })
        this.lua_script_:AddUpEvent(buff_ins, BattlePanel.OnBuffIconUp, { detail })
        local t_spell_buff = Config.get_config_value("t_spell_buff", buff_id)
        local spell_id = t_spell_buff.spell_id
        local icon_alias = ""
        if spell_id ~= 0 then
            local t_spell = Config.get_config_value("t_spell", spell_id)
            icon_alias = t_spell.icon
        else
            icon_alias = t_spell_buff.icon
        end
        if icon_alias ~= "" then
            local sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "spell"):GetSprite(icon_alias)
            buff_ins.transform:Find("buff_icon"):GetComponent("Image").sprite = sprite
        end
        local t_spell_level = Config.get_config_value("t_spell_level", buff_level)
        local quality = t_spell_level.color
        local quality_icon_alias = GameSys.get_quality(quality)
        local sprite_buff = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, "quality"):GetSprite(quality_icon_alias)
        buff_ins.transform:Find("quality_back"):GetComponent("Image").sprite = sprite_buff
        detail_text:GetComponent("Text").text = GameSys.GetBuffDesc(buff_id, buff_level)

        this.buff_states_[site][buff_id] = {
            ["buff_ins"] = buff_ins,
            ["buff_time"] = buff_time,
            ["cur_time"] = 0
        }
    end
end

--移除buff
function BattlePanel.RemoveBuff(site, buff_id)
    if not this.is_showed_ then
        return
    end
    local buffs = this.buff_states_[site]
    if buffs == nil then
        return
    end
    local buff = buffs[buff_id]
    if buff ~= nil then
        GameObject.Destroy(buff.buff_ins)
    end
    this.buff_states_[site][buff_id] = nil
end

--移除所有的buff
function BattlePanel.RemoveAllBuff(site)
    if not this.is_showed_ then
        return
    end
    if this.buff_states_[site] == nil then
        return
    end
    local del_buffs = {}
    for buff_id in pairs(this.buff_states_[site]) do
        table.insert(del_buffs, buff_id)
    end
    for i = 1, #del_buffs do
        BattlePanel.RemoveBuff(site, del_buffs[i])
    end
    this.buff_states_[site] = nil
end

--设置飘字
function BattlePanel.FlowText(tp, site, text_content, icon_info, size, delay)
    if not this.is_showed_ then
        return
    end
    if this.flow_text_ins_ == nil then
        return
    end
    if this.flow_states_[site] == nil then
        this.flow_prestates_[site] = {}
        this.flow_states_[site] = {}
        this.flow_delay_[site] = 0
    end
    if tp == "flow_text" then
        if #this.flow_prestates_[site] == 0 and this.flow_delay_[site] <= 0 then
            BattlePanel.FlowText1(tp, site, text_content, icon_info, size, delay)
        else
            table.insert(this.flow_prestates_[site], { tp, site, text_content, icon_info, size, delay })
        end
    else
        BattlePanel.FlowText1(tp, site, text_content, icon_info, size, delay)
    end
end

--展示飘字
function BattlePanel.FlowText1(tp, site, content, icon_info, size, delay)
    if tp == "flow_text" then
        this.flow_delay_[site] = 0.2
    end
    local flow_ins = GameObject.Instantiate(this.flow_text_ins_.gameObject)

    flow_ins.transform:SetParent(this.flow_points_[site])
    flow_ins.transform.localPosition = Vector3.New(0, 0, 0)
    flow_ins.transform.localScale = Vector3.New(1, 1, 1)
    local l = Util.GetClipLength(flow_ins:GetComponent("Animator"), tp)
    local text = flow_ins.transform:Find("f/text")
    text:GetComponent("Text").text = content
    if size ~= nil then
        text:GetComponent("Text").fontSize = size
    end
    if icon_info ~= nil then
        local title_icon = flow_ins.transform:Find("f/title_image")
        local text_wight = LayoutUtility.GetPreferredWidth(text)
        local icon_wight = title_icon.sizeDelta.x
        local total_wight = text_wight + icon_wight
        local icon_offset = (total_wight / 2) - (icon_wight / 2) + 5
        local text_offset = (total_wight / 2) - (text_wight / 2) + 5
        title_icon.anchoredPosition = Vector2(-icon_offset, 0)
        text.anchoredPosition = Vector2(text_offset, 0)
        local atlas = icon_info.atlas
        local icon_alias = icon_info.icon
        title_icon:GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script_.gameObject.name, atlas):GetSprite(icon_alias)
        title_icon.gameObject:SetActive(true)
    end
    if delay == nil then
        flow_ins:SetActive(true)
        flow_ins:GetComponent("Animator"):Play(tp, 0, 0)
    end
    table.insert(this.flow_states_[site], {
        ["tp"] = tp,
        ["flow_ins"] = flow_ins,
        ["delay"] = delay,
        ["life_time"] = l
    })
end

--移除所有的飘字
function BattlePanel.RemoveAllFlowTexts(site)
    if not this.is_showed_ then
        return
    end
    if this.flow_states_[site] == nil then
        return
    end
    for i = 1, #this.flow_states_ do
        local flow_state = this.flow_states_[i]
        GameObject.Destroy(flow_state.flow_ins)
    end
    this.flow_prestates_[site] = nil
    this.flow_states_[site] = nil
    this.flow_delay_[site] = nil
end

--设置血条
function BattlePanel.SetHpSliser(site, cur_hp)
    if not this.is_showed_ then
        return
    end
    local hp_control = this.hp_slider_controls[site]
    if hp_control ~= nil then
        hp_control:SetHp(cur_hp)
    end
end

--战斗过程结束 清理界面
function BattlePanel.Clears(site)
    ---战斗过程结束 除了飘字  界面表现都清理掉  技能锁住  逃跑按钮无效
    BattlePanel.EndSing(site)
    BattlePanel.RemoveAllBuff(site)
    if site == 0 then
        this.spell_lock_ = true
        for i = 1, #this.spell_states_ do
            local ins = this.spell_btn_inss_[i]
            ins.lock_mask.gameObject:SetActive(true)
            ins.cd_mask.fillAmount = 0
            ins.ring.localScale = Vector3.New(0, 0, 0)
            if i == 2 or i == 3 then
                ins.ins:SetActive(false)
            end
        end
        this.lua_script_:RemoveButtonEvent(this.escape_btn_.gameObject, "click")
    end
end

function BattlePanel.ShowWinPanel(assets)
    if not this.is_showed_ then
        return
    end
    this.win_ = true
    BattlePanel.BagContainTip()
    this.reward_panel_.gameObject:SetActive(true)
    this.win_panel_.gameObject:SetActive(this.win_)
    this.lose_panel_.gameObject:SetActive(not this.win_)
    soundMgr:play_sound("win")
    local reward_root = this.win_panel_:Find("rewards_root")
    local gold = this.win_panel_:Find("res_1/gold")
    local exp = this.win_panel_:Find("res_1/exp")
    gold.transform.gameObject:SetActive(false)
    exp.transform.gameObject:SetActive(false)
    Util.ClearChild(reward_root)
    if assets ~= nil then
        for i = 1, #assets.assets do
            local asset = assets.assets[i]
            if asset.type == 1 and asset.value1 == 1 then
                gold.transform.gameObject:SetActive(true)
                gold:Find("gold_text"):GetComponent("Text").text = GameSys.unit_conversion(asset.value2)
            elseif asset.type == 1 and asset.value1 == 3 then
                exp.transform.gameObject:SetActive(true)
                exp:Find("exp_text"):GetComponent("Text").text = GameSys.unit_conversion(asset.value2)
            else
                local reward_ins = CommonPanel.GetIcon2type(asset, { "battle_asset_" .. i }, this.lua_script_)
                reward_ins.transform:SetParent(reward_root)
                reward_ins.transform.localScale = Vector3.New(1, 1, 1)
            end
        end
        for i = 1, #assets.equips do
            local type = 3
            local value1 = assets.equips[i].template_id
            local asset = {
                ["type"] = type,
                ["value1"] = value1,
                ["value2"] = 0,
                ["value3"] = 0
            }
            local reward_ins = CommonPanel.GetIcon2type(asset, { "battle_equip_" .. i }, this.lua_script_)
            reward_ins.transform:SetParent(reward_root)
            reward_ins.transform.localScale = Vector3.New(1, 1, 1)
        end
        for i = 1, #assets.pets do
            local type = 6
            local value1 = assets.pets[i].template_id
            local asset = {
                ["type"] = type,
                ["value1"] = value1,
                ["value2"] = 0,
                ["value3"] = 0
            }
            local reward_ins = CommonPanel.GetIcon2type(asset, { "battle_pet_" .. i }, this.lua_script_)
            reward_ins.transform:SetParent(reward_root)
            reward_ins.transform.localScale = Vector3.New(1, 1, 1)
        end
    end

    local is_task, task_ids = Battle.IsTaskBattle()
    local task_tip_root = this.win_panel_:Find("task_tip_root")
    task_tip_root.gameObject:SetActive(is_task)
    if is_task then
        Util.ClearChild(task_tip_root)
        for i = 1, #task_ids do
            local text_ins = GameObject.Instantiate(this.task_tip_text_.gameObject)
            text_ins.transform:SetParent(task_tip_root, false)
            text_ins:SetActive(true)
            local t_quest_sub = Config.get_config_value("t_quest_sub", task_ids[i])
            text_ins.transform:GetComponent("Text").text = t_quest_sub.tishi
        end
    end
end

function BattlePanel.ShowLosePanel()
    if not this.is_showed_ then
        return
    end
    this.win_ = false
    this.reward_panel_.gameObject:SetActive(true)
    this.win_panel_.gameObject:SetActive(this.win_)
    this.lose_panel_.gameObject:SetActive(not this.win_)
    soundMgr:play_sound("fail")
end

---展示 副本回合掉落 不结束战斗
function BattlePanel.ShowRoundDrop(assets)
    this.DropEndCallBack_ = BattlePanel.OnDungeonNextRound()
    BattlePanel.BagContainTip()
    local drop_num = BattlePanel.ShowDrop(assets)
    if drop_num == 0 then
        --- 没有掉落 1秒后进入下一轮
        this.auto_exit_time_ = 1
        timerMgr:AddTimer("GoDungeonNextRound", BattlePanel.OnDungeonNextRound, this.auto_exit_time_)
    else
        this.auto_exit_time_ = 3
    end
end

--当副本要进入下一轮
function BattlePanel.OnDungeonNextRound()
    BattlePanel.OnRoundBattleEnd()
    Battle.GoDungeonNextRound()
end

--展示连续战斗的掉落 展示完 进入下一轮战斗
function BattlePanel.ShowMissionDrop(assets)
    this.DropEndCallBack_ = BattlePanel.OnMissionNextRound
    BattlePanel.BagContainTip()
    local drop_num = BattlePanel.ShowDrop(assets)
    local is_task, task_ids = Battle.IsTaskBattle()
    if is_task then
        for i = 1, #task_ids do
            local t_quest_sub = Config.get_config_value("t_quest_sub", task_ids[i])
            BattlePanel.FlowText("flow_text", 0, GameSys.set_color(5, t_quest_sub.tishi))
        end
    end
    if drop_num == 0 then
        --- 没有掉落 1秒后进入下一轮
        this.auto_exit_time_ = 1
        timerMgr:AddTimer("GoDungeonNextRound", BattlePanel.OnMissionNextRound, this.auto_exit_time_)
    else
        this.auto_exit_time_ = 3
    end
end

--当连续战斗进入下一轮
function BattlePanel.OnMissionNextRound()
    BattlePanel.OnRoundBattleEnd()
    Battle.GoMissionNextRound()
end

---展示战斗的掉落 后 结束战斗
function BattlePanel.ShowBattleDrop(assets)
    this.win_ = true
    this.DropEndCallBack_ = function()
        Battle.LeaveBattle(this.win_)
    end
    BattlePanel.BagContainTip()

    local drop_num = BattlePanel.ShowDrop(assets)
    if drop_num == 0 then
        --- 没有掉落 1秒后自动离开
        this.auto_exit_time_ = 1
        timerMgr:AddTimer("AutoExit", function()
            BattlePanel.OnRoundBattleEnd()
            Battle.LeaveBattle(this.win_)
        end, this.auto_exit_time_)
    else
        this.auto_exit_time_ = 3
    end
    local is_task, task_ids = Battle.IsTaskBattle()
    if is_task then
        for i = 1, #task_ids do
            local t_quest_sub = Config.get_config_value("t_quest_sub", task_ids[i])
            BattlePanel.FlowText("flow_text", 0, GameSys.set_color(5, t_quest_sub.tishi))
        end
    end
end

--当一轮战斗结束
function BattlePanel.OnRoundBattleEnd()
    BattlePanel.RemoveAllFlowTexts()
    this.tip_title_.is_show = false
    this.tip_title_.show_time = 2
    this.tip_title_.timer = 0
end

--展示掉落
function BattlePanel.ShowDrop(assets)
    local tnum = 0
    local count = {}
    local count1 = {}
    local num = 0
    if assets ~= nil then
        for i = 1, #assets.assets do
            local asset = assets.assets[i]
            if asset.type == 1 and asset.value1 ~= 3 then
                table.insert(count, tnum)
                tnum = tnum + 1
            elseif asset.type == 1 and asset.value1 == 3 then
                local content = "exp+" .. GameSys.unit_conversion(asset.value2)
                content = GameSys.SetTextColor("#33FF24", content)
                BattlePanel.FlowText("flow_text", 0, content)
            elseif asset.type == 2 then
                table.insert(count, tnum)
                tnum = tnum + 1
            elseif asset.type == 4 then
                table.insert(count, tnum)
                tnum = tnum + 1
            end
        end
        for i = 1, #assets.equips do
            table.insert(count, tnum)
            tnum = tnum + 1
        end
        for i = 1, tnum do
            local index = math.random(1, #count)
            table.insert(count1, count[index])
            table.remove(count, index)
        end
        for i = 1, #assets.assets do
            local asset = assets.assets[i]
            if asset.type == 1 and asset.value1 ~= 3 then
                local t_resource = Config.get_config_value("t_resource", asset.value1)
                local name = GameSys.set_color(t_resource.color, t_resource.name .. " x " .. tostring(asset.value2))
                local obj = nil
                if asset.value1 == 1 then
                    obj = GameObject.Instantiate(this.drop_panels_.gold)
                else
                    obj = GameObject.Instantiate(this.drop_panels_.normal)
                end
                obj.transform.localPosition = Vector3.New(0, 0, 0)
                obj.transform.localEulerAngles = Vector3.New(-90, 30, 0)
                obj.transform.localScale = Vector3.New(1, 1, 1)
                BattlePanel.CreateDrop(name, obj, 1, count1[num + 1])
                num = num + 1
            elseif asset.type == 2 then
                local t_item = Config.get_config_value("t_item", asset.value1)
                local name = GameSys.set_color(t_item.color, t_item.name .. " x " .. tostring(asset.value2))
                local obj = GameObject.Instantiate(this.drop_panels_.normal)
                obj.transform.localPosition = Vector3.New(0, 0, 0)
                obj.transform.localEulerAngles = Vector3.New(-90, 30, 0)
                obj.transform.localScale = Vector3.New(1, 1, 1)
                BattlePanel.CreateDrop(name, obj, t_item.color, count1[num + 1])
                num = num + 1
            elseif asset.type == 4 then
                local t_artifact = Config.get_config_value("t_artifact", asset.value1)
                local name = GameSys.set_color(t_artifact.color, t_artifact.name)
                local obj = GameObject.Instantiate(this.drop_panels_.normal)
                obj.transform.localPosition = Vector3.New(0, 0, 0)
                obj.transform.localEulerAngles = Vector3.New(-90, 30, 0)
                obj.transform.localScale = Vector3.New(1, 1, 1)
                BattlePanel.CreateDrop(name, obj, t_artifact.color, count1[num + 1])
                num = num + 1
            end
        end
        for i = 1, #assets.equips do
            local equip = assets.equips[i]
            local t_equip = Config.get_config_value("t_equip", equip.template_id)
            local name = GameSys.set_color(equip.color, t_equip.name)
            local part = GameSys.GetEquipPart(t_equip.type)
            if part ~= nil then
                local obj1 = resMgr.LoadUnit(t_equip.res)
                obj1 = UnitIns.GetPart(obj1, part)
                if obj1 ~= nil then
                    if part == "weapon" then
                        local obj = GameObject.Instantiate(obj1)
                        obj.transform.localEulerAngles = Vector3.New(0, -150, 0)
                        obj.transform.localScale = Vector3.New(0.5, 0.5, 0.5)
                        obj.transform.localPosition = Vector3.New(this.drop_panels_.const[t_equip.type], 0, this.drop_panels_.const[t_equip.type])
                        BattlePanel.CreateDrop(name, obj, equip.color, count1[num + 1])
                    else
                        local obj = GameObject.Instantiate(this.drop_panels_.normal)
                        obj.transform.localEulerAngles = Vector3.New(-90, 30, -180)
                        obj.transform.localScale = Vector3.New(0.5, 0.5, 0.5)
                        local m = UnityEngine.Mesh()
                        obj1:GetComponent("SkinnedMeshRenderer"):BakeMesh(m)
                        m:RecalculateBounds()
                        obj:GetComponent("MeshFilter").mesh = m
                        obj:GetComponent("MeshRenderer").sharedMaterials = obj1:GetComponent("SkinnedMeshRenderer").sharedMaterials
                        obj.transform.localPosition = Vector3.New(0, this.drop_panels_.const[t_equip.type], 0)
                        BattlePanel.CreateDrop(name, obj, equip.color, count1[num + 1], t_equip.res)
                    end
                else
                    local obj = GameObject.Instantiate(this.drop_panels_.normal)
                    obj.transform.localEulerAngles = Vector3.New(-90, 30, 0)
                    obj.transform.localScale = Vector3.New(1, 1, 1)
                    obj.transform.localPosition = Vector3.New(0, this.drop_panels_.const[t_equip.type], 0)
                    BattlePanel.CreateDrop(name, obj, equip.color, count1[num + 1], t_equip.res)
                end
                num = num + 1
            end
        end
    end
    if num > 0 then
        this.drop_buff_time_ = 0
        soundMgr:play_sound("drop_start")
    end
    return num
end

--创建掉落物
function BattlePanel.CreateDrop(name, obj, color, num, param)
    local ins = GameObject.Instantiate(this.drop_panels_.container.gameObject)
    obj.transform:SetParent(ins.transform:Find("obj"), false)
    obj:SetActive(true)

    local light = nil
    if color > 1 then
        light = GameObject.Instantiate(this.drop_panels_.light[color - 1].gameObject)
        light.transform:SetParent(ins.transform:Find("obj"), false)
        light.transform.localPosition = Vector3.zero
        light.transform.localEulerAngles = Vector3.New(0, 0, 0)
        light.transform.localScale = Vector3.New(1, 1, 1)
        light:SetActive(false)
    end

    ins.transform:SetParent(Scene.UnitRoot)
    local v = Battle.units[10].unit_ins.ins.transform.localPosition
    v.x = v.x + (math.random() - 0.65) * 2.5
    v.z = v.z + (math.random() - 0.5) * 3
    ins.transform.localPosition = v
    ins.transform.localEulerAngles = Vector3.New(0, 0, 0)
    ins.transform.localScale = Vector3.New(1, 1, 1)

    local desc = GameObject.Instantiate(this.drop_panels_.desc.gameObject)
    desc.name = tostring(num)
    desc.transform:SetParent(this.drop_panels_.drops_root)
    desc.transform.localEulerAngles = Vector3.New(0, 0, 0)
    desc.transform.localScale = Vector3.New(1, 1, 1)
    desc.transform:Find("back/text"):GetComponent("LocalizationText").text = name

    local rect = this.drop_panels_.drops_root:GetComponent("RectTransform")
    local wp = Scene.Camera:WorldToScreenPoint(ins.transform.position - Vector3.New(0, 0.1, 0))
    local b, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, wp, GUIRoot.UICamera, nil)
    if b then
        desc.transform.anchoredPosition = pos
    end

    local drop = {}
    drop.ins = ins
    --drop.s_time = num * 0.1
    drop.s_time = 0
    drop.time = 0
    drop.desc = desc
    drop.can_click = true
    drop.type = 0
    drop.name = name
    drop.light = light
    drop.param = param
    drop.color = color
    drop.obj = ins.transform:Find("obj").gameObject
    drop.tail = ins.transform:Find("tail").gameObject
    drop.buff = ins.transform:Find("buff").gameObject
    drop.v1 = drop.ins.transform.localPosition
    if Battle.cur_type == Battle.BATTLE_TYPE.dungeon then
        local p = GUIRoot.UICamera:WorldToScreenPoint(this.teasure_btn_.position)
        local ray = Scene.Camera:ScreenPointToRay(p)
        local l = -ray.origin.z / ray.direction.z
        p = ray:GetPoint(l)
        p = p - Scene.UnitRoot.position
        drop.v2 = p
    else
        drop.v2 = Battle.units[0].unit_ins.ins.transform.localPosition
        drop.v2.y = drop.v2.y + 1.2
    end
    drop.v3 = Vector3.New(drop.v1.x + (math.random() - 0.5) * 4, drop.v1.y + math.random() * 2, drop.v1.z + (math.random() - 0.5) * 4)
    drop.v4 = Vector3.New(drop.v2.x + (math.random() - 0.5) * 4, drop.v2.y + (math.random() - 0.5) * 2, drop.v2.z + (math.random() - 0.5) * 4)

    this.lua_script_:AddEnterEvent(desc.gameObject, BattlePanel.OnEnterDropDesc, nil)

    this.drops_[tostring(num)] = drop
end

--当鼠标进入掉落
function BattlePanel.OnEnterDropDesc(obj, eventdata, params)
    local name = obj.name
    local drop = this.drops_[name]
    if not drop.can_click then
        return
    end
    if drop.type == 2 then
        drop.type = 3
        drop.desc:SetActive(false)
        drop.time = 0
        drop.obj:SetActive(false)
        drop.tail:SetActive(true)
        soundMgr:play_sound("pick_drop")
    end
    drop.can_click = false
end

--设置宝箱按钮
function BattlePanel.SetTeasureBtn(is_dungeon)
    this.teasure_btn_.gameObject:SetActive(is_dungeon)
end

--设置逃跑按钮
function BattlePanel.SetEscapeBtn(is_dungeon)
    this.escape_btn_.gameObject:SetActive(not is_dungeon)
end

--点击退出战斗按钮
function BattlePanel.OnBackBtnClick()
    Battle.LeaveBattle(this.win_)
end

--点击自动战斗按钮
function BattlePanel.AutoBattle(obj, params)
    local auto = params[1]
    FightManger.SwitchAutoFight(auto)
    local content = "自动战斗 " .. (auto and "开启" or "关闭")
    GUIRoot.ShowPanel("MessagePanel", { content })
    BattlePanel.SetAutoBattleBtn(auto)
end

--设置自动战斗按钮
function BattlePanel.SetAutoBattleBtn(auto)
    this.auto_battle_btn_.gameObject:SetActive(auto)
    this.no_auto_battle_btn_.gameObject:SetActive(not auto)
end

--点击逃跑按钮
function BattlePanel.RunAway(obj, params)
    FightManger.RunAway()
end

--点击宝箱按钮
function BattlePanel.OnTeasureBtnClick(obj, params)
    FightManger.ShowDungeonReward()
end

--点击技能按钮
function BattlePanel.OnSpellClick(obj, eventdata, params)
    if not this.spell_lock_ then
        local spell_sort = params[1]
        if spell_sort == 0 then
            return
        end
        ---接 释放技能接口
        local result = FightManger.ReleaseSpell(spell_sort)
        if this.spell_states_[spell_sort].had then
            local r = nil
            if result then
                UIEffect.Hide("aj_cg")
                r = UIEffect.Show("aj_cg")
            else
                UIEffect.Hide("aj_sb")
                r = UIEffect.Show("aj_sb")
            end
            for i = 1, 3 do
                local ui_effect = this.spell_btn_inss_[i].ui_effect
                ui_effect.gameObject:SetActive(i == spell_sort)
                if i == spell_sort then
                    ui_effect.uvRect = r
                end
            end
        end
    end
end

--按下buff图标
function BattlePanel.OnBuffIconDown(go, eventdata, params)
    local detail = params[1]
    local detail_text = params[2]
    detail.gameObject:SetActive(true)
    local height = LayoutUtility.GetPreferredHeight(detail_text)
    detail.sizeDelta = Vector2(detail.sizeDelta.x, height + 6)
end

--抬起buff图标
function BattlePanel.OnBuffIconUp(go, eventdata, params)
    local detail = params[1]
    detail.gameObject:SetActive(false)
end

--按下怪物特性
function BattlePanel.OnMonsterPassiveDown(go, eventdata, params)
    local detail = params[1]
    detail.gameObject:SetActive(true)
end

--抬起怪物特性
function BattlePanel.OnMonsterPassiveUp(go, eventdata, params)
    local detail = params[1]
    detail.gameObject:SetActive(false)
end

--战斗提示（技能?）
function BattlePanel.Tip(content)
    if not this.battle_tip_.gameObject.activeSelf then
        this.battle_tip_.gameObject:SetActive(true)
    end
    this.battle_tip_.alpha = 1
    this.battle_tip_.transform:GetComponent("Text").text = content
end

--背包容量提示
function BattlePanel.BagContainTip()
    local can_get_equip_count = GameSys.CanGetEquipNum()
    if can_get_equip_count <= 0 then
        GUIRoot.ShowPanel("MessagePanel", { "背包内装备容器不足" })
    end
end

--倒计时开始 并及时
function BattlePanel.Timer(time)
    if not this.timer_title_.gameObject.activeSelf then
        this.timer_title_.gameObject:SetActive(true)
    end
    local time_content = math.ceil(time)
    this.timer_text_.text = time_content .. "s"
end

--倒计时结束
function BattlePanel.TimerEnd()
    this.timer_title_.gameObject:SetActive(false)
end

--展示大提示框
function BattlePanel.ShowTipTitle(content)
    this.tip_title_.timer = 0
    this.tip_title_.alpha = 1
    this.tip_title_.is_show = true
    this.tip_title_text_.text = content
    this.tip_title_.gameObject:SetActive(true)
end