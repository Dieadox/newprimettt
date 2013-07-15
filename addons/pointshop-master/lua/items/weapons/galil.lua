ITEM.Name = 'IMI Galil'
ITEM.Price = 2000
ITEM.Model = 'models/weapons/w_rif_galil.mdl'
ITEM.WeaponClass = 'weapon_ttt_galil'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end