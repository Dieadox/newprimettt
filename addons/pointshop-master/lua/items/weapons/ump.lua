ITEM.Name = 'UMP'
ITEM.Price = 1700
ITEM.Model = 'models/weapons/w_smg_ump45.mdl'
ITEM.WeaponClass = 'weapon_ttt_ump'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end