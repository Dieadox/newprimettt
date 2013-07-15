ITEM.Name = 'AK-47'
ITEM.Price = 2500
ITEM.Model = 'models/weapons/w_rif_ak47.mdl'
ITEM.WeaponClass = 'weapon_ttt_ak47'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end