local RolePoints = {
    [2] = {[2] = -100,--Killed Detective as Detective
            [0] = -100,--Killed Innocent as Detective
            [1] = 200--Killed Traitor as Detective
        },
    [0] = {[2] = -100,--Killed Detective as Innocent
            [0] = -100,--Killed Innocent as Innocent
            [1] = 100--Killed Traitor as Innocent
        },
    [1] = {[2] = 350,--Killed Detective as Traitor
            [0] = 300,--Killed Innocent as Traitor
            [1] = -100--Killed Traitor as Traitor
        }
    }
        
function NotifyPlayer(ply, killer)
    local num = RolePoints[killer:GetRole()][ply:GetRole()]
    local bool = string.find(num, "-")
    if bool then
	killer:PrintMessage(HUD_PRINTTALK, "[TTT] Shop: You lost "..num.." coins")
    else
	killer:PrintMessage(HUD_PRINTTALK, "[TTT] Shop: You earned "..num.." coinss")
    end
    killer:PS_GivePoints(num)
end
    
function PointShopDeathHook(ply, killer, dmginfo)
    if !IsValid(killer) or !killer:IsPlayer() or !IsValid(ply) or !ply:IsPlayer() then return end
    if GetRoundState() == ROUND_ACTIVE then
        NotifyPlayer(ply, killer)
    end
end
hook.Add("DoPlayerDeath", "PointShopDeathHook", PointShopDeathHook)