PlayerPanel = {}
PlayerPanel.Control = {}
local this = PlayerPanel.Control
PlayerPanel.otherDate = {}

function PlayerPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.title_text_ = this.transform_:Find("back_ground/panel_top/title_image/title_text")
    this.equip_panel_ = this.transform_:Find("back_ground/panel_among/equip_panel")
    this.equip_back_ = this.transform_:Find("back_ground/panel_top/equip_back")
    this.spell_panel_ = this.transform_:Find("back_ground/panel_among/spell_panel")
    this.pet_panel_ = this.transform_:Find("back_ground/panel_among/pet_panel")
    this.player_page_ = this.transform_:Find("back_ground/panel_down/pages/player_page"):GetComponent("Toggle")
    this.player_page_text_ = this.transform_:Find("back_ground/panel_down/pages/player_page/sel/Text")
    this.spell_page_ = this.transform_:Find("back_ground/panel_down/pages/spell_page"):GetComponent("Toggle")
    this.spell_page_text_ = this.transform_:Find("back_ground/panel_down/pages/spell_page/sel/Text")
    this.pet_page_ = this.transform_:Find("back_ground/panel_down/pages/pet_page"):GetComponent("Toggle")
    this.pet_page_text_ = this.transform_:Find("back_ground/panel_down/pages/pet_page/sel/Text")
    this.equip_red_point_ = this.transform_:Find("back_ground/panel_down/pages/player_page/equip_red")
    this.spell_red_point_ = this.transform_:Find("back_ground/panel_down/pages/spell_page/spell_red")
    this.spell_lock_btn_ = this.transform_:Find("back_ground/panel_down/pages/spell_lock_btn")
    this.pet_lock_btn_ = this.transform_:Find("back_ground/panel_down/pages/pet_lock_btn")
    this.pages_ = {this.player_page_, this.spell_page_, this.pet_page_}
    this.player_page_.isOn = false
    this.spell_page_.isOn = false
    this.pet_page_.isOn = false
    this.equip_panel_.gameObject:SetActive(false)
    this.equip_back_.gameObject:SetActive(false)
    this.spell_panel_.gameObject:SetActive(false)
    this.pet_panel_.gameObject:SetActive(false)

    this.is_self_ = true
    this.open_index_ = 0
    this.open_spell_index_ = 0
    this.is_show_ = true
    this.is_equip_refresh_ = false
    this.is_spell_refresh_ = false
    this.is_pet_refresh_ = false

    PlayerPanel.otherDate = {}
    PlayerEquipPanel.Awake(this.equip_panel_.gameObject, this.lua_script_)
    PlayerSpellPanel.Awake(this.spell_panel_.gameObject, this.lua_script_)
    PlayerPetPanel.Awake(this.pet_panel_.gameObject, this.lua_script_)

    PlayerPanel.RegisterBtnListers()

    local msg = CommonMessage()
    msg.name = "PlayerPanelStateChange"
    msg.m_object:Add(this.is_show_)
    messMgr:AddCommonMessage(msg)
end

function PlayerPanel.OnDestroy(obj)
    PlayerEquipPanel.OnDestroy(this.equip_panel_.gameObject)
    PlayerSpellPanel.OnDestroy(this.spell_panel_.gameObject)
    PlayerPetPanel.OnDestroy(this.pet_panel_.gameObject)
    PlayerPanel.RemoveRedTip()
    PlayerPanel.RemoveMessage()
    if this.is_self_ then
        UnlockManger.RemoveFunBtn({3001, 3002})
    end
    this.is_show_ = false
    local msg = CommonMessage()
    msg.name = "PlayerPanelStateChange"
    msg.m_object:Add(this.is_show_)
    messMgr:AddCommonMessage(msg)
    this = {}
    PlayerPanel.otherDate = {}
end

function PlayerPanel.OnParam(params)
    this.is_self_ = params[1]
    PlayerData.UnlockBtnRegister()
    PlayerPanel.RegisterRedTip()
    PlayerPanel.RegisterMessage()
    PlayerPanel.otherDate = params[2]
    this.open_index_ = params[3]
    if this.open_index_ == nil then
        this.open_index_ = 1
    end
    this.open_spell_index_ = params[4]
    if this.open_spell_index_ == nil then
        this.open_spell_index_ = 1
    end
    PlayerEquipPanel.OnParam({ this.is_self_ })
    PlayerSpellPanel.OnParam({ this.is_self_, this.open_spell_index_ })
    PlayerPetPanel.OnParam({ this.is_self_ })
end

function PlayerPanel.Start(obj)
    this.pages_[this.open_index_]:GetComponent("Toggle").isOn = true
    PlayerPanel.RefreshEquipRed()
    PlayerPanel.RefreshSpellRed()
    PlayerPanel.RefreshLockBtn()
end

function PlayerPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.player_page_.gameObject, "toggle", PlayerPanel.RefreshEquipPanel, nil)
    GameSys.ButtonRegister(this.lua_script_, this.spell_page_.gameObject, "toggle", PlayerPanel.RefreshSpellPanel, nil)
    GameSys.ButtonRegister(this.lua_script_, this.pet_page_.gameObject, "toggle", PlayerPanel.RefreshPetPanel, nil)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PlayerPanel.Close, nil)
end

function PlayerPanel.RegisterRedTip()
    if this.is_self_ then
        AssetsChangeControl.AddEquipChanged(PlayerPanel.RefreshEquipRed)
        AssetsChangeControl.AddLevelChanged(PlayerPanel.RefreshSpellRed)
        AssetsChangeControl.AddItemChanged(PlayerPanel.RefreshSpellRed)
        AssetsChangeControl.AddPetLevelChanged(PlayerPanel.RefreshSpellRed)
    end
end

function PlayerPanel.RemoveRedTip()
    if this.is_self_ then
        AssetsChangeControl.RemoveEquipChanged(PlayerPanel.RefreshEquipRed)
        AssetsChangeControl.RemoveLevelChanged(PlayerPanel.RefreshSpellRed)
        AssetsChangeControl.RemoveItemChanged(PlayerPanel.RefreshSpellRed)
        AssetsChangeControl.RemovePetLevelChanged(PlayerPanel.RefreshSpellRed)
    end
end

function PlayerPanel.RegisterMessage()
    if this.is_self_ then
        Message.register_handle("wear_equip_success", PlayerPanel.RefreshEquipRed)
        Message.register_handle("unlock_spell_success", PlayerPanel.RefreshSpellRed)
        Message.register_handle("upgrade_spell_success", PlayerPanel.RefreshSpellRed)
        Message.register_handle("unlock_passive_success", PlayerPanel.RefreshSpellRed)
        Message.register_handle("upgrade_passive_success", PlayerPanel.RefreshSpellRed)
    end
end


function PlayerPanel.RemoveMessage()
    if this.is_self_ then
        Message.remove_handle("wear_equip_success", PlayerPanel.RefreshEquipRed)
        Message.remove_handle("unlock_spell_success", PlayerPanel.RefreshSpellRed)
        Message.remove_handle("upgrade_spell_success", PlayerPanel.RefreshSpellRed)
        Message.remove_handle("unlock_passive_success", PlayerPanel.RefreshSpellRed)
        Message.remove_handle("upgrade_passive_success", PlayerPanel.RefreshSpellRed)
    end
end

function PlayerData.UnlockBtnRegister()
    if this.is_self_ then
        UnlockManger.RegisterFunBtn({3001, this.spell_lock_btn_, "click", nil, nil, this.lua_script_, true})
        UnlockManger.RegisterFunBtn({3002, this.pet_lock_btn_, "click", nil, nil, this.lua_script_, true})
    else
        GameSys.ButtonRegister(this.lua_script_, this.spell_page_.gameObject, "toggle", PlayerPanel.RefreshSpellPanel, nil)
        GameSys.ButtonRegister(this.lua_script_, this.pet_page_.gameObject, "toggle", PlayerPanel.RefreshPetPanel, nil)
    end
end

function PlayerPanel.RefreshEquipRed()
    if not this.is_self_ then
        this.equip_red_point_.gameObject:SetActive(false)
        return
    end
    local red_show = GameSys.IsCanWearNullSlot()
    PlayerPanel.SetRedShow(this.equip_red_point_, red_show)
end

function PlayerPanel.RefreshSpellRed()
    if not this.is_self_ then
        this.spell_red_point_.gameObject:SetActive(false)
        return
    end
    if GameSys.SpellIsLock() then
        this.spell_red_point_.gameObject:SetActive(false)
        return
    end
    local red_show = GameSys.IsCanAdvanceSpell() or GameSys.IsCanAdvancePassive()
    PlayerPanel.SetRedShow(this.spell_red_point_, red_show)
end

function PlayerPanel.SetRedShow(red, show)
    if show then
        if not red.gameObject.activeSelf  then
            red.gameObject:SetActive(true)
        end
    else
        if red.gameObject.activeSelf  then
            red.gameObject:SetActive(false)
        end
    end
end

function PlayerPanel.RefreshLockBtn()
    if this.is_self_ then
        this.spell_lock_btn_.gameObject:SetActive(GameSys.SpellIsLock())
        this.pet_lock_btn_.gameObject:SetActive(GameSys.PetIsLock())
    else
        this.spell_lock_btn_.gameObject:SetActive(false)
        this.pet_lock_btn_.gameObject:SetActive(false)
    end

end

function PlayerPanel.RefreshEquipPanel(obj, is_on)
    this.equip_back_.gameObject:SetActive(is_on)
    this.equip_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "装 备"
        if not this.is_equip_refresh_ then
            PlayerEquipPanel.RefreshPanel()
            this.is_equip_refresh_ = true
        end
    end
end

function PlayerPanel.RefreshSpellPanel(obj, is_on)
    this.spell_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "技 能"
        if not this.is_spell_refresh_ then
            PlayerSpellPanel.RefreshPanel()
            this.is_spell_refresh_ = true
        end
    end
end

function PlayerPanel.RefreshPetPanel(obj, is_on)
    this.pet_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "宠 物"
        if not this.is_pet_refresh_ then
            PlayerPetPanel.RefreshPanel()
            this.is_pet_refresh_ = true
        end
    end
end

function PlayerPanel.Close()
    GUIRoot.ClosePanel("PlayerPanel")
end


