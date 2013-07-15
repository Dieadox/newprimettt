ITEM.Name = 'Desert Eagle'
ITEM.Price = 650
ITEM.Model = 'models/weapons/w_pist_deagle.mdl'
ITEM.WeaponClass = 'weapon_zm_revolver'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end