local Class = require('hump.class')
local Vector2D = require('hump.vector')
require('BoundingBox')

SpaceObject = Class{
	function(self, img, type, health, pos, vel, accel, angV, heading)
		self.image = img
		self.type = type
		self.health = health
		self.position = pos
		self.velocity = vel or Vector2D(0, 0)
		self.acceleration = accel or Vector2D(0, 0)
		self.angVelocity = angV or 0
		self.heading = heading or 0
		self.collision_with = {}
		self.bounds = BoundingBox(pos.x, pos.y, img:getWidth(), img:getHeight())
	end
}

function SpaceObject:Draw()
	love.graphics.draw(self.image, self.bounds.x, self.bounds.y, self.heading, 
	 1, 1, self.bounds.width / 2, self.bounds.height / 2) -- Rotate about center
end

function SpaceObject:UpdatePosition(dt)
	self.velocity = self.velocity + self.acceleration * dt
	self.position = self.position + self.velocity * dt

	self.heading = self.heading + self.angVelocity * dt

	if self.heading > 360 then 
		self.heading = self.heading - 360 
	end

	self.bounds.x, self.bounds.y = self.position.x, self.position.y
end