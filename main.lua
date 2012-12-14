-- Xbox controller support!
love.joystick = require('XInputLUA')

-- Helper for Controller Support
xpad = require('XPad')

Vector2D = require('hump.vector')
Timer = require('hump.timer')

local controllers = {}
local asteroidsDestoyed = 0
local gameOver = false
local justHit = false

love.filesystem.load("SpaceObject.lua")()
love.filesystem.load("AsteroidFactory.lua")()
love.filesystem.load("Asteroid.lua")()
love.filesystem.load("BoundingBox.lua")()
love.filesystem.load("BulletFactory.lua")()
love.filesystem.load("Bullet.lua")()
love.filesystem.load("Player.lua")()

function love.load()
	xpad:init(love.joystick)

	love.joystick.update()

	player = Player(100, Vector2D(400, 300))
	shipImg = love.graphics.newImage('img/ship.png')

	for i = 1, love.joystick.getNumJoysticks() do
		table.insert(controllers, xpad:newplayer())
	end

	pad = controllers[1]

	Timer.add(3, 
		function (timedFunc)
			local img = love.graphics.newImage('img/asteroid' .. math.random(1, 2) .. '.png')
			local posX = math.random(img:getWidth(), 800 - img:getWidth())
			local posY = 0

			if posX < 250 - img:getWidth() or posX > 550 + img:getWidth() then
				posY = math.random(0, 600 - img:getHeight())
			else
				local selector = math.random(1, 2)
				if selector == 1 then
					posY = math.random(0, 150)
				else
					posY = math.random(450, 600 - img:getHeight())
				end
			end

			local dirToCenter = (Vector2D(400, 300) - Vector2D(posX, posY)):normalize_inplace()
			local velocity = dirToCenter:rotated(math.rad(math.random(-30, 30))) * 50

			AsteroidFactory:GenerateAsteroid(20, --health
				img, --img
				Vector2D(posX, posY), -- pos
				velocity, -- vel
				Vector2D(0, 0), -- accel
				5) -- angV
			Timer.add(3, timedFunc)
		end
	)
end


function DispatchCollisions()
	asteroidsToRemove, bulletsToRemove = {}, {}

	for i, asteroid in ipairs(AsteroidFactory.asteroids) do
		for j, bullet in ipairs(BulletFactory.bullets) do
			if asteroid.bounds:IsColliding(bullet.bounds) then
				asteroid.collision_with["Bullet"](bullet)
				bullet.collision_with["Asteroid"](asteroid)
			end

			if bullet.health <= 0 then
				bulletsToRemove[#bulletsToRemove + 1] = j
			end
		end

		if asteroid.bounds:IsColliding(player.bounds) then
			asteroid.collision_with["Player"](player)

			if not justHit then
				player.collision_with["Asteroid"](asteroid)
			end
			
			justHit = true
			Timer.add(2, function (timedFunc)
				justHit = false
			end)
		end

		if asteroid.health <= 0 then
			asteroid:Explode()
			asteroidsToRemove[#asteroidsToRemove + 1] = i
		end
	end

	asteroidsDestoyed = asteroidsDestoyed + #asteroidsToRemove

	for i, ndx in ipairs(asteroidsToRemove) do
		table.remove(AsteroidFactory.asteroids, ndx)
	end

	for i, ndx in ipairs(bulletsToRemove) do
		table.remove(BulletFactory.bullets, ndx)
	end
end


function love.update(dt)
	if gameOver then
		return
	end

	love.joystick.update()
	xpad:update()
	Timer.update(dt)

	if pad:justReleased("a") then
		player:Shoot()
	end

	if pad:justReleased("b") then
		player.position.x = math.random(0, 800)
		player.position.y = math.random(0, 600)
		player:Update(0)
	end

	if math.abs(pad:getAxis("leftx")) > 0.2 then
		player.angVelocity = player.angVelocity + pad:getAxis("leftx") * 10 * dt
	end

	if math.abs(pad:getAxis("lefty")) > 0.2 then
		player.acceleration.y = player.acceleration.y + pad:getAxis("lefty") * 100 * dt
	else
		player.acceleration.y = 0
	end

	if math.abs(player.velocity.y) > 1 then
		pad:setRumble(math.abs(player.velocity.y) / 300)
		pad:setVibrate(0)
	end

	player:Update(dt)
	AsteroidFactory:UpdateAll(dt, player)
	BulletFactory:UpdateAll(dt)

	DispatchCollisions()

	if player.health <= 0 or asteroidsDestoyed >= 30 then
		gameOver = true
	end
end

function love.draw()
	love.graphics.print("Health: " .. player.health, 10, 10)
	love.graphics.print("Asteroids Destoryed: " .. asteroidsDestoyed, 10, 30)

	player:Draw()
	BulletFactory:DrawAll()
	AsteroidFactory:DrawAll()

	if gameOver then
		if player.health <= 0 then
			love.graphics.print("You LOSE!", 350, 300)
		else
			love.graphics.print("You WIN!", 350, 300)
		end

		return
	end

	if justHit then
		love.graphics.print("Collision!", 350, 300)
	end

	for lives = 1, math.ceil(player.health / 10) do
		love.graphics.draw(shipImg, 800 - player.bounds.width * 2 * lives, 600 - player.bounds.height * 2)
	end
end

function love.keyreleased(key, unicode)
	if key == "escape" then
      love.event.push("quit")
   end
end
