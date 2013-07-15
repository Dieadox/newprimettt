ITEM.Name = 'Scout'
ITEM.Price = 2750
ITEM.Model = 'models/weapons/w_snip_scout.mdl'
ITEM.WeaponClass = 'weapon_zm_rifle'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end