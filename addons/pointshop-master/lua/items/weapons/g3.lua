ITEM.Name = 'G3/SG-1'
ITEM.Price = 5000
ITEM.Model = 'models/weapons/w_snip_g3sg1.mdl'
ITEM.WeaponClass = 'weapon_ttt_g3'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end