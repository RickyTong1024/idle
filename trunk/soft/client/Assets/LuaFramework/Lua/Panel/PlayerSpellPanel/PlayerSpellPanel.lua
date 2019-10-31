PlayerSpellPanel = {}
PlayerSpellPanel.Control = {}
local this = PlayerSpellPanel.Control

function PlayerSpellPanel.Awake(obj, lua_behaviour)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = lua_behaviour
    this.spell_pages_ = obj.transform:Find("panel_top/spell_pages")
    this.unlock_spell_page_ = obj.transform:Find("panel_top/spell_pages/unlock_spell_page")
    this.unlock_attach_page_ = obj.transform:Find("panel_top/spell_pages/unlock_attach_page")
    this.spell_page_text_ = obj.transform:Find("panel_top/spell_pages/unlock_spell_page/ison_image/Text")
    this.attach_page_text_ = obj.transform:Find("panel_top/spell_pages/unlock_attach_page/ison_image/Text")
    this.spell_unlock_panel_ = obj.transform:Find("panel_among/spell_unlock_panel")
    this.attach_unlock_panel_ = obj.transform:Find("panel_among/attach_unlock_panel")
    this.unlock_spell_red_ = obj.transform:Find("panel_top/spell_pages/unlock_spell_page/unlock_spell_red")
    this.unlock_passive_red_ = obj.transform:Find("panel_top/spell_pages/unlock_attach_page/unlock_passive_red")
    this.unlock_spell_page_:GetComponent("Toggle").isOn = false
    this.unlock_attach_page_:GetComponent("Toggle").isOn = false
    this.pages_ = { this.unlock_spell_page_, this.unlock_attach_page_}
    this.spell_page_text_.gameObject:SetActive(false)
    this.attach_page_text_.gameObject:SetActive(false)
    this.spell_unlock_panel_.gameObject:SetActive(false)
    this.attach_unlock_panel_.gameObject:SetActive(false)

    this.is_self_ = true
    this.open_index_ = 1

    PlayerUnlockSpellPanel.Awake(this.spell_unlock_panel_.gameObject, this.lua_script_)
    PlayerUnlockPassivePanel.Awake(this.attach_unlock_panel_.gameObject, this.lua_script_)
end

function PlayerSpellPanel.OnDestroy(obj)
    PlayerUnlockSpellPanel.OnDestroy(this.spell_unlock_panel_.gameObject)
    PlayerUnlockPassivePanel.OnDestroy(this.attach_unlock_panel_.gameObject)
    PlayerSpellPanel.RemoveResTip()
    PlayerSpellPanel.RemoveMessages()
    this = {}
end

function PlayerSpellPanel.OnParam(params)
    this.is_self_ = params[1]
    this.open_index_ = params[2]
    if this.open_index_ == nil then
        this.open_index_ = 1
    end
    PlayerSpellPanel.Registerlisters()
    PlayerSpellPanel.RegisterResTip()
    PlayerSpellPanel.RegisterMessages()
    PlayerUnlockSpellPanel.OnParam({ this.is_self_ })
    PlayerUnlockPassivePanel.OnParam({ this.is_self_ })
end

function PlayerSpellPanel.Registerlisters()
    GameSys.ButtonRegister(this.lua_script_, this.unlock_spell_page_.gameObject, "toggle", PlayerSpellPanel.OnSpellPageClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.unlock_attach_page_.gameObject, "toggle", PlayerSpellPanel.OnAttachPageClick, nil)
end

function PlayerSpellPanel.RegisterResTip()
    if this.is_self_ then
        AssetsChangeControl.AddLevelChanged(PlayerSpellPanel.RefreshSpellRedPoint)
        AssetsChangeControl.AddItemChanged(PlayerSpellPanel.RefreshSpellRedPoint)
        AssetsChangeControl.AddPetLevelChanged(PlayerSpellPanel.RefreshPassiveRedPoint)
    end
end

function PlayerSpellPanel.RemoveResTip()
    if this.is_self_ then
        AssetsChangeControl.RemoveLevelChanged(PlayerSpellPanel.RefreshSpellRedPoint)
        AssetsChangeControl.RemoveItemChanged(PlayerSpellPanel.RefreshSpellRedPoint)
        AssetsChangeControl.RemovePetLevelChanged(PlayerSpellPanel.RefreshPassiveRedPoint)
    end
end

function PlayerSpellPanel.RegisterMessages()
    if this.is_self_ then
        Message.register_handle("unlock_spell_success", PlayerSpellPanel.RefreshSpellRedPoint)
        Message.register_handle("upgrade_spell_success", PlayerSpellPanel.RefreshSpellRedPoint)
        Message.register_handle("unlock_passive_success", PlayerSpellPanel.RefreshPassiveRedPoint)
        Message.register_handle("upgrade_passive_success", PlayerSpellPanel.RefreshPassiveRedPoint)
    end
end

function PlayerSpellPanel.RemoveMessages()
    if this.is_self_ then
        Message.remove_handle("unlock_spell_success", PlayerSpellPanel.RefreshSpellRedPoint)
        Message.remove_handle("upgrade_spell_success", PlayerSpellPanel.RefreshSpellRedPoint)
        Message.remove_handle("unlock_passive_success", PlayerSpellPanel.RefreshPassiveRedPoint)
        Message.remove_handle("upgrade_passive_success", PlayerSpellPanel.RefreshPassiveRedPoint)
    end
end

function PlayerSpellPanel.RefreshPanel()
    this.pages_[this.open_index_]:GetComponent("Toggle").isOn = true
    PlayerSpellPanel.RefreshSpellRedPoint()
    PlayerSpellPanel.RefreshPassiveRedPoint()
end

function PlayerSpellPanel.RefreshSpellRedPoint()
    if this.is_self_ then
        this.unlock_spell_red_.gameObject:SetActive(GameSys.IsCanAdvanceSpell())
    else
        this.unlock_spell_red_.gameObject:SetActive(false)
    end
end

function PlayerSpellPanel.RefreshPassiveRedPoint()
    if this.is_self_ then
        this.unlock_passive_red_.gameObject:SetActive(GameSys.IsCanAdvancePassive())
    else
        this.unlock_passive_red_.gameObject:SetActive(false)
    end
end


function PlayerSpellPanel.OnSpellPageClick(obj, is_on)
    this.spell_page_text_.gameObject:SetActive(is_on)
    if is_on then
        PlayerUnlockSpellPanel.Show()
    else
        PlayerUnlockSpellPanel.Close()
    end
end

function PlayerSpellPanel.OnAttachPageClick(obj, is_on)
    this.attach_page_text_.gameObject:SetActive(is_on)
    if is_on then
        PlayerUnlockPassivePanel.Show()
    else
        PlayerUnlockPassivePanel.Close()
    end
end