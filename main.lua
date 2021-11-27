function love.load()
	love.window.setMode(800, 800, {resizable = false} )
	xOffs = 5
	yOffs = 250
	--if white has to plat turn is 0, if black1
	turn = 0
	all = love.graphics.newImage("chess pieces.png")
	wpawn = love.graphics.newQuad(1000, 0, 200, 200, all:getDimensions())
	Piece = {x, y}
end

function love.update(dt)
	
end

function love.draw()
	--draws board
	love.graphics.setColor(0.95, 0.75, 0.6)
	love.graphics.rectangle("fill", xOffs, yOffs, 400, 400)
	love.graphics.setColor(0.875, 0.6, 0.5)
	for x = 0,7 do
		for y = 0, 7 do
			if (x + y) % 2 == 0 then
				love.graphics.rectangle("fill", x * 50 + xOffs, y * 50 + yOffs, 50, 50)
			end
		end
	end
	
	love.graphics.setColor(1, 1, 1)
	--draw white pawns
	for i = 0, 7 do
		love.graphics.draw(all, wpawn, xOffs + i * 50, yOffs + 6 * 50, turn * 180, 0.25, 0.25)
	end
end
