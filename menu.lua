local menu = {}

menu.load = function (mobile)
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
end

menu.clicked = function (x, y)
    if y >= yOffs and y < yOffs + 50 then 
        loadScene(1)
    elseif y >= yOffs + 100 and y < yOffs + 150 then 
        love.event.quit()
    end
end

menu.draw = function ()
    love.graphics.print("play", xOffs, yOffs, 0, 2)
    love.graphics.print("settings", xOffs, yOffs + 50, 0, 2)
    love.graphics.print("quit", xOffs, yOffs + 100, 0, 2)
end

return menu