ITEM.Name = 'TMP'
ITEM.Price = 1250
ITEM.Model = 'models/weapons/w_smg_tmp.mdl'
ITEM.WeaponClass = 'weapon_ttt_tmp'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end