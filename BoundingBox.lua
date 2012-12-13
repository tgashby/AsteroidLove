local Class = require('hump.class')

BoundingBox = Class {
	function (self, x, y, w, h)
		self.x = x
		self.y = y
		self.width = w
		self.height = h
	end
}

function BoundingBox:IsColliding(otherBox)
	return self.x < otherBox.x + otherBox.weight and 
	 self.x + self.width > otherBox.x and 
	 self.y < otherBox.y + otherBox.height and 
	 self.y + self.height > otherBox.y
end
