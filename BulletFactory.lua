require('Bullet')
require('AsteroidFactory')

BulletFactory = {}
BulletFactory.bulllets = {}

function BulletFactory:GenerateBullet(health, damage, pos, vel, accel, angV, heading)
	self.bullets[#self.bullets + 1] = 
	 Bullet(health, damage, pos, vel, accel, angV, heading)
end

function BulletFactory:UpdateAll(dt)
	local removeNdxs = {}

	for i, bullet in ipairs(self.bullets) do
		bullet.Update(dt)

		if bullet.health <= 0 then
			removeNdxs[#removeNdxs + 1] = i
		end

		for j, asteroid in ipairs(AsteroidFactory.asteroids) do
			if bullet.bounds.IsColliding(asteroid.bounds) then
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
		bullet.Draw()
	end
end
