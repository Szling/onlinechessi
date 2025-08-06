extends CharacterBody3D
class_name Space

@export var my_cords : Vector2i

const BLACK = preload("res://Gameplay/Board/Materials/PlaceholderBlack.tres")
const WHITE = preload("res://Gameplay/Board/Materials/PlaceholderWhite.tres")

var touch_point : Vector3:
	get : return $TouchMark.global_position
var occupant : Piece

@onready var piece_holder : Node3D = get_tree().get_first_node_in_group("PieceHolder")



var setup_positions : Array[Array] = [
	[
		[MasterTools.Type.ROOK , MasterTools.MyColor.WHITE],
		[MasterTools.Type.KNIGHT , MasterTools.MyColor.WHITE],
		[MasterTools.Type.BISHOP , MasterTools.MyColor.WHITE],
		[MasterTools.Type.QUEEN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.KING , MasterTools.MyColor.WHITE],
		[MasterTools.Type.BISHOP, MasterTools.MyColor.WHITE],
		[MasterTools.Type.KNIGHT , MasterTools.MyColor.WHITE],
		[MasterTools.Type.ROOK , MasterTools.MyColor.WHITE],
	],
	[
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
		[MasterTools.Type.PAWN , MasterTools.MyColor.WHITE],
	],
	[
		[],[],[],[],[],[],[],[]
	],
	[
		[],[],[],[],[],[],[],[]
	],
	[
		[],[],[],[],[],[],[],[]
	],
	[
		[],[],[],[],[],[],[],[]
	],
	[
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.PAWN , MasterTools.MyColor.BLACK],
	],
	[
		[MasterTools.Type.ROOK , MasterTools.MyColor.BLACK],
		[MasterTools.Type.KNIGHT , MasterTools.MyColor.BLACK],
		[MasterTools.Type.BISHOP , MasterTools.MyColor.BLACK],
		[MasterTools.Type.QUEEN , MasterTools.MyColor.BLACK],
		[MasterTools.Type.KING , MasterTools.MyColor.BLACK],
		[MasterTools.Type.BISHOP, MasterTools.MyColor.BLACK],
		[MasterTools.Type.KNIGHT , MasterTools.MyColor.BLACK],
		[MasterTools.Type.ROOK , MasterTools.MyColor.BLACK],
	],
]


func _ready() -> void:
	MasterTools.on_piece_arrived.connect(on_piece_arrived)
	MasterTools.marco_space.connect(on_marco_space)
	colorize()
	place_piece()

func place_piece()->void:
	if setup_positions[my_cords.y][my_cords.x] != []:
		piece_holder.place_piece(
			setup_positions[my_cords.y][my_cords.x][0],
			setup_positions[my_cords.y][my_cords.x][1],
			$"."
			)

func colorize()->void:
	@warning_ignore("integer_division")
	if my_cords.x/2 == float(my_cords.x)/2:
		@warning_ignore("integer_division")
		if my_cords.y/2 == float(my_cords.y)/2:
			$Mesh.mesh.surface_set_material(0,BLACK)
		else:
			$Mesh.mesh.surface_set_material(0,WHITE)
	else:
		@warning_ignore("integer_division")
		if my_cords.y/2 == float(my_cords.y)/2:
			$Mesh.mesh.surface_set_material(0,WHITE)
		else:
			$Mesh.mesh.surface_set_material(0,BLACK)


func on_piece_arrived(who:Piece , cords:Vector2i)->void:
	if cords == my_cords:
		occupant = who


func on_marco_space(cords:Vector2i)->void:
	if cords == my_cords:
		MasterTools.polo.emit($".", my_cords)






















#Stop Shortening
