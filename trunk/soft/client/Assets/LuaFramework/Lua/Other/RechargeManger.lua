RechargeManger = {}
local recharge_sever_ = {}
function RechargeManger.Init()
    RechargeManger.RegisterMessage()
end

function RechargeManger.DoRecharge(recharge_id)
    recharge_sever_ = {1, recharge_id}
    local msg = player_msg_pb.cmsg_recharge()
    msg.recharge_id = recharge_id
    local data = msg:SerializeToString()
    GameTcp.Send(opcodes.CMSG_RECHARGE, data, { opcodes.SMSG_RECHARGE })
end

function RechargeManger.DoRechargeGift(recharge_gift_id)

end

function RechargeManger.RegisterMessage()
    Message.register_net_handle(opcodes.SMSG_RECHARGE, RechargeManger.SMSG_RECHARGE)
end

function RechargeManger.Fini()
    Message.remove_net_handle(opcodes.SMSG_RECHARGE, RechargeManger.SMSG_RECHARGE)
end

function RechargeManger.SMSG_RECHARGE(message)
    if recharge_sever_ [1] == 1 then
        local t_recharge = Config.get_config_value("t_recharge", recharge_sever_[2])
        PlayerData.add_resource(2, t_recharge.crystal)
        if t_recharge.type == 3 then
            for i = 1, #PlayerData.player.recharge_ids do
                if PlayerData.player.recharge_ids[i] == t_recharge.id then
                    PlayerData.player.recharge_ids[i] = t_recharge.pre_id
                end
            end
        end

        local msg = CommonMessage()
        msg.name = "recharge_success"
        messMgr:AddCommonMessage(msg)
    end
end
