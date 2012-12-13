require('Bullet')
require('AsteroidFactory')

BulletFactory = {}
BulletFactory.bullets = {}

function BulletFactory:GenerateBullet(damage, pos, vel, angV)
	self.bullets[#self.bullets + 1] = 
	 Bullet(1, damage, pos, vel, nil, angV)
end

function BulletFactory:UpdateAll(dt)
	for i, bullet in ipairs(self.bullets) do
		bullet:Update(dt)
	end
end

function BulletFactory:DrawAll()
	for i, bullet in ipairs(self.bullets) do
		bullet:Draw()
	end
end
