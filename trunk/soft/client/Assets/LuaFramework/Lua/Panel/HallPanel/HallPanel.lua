HallPanel = {}
HallPanel.Control = {}
local this = HallPanel.Control

function HallPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent('LuaUIBehaviour')
    this.sgc_back_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back")
    this.castle_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_2/castle_btn")
    this.esports_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_3/esports_btn")
    this.forge_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_4/forge_btn")
    this.lottery_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_5/lottery_btn")
    this.map_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_5/map_btn")
    this.shop_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_5/shop_btn")
    this.sign_btn_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/maotouying_sgc/sign_btn")
    this.quest_bs_ = this.transform_:Find("back_ground/scroll_back/view/sgc_back/back_sgc_3/esports_btn/quest_bs")
    this.bottom_image_ = this.transform_:Find("back_ground/bottom_image")

    this.screen_resolution_ = {
        x = Screen.width,
        y = Screen.height
    }

    this.quest_type_ = {"zjdt_ui045", "zjdt_ui044"}

    HallPanel.RegisterBtnListers()
    HallPanel.RegisterMessage()
    this.transform_:SetSiblingIndex(0)
end

function HallPanel.OnDestroy(obj)
    HallPanel.RemoveMessage()
    this = {}
end

function HallPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.esports_btn_.gameObject, "click", HallPanel.OnEsportsBtnClick, nil,false)
    UnlockManger.RegisterFunBtn({1001, this.forge_btn_, "click", HallPanel.OnForgeBtnClick, nil, this.lua_script_, false})
    UnlockManger.RegisterFunBtn({1002, this.shop_btn_, "click", HallPanel.OnShopBtnClick, nil, this.lua_script_, false})
    UnlockManger.RegisterFunBtn({1003, this.lottery_btn_, "click", HallPanel.OnLotteryBtnClick, nil, this.lua_script_, false})
    UnlockManger.RegisterFunBtn({1004, this.castle_btn_, "click", HallPanel.OnCastleBtnClick, nil, this.lua_script_, false})
    UnlockManger.RegisterFunBtn({1005, this.sign_btn_, "click", HallPanel.OnSignBtnClick, nil, this.lua_script_, false})
    UnlockManger.RegisterFunBtn({1006, this.map_btn_, "click", HallPanel.OnMapBtnClick, nil, this.lua_script_, false})
end

function HallPanel.RegisterMessage()
    Message.register_handle("unlock_success", HallPanel.OnUnlockSuccess)
    Message.register_handle("need_check_quest", HallPanel.CheckQuest)
    Message.register_handle("dubai_end", HallPanel.DuBaiEnd)
    Message.register_handle("dubai_start", HallPanel.DuBaiStart)
end

function HallPanel.RemoveMessage()
    UnlockManger.RemoveFunBtn({1001, 1002, 1003, 1004, 1005, 1006})
    Message.remove_handle("unlock_success", HallPanel.OnUnlockSuccess)
    Message.remove_handle("need_check_quest", HallPanel.CheckQuest)
    Message.remove_handle("dubai_end", HallPanel.DuBaiEnd)
    Message.remove_handle("dubai_start", HallPanel.DuBaiStart)
end

function HallPanel.Start(obj)
    HallPanel.RefreshPanel()
    --展示下面按钮底板
    this.bottom_image_.gameObject:SetActive(GameSys.BasicBtnUnlock())
end

function HallPanel.RefreshPanel()
    GameSys.ScreenSca(this.sgc_back_)
    HallPanel.CheckQuest()
end

function HallPanel.OnCastleBtnClick()
    GUIRoot.ShowPanel("TowerPanel")
end

function HallPanel.OnEsportsBtnClick()
    GUIRoot.ShowPanel("HallTwoPanel")
end

function HallPanel.OnLotteryBtnClick()
    --GUIRoot.ShowPanel("ArtifactPanel")
    if tonumber(PlayerData.player.level) >= Config.get_config_value("t_const", "rank_join_level").value then
        GUIRoot.ShowPanel("EsportsPanel")
    else
        local str = "等级不够 未解锁"
        GUIRoot.ShowPanel("MessagePanel", { str })
    end
end

function HallPanel.OnTaskBtnClick()
    GUIRoot.ShowPanel("TaskPanel")
end

function BasicUIPanel.OnForgeBtnClick()
    GUIRoot.ShowPanel("MessagePanel", { "未开放" })
end

function HallPanel.OnSignBtnClick()
    GUIRoot.ShowPanel("MessagePanel", { "未开放" })
end

function HallPanel.OnMapBtnClick()
    GUIRoot.ShowPanel("LoadingPanel", {function (params)
        GUIRoot.ShowPanel("PortalPanel")
    end, nil})
end

function HallPanel.OnShopBtnClick(obj)
    GUIRoot.ShowPanel("ShopPanel")
end

function HallPanel.OnForgeBtnClick()
    GUIRoot.ShowPanel("ForgePanel")
end

function HallPanel.SMSG_MAP_GO()
    local map_data = {}
    map_data.cur_map_id = 1
    map_data.pre_map_id = 0
    State.ChangeState(State.state.ss_map, map_data)
end

----------------------------
function HallPanel.OnUnlockSuccess(message)
    local unlock_id = message.m_object[0]
    if unlock_id == 4001 then
        HallPanel.ShowBasicBtns()
    elseif unlock_id == 4002 then
        HallPanel.ShowBasicBtns()
    elseif unlock_id == 4003 then
        HallPanel.ShowBasicBtns()
    elseif unlock_id == 4006 then
        HallPanel.ShowBasicBtns()
    end
end

function HallPanel.ShowBasicBtns()
    if not this.bottom_image_.gameObject.activeSelf and GameSys.PlayerNameUnlock() then
        this.bottom_image_.gameObject:SetActive(true)
    end
end

function HallPanel.CheckQuest(message)
    local npc_list = GameSys.GetNpcList(0)
    local has_quest = false
    local type = 2
    for i = 1, #npc_list do
        local has_quest2, type2 = QuestManger.NpcHasQuest(npc_list[i].id)
        if has_quest2 == true then
            has_quest = true
            if type2 == 1 then
                type = 1
                break
            end
        end
        if QuestManger.DailyShow(npc_list[i].id) then
            has_quest = true
        end
    end

    if has_quest then
        this.quest_bs_:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.lua_script_.gameObject.name):GetSprite(this.quest_type_[type])
        this.quest_bs_.gameObject:SetActive(true)
    else
        this.quest_bs_.gameObject:SetActive(false)
    end
end

function HallPanel.DuBaiStart()
    this.esports_btn_.gameObject:SetActive(false)
end

function HallPanel.DuBaiEnd()
    this.esports_btn_.gameObject:SetActive(true)
end