require("game")
require("menu")

function love.load( ... )
	scene = 0
	mobile = false
	--scene 0: menu, scene 1: game, scene 2: settings
	menuLoad(mobile)
end

function love.touchpressed(id, x, y, dx, dy, p)
	if scene == 0 then 
		menuClicked(x, y)
	elseif scene == 1 then
		gameClicked(x, y)
	end
end
function love.mousepressed(x, y, b, isTouch)
	if scene == 0 then 
		menuClicked(x, y)
	elseif scene == 1 then
		gameClicked(x, y)
	end
end

function love.draw()
	if scene == 0 then
		menuDraw()
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