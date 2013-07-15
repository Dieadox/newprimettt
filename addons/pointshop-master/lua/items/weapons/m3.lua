ITEM.Name = 'M3 Super 90'
ITEM.Price = 1700
ITEM.Model = 'models/weapons/w_shot_m3super90.mdl'
ITEM.WeaponClass = 'weapon_zm_shotgun'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end