extends Node3D

const PAWN = preload("res://Gameplay/Pieces/pawn.tscn")
const ROOK = preload("res://Gameplay/Pieces/rook.tscn")
const KNIGHT = preload("res://Gameplay/Pieces/knight.tscn")
const BISHOP = preload("res://Gameplay/Pieces/bishop.tscn")
const QUEEN = preload("res://Gameplay/Pieces/queen.tscn")
const KING = preload("res://Gameplay/Pieces/king.tscn")

func place_piece(type:MasterTools.Type,clr:MasterTools.MyColor, location: CharacterBody3D)->void:
	var a : Piece
	match type:
		MasterTools.Type.PAWN:
			a = PAWN.instantiate()
		MasterTools.Type.ROOK:
			a = ROOK.instantiate()
		MasterTools.Type.KNIGHT:
			a = KNIGHT.instantiate()
		MasterTools.Type.BISHOP:
			a = BISHOP.instantiate()
		MasterTools.Type.QUEEN:
			a = QUEEN.instantiate()
		MasterTools.Type.KING:
			a = KING.instantiate()
		_:
			printerr(name, " No Piece Selected")
			return
	match clr:
		MasterTools.MyColor.WHITE:
			a.my_color = MasterTools.MyColor.WHITE
		MasterTools.MyColor.BLACK:
			a.my_color = MasterTools.MyColor.BLACK
		_:
			printerr(name, " No color selected")
	a.location = location
	call_deferred("add_child", a)
	
	
