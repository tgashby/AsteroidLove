local Class = require('hump.class')
local Vector2D = require('hump.vector')
local BoundingBox = require('BoundingBox')

local UnitVec = Vector2D(0, 1)

SpaceObject = Class{
	function(self, img, type, health, pos, vel, accel, angV, 
 	 heading)
		self.image = img
		self.type = type
		self.health = health
		self.position = pos
		self.velocity = vel or Vector2D(0, 0)
		self.acceleration = accel or Vector2D(0, 0)
		self.angVelocity = angV or 0
		self.heading = heading or 0
		self.collision_with = {"*" = function(spaceObj2) end}
		self.bounds = BoundingBox(pos.x, pos.y, img:getWidth(), img:getHeight())
	end
}

function SpaceObject:Draw()
	love.graphics.draw(self.image, self.x, self.y, heading)
end

function SpaceObject:UpdatePosition(dt)
	self.velocity = self.velocity + self.acceleration * dt
	self.position = self.position + UnitVec:rotated(self.heading) * 
	 self.velocity * dt

	self.heading = self.heading + self.angVelocity * dt

	if self.heading > 360 then 
		self.heading = self.heading - 360 
	end

	self.bounds.x, self.bounds.y = self.position.x, self.position.y
end