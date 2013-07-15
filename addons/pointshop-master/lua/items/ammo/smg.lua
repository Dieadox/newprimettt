ITEM.Name = 'SMG/Rifle Ammo'
ITEM.Price = 650
ITEM.Model = 'models/items/boxmrounds.mdl'
ITEM.WeaponClass = 'item_ammo_smg1_ttt'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:Give(self.WeaponClass)
end