ITEM.Name = 'USP'
ITEM.Price = 500
ITEM.Model = 'models/weapons/w_pist_usp.mdl'
ITEM.WeaponClass = 'weapon_ttt_usp'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end