-- Xbox controller support!
love.joystick = require('XInputLUA')

-- Helper for Controller Support
xpad = require('XPad')

Vector2D = require('hump.vector')

local controllers = {}

local buttonnames = {
	"a", "b", "x", "y",	"lt", "rt",	"lb", 
	"rb", "ls", "rs", "back", "start",
}

local axisnames = {
	"leftx", "lefty", "rightx",	"righty", 
	"lefttrigger", "righttrigger",
}

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
	AsteroidFactory:GenerateAsteroid(20, love.graphics.newImage('img/asteroid1.png'), Vector2D(20, 20))

	for i = 1, love.joystick.getNumJoysticks() do
		table.insert(controllers, xpad:newplayer())
	end

	pad = controllers[1]
end

function love.update(dt)
	love.joystick.update()
	xpad:update()

	if pad:justReleased("a") then
		player:Shoot()
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
	BulletFactory:UpdateAll(dt)
	AsteroidFactory:UpdateAll(dt, player)
end

function love.draw()
	player:Draw()
	BulletFactory:DrawAll()
	AsteroidFactory:DrawAll()
end

function love.keyreleased(key, unicode)
	if key == "escape" then
      love.event.push("quit")   -- actually causes the app to quit
   end
end
