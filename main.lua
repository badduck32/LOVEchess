game = require("game")
menu = require("menu")
settings = require("settings")
json = require "json"

function love.load()
	scene = 0
	mobile = false
	--scene 0: menu, scene 1: game, scene 2: settings
	menu.load(mobile)
end

function love.touchpressed(id, x, y, dx, dy, p)
	if scene == 0 then 
		menu.clicked(x, y)
	elseif scene == 1 then
		gameClicked(x, y)
	end
end
function love.mousepressed(x, y, b, isTouch)
	if scene == 0 then 
		menu.clicked(x, y)
	elseif scene == 1 then
		gameClicked(x, y)
	end
end

function love.draw()
	if scene == 0 then
		menu.draw()
	elseif scene == 1 then 
		gameDraw()
	end
end

function loadScene(i)
	scene = i
	if scene == 1 then 
		gameLoad(mobile)
	end
end