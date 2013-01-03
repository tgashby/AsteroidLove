require('Bullet')
require('AsteroidFactory')

BulletFactory = {}
BulletFactory.bullets = {}

function BulletFactory:GenerateBullet(damage, pos, vel, angV)
	self.bullets[#self.bullets + 1] =
	 Bullet(1, damage, pos, vel, nil, angV)
end

function BulletFactory:UpdateAll(dt)
    local bulletsToRemove = {}

	for i, bullet in ipairs(self.bullets) do
		bullet:Update(dt)
        local bPos = bullet.position
        if bPos.x < 0 or bPos.x > 800 or bPos.y < 0 or bPos.y > 600 then
            bulletsToRemove[#bulletsToRemove + 1] = i
        end
	end

    for i, ndx in ipairs(bulletsToRemove) do
        table.remove(BulletFactory.bullets, ndx)
    end
end

function BulletFactory:DrawAll()
	for i, bullet in ipairs(self.bullets) do
		bullet:Draw()
	end
end
