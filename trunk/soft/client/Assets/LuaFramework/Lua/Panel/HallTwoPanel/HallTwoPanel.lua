HallTwoPanel = {}
HallTwoPanel.Control = {}
local this = HallTwoPanel.Control

function HallTwoPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script = this.transform_:GetComponent('LuaUIBehaviour')
    this.scroll_rect = this.transform_:Find("npc_list_panel/back_image/panel_among/this.scroll_rect")
    this.content_root_ = this.transform_:Find("npc_list_panel/back_image/panel_among/npc_root/view_root/content_root")
    this.select_item_ = this.transform_:Find("npc_list_panel/back_image/panel_among/select_item")
    this.npc_list_panel_ = this.transform_:Find("npc_list_panel")
    this.close_btn_ = this.transform_:Find("npc_list_panel/back_image/close_btn")
    this.nul_show_ = this.transform_:Find("npc_list_panel/back_image/panel_among/npc_root/nul_show")

    this.quest_type_ = {"zjdt_ui045", "zjdt_ui044"}

    HallTwoPanel.RegisterBtnListers()
end

function HallTwoPanel.OnDestroy()
    HallTwoPanel.RemoveMessage()
end

function HallTwoPanel.Start(obj)
    HallTwoPanel.NpcListInit()
end

function HallTwoPanel.RegisterBtnListers()
    GameSys.ButtonRegister(this.lua_script, this.close_btn_.gameObject, "click", HallTwoPanel.Close)
    Message.register_handle("need_check_quest", HallTwoPanel.QuestRefresh)
end


function HallTwoPanel.RemoveMessage()
    Message.remove_handle("need_check_quest", HallTwoPanel.QuestRefresh)
end

function HallTwoPanel.QuestRefresh()
    HallTwoPanel.NpcListInit()
end

function HallTwoPanel.NpcListInit()
    local npc_list = GameSys.GetNpcList(0)
    Util.ClearChild(this.content_root_)
    if #npc_list > 0 then
        for i = 1, #npc_list do
            local slot_ins = GameObject.Instantiate(this.select_item_.gameObject)
            slot_ins.transform:SetParent(this.content_root_, false)
            slot_ins.transform.localScale = Vector3.one
            slot_ins.transform.localPosition = Vector3.zero
            local has, type = QuestManger.NpcHasQuest(npc_list[i].id)
            local npc_name = npc_list[i].name
            if has then
                local quest_tag = slot_ins.transform:Find("quest_tag")
                quest_tag:GetComponent("Image").sprite = GUIRoot.GetSelfAtlas(this.lua_script.gameObject.name):GetSprite(this.quest_type_[type])
                quest_tag.gameObject:SetActive(true)
            end
            slot_ins.transform:Find("select_text"):GetComponent("LocalizationText").text = npc_name
            slot_ins.transform:Find("back/npc_icon"):GetComponent("Image").sprite = GUIRoot.LoadAtlas(this.lua_script.gameObject.name, "npc"):GetSprite(npc_list[i].icon)
            slot_ins.transform.name = string.format("%s_%s" , npc_list[i].id, tostring(i))
            GameSys.ButtonRegister(this.lua_script, slot_ins.gameObject, "click", HallTwoPanel.ClickNpc, {npc_list[i].id})
            slot_ins.gameObject:SetActive(true)
        end
        this.npc_list_panel_.gameObject:SetActive(true)
    else
        this.npc_list_panel_.gameObject:SetActive(true)
        this.nul_show_.gameObject:SetActive(true)
    end
end

function HallTwoPanel.ClickNpc(obj, params)
    local npc_id = params[1]
    if npc_id ~= nil then
        QuestManger.NpcOnClick(tonumber(npc_id))
    end
end

function HallTwoPanel.Close()
    GUIRoot.ClosePanel("HallTwoPanel")
end
