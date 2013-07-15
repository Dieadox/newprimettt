ITEM.Name = 'Suit Charger (Nothing)'
ITEM.Price = 1000
ITEM.Model = 'models/props_combine/suit_charger001.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

function ITEM:OnEquip(ply, modifications)
	ply:PS_AddClientsideModel(self.ID)
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.65, 0)
	pos = pos + (ang:Right() * 0) + (ang:Up() * -1) + (ang:Forward() * 0)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), -90)
	
	return model, pos, ang
end