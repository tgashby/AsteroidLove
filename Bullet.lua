local Class = require('hump.class')
local Vector2D = require('hump.vector')
local SpaceObject = require('SpaceObject')

Bullet = {inherits = SpaceObject,
	function (self, health, damage, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, love.graphics.newImage('img/bullet.png'), 
		 "Bullet", health, pos, vel, accel, angV, heading)

		self.damage = damage
	end
}

function Bullet:collision_with["Asteroid"] (asteroid)
	self.health = 0

	-- Dirty cheater way to deal with multiple collisions
	self.damage = 0
end

function Bullet:Update(dt)
	self.UpdatePosition(dt)
end