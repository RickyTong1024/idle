BookPanel = {}
BookPanel.Control = {}
local this = BookPanel.Control

BookPanel.cur_unlock_type_ = 0

function BookPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = obj:GetComponent("LuaUIBehaviour")
    this.title_text_ = this.transform_:Find("back_ground/panel_top/title_image/title_text")
    this.pet_page_ = this.transform_:Find("back_ground/panel_down/pages/pet_page"):GetComponent("Toggle")
    this.monster_page_ = this.transform_:Find("back_ground/panel_down/pages/monster_page"):GetComponent("Toggle")
    this.equip_page_ = this.transform_:Find("back_ground/panel_down/pages/equip_page"):GetComponent("Toggle")
    this.artifact_page_ = this.transform_:Find("back_ground/panel_down/pages/artifact_page"):GetComponent("Toggle")
    this.pet_panel_ = this.transform_:Find("back_ground/pet_panel")
    this.monster_panel_ = this.transform_:Find("back_ground/monster_panel")
    this.equip_panel_ = this.transform_:Find("back_ground/equip_panel")
    this.artifact_panel_ = this.transform_:Find("back_ground/artifact_panel")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.pet_lock_btn_ = this.transform_:Find("back_ground/panel_down/pages/pet_lock_btn")
    this.artifact_lock_btn_ = this.transform_:Find("back_ground/panel_down/pages/artifact_lock_btn")
    this.artifact_red_point_ = this.transform_:Find("back_ground/panel_down/pages/artifact_page/artifact_red_point")
    this.equip_red_point_ = this.transform_:Find("back_ground/panel_down/pages/equip_page/equip_red_point")
    this.pet_red_point_ = this.transform_:Find("back_ground/panel_down/pages/pet_page/pet_red_point")
    this.monster_red_point_ = this.transform_:Find("back_ground/panel_down/pages/monster_page/monster_red_point")
    this.pet_page_.isOn = false
    this.monster_page_.isOn = false
    this.equip_page_.isOn = false
    this.artifact_page_.isOn = false
    this.pet_panel_.gameObject:SetActive(false)
    this.monster_panel_.gameObject:SetActive(false)
    this.equip_panel_.gameObject:SetActive(false)
    this.artifact_panel_.gameObject:SetActive(false)
    this.is_pet_refresh_ = false
    this.is_monster_refresh_ = false
    this.is_equip_refresh_ = false
    this.is_artifact_refresh_ = false

    PetPanel.Awake(this.pet_panel_.gameObject, this.lua_script_)
    MonsterPanel.Awake(this.monster_panel_.gameObject, this.lua_script_)
    EquipPanel.Awake(this.equip_panel_.gameObject, this.lua_script_)
    ArtifactPanel.Awake(this.artifact_panel_.gameObject, this.lua_script_)
    BookPanel.UnlockBtnRegister()
    BookPanel.RegisterBtnListers()
    BookPanel.RegisterRedLister()
    BookPanel.RegisterMessage()
end

function BookPanel.OnDestroy()
    BookPanel.RemoveMessage()
    BookPanel.RemoveRedLister()
    UnlockManger.RemoveFunBtn({3003, 3004})
    PetPanel.OnDestroy(this.pet_panel_)
    MonsterPanel.OnDestroy(this.monster_panel_)
    EquipPanel.OnDestroy(this.equip_panel_)
    ArtifactPanel.OnDestroy(this.artifact_panel_)
    this = {}
end

function BookPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script_, this.pet_page_.gameObject, "toggle", BookPanel.OnPetClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.monster_page_.gameObject, "toggle", BookPanel.OnMonsterClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.equip_page_.gameObject, "toggle", BookPanel.OnEquipClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.artifact_page_.gameObject, "toggle", BookPanel.OnArtifactClick, nil)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", BookPanel.OnCloseBtnClick, nil)
end

function BookPanel.UnlockBtnRegister()
    UnlockManger.RegisterFunBtn({3004, this.pet_lock_btn_.gameObject, "click", nil, nil, this.lua_script_, true})
    UnlockManger.RegisterFunBtn({3003, this.artifact_lock_btn_.gameObject, "click", nil, nil, this.lua_script_, true})
end

function BookPanel.RegisterMessage()
    Message.register_handle("get_artifact_reputation_success", BookPanel.RefreshArtifactRed)
    Message.register_handle("get_pet_reputation_success", BookPanel.RefreshPetRed)
    Message.register_handle("get_monster_reputation_success", BookPanel.RefreshMonsterRed)
    Message.register_handle("get_dress_reputation_success", BookPanel.RefreshEquipRed)
end

function BookPanel.RemoveMessage()
    Message.remove_handle("get_artifact_reputation_success", BookPanel.RefreshArtifactRed)
    Message.remove_handle("get_pet_reputation_success", BookPanel.RefreshPetRed)
    Message.remove_handle("get_monster_reputation_success", BookPanel.RefreshMonsterRed)
    Message.remove_handle("get_dress_reputation_success", BookPanel.RefreshEquipRed)
end

function BookPanel.RegisterRedLister()
    AssetsChangeControl.AddKillNumChanged(BookPanel.RefreshMonsterRed)
    AssetsChangeControl.AddDressChanged(BookPanel.RefreshEquipRed)
    AssetsChangeControl.AddGoldChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.AddItemChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.AddArtifactChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.AddItemChanged(BookPanel.RefreshPetRed)
    AssetsChangeControl.AddPetChanged(BookPanel.RefreshPetRed)
end

function BookPanel.RemoveRedLister()
    AssetsChangeControl.RemoveKillNumChanged(BookPanel.RefreshMonsterRed)
    AssetsChangeControl.RemoveDressChanged(BookPanel.RefreshEquipRed)
    AssetsChangeControl.RemoveGoldChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.RemoveItemChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.RemoveArtifactChanged(BookPanel.RefreshArtifactRed)
    AssetsChangeControl.RemoveItemChanged(BookPanel.RefreshPetRed)
    AssetsChangeControl.RemovePetChanged(BookPanel.RefreshPetRed)
end

function BookPanel.Start(obj)
    BookPanel.RefreshPanel()
    this.monster_page_.isOn = true
end

function BookPanel.RefreshPanel()
    BookPanel.RefreshArtifactRed()
    BookPanel.RefreshEquipRed()
    BookPanel.RefreshMonsterRed()
    BookPanel.RefreshPetRed()
end

function BookPanel.RefreshMonsterRed()
    local red_show = GameSys.CanGetMonsterReputation()
    BookPanel.SetRedShow(this.monster_red_point_, red_show)
end

function BookPanel.RefreshEquipRed()
    local red_show = GameSys.CanGetDressReputation()
    BookPanel.SetRedShow(this.equip_red_point_, red_show)
end

function BookPanel.RefreshArtifactRed()
    local red_show = GameSys.CanGetArtifactReputation() or GameSys.CanForgeArtifact()
    BookPanel.SetRedShow(this.artifact_red_point_, red_show)
end

function BookPanel.RefreshPetRed()
    local red_show = GameSys.CanGetPetReputation() or GameSys.CanSyntPet()
    BookPanel.SetRedShow(this.pet_red_point_, red_show)
end

function BookPanel.SetRedShow(red, show)
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

function BookPanel.OnPetClick(obj, is_on, params)
    this.pet_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "宠 物"
        if not this.is_pet_refresh_ then
            PetPanel.RefreshPanel()
            this.is_pet_refresh_ = true
        end
    end
end

function BookPanel.OnMonsterClick(obj, is_on, params)
    this.monster_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "怪 物"
        if not this.is_monster_refresh_ then
            MonsterPanel.RefreshPanel()
            this.is_monster_refresh_ = true
        end
    end
end

function BookPanel.OnEquipClick(obj, is_on, params)
    this.equip_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "装 备"
        if not this.is_equip_refresh_ then
            EquipPanel.RefreshPanel()
            this.is_equip_refresh_ = true
        end
    end
end

function BookPanel.OnArtifactClick(obj, is_on, params)
    this.artifact_panel_.gameObject:SetActive(is_on)
    if is_on then
        this.title_text_:GetComponent("Text").text = "神 器"
        if not this.is_artifact_refresh_ then
            ArtifactPanel.RefreshPanel()
            this.is_artifact_refresh_ = true
        end
    end
end

function BookPanel.OnCloseBtnClick(obj, params)
    BookPanel.Close()
end

function BookPanel.Close()
    GUIRoot.ClosePanel("BookPanel")
end