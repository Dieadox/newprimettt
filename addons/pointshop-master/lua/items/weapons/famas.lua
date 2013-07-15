ITEM.Name = 'Famas'
ITEM.Price = 2250
ITEM.Model = 'models/weapons/w_rif_famas.mdl'
ITEM.WeaponClass = 'weapon_ttt_famas'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end