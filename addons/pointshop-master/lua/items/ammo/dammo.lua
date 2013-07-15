ITEM.Name = 'Deagle Ammo'
ITEM.Price = 650
ITEM.Model = 'models/items/357ammo.mdl'
ITEM.WeaponClass = 'item_ammo_revolver_ttt'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:Give(self.WeaponClass)
end