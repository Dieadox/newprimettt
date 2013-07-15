ITEM.Name = 'Nyan Cat Trail'
ITEM.Price = 3500
ITEM.Material = 'trails/nyancat.vmt'

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
