MailPanel = {}
MailPanel.Control = {}
local this = MailPanel.Control
-- 这是个邮件领取界面的Lua脚本
function MailPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")

    this.ins_ = this.gameObject_
    this.back_btn_ = this.transform_:Find("back_ground/back_btn"):GetComponent("Button")
    this.mail_group_content_ = this.transform_:Find("back_ground/mail_center_panel/mail_group_background/mail_group_content")
    this.down_layer_ = this.transform_:Find("back_ground/down_layer")
    this.receive_all_btn_ = this.transform_:Find("back_ground/down_layer/button_panel/receive_all_btn"):GetComponent("Button")
    this.nul_show_ = this.transform_:Find("back_ground/mail_center_panel/mail_group_background/nul_show")
    this.icon_res_ = this.transform_:Find("back_ground/icon_res")
    this.mail_two_panel_ = this.transform_:Find("mail_two_panel")
    this.remove_all_btn_ = this.transform_:Find("back_ground/down_layer/button_panel/remove_all_btn")
    this.title_text_ = this.transform_:Find("mail_two_panel/back/panel_top/title_image/title_text")
    this.icon_root_ = this.transform_:Find("mail_two_panel/back/control_layer/icon_root")
    this.mat_view_ = this.transform_:Find("mail_two_panel/back/control_layer/icon_root/mat_view")
    this.text_back_ = this.transform_:Find("mail_two_panel/back/control_layer/text_back")
    this.close_btn_ = this.transform_:Find("mail_two_panel/back/close_btn")
    this.mail_guid_ = {}
    this.superlist_ = nil
    this.mails_ = {}
    MailPanel.RegisterBtnListen()
    MailPanel.RegisterMessage()
    MailPanel.InitSuperList()
    this.ins_.gameObject:SetActive(false)
    MailPanel.GetMailList()
end

function MailPanel.GetMailList()
    GameTcp.Send(opcodes.CMSG_MAIL_LIST, nil, { opcodes.SMSG_MAIL_LIST })
end

function MailPanel.OnDestroy()
    MailPanel.RemoveMessage()
    this = {}
end

function MailPanel.RegisterBtnListen()

    GameSys.ButtonRegister(this.lua_script_, this.remove_all_btn_.gameObject, "click", MailPanel.OnRemoveAllClick)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", MailPanel.CloseTwoPanel)
    GameSys.ButtonRegister(this.lua_script_, this.back_btn_.gameObject, "click", MailPanel.OnBackClick)
    GameSys.ButtonRegister(this.lua_script_, this.receive_all_btn_.gameObject, "click", MailPanel.OnReceiveAllClick)
end

function MailPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_MAIL_GET, MailPanel.SMSG_MAIL_GET)
    Message.register_net_handle(opcodes.SMSG_MAIL_REMOVE, MailPanel.SMSG_MAIL_REMOVE)
    Message.register_net_handle(opcodes.SMSG_MAIL_LIST, MailPanel.SMSG_MAIL_LIST)
end

function MailPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_MAIL_GET, MailPanel.SMSG_MAIL_GET)
    Message.remove_net_handle(opcodes.SMSG_MAIL_REMOVE, MailPanel.SMSG_MAIL_REMOVE)
    Message.remove_net_handle(opcodes.SMSG_MAIL_LIST, MailPanel.SMSG_MAIL_LIST)
end

function MailPanel.OnBackClick()
    GUIRoot.ClosePanel("MailPanel")
end

function MailPanel.InitSuperList()
    this.superlist_ = this.mail_group_content_:GetComponent("UIScrollGrid")
    this.superlist_.prefab = this.icon_res_.gameObject
    this.superlist_.SetDataHandle = function(go, index)
        local value = this.mails_[index + 1]
        local asset = {}
        asset.type = value.type[1]
        asset.value1 = value.value1[1]
        asset.value2 = value.value2[1]
        asset.value3 = value.value3[1]
        local com_icon = CommonPanel.GetIcon2type(asset, { "mail" .. value.value1[1]..index }, this.lua_script_)
        local root_big_icon = go.transform:Find("back_image/big_icon_root")
        GameSys.ClearChild(root_big_icon)
        com_icon.transform:SetParent(root_big_icon, false)
        com_icon.transform.localScale = Vector3.one
        com_icon.transform.localPosition = Vector3.zero
        go.transform:Find("back_image/mail_title_text"):GetComponent("LocalizationText").text = value.title -- 邮件标题
        local valid_time = tonumber(value.creat_time) + 604800000 - tonumber(timerMgr:now_string())
        go.transform:Find("back_image/mail_time_text"):GetComponent("LocalizationText").text = count_time_day(valid_time, 2) -- 邮件剩余有效时间
        local click_obj = go.transform:Find("back_image/click_obj").transform:GetChild(0).gameObject
        if click_obj ~= nil then
            this.lua_script_:RemoveClick(click_obj)
        end
        click_obj.name = tostring(value.guid)
        GameSys.ButtonRegister(this.lua_script_, click_obj.gameObject, "click", MailPanel.ClickReceiveItem, {this.mails_[index + 1]})
        if value.used == 0 then
            click_obj.transform:Find("target_btn_text"):GetComponent("LocalizationText").text = "领取"
        else
            click_obj.transform:Find("target_btn_text"):GetComponent("LocalizationText").text = "删除"
        end
        local small_icon_parent = go.transform:Find("back_image/small_rewards_obj")

        local look_obj = go.transform:Find("back_image/click_obj").transform:GetChild(1).gameObject
        if look_obj ~= nil then
            this.lua_script_:RemoveClick(look_obj)
        end
        look_obj.name = "look_"..tostring(value.guid)
        GameSys.ButtonRegister(this.lua_script_, look_obj.gameObject, "click", MailPanel.LookClick, {this.mails_[index + 1]})
        GameSys.ClearChild(small_icon_parent)
        if #value.type > 1 then
            for k = 2, #value.type do
                local asset2 = {}
                asset2.type = value.type[k]
                asset2.value1 = value.value1[k]
                asset2.value2 = value.value2[k]
                asset2.value3 = value.value3[k]
                local com_icon2 = CommonPanel.GetIcon2type(asset2, { "mail" .. value.value1[k]..k..index }, this.lua_script_)
                com_icon2.transform:SetParent(small_icon_parent, false)
                com_icon2.transform.localScale = Vector3(0.5, 0.5, 0)
                com_icon2.transform.localPosition = Vector3.zero
                com_icon2.gameObject:SetActive(true)
            end
        end
        go.gameObject:SetActive(true)
    end
    this.superlist_:Init()
end

function MailPanel.CloseTwoPanel()
    this.mail_two_panel_.gameObject:SetActive(false)
end

function MailPanel.RefreshMail()
    if (#this.mails_ < 1) then
        this.nul_show_.gameObject:SetActive(true)
    else
        this.nul_show_.gameObject:SetActive(false)
    end

    this.superlist_:SetData(#this.mails_)
end

function MailPanel.Sort_(a, b)
    local r
    local at = a.creat_time
    local bt = a.creat_time
    local au = tonumber(a.used)
    local bu = tonumber(b.used)
    if au == bu then
        r = at > bt
    else
        r = au < bu
    end
    return r
end

---------- 领取全部 --------------
function MailPanel.OnReceiveAllClick()
    local leng = 0
    for _, _ in pairs(this.mails_) do
        leng = leng + 1
        break
    end
    if leng == 0 then
        return
    end
    this.mail_guid_ = {}
    local msg = player_msg_pb.cmsg_mail_get()
    for k, v in pairs(this.mails_) do
        if v.used == 0 then
            msg.mail_guids:append(v.guid)
            this.mail_guid_[k] = v.guid
        end
    end
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_MAIL_GET, data, { opcodes.SMSG_MAIL_GET })
end

function MailPanel.ClickReceiveItem(obj, param)
    local mail = param[1]
    if mail.used == 0 then
        this.mail_guid_ = {}
        this.mail_guid_[1] = mail.guid
        local msg = player_msg_pb.cmsg_mail_get()
        msg.mail_guids:append(mail.guid)
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_MAIL_GET, data, { opcodes.SMSG_MAIL_GET })
    else
        this.mail_guid_[1] = mail.guid
        local msg = player_msg_pb.cmsg_mail_remove()
        msg.mail_guids:append(mail.guid)
        local data = msg:SerializeToString()
        GameTcp.Send(opcodes.CMSG_MAIL_REMOVE, data, { opcodes.SMSG_MAIL_REMOVE })
    end
end

function MailPanel.LookClick(obj, param)
    local mail = param[1]
    this.title_text_:GetComponent("LocalizationText").text = mail.title
    GameSys.ClearChild(this.mat_view_)
    if #mail.type > 0 then
        for k = 1, #mail.type do
            local asset2 = {}
            asset2.type = mail.type[k]
            asset2.value1 = mail.value1[k]
            asset2.value2 = mail.value2[k]
            asset2.value3 = mail.value3[k]
            local com_icon2 = CommonPanel.GetIcon2type(asset2, { "mail_look" .. mail.value1[k]..k }, this.lua_script_)
            com_icon2.transform:SetParent(this.mat_view_, false)
            com_icon2.gameObject:SetActive(true)
        end
        this.icon_root_.gameObject:SetActive(true)
    else
        this.icon_root_.gameObject:SetActive(false)
    end
    this.text_back_.transform:Find("view/mail_text"):GetComponent("LocalizationText").text = mail.sender_name..":\n"..mail.text
    this.mail_two_panel_.gameObject:SetActive(true)
end

function MailPanel.OnRemoveAllClick()
    local leng = 0
    for _, _ in pairs(this.mails_) do
        leng = leng + 1
        break
    end
    if leng == 0 then
        return
    end
    this.mail_guid_ = {}
    local msg = player_msg_pb.cmsg_mail_remove()
    for k, v in pairs(this.mails_) do
        if v.used == 1 then
            msg.mail_guids:append(v.guid)
            this.mail_guid_[k] = v.guid
        end
    end

    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_MAIL_REMOVE, data, { opcodes.SMSG_MAIL_REMOVE })
end

function  MailPanel.SMSG_MAIL_LIST(message)
    local msg = player_msg_pb.smsg_mail_list()
    msg:ParseFromString(message.luabuff)
    this.mails_ = MailPanel.GetMialCofig(msg)
    if #this.mails_ < 1 then
        PlayerData.player.has_mail = 0
        AssetsChangeControl.OnMailChanged()
    end
    MailPanel.RefreshMail()
    this.ins_.gameObject:SetActive(true)
end

function MailPanel.GetMialCofig(msg)
    local t_mail = {}
    for k, v in ipairs(msg.mails) do
        if (os.time() - (v.creat_time / 1000)) < 604800 then
            table.insert(t_mail, v)
        end
    end

    if #t_mail > 1 then
        table.sort(t_mail, MailPanel.Sort_)
    end
    return t_mail
end

function MailPanel.SMSG_MAIL_GET(message)
    local msg = player_msg_pb.smsg_mail_get()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets)
    MailPanel.GetMailList()
    AssetsChangeControl.OnMailChanged()
end

function MailPanel.SMSG_MAIL_REMOVE(message)
    MailPanel.GetMailList()
    for i = 1, #this.mail_guid_ do
        this.mails_[this.mail_guid_[i]] = nil
    end
    if #this.mails_ == 0 then
        PlayerData.player.has_mail = 0
    end
    AssetsChangeControl.OnMailChanged()
end