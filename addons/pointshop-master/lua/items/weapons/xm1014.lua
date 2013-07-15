ITEM.Name = 'XM1014'
ITEM.Price = 3000
ITEM.Model = 'models/weapons/w_shot_xm1014.mdl'
ITEM.WeaponClass = 'weapon_ttt_m3'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end