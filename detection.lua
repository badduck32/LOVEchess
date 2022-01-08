local detection = {}

detection.pieceAt = function (x, y, white)
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

detection.highlightAt = function (x, y)
	for i, highlight in ipairs(highlights) do
		if highlight.x == x and highlight.y == y then 
			return true
		end 
	end 
	return false 
end

--if checkingAttack is true, it checks if a certain square is being attacked instead of creating highlights
--ax and ay are attack x and attack y
detection.createHighlights = function (piece, checkingAttack, ax, ay)
	if not checkingAttack then
		pieceIndexOffset = 0
	end
	--pawn
	if piece.type == 6 then 
		--if piece is white, ydelta = -1, else = 1
		yDelta = piece.white and -1 or 1
		--check if there's a piece directly in front
		if detection.pieceAt(piece.x, piece.y + yDelta) ~= nil then 
			pieceIndexOffset = pieceIndexOffset + 2
		else
			--check if pawn is allowed to move 2 squares
			if piece.firstMove and detection.pieceAt(piece.x, piece.y + yDelta * 2) == nil and not checkingAttack then 
				highlights[2] = Highlight:create{x = piece.x, y = piece.y + yDelta}
				highlights[3 - pieceIndexOffset] = Highlight:create{x = piece.x, y = piece.y + yDelta * 2}
				--should also store that it moved 2 squares for en passant
			--if not, move one square
			elseif not checkingAttack then
				highlights[2] = Highlight:create{x = piece.x, y = piece.y + yDelta}
				pieceIndexOffset = pieceIndexOffset + 1
			end
		end
		--checks if it can take left
		if detection.pieceAt(piece.x - 1, piece.y + yDelta, not piece.white) ~= nil or checkingAttack then 
			detection.createHighlightAt(4 - pieceIndexOffset, piece.x - 1,piece.y + yDelta, checkingAttack, ax, ay)
		elseif not checkingAttack then
			pieceIndexOffset = pieceIndexOffset + 1
		end
		--checks if it can take right
		if detection.pieceAt(piece.x + 1, piece.y + yDelta, not piece.white) ~= nil or checkingAttack then 
			detection.createHighlightAt(5 - pieceIndexOffset, piece.x + 1, piece.y + yDelta, checkingAttack, ax, ay)
		elseif not checkingAttack then
			pieceIndexOffset = pieceIndexOffset + 1
		end
		--checks for en passant left
		if pawnMoved2Squares ~= nil and detection.pieceAt(piece.x - 1, piece.y, not piece.white) == pawnMoved2Squares then 
			detection.createHighlightAt(6 - pieceIndexOffset, piece.x - 1, piece.y + yDelta, checkingAttack, ax, ay)
		elseif not checkingAttack then
			pieceIndexOffset = pieceIndexOffset + 1
		end
		--checks for en passant right
		if pawnMoved2Squares ~= nil and detection.pieceAt(piece.x + 1, piece.y, not piece.white) == pawnMoved2Squares then 
			detection.createHighlightAt(7 - pieceIndexOffset, piece.x + 1, piece.y + yDelta, checkingAttack, ax, ay)
		elseif not checkingAttack then
			pieceIndexOffset = pieceIndexOffset + 1
		end
	--rook
	elseif piece.type == 5 then
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					end
					break
				end
				detection.createHighlightAt(1 + i + ((li - 1) * 7) - pieceIndexOffset, piece.x + x * i, piece.y + y * i, checkingAttack, ax, ay)
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i)
					end
					break
				end
			end
		end
	--knight
	elseif piece.type == 4 then
		for i = 1, 8 do
			if i <= 4 then
				if detection.pieceAt(piece.x + ((i % 2) * 2) - 1, piece.y + (i <= 2 and 2 or -2), piece.white) ~= nil and not checkingAttack then
					pieceIndexOffset = pieceIndexOffset + 1
				else
					detection.createHighlightAt(i + 1 - pieceIndexOffset, piece.x + ((i % 2) * 2) - 1, piece.y + (i <= 2 and 2 or -2), checkingAttack, ax, ay)
				end
			else
				if detection.pieceAt(piece.x + (i <= 6 and 2 or -2), piece.y + ((i % 2) * 2) - 1, piece.white) ~= nil and not checkingAttack then 
					pieceIndexOffset = pieceIndexOffset + 1
				else 
					detection.createHighlightAt(i + 1 - pieceIndexOffset, piece.x + (i <= 6 and 2 or -2), piece.y + ((i % 2) * 2) - 1, checkingAttack, ax, ay)
				end
			end
		end
	--bishop
	elseif piece.type == 3 then 
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					end
					break
				end
				detection.createHighlightAt(1 + i + ((li - 1) * 7) - pieceIndexOffset, piece.x + x * i, piece.y + y * i, checkingAttack, ax, ay)
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then 
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i)
					end
					break
				end
			end
		end
	--queen
	elseif piece.type == 2 then
		--diagonal
		for li = 1, 4 do
			x = (li % 2) * (li <= 2 and 1 or -1)
			y = ((li + 1) % 2) * (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					end
					break
				end
				detection.createHighlightAt(1 + i + ((li - 1) * 7) - pieceIndexOffset, piece.x + x * i, piece.y + y * i, checkingAttack, ax, ay)
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i)
					end
					break
				end
			end
		end
		--hor/ver
		for li = 1, 4 do
			x = (li % 2) * 2 - 1
			y = (li <= 2 and 1 or -1)
			for i = 1, 7 do
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i + 1)
					end
					break
				end
				detection.createHighlightAt(29 + i + ((li - 1) * 7) - pieceIndexOffset, piece.x + x * i, piece.y + y * i, checkingAttack, ax, ay)
				if detection.pieceAt(piece.x + x * i, piece.y + y * i, not piece.white) ~= nil then
					if not checkingAttack then
						pieceIndexOffset = pieceIndexOffset + (7 - i)
					end
					break
				end
			end
		end
	--king
	elseif piece.type == 1 and not checkingAttack then
		for i = 1, 4 do 
			if (detection.pieceAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, piece.white) ~= nil or detection.beingAttackedAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, not piece.white)) then 
				pieceIndexOffset = pieceIndexOffset + 1
			else
				detection.createHighlightAt(i + 1 - pieceIndexOffset, piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, checkingAttack, ax, ay)
			end
		end
		for i = 6, 9 do 
			if (detection.pieceAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, piece.white) ~= nil or detection.beingAttackedAt(piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, not piece.white)) then 
				pieceIndexOffset = pieceIndexOffset + 1
			else
				detection.createHighlightAt(i - pieceIndexOffset, piece.x + (i - 1) % 3 - 1, piece.y + math.floor((i - 1) / 3) - 1, checkingAttack, ax, ay)
			end
		end
	end
end

detection.createHighlightAt = function (index, x, y, checkingAttack, ax, ay)
	if checkingAttack == nil or checkingAttack == false then
		highlights[index] = Highlight:create{x = x, y = y}
	elseif x == ax and y == ay then
		attacksSquare = true
	end
end

--checks if any given square is actively being attacked by any piece on the board
--if white = true, check if any white piece attacks said square
detection.beingAttackedAt = function (x, y, white)
	test = 0
	if white then 
		arr = wpieces
	else 
		arr = bpieces
	end
	for i, piece in ipairs(arr) do
		if piece.dead == false then
			--checks if square at x, y is being attacked by the currently indexed white piece
			detection.createHighlights(piece, true, x, y)
		end
		if attacksSquare then
			attacksSquare = false
			--txt = txt .. " f: " .. test .. " t type: " .. piece.type .. "x: " .. x .. "y: " .. y
			test = 0
			return true
		else
			test = test + 1
		end
	end
	return false
end

detection.isChecked = function ()
	if whitesTurn then
		if detection.beingAttackedAt(wpieces[16].x, wpieces[16].y, not whitesTurn) then
			print("white is checked")
		end
	else
		if detection.beingAttackedAt(bpieces[16].x, bpieces[16].y, not whitesTurn) then
			print("black is checked")
		end
	end
end

return detection