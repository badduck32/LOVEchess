function love.load()
	love.window.setMode(800, 800, {resizable = false} )
	xOffs = 5
	yOffs = 250
	--if white has to play turn is 0, if black1
	turn = 0
	all = love.graphics.newImage("chess pieces.png")
	types = {love.graphics.newQuad(0, 0, 200, 200, all:getDimensions()), love.graphics.newQuad(200, 0, 200, 200, all:getDimensions()),
	love.graphics.newQuad(400, 0, 200, 200, all:getDimensions()), love.graphics.newQuad(600, 0, 200, 200, all:getDimensions()),
	love.graphics.newQuad(800, 0, 200, 200, all:getDimensions()), love.graphics.newQuad(1000, 0, 200, 200, all:getDimensions()) }
	Piece = {x = 0, y = 0, dead = false, type = 0}
	--types: 1 = king, 2 = queen, 3 = bishop, 4 = knight, 5 = rook, 6 = pawn

	function Piece:create (o)
  		o.parent = self
  		return o
	end

	function Piece:move (p)
  		self.x = self.x + p.x
  		self.y = self.y + p.y
	end

	--
	-- creating points
	--
	p1 = Piece:create{x = 2, y = 2, dead = false, type = 2}
	p2 = Piece:create{x = 10}  -- y will be inherited until it is set

	--
	-- example of a method invocation
	--
	--p1:move(p2)
end

function love.update(dt)
	
end

function love.draw()
	--draws board
	love.graphics.setColor(0.95, 0.75, 0.6)
	--love.graphics.print(p1.type + "t", 10, 10)
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
		love.graphics.draw(all, types[p1.type], xOffs + p1.x * 50, yOffs + p1.y * 50, --[[turn * 180--]]0, 0.25, 0.25)
	end
end