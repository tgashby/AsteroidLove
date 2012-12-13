local Class = require('hump.class')
local Vector2D = require('hump.vector')
require('SpaceObject')

Asteroid = Class{inherts = SpaceObject,
	function(self, health, img, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, img, "Asteroid", health, pos, vel, accel,
		 angV, heading)
		self.collision_with["Player"] = function (player)
			self.health = 0
		end
		self.collision_with["Bullet"] = function (bullet)
			self.health = self.health - bullet.damage
		end
	end
}

function Asteroid:Explode()
	-- Split into smaller asteroids
	print("Asteroid Destroyed!")
end

function Asteroid:Update(dt)
	self.UpdatePosition(dt)
end
