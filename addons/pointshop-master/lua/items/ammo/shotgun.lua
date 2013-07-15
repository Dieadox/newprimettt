ITEM.Name = 'Shotgun Ammo'
ITEM.Price = 650
ITEM.Model = 'models/items/boxbuckshot.mdl'
ITEM.WeaponClass = 'item_box_buckshot_ttt'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:Give(self.WeaponClass)
end