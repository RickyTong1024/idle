SetingPanel = {}
-- 这是个设置的Lua脚本
SetingPanel.Control = {}
local this = SetingPanel.Control
function SetingPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.seting_panel_ = this.transform_:Find("root_panel")
    this.down_layer_ = this.seting_panel_.transform:Find("down_layer")
    this.close_btn_ = this.seting_panel_.transform:Find("close_btn")
    this.back_btn = this.seting_panel_.transform:Find("back_btn")
    this.back_btn.gameObject:SetActive(false)
    this.control_layer_ = this.seting_panel_.transform:Find("control_layer")
    local seting_layer = this.control_layer_.transform:Find("seting_layer")
    local gitf_layer = this.control_layer_.transform:Find("gitf_layer")
    this.select_layer = this.control_layer_.transform:Find("select_layer")
    this.reset_music = seting_layer.transform:Find("reset_music")
    this.set_music = seting_layer.transform:Find("set_music")
    this.music_but = seting_layer.transform:Find("background_music/music_toggle")
    this.rank = obj.transform:Find("root_panel/control_layer/select_layer/rank")
    this.effect_but = seting_layer.transform:Find("sound_effect/sound_toggle")
    this.control_list = {}

    table.insert(this.control_list, seting_layer)
    table.insert(this.control_list, gitf_layer)
    this.gitf_layer_receive = gitf_layer.transform:Find("dynamic_effect/receive")
    this.seting_music_edit_ = this.control_layer_.transform:Find("seting_layer/background_music/music_edit"):GetComponent("Slider")
    this.seting_sound_edit_ = this.control_layer_.transform:Find("seting_layer/sound_effect/sound_edit"):GetComponent("Slider")
    this.seting_music_edit_text_ = this.control_layer_.transform:Find("seting_layer/background_music/num"):GetComponent("Text")
    this.seting_sound_edit_text_ = this.control_layer_.transform:Find("seting_layer/sound_effect/num"):GetComponent("Text")

    SetingPanel.RegisterMessage()
    SetingPanel.RegisterBtnListen()
end

function SetingPanel.Start(obj)
    SetingPanel.InitPanel()
end

function SetingPanel.OnDestroy()
    SetingPanel.RemoveMessage()
    this = {}
end

function SetingPanel.InitPanel()
    SetingPanel.ShowSetingPanel()
end

function SetingPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_LIBAO_EXCHANGE, SetingPanel.ReceiSuccess)
end

function SetingPanel.RemoveMessage()
    UnlockManger.RemoveFunBtn({2001})
    Message.remove_net_handle(opcodes.SMSG_LIBAO_EXCHANGE, SetingPanel.ReceiSuccess)
end

function SetingPanel.RegisterBtnListen()
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", SetingPanel.OnCloseClick)
    GameSys.ButtonRegister(this.lua_script_, this.back_btn.gameObject, "click", SetingPanel.OnBackClick)
    GameSys.ButtonRegister(this.lua_script_, this.reset_music.gameObject, "click", SetingPanel.ResetMusic)
    GameSys.ButtonRegister(this.lua_script_, this.set_music.gameObject, "click", SetingPanel.SetMusic)
    UnlockManger.RegisterFunBtn({2001, this.rank, "click", SetingPanel.ShowRankPanel, nil, this.lua_script_, true})
    GameSys.ButtonRegister(this.lua_script_, this.effect_but.gameObject, "toggle", SetingPanel.ChangeEffect)
    GameSys.ButtonRegister(this.lua_script_, this.music_but.gameObject, "toggle", SetingPanel.ChangeMusic)
    this.lua_script_:AddSliderEvent(this.seting_music_edit_.gameObject, SetingPanel.BackgroundMusic)
    this.lua_script_:AddSliderEvent(this.seting_sound_edit_.gameObject, SetingPanel.SoundEffect)
    GameSys.ButtonRegister(this.lua_script_, this.select_layer:Find("sound").gameObject, "click", SetingPanel.OpenMusicSetLayer)
    GameSys.ButtonRegister(this.lua_script_, this.select_layer:Find("exchange").gameObject, "click", SetingPanel.OpenGiftLayer)
    GameSys.ButtonRegister(this.lua_script_, this.gitf_layer_receive.gameObject, "click", SetingPanel.GitfReceive)

end

function SetingPanel.OnCloseClick()
    GUIRoot.ClosePanel("SetingPanel")
end

function SetingPanel.OnSetClick()
end
---------------------------显示界面---------------------------

function SetingPanel.OpenPlayerLayer(obj)
    if msg == false then
        return
    end
    this.control_list[3].gameObject:SetActive(true)

end

function SetingPanel.OpenMusicSetLayer(obj)
    SetingPanel.SelectSetWay()
    SetingPanel.ShowSetingPanel()
    this.close_btn_.gameObject:SetActive(false)
    this.back_btn.gameObject:SetActive(true)
    this.control_list[1].gameObject:SetActive(true)
end

function SetingPanel.OpenGiftLayer(obj)
    SetingPanel.SelectSetWay()
    this.close_btn_.gameObject:SetActive(false)
    this.back_btn.gameObject:SetActive(true)
    local gift_layer = this.control_list[2]
    gift_layer.gameObject:SetActive(true)
    gift_layer:Find("dynamic_effect/InputField"):GetComponent("InputField").text = ""
end

function SetingPanel.ShowSetingPanel()
    if PlayerPrefs.HasKey('SoundVolume') then
        local value = PlayerPrefs.GetFloat('SoundVolume')
        this.seting_music_edit_text_.text = string.format("%u", value * 100)
        this.seting_music_edit_.value = value
    else
        this.seting_music_edit_text_.text = "100%"
    end

    if PlayerPrefs.HasKey('SoundEffectVolume') then
        local value = PlayerPrefs.GetFloat('SoundEffectVolume')
        this.seting_sound_edit_text_.text = string.format("%u", value * 100)
        this.seting_sound_edit_.value = value
    else
        this.seting_sound_edit_text_.text = "100%"
    end

end

function SetingPanel.ResetMusic()
    this.seting_music_edit_.value = 1
    this.seting_sound_edit_.value = 1
    soundMgr.SoundVolume = 1
    soundMgr.SoundEffectVolume = 1
    this.effect_but:GetComponent("Toggle").isOn = true
    this.music_but:GetComponent("Toggle").isOn = true
end

function SetingPanel.SetMusic()
    SetingPanel.OnBackClick()
end

function SetingPanel.ShowRankPanel()
    GUIRoot.ClosePanel("SetingPanel")
    GUIRoot.ShowPanel("RankPanel")
end

function SetingPanel.ChangeEffect(obj, msg)
    if msg then
        this.seting_sound_edit_.value = 1
        soundMgr.SoundEffectVolume = 1
    else
        this.seting_sound_edit_.value = 0
        soundMgr.SoundEffectVolume = 0
    end
end

function SetingPanel.ChangeMusic(obj, msg)
    if msg then
        this.seting_music_edit_.value = 1
        soundMgr.SoundVolume = 1
    else
        this.seting_music_edit_.value = 0
        soundMgr.SoundVolume = 0
    end
end

function SetingPanel.OnBackClick()
    SetingPanel.SelectSetWay()
    this.close_btn_.gameObject:SetActive(true)
    this.back_btn.gameObject:SetActive(false)
    this.select_layer.gameObject:SetActive(true)
end

function SetingPanel.SelectSetWay()
    this.select_layer.gameObject:SetActive(false)
    for k, v in pairs(this.control_list) do
        v.gameObject:SetActive(false)
    end
end

function SetingPanel.BackgroundMusic(go, value)
    this.seting_music_edit_text_.text = string.format("%u", value * 100) .. "%"
    soundMgr.SoundVolume = value
end

function SetingPanel.SoundEffect(go, value)
    this.seting_sound_edit_text_.text = string.format("%u", value * 100) .. "%"
	soundMgr.SoundEffectVolume = value
end

function SetingPanel.GitfReceive()
    local gift_layer = this.control_list[2]
    local gift_code = gift_layer:Find("dynamic_effect/InputField/Text"):GetComponent("Text").text
    if gift_code == nil or gift_code == "" then
        local str = "不能为空"
        GUIRoot.ShowPanel("MessagePanel", { str })
        return
    end
    local msg = player_msg_pb.cmsg_libao_exchange()
    msg.username = PlayerPrefs.GetString('username')
    msg.code = gift_code
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_LIBAO_EXCHANGE, data, { opcodes.SMSG_LIBAO_EXCHANGE }, "领取礼包吗", 60)
end

function SetingPanel.ReceiSuccess(message)
    local msg = player_msg_pb.smsg_libao_exchange()
    msg:ParseFromString(message.luabuff)
    if msg.assets ~= nil then
        PlayerData.add_assets(msg.assets)
        GUIRoot.ShowPanel("MessagePanel", { "成功" })
    else
        GUIRoot.ShowPanel("MessagePanel", { "领取失败" })
    end
end
