local Class = require('hump.class')
local Vector2D = require('hump.vector')
require('SpaceObject')
require('AsteroidFactory')

Asteroid = Class {inherits = SpaceObject,
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
	if self.bounds.width > 24 then
		for i=1, 4 do
			local velocity = Vector2D(0, 1):rotated(math.rad(math.random(0, 360))) * 70

			AsteroidFactory:GenerateAsteroid(10, --health
			 love.graphics.newImage('img/asteroidPiece' .. math.random(1, 4) .. '.png'), --img
			 self.position, -- pos
			 velocity, -- vel
			 Vector2D(0, 0), -- accel
			 9) -- angV
		end
	end
end

function Asteroid:Update(dt)
	self:UpdatePosition(dt)
end
