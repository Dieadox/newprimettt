ITEM.Name = 'P90'
ITEM.Price = 2350
ITEM.Model = 'models/weapons/w_smg_p90.mdl'
ITEM.WeaponClass = 'weapon_ttt_p90'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end