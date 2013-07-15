ITEM.Name = 'Rubber Boots (-80% Fall Damage)'
ITEM.Price = 25000
ITEM.Model = 'models/xqm/helicopterrotorhuge.mdl' --Temporary until boot model is added, this is just for fun.
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

local ShouldRecieveFallDamage
function ITEM:OnEquip(ply, modifications)
   ply:PS_AddClientsideModel(self.ID)
   ply.ShouldRecieveFallDamage = true
end

function ITEM:OnHolster(ply)
   ply:PS_RemoveClientsideModel(self.ID)
   ply.ShouldRecieveFallDamage = false
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
   model:SetModelScale(0, 0)
   pos = pos + (ang:Right() * 7) + (ang:Forward() * 6)

   return model, pos, ang
end

local function ReduceFallDamage(ent, dmginfo)
      if ent:IsPlayer() and ent.ShouldRecieveFallDamage and dmginfo:IsFallDamage() then
         dmginfo:ScaleDamage(0.2)
      end
   end
hook.Add("EntityTakeDamage", "ReduceFallDamage", ReduceFallDamage)