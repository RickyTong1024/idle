PetSyntPanel = {}
PetSyntPanel.Control = {}
local this = PetSyntPanel.Control

function PetSyntPanel.Awake(obj)
    this = {}
    this.gameObject_ = obj
    this.transform_ = obj.transform
    this.lua_script_ = this.transform_:GetComponent("LuaUIBehaviour")
    this.close_btn_ = this.transform_:Find("back_ground/close_btn")
    this.info_root_ = this.transform_:Find("back_ground/panel_among/info_root")
    this.mats_root_ = this.transform_:Find("back_ground/panel_among/mats_root")
    this.synt_btn_ = this.transform_:Find("back_ground/panel_among/synt_btn")

    this.shard_id_ = 0
    this.cur_pet_id_ = 0
    this.cur_t_pet_ = nil
    this.cur_shard_ = 0
    this.need_shard_ = 0
    this.shard_enough_ = false

    PetSyntPanel.RegisterBtnLister()
    PetSyntPanel.RegisterMessage()
end

function PetSyntPanel.OnDestroy(obj)
    PetSyntPanel.RemoveMessage()
    this = {}
end

function PetSyntPanel.RegisterBtnLister()
    GameSys.ButtonRegister(this.lua_script_, this.synt_btn_.gameObject, "click", PetSyntPanel.OnSyntBtnClick)
    GameSys.ButtonRegister(this.lua_script_, this.close_btn_.gameObject, "click", PetSyntPanel.Close)
end

function PetSyntPanel.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_PET_GET, PetSyntPanel.OnSyntSuccess)
end

function PetSyntPanel.RemoveMessage()
    Message.remove_net_handle(opcodes.SMSG_PET_GET, PetSyntPanel.OnSyntSuccess)
end

function PetSyntPanel.OnParam(params)
    this.cur_pet_id_ = params[1]
end

function PetSyntPanel.Start(obj)
    PetSyntPanel.RefreshPanel()
end

function PetSyntPanel.RefreshPanel()
    PetSyntPanel.SetData()
    CommonPanel.SetPetInfoPanel(nil, this.cur_pet_id_, this.lua_script_, this.info_root_)
    Util.ClearChild(this.mats_root_)
    local mat_icon = GameSys.GetMatIcon(this.shard_id_, GameSys.GetItemCount(this.shard_id_), this.cur_t_pet_.shard_num, "pet_shard_icon_btn", this.lua_script_)
    mat_icon.transform:SetParent(this.mats_root_)
    mat_icon.transform.localScale = Vector3.one
end

function PetSyntPanel.SetData()
    this.cur_t_pet_ = Config.get_config_value("t_pet", this.cur_pet_id_)
    this.need_shard_ = this.cur_t_pet_.shard_num
    this.shard_id_ = this.cur_t_pet_.shard_id
    this.cur_shard_ = GameSys.GetItemCount(this.shard_id_)
    this.shard_enough_ = (this.cur_shard_ >= this.need_shard_)
end

function PetSyntPanel.OnSyntBtnClick(obj)
    if not this.shard_enough_ then
        GUIRoot.ShowPanel("MessagePanel", { "碎片不足" })
        return
    end
    local msg = player_msg_pb.cmsg_pet_get()
    msg.pet_id = this.cur_pet_id_
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_PET_GET, data, { opcodes.SMSG_PET_GET })
end

function PetSyntPanel.OnSyntSuccess(message)
    local msg = player_msg_pb.smsg_pet_get()
    msg:ParseFromString(message.luabuff)
    PlayerData.add_assets(msg.assets)
    PlayerData.remove_item(this.shard_id_, this.need_shard_)
    local msg1 = CommonMessage()
    msg1.name = "pet_synt_success"
    messMgr:AddCommonMessage(msg1)
    PetSyntPanel.Close()
end

function PetSyntPanel.Close()
    GUIRoot.ClosePanel("PetSyntPanel")
end