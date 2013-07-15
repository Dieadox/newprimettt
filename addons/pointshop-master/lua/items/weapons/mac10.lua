ITEM.Name = 'MAC-10'
ITEM.Price = 1400
ITEM.Model = 'models/weapons/w_smg_mac10.mdl'
ITEM.WeaponClass = 'weapon_zm_mac10'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end