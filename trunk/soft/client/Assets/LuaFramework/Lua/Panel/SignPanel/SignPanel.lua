SignPanel = {}
-- 这是个签到的Lua脚本
SignPanel.Control = {}
local this = SignPanel.Control

function SignPanel.Awake(obj)

    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.sign_panel_ = this.transform_:Find("root_panel")
    this.sign_btn_ = this.sign_panel_:Find("down_layer/sign_btn"):GetComponent("Button")
    this.sign_days_label_ = this.sign_panel_:Find("down_layer/sign_days"):GetComponent("LocalizationText")
    this.back_btn_ = this.sign_panel_:Find("back_btn"):GetComponent("Button")
    this.reward_grid_ = this.sign_panel_.transform:Find("display_reward_panel/display_reward_grid/reward_view_content")
    this.sign_item = this.sign_panel_:Find("sign_item")
    this.item_size = Vector3(0.728, 0.728, 0.728)
    SignPanel.RegisterBtnListen()
    SignPanel.RegisterMessage()

    SignPanel.InitPanel()
end

function SignPanel.Start()

end

function SignPanel.OnDestroy()
    SignPanel.RemoveMessage()
    this = {}
end

function SignPanel.InitPanel()
    this.sign_panel_.gameObject:SetActive(true)
    SignPanel.ShowSignPanel()
end

function SignPanel.RegisterBtnListen()
    GameSys.ButtonRegister(this.lua_script_, this.sign_btn_.gameObject, "click", SignPanel.OnSignClick)
    GameSys.ButtonRegister(this.lua_script_, this.back_btn_.gameObject, "click", SignPanel.OnBackClick)
end

function SignPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_CHECK, SignPanel.SMSG_SIGN_PLAYER)
end

function SignPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_CHECK, SignPanel.SMSG_SIGN_PLAYER)
end

function SignPanel.OnBackClick()
    GameSys.ClearChild(this.reward_grid_)
    GUIRoot.ClosePanel("SignPanel")
end

function SignPanel.OnSetClick()
    this.sign_panel_.gameObject:SetActive(false)
    this.back_btn_.gameObject:SetActive(true)
end
---------------------------显示界面---------------------------
-- 打开签到主界面
function SignPanel.ShowSignPanel()
    SignPanel.ShowSignDays()
    SignPanel.CreateGrid(this.reward_grid_)
end

function SignPanel.ShowSignDays()
    this.sign_days_label_.text = string.format("当前已签到 <color=#33ff24>%d</color> 天", PlayerData.player.checked_days)
end

function SignPanel.CreateGrid(content)
    GameSys.ClearChild(content)
    local t_sign = SignPanel.GetSignCofig()
    local checked_days = PlayerData.player.checked_days
    local sign_day = checked_days
    if checked_days >= 30 then
        sign_day = checked_days % 30
    end
    local asset
    for i = 1, #t_sign do
        if checked_days < 30 then
            asset = t_sign[i].reward[1]
        else
            asset = t_sign[i].reward[2]
        end
        local sign_item_t = GameObject.Instantiate(this.sign_item.gameObject)
        sign_item_t.transform:SetParent(content, false)
        sign_item_t.transform.localScale = Vector3.one
        sign_item_t.transform.name = "sign_"..t_sign[i].index
        sign_item_t.transform:Find("day/day_text"):GetComponent("LocalizationText").text = tostring(i)
        local item_t = CommonPanel.GetIcon2type(asset, { i, nil, asset }, this.lua_script_)
        item_t.transform:SetParent(sign_item_t.transform:Find("item_View"), false)
        item_t.transform.localScale = Vector3.one
        item_t.transform.localPosition = Vector3.zero
        sign_item_t.transform:Find("name_text"):GetComponent("LocalizationText").text = GameSys.GetAssetName(asset)
        if i < (sign_day + 1) then
            item_t.transform:Find(i .. "/select").gameObject:SetActive(true)
        end
        item_t:SetActive(true)
        sign_item_t:SetActive(true)
    end
end

function SignPanel.GetSignCofig()
    local t_sign = {}
    for k, v in pairs(Config.t_sign) do
        table.insert(t_sign, v)
    end

    if #t_sign > 1 then
        table.sort(t_sign, SignPanel.Sort_)
    end

    return t_sign
end

function SignPanel.Sort_(a, b)
    return a.index < b.index
end

---------- 点击签到 -----------------

function SignPanel.OnSignClick(obj)
    -- 如果今天签过了 就跳过
    if PlayerData.player.is_checked ~= 0 then
        GUIRoot.ShowPanel("MessagePanel", { "今天签过了" })
        return
    end
    local msg = player_msg_pb.cmsg_check()
    msg.check_day = PlayerData.player.checked_days
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_CHECK, data, { opcodes.SMSG_CHECK })
end

function SignPanel.SMSG_SIGN_PLAYER(message)
    local msg = player_msg_pb.smsg_check()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets)
    -- 每日任务
    PlayerData.daily_schedule(1001, 1)
    AssetsChangeControl.OnDailyChanged()
    SignPanel.ShowSucceedPanel()
    AssetsChangeControl.OnSignChanged()
end

----------- 显示成功界面 -------------------
function SignPanel.ShowSucceedPanel()
    local checked_days = PlayerData.player.checked_days + 1
    local sign_day = checked_days
    if checked_days >= 30 then
        sign_day = checked_days % 30
    end
    PlayerData.player.is_checked = 1
    PlayerData.player.checked_days = checked_days
    SignPanel.ShowSignDays()
    SignPanel.CreateGrid(this.reward_grid_)
end
