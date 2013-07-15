ITEM.Name = 'Pistol Ammo'
ITEM.Price = 650
ITEM.Model = 'models/items/boxsrounds.mdl'
ITEM.WeaponClass = 'item_ammo_pistol_ttt'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:Give(self.WeaponClass)
end