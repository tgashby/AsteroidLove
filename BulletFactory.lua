require('Bullet')
require('AsteroidFactory')

BulletFactory = {}
BulletFactory.bullets = {}

function BulletFactory:GenerateBullet(damage, pos, vel, angV)
	self.bullets[#self.bullets + 1] = 
	 Bullet(1, damage, pos, vel, nil, angV)
end

function BulletFactory:UpdateAll(dt)
	local removeNdxs = {}

	for i, bullet in ipairs(self.bullets) do
		bullet:Update(dt)

		if bullet.health <= 0 then
			removeNdxs[#removeNdxs + 1] = i
		end

		for j, asteroid in ipairs(AsteroidFactory.asteroids) do
			if bullet.bounds:IsColliding(asteroid.bounds) then
				bullet.collision_with["Asteroid"](asteroid)
			end
		end
	end

	for i, ndx in ipairs(removeNdxs) do
		table.remove(self.bullets, ndx)
	end
end

function BulletFactory:DrawAll()
	for i, bullet in ipairs(self.bullets) do
		bullet:Draw()
	end
end
