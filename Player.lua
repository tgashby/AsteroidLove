local Class = require('hump.class')
local Vector2D = require('hump.vector')
local SpaceObject = require('SpaceObject')

Player = Class{inherts = SpaceObject,
	function(self, health, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, love.graphics.newImage('img/player.png'), 
		 "Player", health, pos, vel, accel, angV, heading)

		self.VEL_DRAG = 0.2
		self.ANG_DRAG = 0.1
	end
}

function Player:collision_with["Asteroid"] (asteroid)
	self.health = self.health - 10;
end

function Player:Update(dt)
	self.UpdatePosition(dt)

	if self.velocity.x > 0 then
		self.velocity.x = self.velocity.x - self.VEL_DRAG
	elseif self.velocity.x < 0 then 
		self.velocity.x = self.velocity.x + self.VEL_DRAG
	end

	if self.velocity.y > 0 then
		self.velocity.y = self.velocity.y - self.VEL_DRAG
	elseif self.velocity.y < 0 then 
		self.velocity.y = self.velocity.y + self.VEL_DRAG
	end

	if self.angVelocity > 0 then
		self.angVelocity = self.angVelocity - self.ANG_DRAG
	elseif self.angVelocity < 0 then 
		self.angVelocity = self.angVelocity + self.ANG_DRAG
	end

	if self.heading > 360 then 
		self.heading = self.heading - 360 
	end
end