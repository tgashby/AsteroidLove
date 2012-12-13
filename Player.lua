local Class = require('hump.class')
local Vector2D = require('hump.vector')
require('SpaceObject')
require('BulletFactory')

local UnitVec = Vector2D(0, 1)

Player = Class{inherits = SpaceObject,
	function(self, health, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, love.graphics.newImage('img/ship.png'), 
		 "Player", health, pos, vel, accel, angV, heading)

		self.ANG_DRAG = 0.1

		self.collision_with["Asteroid"] = function (asteroid)
			self.health = self.health - 10
		end
	end
}

function Player:Update(dt)
	self.velocity = self.velocity + self.acceleration * dt

	-- Player can only move forward, hence the pos - vel
	self.position = self.position - UnitVec:rotated(self.heading) * 
	 self.velocity.y * dt

	self.heading = self.heading + self.angVelocity * dt

	if self.heading > 360 then 
		self.heading = self.heading - 360 
	end

	self.bounds.x, self.bounds.y = self.position.x, self.position.y

	if self.angVelocity > 0 then
		self.angVelocity = self.angVelocity - self.ANG_DRAG
	elseif self.angVelocity < 0 then 
		self.angVelocity = self.angVelocity + self.ANG_DRAG
	end

	if self.heading > 360 then 
		self.heading = self.heading - 360 
	end
end

function Player:Shoot()
	BulletFactory:GenerateBullet(10, Vector2D(self.bounds.x - (UnitVec:rotated(self.heading) * 16).x, 
	 self.bounds.y - (UnitVec:rotated(self.heading) * 16).y), UnitVec:rotated(self.heading) * -150, 10)
end