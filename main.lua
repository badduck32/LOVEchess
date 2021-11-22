function love.load()
	love.window.setMode(800, 800, {resizable = false} )
	xOffs = 0
	yOffs = 100
end

function love.update(dt)
	--[[for i = 1,64
		love.graphics.rectangle("fill", )
	end--]]
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", xOffs, yOffs, 400, 400)
	love.graphics.setColor(0, 0, 0)
	for x = 0,7 do
		if x % 2 == 0 then
			love.graphics.rectangle("fill", x * 50 + xOffs, yOffs, 50, 50)
		end
	end
end
