function love.load()
	love.window.setMode(411, 800, {resizable = false} )
	xOffs = 5
	yOffs = 250
	--if white has to play turn is 0, if black1
	turn = 0
	sprites = love.graphics.newImage("chess pieces.png")
	types = {}
	for i = 1, 6 do
		types[i] = love.graphics.newQuad((i - 1) * 200, 0, 200, 200, sprites:getDimensions())
	end
	for i = 7, 12 do
		types[i] = love.graphics.newQuad((i - 7) * 200, 200, 200, 200, sprites:getDimensions())
	end
	Piece = {x = 0, y = 0, dead = false, type = 6}
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
	-- creating pieces
	--
	function CreatePieces (white)
		if white then
			offset = 0
			multiplier = 1
		else
			offset = 7
			multiplier = -1
		end
		arr = {}
		for i = 1, 8 do
			arr[i] = Piece:create{x = i - 1, y = offset + multiplier * 6, dead = false, type = 6}
		end
		--rooks
		arr[9] = Piece:create{x = 0, y = offset + multiplier * 7, dead = false, type = 5}
		arr[10] = Piece:create{x = 7, y = offset + multiplier * 7, dead = false, type = 5}
		--knights
		arr[11] = Piece:create{x = 1, y = offset + multiplier * 7, dead = false, type = 4}
		arr[12] = Piece:create{x = 6, y = offset + multiplier * 7, dead = false, type = 4}
		--bishops
		arr[13] = Piece:create{x = 2, y = offset + multiplier * 7, dead = false, type = 3}
		arr[14] = Piece:create{x = 5, y = offset + multiplier * 7, dead = false, type = 3}
		--queen
		arr[15] = Piece:create{x = 3, y = offset + multiplier * 7, dead = false, type = 2}
		--king
		arr[16] = Piece:create{x = 4, y = offset + multiplier * 7, dead = false, type = 1}
		--1-8: pawns, 9-10: rook, 11-12: knight, 13-14: bishop, 15: queen, 16: king
		return arr
	end
	wpieces = CreatePieces(true)
	bpieces = CreatePieces(false)
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
			if (x + y) % 2 == 1 then
				love.graphics.rectangle("fill", x * 50 + xOffs, y * 50 + yOffs, 50, 50)
			end
		end
	end
	
	love.graphics.setColor(1, 1, 1)
	--draw white pawns
	for i, piece in ipairs(wpieces) do
		love.graphics.draw(sprites, types[piece.type], xOffs + piece.x * 50, yOffs + piece.y * 50, --[[turn * 180--]]0, 0.25, 0.25)
	end
	for i, piece in ipairs(bpieces) do
		love.graphics.draw(sprites, types[piece.type + 6], xOffs + piece.x * 50, yOffs + piece.y * 50, --[[turn * 180--]]0, 0.25, 0.25)
	end
	--love.graphics.print(tostring(bpieces[1].y), xOffs + 10, yOffs + 10)
end