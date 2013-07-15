ITEM.Name = 'SG-550'
ITEM.Price = 4200
ITEM.Model = 'models/weapons/w_snip_sg550.mdl'
ITEM.WeaponClass = 'weapon_ttt_sg550'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end