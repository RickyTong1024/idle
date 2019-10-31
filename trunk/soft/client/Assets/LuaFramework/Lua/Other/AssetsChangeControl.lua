AssetsChangeControl = {}

AssetsChangeControl.gold_call_backs = {}
AssetsChangeControl.jewel_call_backs = {}
AssetsChangeControl.exp_call_backs = {}
AssetsChangeControl.honor_call_backs = {}
AssetsChangeControl.reputation_call_backs = {}
AssetsChangeControl.progress_call_backs = {}
AssetsChangeControl.item_call_backs = {}
AssetsChangeControl.equip_call_backs = {}
AssetsChangeControl.artifact_call_backs = {}
AssetsChangeControl.rune_call_backs = {}
AssetsChangeControl.pet_call_backs = {}
AssetsChangeControl.level_call_backs = {}
AssetsChangeControl.pet_level_call_backs = {}
AssetsChangeControl.kill_num_call_backs = {}
AssetsChangeControl.dress_call_backs = {}
AssetsChangeControl.mail_call_backs = {}
AssetsChangeControl.sign_call_backs = {}
AssetsChangeControl.daily_call_backs = {}
function AssetsChangeControl.AddGoldChanged(call_back)
    table.insert(AssetsChangeControl.gold_call_backs, call_back)
end

function AssetsChangeControl.RemoveGoldChanged(call_back)
    for i = 1, #AssetsChangeControl.gold_call_backs do
        if AssetsChangeControl.gold_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.gold_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddJewelChanged(call_back)
    table.insert(AssetsChangeControl.jewel_call_backs, call_back)
end

function AssetsChangeControl.RemoveJewelChanged(call_back)
    for i = 1, #AssetsChangeControl.jewel_call_backs do
        if AssetsChangeControl.jewel_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.jewel_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddExpChanged(call_back)
    table.insert(AssetsChangeControl.exp_call_backs, call_back)
end

function AssetsChangeControl.RemoveExpChanged(call_back)
    for i = 1, #AssetsChangeControl.exp_call_backs do
        if AssetsChangeControl.exp_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.exp_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddHonorChanged(call_back)
    table.insert(AssetsChangeControl.honor_call_backs, call_back)
end

function AssetsChangeControl.RemoveHonorChanged(call_back)
    for i = 1, #AssetsChangeControl.honor_call_backs do
        if AssetsChangeControl.honor_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.honor_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddReputationChanged(call_back)
    table.insert(AssetsChangeControl.reputation_call_backs, call_back)
end

function AssetsChangeControl.RemoveReputationChanged(call_back)
    for i = 1, #AssetsChangeControl.reputation_call_backs do
        if AssetsChangeControl.reputation_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.reputation_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddProgressChanged(call_back)
    table.insert(AssetsChangeControl.progress_call_backs, call_back)
end

function AssetsChangeControl.RemoveProgressChanged(call_back)
    for i = 1, #AssetsChangeControl.progress_call_backs do
        if AssetsChangeControl.progress_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.progress_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddItemChanged(call_back)
    table.insert(AssetsChangeControl.item_call_backs, call_back)
end

function AssetsChangeControl.RemoveItemChanged(call_back)
    for i = 1, #AssetsChangeControl.item_call_backs do
        if AssetsChangeControl.item_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.item_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddEquipChanged(call_back)
    table.insert(AssetsChangeControl.equip_call_backs, call_back)
end

function AssetsChangeControl.RemoveEquipChanged(call_back)
    for i = 1, #AssetsChangeControl.equip_call_backs do
        if AssetsChangeControl.equip_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.equip_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddArtifactChanged(call_back)
    table.insert(AssetsChangeControl.artifact_call_backs, call_back)
end

function AssetsChangeControl.RemoveArtifactChanged(call_back)
    for i = 1, #AssetsChangeControl.artifact_call_backs do
        if AssetsChangeControl.artifact_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.artifact_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddRuneChanged(call_back)
    table.insert(AssetsChangeControl.rune_call_backs, call_back)
end

function AssetsChangeControl.RemoveRuneChanged(call_back)
    for i = 1, #AssetsChangeControl.rune_call_backs do
        if AssetsChangeControl.rune_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.rune_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddPetChanged(call_back)
    table.insert(AssetsChangeControl.pet_call_backs, call_back)
end

function AssetsChangeControl.RemovePetChanged(call_back)
    for i = 1, #AssetsChangeControl.pet_call_backs do
        if AssetsChangeControl.pet_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.pet_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddLevelChanged(call_back)
    table.insert(AssetsChangeControl.level_call_backs, call_back)
end

function AssetsChangeControl.RemoveLevelChanged(call_back)
    for i = 1, #AssetsChangeControl.level_call_backs do
        if AssetsChangeControl.level_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.level_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddPetLevelChanged(call_back)
    table.insert(AssetsChangeControl.pet_level_call_backs, call_back)
end

function AssetsChangeControl.RemovePetLevelChanged(call_back)
    for i = 1, #AssetsChangeControl.pet_level_call_backs do
        if AssetsChangeControl.pet_level_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.pet_level_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddKillNumChanged(call_back)
    table.insert(AssetsChangeControl.kill_num_call_backs, call_back)
end

function AssetsChangeControl.RemoveKillNumChanged(call_back)
    for i = 1, #AssetsChangeControl.kill_num_call_backs do
        if AssetsChangeControl.kill_num_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.kill_num_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddDressChanged(call_back)
    table.insert(AssetsChangeControl.dress_call_backs, call_back)
end

function AssetsChangeControl.RemoveDressChanged(call_back)
    for i = 1, #AssetsChangeControl.dress_call_backs do
        if AssetsChangeControl.dress_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.dress_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddMailChanged(call_back)
    table.insert(AssetsChangeControl.mail_call_backs, call_back)
end

function AssetsChangeControl.RemoveMailChanged(call_back)
    for i = 1, #AssetsChangeControl.mail_call_backs do
        if AssetsChangeControl.mail_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.mail_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddSignChanged(call_back)
    table.insert(AssetsChangeControl.sign_call_backs, call_back)
end

function AssetsChangeControl.RemoveSignChanged(call_back)
    for i = 1, #AssetsChangeControl.sign_call_backs do
        if AssetsChangeControl.sign_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.sign_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.AddDailyChanged(call_back)
    table.insert(AssetsChangeControl.daily_call_backs, call_back)
end

function AssetsChangeControl.RemoveDailyChanged(call_back)
    for i = 1, #AssetsChangeControl.daily_call_backs do
        if AssetsChangeControl.daily_call_backs[i] == call_back then
            table.remove(AssetsChangeControl.daily_call_backs, i)
            return
        end
    end
end

function AssetsChangeControl.OnItemChanged(item_id, num)
    for i = 1, #AssetsChangeControl.item_call_backs do
        local call_back = AssetsChangeControl.item_call_backs[i]
        call_back(item_id, num)
    end
end

function AssetsChangeControl.OnEquipChanged(equip, type)
    for i = 1, #AssetsChangeControl.equip_call_backs do
        local call_back = AssetsChangeControl.equip_call_backs[i]
        call_back(equip, type)
    end
end

function AssetsChangeControl.OnArtifactChanged(artifact_id, state)
    for i = 1, #AssetsChangeControl.artifact_call_backs do
        local call_back = AssetsChangeControl.artifact_call_backs[i]
        call_back(artifact_id, state)
    end
end

function AssetsChangeControl.OnRuneChanged(rune_id, num)
    for i = 1, #AssetsChangeControl.rune_call_backs do
        local call_back = AssetsChangeControl.rune_call_backs[i]
        call_back(rune_id, num)
    end
end

function AssetsChangeControl.OnPetChanged(pet, type)
    for i = 1, #AssetsChangeControl.pet_call_backs do
        local call_back = AssetsChangeControl.pet_call_backs[i]
        call_back(pet, type)
    end
end

function AssetsChangeControl.OnLevelChanged(player_level)
    for i = 1, #AssetsChangeControl.level_call_backs do
        local call_back = AssetsChangeControl.level_call_backs[i]
        call_back(player_level)
    end
end

function AssetsChangeControl.OnPetLevelChanged(pet)
    for i = 1, #AssetsChangeControl.pet_level_call_backs do
        local call_back = AssetsChangeControl.pet_level_call_backs[i]
        call_back(pet)
    end
end

function AssetsChangeControl.OnKillNumChanged(kill_num)
    for i = 1, #AssetsChangeControl.kill_num_call_backs do
        local call_back = AssetsChangeControl.kill_num_call_backs[i]
        call_back(kill_num)
    end
end

function AssetsChangeControl.OnDressChanged(equip_id)
    for i = 1, #AssetsChangeControl.dress_call_backs do
        local call_back = AssetsChangeControl.dress_call_backs[i]
        call_back(equip_id)
    end
end

function AssetsChangeControl.OnGoldChanged()
    for i = 1, #AssetsChangeControl.gold_call_backs do
        local call_back = AssetsChangeControl.gold_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnJewelChanged()
    for i = 1, #AssetsChangeControl.jewel_call_backs do
        local call_back = AssetsChangeControl.jewel_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnExpChanged()
    for i = 1, #AssetsChangeControl.exp_call_backs do
        local call_back = AssetsChangeControl.exp_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnHonorChanged()
    for i = 1, #AssetsChangeControl.honor_call_backs do
        local call_back = AssetsChangeControl.honor_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnReputationChanged()
    for i = 1, #AssetsChangeControl.reputation_call_backs do
        local call_back = AssetsChangeControl.reputation_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnProgressChanged()
    for i = 1, #AssetsChangeControl.progress_call_backs do
        local call_back = AssetsChangeControl.progress_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnMailChanged()
    for i = 1, #AssetsChangeControl.mail_call_backs do
        local call_back = AssetsChangeControl.mail_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnSignChanged()
    for i = 1, #AssetsChangeControl.sign_call_backs do
        local call_back = AssetsChangeControl.sign_call_backs[i]
        call_back()
    end
end

function AssetsChangeControl.OnDailyChanged()
    for i = 1, #AssetsChangeControl.daily_call_backs do
        local call_back = AssetsChangeControl.daily_call_backs[i]
        call_back()
    end
end




