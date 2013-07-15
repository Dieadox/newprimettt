ITEM.Name = 'Semen Launcher'
ITEM.Price = 2500
ITEM.Model = 'models/weapons/w_bugbait.mdl'
ITEM.WeaponClass = 'weapon_ttt_cum'
ITEM.SingleUse = true
ITEM.AllowedUserGroups = { "respected", "bronze", "silver", "gold", "diamond", "demi-god", "admin", "superadmin", "coowner", "developer", "owner" }

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end