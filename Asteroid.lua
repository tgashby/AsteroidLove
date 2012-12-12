local Class = require('hump.class')
local Vector2D = require('hump.vector')
local SpaceObject = require('SpaceObject')

Asteroid = Class{inherts = SpaceObject,
	function(self, health, img, pos, vel, accel, angV, heading)
		SpaceObject.construct(self, img, "Asteroid", health, pos, vel, accel,
		 angV, heading)
	end
}

function Asteroid:Explode()
	-- Split into smaller asteroids
	print("Asteroid Destroyed!")
end

function Asteroid:collision_with["Player"] (player)
	self.health = 0
end

function Asteroid:collision_with["Bullet"] (bullet)
	self.health = self.health - bullet.damage
end

function Asteroid:Update(dt)
	self.UpdatePosition(dt)
end