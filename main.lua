function love.load()
	love.window.setMode(411, 450, {resizable = false} )
	mobile = false
	xOffs = 5
	yOffs = 50
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
	Piece = {x = 0, y = 0, dead = false, type = 6, white = true}
	--types: 1 = king, 2 = queen, 3 = bishop, 4 = knight, 5 = rook, 6 = pawn
	Highlight = {x = 0, y = 0}
	--highlight squares to see legal moves. only generates when clicking a piece, and reset when another piece is clicked or a move is played
	highlights = {}

	function Piece:create (o)
  		o.parent = self
  		return o
	end

	function Piece:move (p)
  		self.x = self.x + p.x
  		self.y = self.y + p.y
	end

	function Highlight:create (o)
		o.parent = self 
		return o 
	end

	function createPieces (white)
		if white then
			offset = 0
			mult = 1
		else
			offset = 7
			mult = -1
		end
		arr = {}
		for i = 1, 8 do
			arr[i] = Piece:create{x = i - 1, y = offset + mult * 6, dead = false, type = 6, white = white}
		end
		--rooks
		arr[9] = Piece:create{x = 0, y = offset + mult * 7, dead = false, type = 5, white = white}
		arr[10] = Piece:create{x = 7, y = offset + mult * 7, dead = false, type = 5, white = white}
		--knights
		arr[11] = Piece:create{x = 1, y = offset + mult * 7, dead = false, type = 4, white = white}
		arr[12] = Piece:create{x = 6, y = offset + mult * 7, dead = false, type = 4, white = white}
		--bishops
		arr[13] = Piece:create{x = 2, y = offset + mult * 7, dead = false, type = 3, white = white}
		arr[14] = Piece:create{x = 5, y = offset + mult * 7, dead = false, type = 3, white = white}
		--queen
		arr[15] = Piece:create{x = 3, y = offset + mult * 7, dead = false, type = 2, white = white}
		--king
		arr[16] = Piece:create{x = 4, y = offset + mult * 7, dead = false, type = 1, white = white}
		--1-8: pawns, 9-10: rook, 11-12: knight, 13-14: bishop, 15: queen, 16: king
		return arr
	end
	wpieces = createPieces(true)
	bpieces = createPieces(false)
end

--debug
function love.keypressed(key)
	turn = turn == 0 and 1 or 0
end

--clicking/touching implementation
function love.touchpressed(id, x, y, dx, dy, p)
	clicked(x, y)
end
function love.mousepressed(x, y, b, isTouch)
	clicked(x, y)
end

--returns the piece at specified x and y coordinate (tile coords)
function pieceAt(x, y)
	for i, piece in ipairs(wpieces) do 
		if piece.x == x and piece.y == y then
			return piece
		end
	end
	for i, piece in ipairs(bpieces) do 
		if piece.x == x and piece.y == y then
			return piece
		end
	end
end

function clicked (fx, fy)
	highlights = {}
	--finds which tile was clicked
	x = math.floor((fx - xOffs) / 50)
	y = math.floor((fy - yOffs) / 50)
	--creates first highlight at clicked piece pos
	highlights[1] = Highlight:create{x = x, y = y}
	if pieceAt(x, y) ~= nil then
		createHighlights(pieceAt(x, y))
	end
end

function createHighlights(piece)
	--pawn
	if piece.type == 6 then 
		if piece.white then
			highlights[2] = Highlight:create{x = piece.x, y = piece.y - 1}
		else 
			highlights[2] = Highlight:create{x = piece.x, y = piece.y + 1}
		end
	--rook
	elseif piece.type == 5 then
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				highlights[1 + i + ((li - 1) * 7)] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
			end
		end
	--knight
	elseif piece.type == 4 then
		for i = 1, 8 do
			if i <= 4 then
				highlights[i + 1] = Highlight:create{x = piece.x + ((i % 2) * 2) - 1, y = piece.y + (i <= 2 and 2 or -2)}
			else
				highlights[i + 1] = Highlight:create{x = piece.x + (i <= 6 and 2 or -2), y = piece.y + ((i % 2) * 2) - 1}
			end
		end
	--bishop
	elseif piece.type == 3 then 
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				highlights[1 + i + ((li - 1) * 7)] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
			end
		end
	--queen
	elseif piece.type == 2 then
		--diagonal
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				highlights[1 + i + ((li - 1) * 7)] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
			end
		end
		--hor/ver
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				highlights[29 + i + ((li - 1) * 7)] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
			end
		end
	--king
	elseif piece.type == 1 then
		for i = 1, 4 do 
			highlights[i + 1] = Highlight:create{x = piece.x + (i - 1) % 3 - 1, y = piece.y + math.floor((i - 1) / 3) - 1}
		end
		for i = 6, 9 do 
			highlights[i] = Highlight:create{x = piece.x + (i - 1) % 3 - 1, y = piece.y + math.floor((i - 1) / 3) - 1}
		end
	end
end

function love.draw()
	--draws board
	love.graphics.setColor(0.95, 0.75, 0.6)
	love.graphics.rectangle("fill", xOffs, yOffs, 400, 400)
	love.graphics.setColor(0.875, 0.6, 0.5)
	for x = 0,7 do
		for y = 0, 7 do
			if (x + y) % 2 == 1 then
				love.graphics.rectangle("fill", x * 50 + xOffs, y * 50 + yOffs, 50, 50)
			end
		end
	end

	--draws highlight squares
	love.graphics.setColor(0.95, 0.85, 0.1)
	for i, square in ipairs(highlights) do
		love.graphics.rectangle("fill", xOffs + square.x * 50, yOffs + square.y * 50, 50, 50)
	end

	function drawPieces(arr)
		for i, piece in ipairs(arr) do
			love.graphics.draw(sprites, types[piece.type + (piece.white and 0 or 6)], xOffs + (piece.x + turn ) * 50, yOffs + (piece.y + turn) * 50, turn * math.pi, 0.25, 0.25)
		end
	end

	love.graphics.setColor(1, 1, 1)
	--draw white pieces
	drawPieces(wpieces)
	--draw black pieces
	drawPieces(bpieces)
	--love.graphics.print( tostring(txt) )
end