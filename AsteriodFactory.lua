require('Asteroid')
require('BulletFactory')

AsteroidFactory = {}
AsteroidFactory.asteroids = {}

function AsteroidFactory:GenerateAsteroid(health, pos, vel, accel, angV, heading)
	self.asteroids[#self.asteroids + 1] = 
	 Asteroid(health, pos, vel, accel, angV, heading)
end

function AsteroidFactory:UpdateAll(dt, player)
	local removeNdxs = {}

	for i, asteroid in ipairs(self.asteroids) do
		asteroid.Update(dt)

		if asteroid.health <= 0 then
			asteroid.Explode()
			removeNdxs[#removeNdxs + 1] = i
		end

		for j, bullet in ipairs(BulletFactory.bullets) do
			if asteroid.bounds.IsColliding(bullet.bounds) then
				asteroid.collision_with["Bullet"](bullet)
			end
		end

		if asteroid.bounds.IsColliding(player.bounds) then
			asteroid.collision_with["Player"](player)
		end
	end

	for i, ndx in ipairs(removeNdxs) do
		table.remove(self.asteroids, ndx)
	end
end

function AsteroidFactory:DrawAll()
	for i, asteroid in ipairs(self.asteroids) do
		asteroid.Draw()
	end
end
