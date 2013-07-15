ITEM.Name = 'Kleiner Glasses'
ITEM.Price = 2000
ITEM.Model = 'models/gmod_tower/klienerglasses.mdl'
ITEM.Attachment = 'eyes'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	pos = pos + (ang:Forward() * -1.6)
	return model, pos, ang
end
