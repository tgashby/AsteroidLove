local Class = require('hump.class')
local Vector2D = require('hump.vector')
require('SpaceObject')

Bullet = {inherits = SpaceObject,
	function (self, health, damage, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, love.graphics.newImage('img/bullet.png'), 
		 "Bullet", health, pos, vel, accel, angV, heading)

		self.damage = damage
		self.collision_with["Asteroid"] = function (asteroid)
			self.health = 0

			-- Dirty cheater way to deal with multiple collisions
			self.damage = 0
		end
	end
}

function Bullet:Update(dt)
	self.UpdatePosition(dt)
end
