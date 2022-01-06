function gameLoad(mobile)
	txt = ""
	if mobile == false then
		love.window.setMode(400, 400, {resizable = false} )
		xOffs = 0
		yOffs = 0
	else
		love.window.setMode(411, 450, {resizable = false} )
		xOffs = 5
		yOffs = 50
	end
	whitesTurn = true
	sprites = love.graphics.newImage("images/chess_pieces.png")
	types = {}
	for i = 1, 6 do
		types[i] = love.graphics.newQuad((i - 1) * 200, 0, 200, 200, sprites:getDimensions())
	end
	for i = 7, 12 do
		types[i] = love.graphics.newQuad((i - 7) * 200, 200, 200, 200, sprites:getDimensions())
	end
	Piece = {x = 0, y = 0, dead = false, type = 6, white = true, firstMove = true}
	--types: 1 = king, 2 = queen, 3 = bishop, 4 = knight, 5 = rook, 6 = pawn
	Highlight = {x = 0, y = 0}
	--highlight squares to see legal moves. only generates when clicking a piece, and reset when another piece is clicked or a move is played
	highlights = {}
	--highlight array to store the highlight objects in
	selectedPiece = nil

	function Piece:create (o)
  		o.parent = self
  		return o
	end

	--[[function Piece:move (p)
  		self.x = self.x + p.x
  		self.y = self.y + p.y
	end--]]

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
		--pawns
		for i = 1, 8 do
			arr[i] = Piece:create{x = i - 1, y = offset + mult * 6, dead = false, type = 6, white = white, firstMove = true}
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
	--array of white piece objects
	bpieces = createPieces(false)
	--array of black piece objects
end

--debug
--[[function love.keypressed(key)
whitesTurn = whitesTurn == 0 and 1 or 0
end--]]

--clicking/touching implementation
--[[function love.touchpressed(id, x, y, dx, dy, p)
	gameClicked(x, y)
end
function love.mousepressed(x, y, b, isTouch)
	gameClicked(x, y)
end--]]

--returns the piece at specified x and y coordinate (tile coords)
function pieceAt(x, y, white)
	if white == nil or white == true then 
		for i, piece in ipairs(wpieces) do 
			if piece.dead == false and piece.x == x and piece.y == y then
				return piece
			end
		end
	end
	if white == nil or white == false then
		for i, piece in ipairs(bpieces) do 
			if piece.dead == false and piece.x == x and piece.y == y then
				return piece
			end
		end
	end
end

function highlightAt(x, y)
	for i, highlight in ipairs(highlights) do
		if highlight.x == x and highlight.y == y then 
			return true
		end 
	end 
	return false 
end

function gameClicked (fx, fy)
	x = math.floor((fx - xOffs) / 50)
	y = math.floor((fy - yOffs) / 50)
	--finds which tile was clicked
	if highlightAt(x, y) and selectedPiece ~= nil and pieceAt(x, y) ~= selectedPiece then 
		if pieceAt(x, y) ~= nil and pieceAt(x, y) ~= selectedPiece then 
			pieceAt(x, y).dead = true 
		end 
		--if theres already a piece at the position you will move to, make that piece dead
		whitesTurn = not whitesTurn
		selectedPiece.x = x
		selectedPiece.y = y
		highlights = {}
		selectedPiece.firstMove = false
		selectedPiece = nil
	else
		highlights = {}
		--empties the highlight array
		highlights[1] = Highlight:create{x = x, y = y}
		--creates first highlight at clicked piece pos
		if pieceAt(x, y, whitesTurn) ~= nil then
			selectedPiece = pieceAt(x, y)
			createHighlights(pieceAt(x, y))
			--if theres a piece at the clicked position, create the highlights for that piece
		else
			selectedPiece = nil 
		end
	end
end

function createHighlights(piece)
	--pawn
	if piece.type == 6 then 
		pieceIndexOffset = 0
		--if piece is white, ydelta = -1, else = 1
		yDelta = piece.white and -1 or 1
		--check if there's a piece directly in front
		if pieceAt(piece.x, piece.y + yDelta) ~= nil then 
			pieceIndexOffset = pieceIndexOffset + 2
		else
			--check if pawn is allowed to move 2 squares
			if piece.firstMove and pieceAt(piece.x, piece.y + yDelta * 2) == nil then 
				highlights[2] = Highlight:create{x = piece.x, y = piece.y + yDelta}
				highlights[3 - pieceIndexOffset] = Highlight:create{x = piece.x, y = piece.y + yDelta * 2}
				--should also store that it moved 2 squares for en passant
			--if not, move one square
			else
				highlights[2] = Highlight:create{x = piece.x, y = piece.y + yDelta}
				pieceIndexOffset = pieceIndexOffset + 1
			end
		end
		--checks if it can take left
		if pieceAt(piece.x - 1, piece.y + yDelta, not piece.white) ~= nil then 
			highlights[4 - pieceIndexOffset] = Highlight:create{x = piece.x - 1, y = piece.y + yDelta}
		else 
			pieceIndexOffset = pieceIndexOffset + 1
		end
		--checks if it can take right
		if pieceAt(piece.x + 1, piece.y + yDelta, not piece.white) ~= nil then 
			highlights[5 - pieceIndexOffset] = Highlight:create{x = piece.x + 1, y = piece.y + yDelta}
		else 
			pieceIndexOffset = pieceIndexOffset + 1
		end
		--2 = in front, 3 = 2 in front, 4 = left, 5 = right
	--rook
	elseif piece.type == 5 then
		pieceIndexOffset = 0
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					break
				end
				highlights[1 + i + ((li - 1) * 7) - pieceIndexOffset] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
				if pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i)
					break
				end
			end
		end
	--knight
	elseif piece.type == 4 then
		pieceIndexOffset = 0
		for i = 1, 8 do
			if i <= 4 then
				if pieceAt(piece.x + ((i % 2) * 2) - 1, piece.y + (i <= 2 and 2 or -2), piece.white) ~= nil then
					pieceIndexOffset = pieceIndexOffset + 1
				else
					highlights[i + 1 - pieceIndexOffset] = Highlight:create{x = piece.x + ((i % 2) * 2) - 1, y = piece.y + (i <= 2 and 2 or -2)}
				end
			else
				if pieceAt(piece.x + (i <= 6 and 2 or -2), piece.y + ((i % 2) * 2) - 1, piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + 1
				else 
					highlights[i + 1 - pieceIndexOffset] = Highlight:create{x = piece.x + (i <= 6 and 2 or -2), y = piece.y + ((i % 2) * 2) - 1}
				end
			end
		end
	--bishop
	elseif piece.type == 3 then 
		pieceIndexOffset = 0
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					break
				end
				highlights[1 + i + ((li - 1) * 7) - pieceIndexOffset] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
				if pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i)
					break
				end
			end
		end
	--queen
	elseif piece.type == 2 then
		--diagonal
		pieceIndexOffset = 0
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					break
				end
				highlights[1 + i + ((li - 1) * 7) - pieceIndexOffset] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
				if pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i)
					break
				end
			end
		end
		--hor/ver
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					break
				end
				highlights[29 + i + ((li - 1) * 7) - pieceIndexOffset] = Highlight:create{x = piece.x + x * i, y = piece.y + y * i}
				if pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					pieceIndexOffset = pieceIndexOffset + (7 - i)
					break
				end
			end
		end
	--king
	elseif piece.type == 1 then
		pieceIndexOffset = 0
		for i = 1, 4 do 
			if pieceAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, piece.white) ~= nil then 
				pieceIndexOffset = pieceIndexOffset + 1
			else
				highlights[i + 1 - pieceIndexOffset] = Highlight:create{x = piece.x + (i - 1) % 3 - 1, y = piece.y + math.floor((i - 1) / 3) - 1}
			end
		end
		for i = 6, 9 do 
			if pieceAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, piece.white) ~= nil then 
				pieceIndexOffset = pieceIndexOffset + 1
			else
				highlights[i - pieceIndexOffset] = Highlight:create{x = piece.x + (i - 1) % 3 - 1, y = piece.y + math.floor((i - 1) / 3) - 1}
			end
		end
	end
end

function gameDraw()
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
	love.graphics.setColor(0.95, 0.85, 0.1, 0.5)
	for i, square in ipairs(highlights) do
		love.graphics.rectangle("fill", xOffs + square.x * 50, yOffs + square.y * 50, 50, 50)
	end

	function drawPieces(arr)
		for i, piece in ipairs(arr) do
			if piece.dead == false then
				love.graphics.draw(sprites, types[piece.type + (piece.white and 0 or 6)], xOffs + (piece.x + (whitesTurn and 0 or 1)) * 50, yOffs + (piece.y + (whitesTurn and 0 or 1)) * 50, (whitesTurn and 0 or 1) * math.pi, 0.25, 0.25)
			end
		end
	end

	love.graphics.setColor(1, 1, 1)
	--draw white pieces
	drawPieces(wpieces)
	--draw black pieces
	drawPieces(bpieces)
	love.graphics.print( tostring(txt) )
end