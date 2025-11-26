-- Admin helper commands to manage traveling merchant spawn locations

if SERVER then
    util.AddNetworkString("dtm_spawn_tool_feedback")

    local function sendFeedback(ply, msg, level)
        if DarkRP and DarkRP.notify then
            DarkRP.notify(ply, level or 0, 4, msg)
        else
            ply:ChatPrint(msg)
        end
    end

    local function isAllowed(ply)
        if not IsValid(ply) then return false end
        return ply:IsSuperAdmin() or ply:IsAdmin()
    end

    concommand.Add("dtm_addspawn", function(ply)
        if IsValid(ply) and not isAllowed(ply) then return end

        local pos = IsValid(ply) and ply:GetPos() or nil
        local ang = IsValid(ply) and ply:EyeAngles() or nil

        if not pos or not ang then return end

        DubzTravelingMerchant.AddSpawn(pos, ang)
        sendFeedback(ply, "Added traveling merchant spawn at your position.", 0)
    end)

    concommand.Add("dtm_clearspawns", function(ply)
        if IsValid(ply) and not isAllowed(ply) then return end

        DubzTravelingMerchant.ClearSpawns()
        sendFeedback(ply, "Cleared all traveling merchant spawns (file removed).", 1)
    end)
end
