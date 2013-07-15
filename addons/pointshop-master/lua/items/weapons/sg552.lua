ITEM.Name = 'SG-552'
ITEM.Price = 3500
ITEM.Model = 'models/weapons/w_rif_sg552.mdl'
ITEM.WeaponClass = 'weapon_ttt_sg552'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end