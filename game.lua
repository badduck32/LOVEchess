detection = require("detection")

local game = {}

--ss stands for square size
local xoffs, yoffs, w, h, ss

function resized()
	xoffs, yoffs, w, h = love.window.getSafeArea()
	ss = w/8
	yoffs = yoffs + (h/2) - (ss*4)
end

function game.load()
	txt = ""
	resized()
	whitesTurn = true
	sprites = love.graphics.newImage("images/chess_pieces.png")
	types = {}
	for i = 1, 6 do
		types[i] = love.graphics.newQuad((i - 1) * 200, 0, 200, 200, sprites:getDimensions())
	end
	for i = 7, 12 do
		types[i] = love.graphics.newQuad((i - 7) * 200, 200, 200, 200, sprites:getDimensions())
	end
	--last 2 object variables are for the pawn only
	Piece = {x = 0, y = 0, dead = false, type = 6, white = true, firstMove = true}
	--types: 1 = king, 2 = queen, 3 = bishop, 4 = knight, 5 = rook, 6 = pawn
	Highlight = {x = 0, y = 0}
	--highlight squares to see legal moves. only generates when clicking a piece, and reset when another piece is clicked or a move is played
	highlights = {}
	--highlight array to store the highlight objects in
	selectedPiece = nil
	--stores a pawn that moved 2 squares last turn (for en passant)
	pawnMoved2Squares = nil
	--boolean to break a loop (this is the easiest and best way I found of doing it)
	attacksSquare = false

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
function love.keypressed(key)
	--beingAttackedAt(0, 0)
end

--clicking/touching implementation
--[[function love.touchpressed(id, x, y, dx, dy, p)
	gameClicked(x, y)
end
function love.mousepressed(x, y, b, isTouch)
	gameClicked(x, y)
end--]]

--returns the piece at specified x and y coordinate (tile coords)

game.clicked = function (fx, fy)
	--finds which tile was clicked
	x = math.floor((fx - xoffs) / ss)
	y = math.floor((fy - yoffs) / ss)
	if detection.highlightAt(x, y) and selectedPiece ~= nil and detection.pieceAt(x, y) ~= selectedPiece then 
		--if theres already a piece at the position you will move to (or if en passant), make that piece dead
		if detection.pieceAt(x, y) ~= nil and detection.pieceAt(x, y) ~= selectedPiece then 
			detection.pieceAt(x, y).dead = true 
		end 
		if pawnMoved2Squares ~= nil and selectedPiece.type == 6 and detection.pieceAt(x, y + (selectedPiece.white and 1 or -1), not selectedPiece.white) == pawnMoved2Squares then 
			detection.pieceAt(x, y + (selectedPiece.white and 1 or -1)).dead = true 
		end
		whitesTurn = not whitesTurn
		--check if a pawn moved 2 squares (for en passant)
		if selectedPiece.type == 6 and math.abs(y - selectedPiece.y) == 2 then
			pawnMoved2Squares = selectedPiece
		else 
			pawnMoved2Squares = nil
		end
		selectedPiece.x = x
		selectedPiece.y = y
		highlights = {}
		selectedPiece.firstMove = false
		--check if the other player's king is checked
		detection.isChecked(whitesTurn)
		selectedPiece = nil
		
	else
		--empties the highlight array
		highlights = {}
		--creates first highlight at clicked piece pos
		highlights[1] = Highlight:create{x = x, y = y}
		--if theres a piece at the clicked position, create the highlights for that piece
		if detection.pieceAt(x, y, whitesTurn) ~= nil then
			selectedPiece = detection.pieceAt(x, y)
			detection.piecePinned(selectedPiece)
			detection.createHighlights(selectedPiece, false)
		else
			selectedPiece = nil 
		end
	end
end

game.draw = function ()
	--draws board
	love.graphics.setColor(0.95, 0.75, 0.6)
	love.graphics.rectangle("fill", xoffs, yoffs, w, w)
	love.graphics.setColor(0.875, 0.6, 0.5)
	for x = 0,7 do
		for y = 0, 7 do
			if (x + y) % 2 == 1 then
				love.graphics.rectangle("fill", x * ss + xoffs, y * ss + yoffs, ss, ss)
			end
		end
	end

	--draws highlight squares
	love.graphics.setColor(0.95, 0.85, 0.1, 0.5)
	for i, square in ipairs(highlights) do
		love.graphics.rectangle("fill", xoffs + square.x * ss, yoffs + square.y * ss, ss, ss)
	end

	function drawPieces(arr)
		for i, piece in ipairs(arr) do
			if piece.dead == false then
				love.graphics.draw(sprites, types[piece.type + (piece.white and 0 or 6)], xoffs + (piece.x + (whitesTurn and 0 or 1)) * ss, yoffs + (piece.y + (whitesTurn and 0 or 1)) * ss, (whitesTurn and 0 or 1) * math.pi, w/200/8, w/200/8)
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

return game