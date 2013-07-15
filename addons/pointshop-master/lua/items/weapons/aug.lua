ITEM.Name = 'AUG'
ITEM.Price = 3500
ITEM.Model = 'models/weapons/w_rif_aug.mdl'
ITEM.WeaponClass = 'weapon_ttt_aug'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end