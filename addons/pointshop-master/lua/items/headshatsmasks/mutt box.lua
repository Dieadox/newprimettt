ITEM.Name = 'Mutt box'
ITEM.Price = 2000
ITEM.Model = 'models/props_lab/kennel_physics.mdl'
ITEM.Attachment = 'eyes'
ITEM.AllowedUserGroups = { "admin", "superadmin", "donator" }


function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end


function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end


function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(.5, 0)
		pos = pos + (ang:Right() * 0) + (ang:Forward() * -2) + (ang:Up() * -5)
	
	
	return model, pos, ang
end