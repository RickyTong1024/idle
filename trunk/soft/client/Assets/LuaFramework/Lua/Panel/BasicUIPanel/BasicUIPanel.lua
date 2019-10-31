BasicUIPanel = {}
BasicUIPanel.Control = {}
local this = BasicUIPanel.Control

function BasicUIPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.bag_btn_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/bag_btn")
    this.player_btn_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/player_btn")
    this.book_btn_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/book_btn")
    this.task_btn_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/task_btn")
    this.content_ = this.transform_:Find("back_ground/basic_panel_tright/quest/view/content")
    this.quest_image_back_res_ = this.transform_:Find("back_ground/basic_panel_tright/quest_image_back_res")
    this.quest_ = this.transform_:Find("back_ground/basic_panel_tright/quest")
    this.trans_ = this.transform_:Find("back_ground/basic_panel_tright/quest/trans")
    this.bag_red_point_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/bag_btn/bag_red_point")
    this.player_red_point_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/player_btn/player_red_point")
    this.book_red_point_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/book_btn/book_red_point")
    this.task_red_point_ = this.transform_:Find("back_ground/basic_panel_bottom/basic_btns/task_btn/task_red_point")
    this.tip_btn_ = this.transform_:Find("back_ground/basic_panel_bottom/tip_btn")
    this.basic_panel_tright_ = this.transform_:Find("back_ground/basic_panel_tright")
    this.basic_panel_bottom_ = this.transform_:Find("back_ground/basic_panel_bottom")
    this.basic_exp_panel_ = this.transform_:Find("back_ground/basic_exp_panel")
    this.exp_slider_ = this.transform_:Find("back_ground/basic_exp_panel/exp_slider_back/exp_slider"):GetComponent("Image")
    this.exp_slider_bai_ = this.transform_:Find("back_ground/basic_exp_panel/exp_slider_back/exp_slider/exp_slider_bai"):GetComponent("Image")
    this.exp_text_ = this.transform_:Find("back_ground/basic_exp_panel/exp_slider_back/exp_slider/exp_text"):GetComponent("Text")
    this.basic_panel_tleft_ = this.transform_:Find("back_ground/basic_panel_tleft")
    this.h_player_icon_btn_ = this.transform_:Find("back_ground/basic_panel_tleft/hall_top/h_player_info/h_player_icon_btn")
    this.h_player_name_ = this.transform_:Find("back_ground/basic_panel_tleft/hall_top/h_player_info/h_player_name")
    this.h_player_fight_ = this.transform_:Find("back_ground/basic_panel_tleft/hall_top/h_player_info/h_player_fight")
    this.h_mail_btn_ = this.transform_:Find("back_ground/basic_panel_tleft/hall_top/h_player_info/mail_obj/h_mail_btn")
    this.h_sign_btn_ = this.transform_:Find("back_ground/basic_panel_tleft/hall_top/h_player_info/sign_obj/h_sign_btn")
    this.transform_:SetSiblingIndex(0)
    this.exp_bar_ = nil
    this.quest_image_ = { "gjrui_112", "gjrui_111", "gjrui_111" }
    this.orient_type_ = { "gjrui_114", "gjrui_115" }
    this.quest_obj_ = {}
    this.trans_tag_ = true
    BasicUIPanel.RegisterBtnListers()
    BasicUIPanel.RegisterMessage()
    BasicUIPanel.RegisterRedLister()
end

function BasicUIPanel.OnDestroy()

    BasicUIPanel.RemoveMessage()
    BasicUIPanel.RemoveRedLister()
    if this.exp_bar_ ~= nil then
        this.exp_bar_:Destroy()
        this.exp_bar_ = nil
    end
    this = {}
end

function BasicUIPanel.ChangeState()
    if State.cur_state ~= State.state.ss_battle then
        this.basic_panel_tleft_.gameObject:SetActive(true)
        this.basic_panel_bottom_.gameObject:SetActive(true)
        this.basic_panel_tright_.gameObject:SetActive(true)
    else
        this.basic_panel_tleft_.gameObject:SetActive(false)
        this.basic_panel_bottom_.gameObject:SetActive(false)
        this.basic_panel_tright_.gameObject:SetActive(false)
    end
end

function BasicUIPanel.IsNewPlayer()
    if PlayerData.player.aside == 0 then
        local common_msg = CommonMessage()
        common_msg.name = "dubai_start"
        messMgr:AddCommonMessage(common_msg)
        GUIRoot.ShowPanel("NarratorPanel", { 0, function()
            local msg = promotion_msg_pb.cmsg_aside()
            msg.aside_id = 1
            local data = msg:SerializeToString()
            GameTcp.Send(opcodes.CMSG_ASIDE, data, {opcodes.SMSG_ASIDE},"开场独白")
            local t_xinshou_hua = Config.get_config_value("t_const", "dubai").value
            GUIRoot.ShowPanel("TalkPanel", {t_xinshou_hua, {nil, function ()
                local common_msg = CommonMessage()
                common_msg.name = "dubai_end"
                messMgr:AddCommonMessage(common_msg)
            end}})
        end })
    end
end

function BasicUIPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.trans_.gameObject, "click", BasicUIPanel.QuestChangeActive)
    GameSys.ButtonRegister(this.lua_script_, this.tip_btn_.gameObject, "click", BasicUIPanel.OnTipBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.h_player_icon_btn_.gameObject, "click", BasicUIPanel.OnPlayerSetBtnClick)
    UnlockManger.RegisterFunBtn({4004, this.h_mail_btn_, "click", BasicUIPanel.OnMailBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({4005, this.h_sign_btn_, "click", BasicUIPanel.OnSignBtnClick, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({ 4001, this.bag_btn_, "click", BasicUIPanel.OnBagBtnClick, nil, this.lua_script_ , true})
    UnlockManger.RegisterFunBtn({ 4002, this.player_btn_, "click", BasicUIPanel.OnPlayerBtnClick, nil, this.lua_script_ , true})
    UnlockManger.RegisterFunBtn({ 4003, this.book_btn_, "click", BasicUIPanel.OnBookBtnClick, nil, this.lua_script_ , true})
    UnlockManger.RegisterFunBtn({ 4006, this.task_btn_, "click", BasicUIPanel.OnTaskBtnClick, nil, this.lua_script_ , true})
end

function BasicUIPanel.RegisterMessage()
    Message.register_handle("change_avatar_success", BasicUIPanel.RefreshPlayerIcon)
    Message.register_handle("need_check_quest", BasicUIPanel.QuestShow)
    Message.register_handle("battle_end", BasicUIPanel.QuestShow)
    Message.register_handle("wear_equip_success", BasicUIPanel.CheckEquipRed)
    Message.register_handle("unlock_spell_success", BasicUIPanel.CheckSpellRed)
    Message.register_handle("upgrade_spell_success", BasicUIPanel.CheckSpellRed)
    Message.register_handle("unlock_passive_success", BasicUIPanel.CheckSpellRed)
    Message.register_handle("upgrade_passive_success", BasicUIPanel.CheckSpellRed)
    Message.register_handle("get_artifact_reputation_success", BasicUIPanel.CheckBookRed)
    Message.register_handle("get_pet_reputation_success", BasicUIPanel.CheckBookRed)
    Message.register_handle("get_monster_reputation_success", BasicUIPanel.CheckBookRed)
    Message.register_handle("get_dress_reputation_success", BasicUIPanel.CheckBookRed)
    Message.register_handle("unlock_success", BasicUIPanel.OnUnlockSuccess)
    Message.register_handle("name_end", BasicUIPanel.OnMakeNameEnd)
    Message.register_net_handle(opcodes.SMSG_ASIDE, BasicUIPanel.SMSG_ASIDE)
end

function BasicUIPanel.RemoveMessage()
    UnlockManger.RemoveFunBtn({ 4001, 4002, 4003, 4004, 4005, 4006 })
    Message.remove_handle("change_avatar_success", BasicUIPanel.RefreshPlayerIcon)
    Message.remove_handle("need_check_quest", BasicUIPanel.QuestShow)
    Message.remove_handle("battle_end", BasicUIPanel.QuestShow)
    Message.remove_handle("wear_equip_success", BasicUIPanel.CheckEquipRed)
    Message.remove_handle("unlock_spell_success", BasicUIPanel.CheckSpellRed)
    Message.remove_handle("upgrade_spell_success", BasicUIPanel.CheckSpellRed)
    Message.remove_handle("unlock_passive_success", BasicUIPanel.CheckSpellRed)
    Message.remove_handle("upgrade_passive_success", BasicUIPanel.CheckSpellRed)
    Message.remove_handle("get_artifact_reputation_success", BasicUIPanel.CheckBookRed)
    Message.remove_handle("get_pet_reputation_success", BasicUIPanel.CheckBookRed)
    Message.remove_handle("get_monster_reputation_success", BasicUIPanel.CheckBookRed)
    Message.remove_handle("get_dress_reputation_success", BasicUIPanel.CheckBookRed)
    Message.remove_handle("unlock_success", BasicUIPanel.OnUnlockSuccess)
    Message.remove_handle("name_end", BasicUIPanel.OnMakeNameEnd)
    Message.remove_net_handle(opcodes.SMSG_ASIDE, MailPanel.SMSG_ASIDE)
end

function BasicUIPanel.RegisterRedLister()
    AssetsChangeControl.AddDailyChanged(BasicUIPanel.RefreshDaily)
    AssetsChangeControl.AddMailChanged(BasicUIPanel.RefreshMail)
    AssetsChangeControl.AddSignChanged(BasicUIPanel.RefreshSign)
    AssetsChangeControl.AddExpChanged(BasicUIPanel.OnExpChanged)
    AssetsChangeControl.AddKillNumChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddDressChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddGoldChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddItemChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddArtifactChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddPetChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.AddItemChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.AddGoldChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.AddEquipChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.AddEquipChanged(BasicUIPanel.CheckEquipRed)
    AssetsChangeControl.AddLevelChanged(BasicUIPanel.CheckSpellRed)
    AssetsChangeControl.AddItemChanged(BasicUIPanel.CheckSpellRed)
    AssetsChangeControl.AddPetLevelChanged(BasicUIPanel.CheckSpellRed)
end

function BasicUIPanel.RemoveRedLister()
    AssetsChangeControl.RemoveMailChanged(BasicUIPanel.RefreshDaily)
    AssetsChangeControl.RemoveMailChanged(BasicUIPanel.RefreshMail)
    AssetsChangeControl.RemoveSignChanged(BasicUIPanel.RefreshSign)
    AssetsChangeControl.RemoveExpChanged(BasicUIPanel.OnExpChanged)
    AssetsChangeControl.RemoveKillNumChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemoveDressChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemoveGoldChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemoveItemChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemoveArtifactChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemovePetChanged(BasicUIPanel.CheckBookRed)
    AssetsChangeControl.RemoveEquipChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.RemoveItemChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.RemoveGoldChanged(BasicUIPanel.CheckBagRed)
    AssetsChangeControl.RemoveEquipChanged(BasicUIPanel.CheckEquipRed)
    AssetsChangeControl.RemoveLevelChanged(BasicUIPanel.CheckSpellRed)
    AssetsChangeControl.RemoveItemChanged(BasicUIPanel.CheckSpellRed)
    AssetsChangeControl.RemovePetLevelChanged(BasicUIPanel.CheckSpellRed)
end

function BasicUIPanel.Start(obj)
    BasicUIPanel.RefreshPanel()
    BasicUIPanel.RefreshMail()
    BasicUIPanel.RefreshSign()
    BasicUIPanel.RefreshDaily()
    --是否展示经验条
    this.basic_exp_panel_.gameObject:SetActive(GameSys.PlayerNameUnlock())
    if GameSys.PlayerNameUnlock() then
        this.exp_bar_ = ExpBar.CreateExpBar(PlayerData.player.level, PlayerData.player.exp, this.exp_slider_, this.exp_slider_bai_, this.exp_text_)
    end
end

function BasicUIPanel.OnMakeNameEnd(message)
    if this.exp_bar_ == nil then
        this.basic_exp_panel_.gameObject:SetActive(true)
        this.exp_bar_ = ExpBar.CreateExpBar(PlayerData.player.level, PlayerData.player.exp, this.exp_slider_, this.exp_slider_bai_, this.exp_text_)
    end
end

function BasicUIPanel.RefreshPanel()
    BasicUIPanel.QuestShow()
    BasicUIPanel.IsNewPlayer()
    BasicUIPanel.RefreshReds()
    BasicUIPanel.RefreshPlayer()
end

function BasicUIPanel.RefreshPlayer()
    BasicUIPanel.RefreshPlayerIcon()
    this.h_player_name_:GetComponent("Text").text = PlayerData.player.name
    this.h_player_fight_:GetComponent("Text").text = string.format("强度 %s", GameSys.unit_conversion(toInt(PlayerData.get_fight_power())))
    if PlayerData.player.name == "" then
        this.basic_panel_tleft_.gameObject:SetActive(false)
    else
        if State.cur_state ~= State.state.ss_battle then
            this.basic_panel_tleft_.gameObject:SetActive(true)
        end
    end
end

function BasicUIPanel.OnExpChanged()
    if this.exp_bar_ ~= nil then
        this.exp_bar_:SetExp(PlayerData.player.level, PlayerData.player.exp)
    end
end

function BasicUIPanel.RefreshReds()
    this.tip_state_= {
        ["active"] = false,
        ["spell_tip"] = false,
        ["passive_tip"] = false
    }
    BasicUIPanel.CheckPlayerRed()
    BasicUIPanel.CheckBagRed()
    BasicUIPanel.CheckBookRed()
end

function BasicUIPanel.OnUnlockSuccess(message)
    local unlock_id = message.m_object[0]
    if unlock_id == 4001 then
        BasicUIPanel.CheckBagRed()
    elseif unlock_id == 4002 or unlock_id == 3001 then
        BasicUIPanel.CheckPlayerRed()
    elseif unlock_id == 4003 then
        BasicUIPanel.CheckBookRed()
    end
end

function BasicUIPanel.CheckBookRed()
    if GameSys.BookIsLock() then
        return
    end
    local red = GameSys.CanGetMonsterReputation() or GameSys.CanGetDressReputation() or GameSys.CanGetArtifactReputation() or GameSys.CanGetPetReputation() or GameSys.CanForgeArtifact() or GameSys.CanSyntPet()
    BasicUIPanel.SetRed(this.book_red_point_, red)
end

function BasicUIPanel.CheckBagRed()
    if GameSys.BagIsLock() then
        return
    end
    local red = GameSys.IsEquipFull() or GameSys.HasCurLevelForge()
    BasicUIPanel.SetRed(this.bag_red_point_, red)
end

function BasicUIPanel.CheckPlayerRed()
    if GameSys.PlayerBtnIsLock() then
        return
    end
    local show_red = false
    if  GameSys.SpellIsLock()  then
        this.tip_state_.active = false
        show_red = GameSys.IsCanWearNullSlot()
    else
        this.tip_state_.active = true
        local is_equip_red = GameSys.IsCanWearNullSlot()
        local is_spell_red = GameSys.IsCanAdvanceSpell()
        local is_passive_red = GameSys.IsCanAdvancePassive()
        show_red = is_equip_red or is_spell_red or is_passive_red
        this.tip_state_.spell_tip = is_spell_red
        this.tip_state_.passive_tip = is_passive_red
    end
    BasicUIPanel.SetRed(this.player_red_point_, show_red)
    BasicUIPanel.SetTip()
end

function BasicUIPanel.CheckEquipRed()
    if GameSys.PlayerBtnIsLock() then
        return
    end
    local show_red = GameSys.IsCanWearNullSlot()
    if not show_red and this.player_red_point_.gameObject.activeSelf then
        if not GameSys.SpellIsLock()  then
            show_red = GameSys.IsCanAdvanceSpell() or GameSys.IsCanAdvancePassive()
        end
    end
    BasicUIPanel.SetRed(this.player_red_point_, show_red)
end

function BasicUIPanel.CheckSpellRed()
    if GameSys.PlayerBtnIsLock() or GameSys.SpellIsLock() then
        return
    end
    this.tip_state_.active = true
    local is_spell_red = GameSys.IsCanAdvanceSpell()
    local is_passive_red = GameSys.IsCanAdvancePassive()
    this.tip_state_.spell_tip = is_spell_red
    this.tip_state_.passive_tip = is_passive_red
    local show_red = is_spell_red or is_passive_red
    if not show_red and this.player_red_point_.gameObject.activeSelf then
       show_red = GameSys.IsCanWearNullSlot()
    end
    BasicUIPanel.SetRed(this.player_red_point_, show_red)
    BasicUIPanel.SetTip()
end

function BasicUIPanel.SetRed(red_point, show)
    if show then
        if not red_point.gameObject.activeSelf then
            red_point.gameObject:SetActive(true)
        end
    else
        if red_point.gameObject.activeSelf then
            red_point.gameObject:SetActive(false)
        end
    end
end

function BasicUIPanel.SetTip()
    if not this.tip_state_.active and (not this.tip_btn_.gameObject.activeSelf) then
        return
    end
    local is_show = this.tip_state_.spell_tip or this.tip_state_.passive_tip
    this.tip_btn_.gameObject:SetActive(is_show)
end

function BasicUIPanel.OnTipBtnClick(obj, param)
    if this.tip_state_.spell_tip then
        PlayerUnlockSpellPanel.DirectShow()
    elseif this.tip_state_.passive_tip then
        PlayerUnlockPassivePanel.DirectShow()
    end
end

function BasicUIPanel.OnBagBtnClick()
    GUIRoot.ShowPanel("BagPanel", {1})
end

function BasicUIPanel.OnPlayerBtnClick()
    GUIRoot.ShowPanel("PlayerPanel", { true })
end

function BasicUIPanel.OnBookBtnClick()
    GUIRoot.ShowPanel("BookPanel")
end

function BasicUIPanel.OnPlayerSetBtnClick(obj)
    GUIRoot.ShowPanel("PlayerSetPanel")
end

function BasicUIPanel.OnMailBtnClick()
    GUIRoot.ShowPanel("MailPanel")
end

function BasicUIPanel.OnSignBtnClick()
    GUIRoot.ShowPanel("SignPanel")
end

function BasicUIPanel.OnTaskBtnClick()
    GUIRoot.ShowPanel("TaskPanel")
end

function BasicUIPanel.RefreshMail()
    if PlayerData.player.has_mail == 1 then
        this.h_mail_btn_.transform:Find("mail_red_point").gameObject:SetActive(true)
    else
        this.h_mail_btn_.transform:Find("mail_red_point").gameObject:SetActive(false)
    end
end

function BasicUIPanel.RefreshSign()
    if PlayerData.player.is_checked == 0 then
        this.h_sign_btn_.transform:Find("sign_red_point").gameObject:SetActive(true)
    else
        this.h_sign_btn_.transform:Find("sign_red_point").gameObject:SetActive(false)
    end
end

function BasicUIPanel.RefreshDaily()
    BasicUIPanel.SetRed(this.task_red_point_, GameSys.DailyRed())
end

function BasicUIPanel.RefreshPlayerIcon()
    local icon_index = PlayerData.player.avatar
    if icon_index == 0 then
        icon_index = 1
    end
    local sprite_alias = Config.get_config_value("t_avatar", icon_index).res
    if sprite_alias ~= "" then
        local sprite = GUIRoot.LoadAtlas(this.gameObject_.name, "avatar"):GetSprite(sprite_alias)
        if sprite ~= "" then
            this.h_player_icon_btn_:GetComponent("Image").sprite = sprite
        end
    end
end

function BasicUIPanel.QuestChangeActive()
    this.trans_tag_ = not this.trans_tag_
    if this.trans_tag_ then
        this.quest_.transform.localPosition = Vector3(0, -60, 0)
        this.trans_.transform.localRotation = Vector3(0, 0, 0)
        this.trans_.transform:GetComponent("RectTransform").anchoredPosition = Vector2(-1, 126)
    else
        this.quest_.transform.localPosition = Vector3(212, -60, 0)
        this.trans_.transform.localRotation = Vector3(0, 0, 180)
        this.trans_.transform:GetComponent("RectTransform").anchoredPosition = Vector2(-29, 126)
    end
end

function BasicUIPanel.QuestShow()
    Util.ClearChild(this.content_)
    this.quest_obj_ = {}
    this.quest_.gameObject:SetActive(false)
    local index = 0
    if #PlayerData.player.tasks > 0 then
        for i = 1, #PlayerData.player.tasks do
            local quest_d = Config.get_config_value("t_quest", PlayerData.player.tasks[i])
            local sub_s = QuestManger.GetQuestSub(quest_d.id)
            local show_ = false
            for j = 1, #sub_s do
                if QuestManger.QuestIsInTask_Ids(sub_s[j].id) then
                    show_ = true
                    index = index + 1
                    break
                end
            end
            if sub_s ~= nil then
                if show_ then
                    if quest_d ~= nil then
                        local quest_s = GameObject.Instantiate(this.quest_image_back_res_.gameObject)
                        quest_s.transform:SetParent(this.content_, false)
                        quest_s.transform.localPosition = Vector3.zero
                        quest_s.transform.localScale = Vector3.one
                        quest_s.transform:Find("quest_type_image"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.quest_image_[quest_d.type])
                        quest_s.transform:Find("quest_type_image/quest_name"):GetComponent("LocalizationText").text = quest_d.name
                        local has, quest_sub = QuestManger.GetQuestJc(quest_d.id)
                        if has then
                            local desc = QuestManger.GetQuestDesc(quest_sub)
                            quest_s.transform:Find("quest_place"):GetComponent("LocalizationText").text = string.format("地点: %s", QuestManger.GetQuestPlace(quest_sub.id))
                            quest_s.transform:Find("quest_desc_res"):GetComponent("LocalizationText").text = desc
                        else
                            quest_s:GetComponent("LocalizationText").text = "unknown"
                        end
                        this.quest_obj_[quest_d.id] = quest_s
                        quest_s:SetActive(true)
                    end
                end
            end
        end
    end
    if index > 0 then
        this.quest_.gameObject:SetActive(true)
    else
        this.quest_.gameObject:SetActive(false)
    end

end

function BasicUIPanel.OrientShow(cur_map, cur_pos)
    for k, v in pairs(this.quest_obj_) do
        if State.cur_state == State.state.ss_map then
            local has, quest_sub = QuestManger.GetQuestJc(k)
            if has then
                if quest_sub.event_type == 1 then
                    local npc = Config.get_config_value("t_npc", quest_sub.npcid)
                    if npc ~= nil then
                        if npc.map > 0 and npc.map == cur_map then
                            v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ npc.x, npc.y }, { cur_pos[1], cur_pos[2] }, 135))
                            v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                        end
                    end
                elseif quest_sub.event_type == 2 or quest_sub.event_type == 5 then
                    if quest_sub.map > 0 and quest_sub.map == cur_map then
                        if quest_sub.tar_x == 0 and quest_sub.tar_y == 0 then
                            v.transform:Find("quest_place/orient"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.orient_type_[2])
                        else
                            v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ quest_sub.tar_x, quest_sub.tar_y }, { cur_pos[1], cur_pos[2] }, 135))
                        end
                        v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                    end
                elseif quest_sub.event_type == 3 then
                    if quest_sub.map > 0 and quest_sub.map == cur_map then
                        v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ quest_sub.event_param2, quest_sub.event_param3 }, { cur_pos[1], cur_pos[2] }, 135))
                        v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                    end
                elseif quest_sub.event_type == 4 then
                    local npc = Config.get_config_value("t_npc", quest_sub.npcid)
                    if npc ~= nil then
                        if npc.map > 0 and npc.map == cur_map then
                            v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ npc.x, npc.y }, { cur_pos[1], cur_pos[2] }, 135))
                            v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                        end
                    end
                elseif quest_sub.event_type == 11 then
                    if quest_sub.map > 0 and quest_sub.map == cur_map then
                        v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ quest_sub.tar_x, quest_sub.tar_y }, { cur_pos[1], cur_pos[2] }, 135))
                        v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                    end
                elseif quest_sub.event_type == 13 then
                    if quest_sub.map > 0 and quest_sub.map == cur_map then
                        local t_mission = Config.get_config_value("t_mission", quest_sub.event_param1)
                        if t_mission ~= nil then
                            v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ t_mission.x, t_mission.y }, { cur_pos[1], cur_pos[2] }, 135))
                        else
                            v.transform:Find("quest_place/orient"):GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.gameObject_.name):GetSprite(this.orient_type_[2])
                        end
                        v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                    end
                end
            else
                local quest = Config.get_config_value("t_quest", k)
                local npc = Config.get_config_value("t_npc", quest.npc_id)
                if npc ~= nil then
                    if npc.map > 0 and npc.map == cur_map then
                        v.transform:Find("quest_place/orient"):GetComponent("RectTransform").localEulerAngles = Vector3(0, 0, GameSys.Rotation({ npc.x, npc.y }, { cur_pos[1], cur_pos[2] }, 135))
                        v.transform:Find("quest_place/orient").gameObject:SetActive(true)
                    else
                        v.transform:Find("quest_place/orient").gameObject:SetActive(false)
                    end
                end
            end
        else
            v.transform:Find("quest_place/orient").gameObject:SetActive(false)
        end
    end
end

function BasicUIPanel.GetMonsterMission(monster_id)
    for _, v in pairs(Config.t_mission) do
        if v.mtype == 1 and v.monsterid == monster_id then
            return v.mparam3
        end
    end
    return 0
end

function BasicUIPanel.SMSG_ASIDE(message)
    PlayerData.player.aside = PlayerData.player.aside + 1
end