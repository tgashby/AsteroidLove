AsteroidFactory = {}
AsteroidFactory.asteroids = {}

function AsteroidFactory:GenerateAsteroid(health, img, pos, vel, accel, angV, heading)
	self.asteroids[#self.asteroids + 1] = 
	 Asteroid(health, img, pos, vel, accel, angV, heading)
end

function AsteroidFactory:UpdateAll(dt, player)
	local removeNdxs = {}

	for i, asteroid in ipairs(self.asteroids) do
		asteroid:Update(dt)
	end
end

function AsteroidFactory:DrawAll()
	for i, asteroid in ipairs(self.asteroids) do
		asteroid:Draw()
	end
end
