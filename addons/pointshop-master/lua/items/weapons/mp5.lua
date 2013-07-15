ITEM.Name = 'MP5 Navy'
ITEM.Price = 1500
ITEM.Model = 'models/weapons/w_smg_mp5.mdl'
ITEM.WeaponClass = 'weapon_ttt_mp5'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end