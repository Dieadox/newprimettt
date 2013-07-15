ITEM.Name = 'Glock'
ITEM.Price = 400
ITEM.Model = 'models/weapons/w_pist_glock18.mdl'
ITEM.WeaponClass = 'weapon_ttt_glock'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end