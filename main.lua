-- Xbox controller support!
love.joystick = require('XInputLUA')

-- Helper for Controller Support
xpad = require('XPad')

local controllers = {}

local buttonnames = {
	"a", "b", "x", "y",	"lt", "rt",	"lb", 
	"rb", "ls", "rs", "back", "start",
}

local axisnames = {
	"leftx", "lefty", "rightx",	"righty", 
	"lefttrigger", "righttrigger",
}

function love.load()
	xpad:init(love.joystick)

	love.joystick.update()

	for i = 1, love.joystick.getNumJoysticks() do
		table.insert(controllers, xpad:newplayer())
	end
end

function love.update(dt)
	love.joystick.update()
	xpad:update()
end

function love.draw()
	-- draw
end

function love.mousepressed(x, y, button)
	-- body
end

function love.mousereleased(x, y, button)
	-- body
end

function love.keypressed(key, unicode)
	-- body
end

function love.keyreleased(key, unicode)
	-- body
end

function love.joystickpressed(joystick, button)
	print("pressed " .. buttonnames[button])
end

function love.joystickreleased(joystick, button)
	print("release ".. buttonnames[button])
end