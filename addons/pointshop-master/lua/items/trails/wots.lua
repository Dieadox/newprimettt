ITEM.Name = 'War Of The Servers Trail'
ITEM.Price = 7500
ITEM.Material = 'trails/wots.vmt'

function ITEM:OnEquip(ply, modifications)
	ply.TubeTrail = util.SpriteTrail(ply, 0, modifications.color, false, 15, 1, 4, 0.125, self.Material)
end

function ITEM:OnHolster(ply)
	SafeRemoveEntity(ply.TubeTrail)
end

function ITEM:Modify(modifications)
	PS:ShowColorChooser(self, modifications)
end

function ITEM:OnModify(ply, modifications)
	SafeRemoveEntity(ply.TubeTrail)
	self:OnEquip(ply, modifications)
end
