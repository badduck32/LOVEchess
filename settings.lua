local settings = {}

settings.load = function (mobile)
    --load stuff
	if mobile == false then
		love.window.setMode(400, 400, {resizable = false} )
		xOffs = 0
		yOffs = 0
	else
		love.window.setMode(411, 450, {resizable = false} )
		xOffs = 5
		yOffs = 50
	end
    screenRotates = false
end

settings.clicked = function (x, y)
    if y >= yOffs and y < yOffs + 50 then 
        screenRotates = not screenRotates
    elseif y >= yOffs + 50 and y < yOffs + 100 then
        loadScene(0)
    end
end

settings.draw = function ()
    love.graphics.print("screen rotates when move played: " .. screenRotates, xOffs, yOffs, 0, 2)
    love.graphics.print("back", xOffs, yOffs + 50, 0, 2)
end

return menu