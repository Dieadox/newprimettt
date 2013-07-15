ITEM.Name = 'Dual Elites'
ITEM.Price = 800
ITEM.Model = 'models/weapons/w_pist_elite.mdl'
ITEM.WeaponClass = 'weapon_ttt_dual'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end