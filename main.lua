game = require("game")
menu = require("menu")
settings = require("settings")
json = require("json")

function love.load()
	scene = 0
	mobile = false
	--scene 0: menu, scene 1: game, scene 2: settings
	menu.load(mobile)
end

--touching/mouse clicking support
function love.touchpressed(id, x, y, dx, dy, p)
	if scene == 0 then 
		menu.clicked(x, y)
	elseif scene == 1 then
		game.clicked(x, y)
	elseif scene == 2 then
		settings.clicked(x, y)
	end
end
function love.mousepressed(x, y, b, isTouch)
	if scene == 0 then 
		menu.clicked(x, y)
	elseif scene == 1 then
		game.clicked(x, y)
	elseif scene == 2 then
		print("settingclicked")
		settings.clicked(x, y)
	end
end

function love.draw()
	if scene == 0 then
		menu.draw()
	elseif scene == 1 then 
		game.draw()
	elseif scene == 2 then
		settings.draw()
	end
end

function loadScene(i)
	scene = i
	print(scene)
	if scene == 1 then 
		game.load(mobile)
	elseif scene == 2 then
		settings.load(mobile)
	end
end