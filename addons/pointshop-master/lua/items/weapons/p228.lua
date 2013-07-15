ITEM.Name = 'P228'
ITEM.Price = 600
ITEM.Model = 'models/weapons/w_pist_p228.mdl'
ITEM.WeaponClass = 'weapon_ttt_p228'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end