extends CharacterBody3D
class_name Piece

@export var my_color : MasterTools.MyColor
@export var my_type : MasterTools.Type = MasterTools.Type.UNKOWN

var location : CharacterBody3D
var awaiting_new_location : bool = false

var touch_point : Vector3 :
	get : return $TouchMark.global_position


const BLACK = preload("res://Gameplay/Pieces/Materials/PlaceholderBlack.tres")
const WHITE = preload("res://Gameplay/Pieces/Materials/PlaceholderWhite.tres")


## Movement Variables
var round_moves : float = 0.02
var rise_offset : Vector3 = Vector3(0,3,0)
var v_speed : float = 6
var h_speed : float = 15


func _ready() -> void:
	ClientNetworkGlobals.on_move_answer.connect(on_move_answer)
	MasterTools.polo.connect(on_polo)
	MasterTools.on_piece_arrived.connect(on_piece_arrived)
	MasterTools.marco_piece.connect(on_marco_piece)
	match my_color:
			MasterTools.MyColor.WHITE:
				$MeshInstance3D.mesh.surface_set_material(0,WHITE)
			MasterTools.MyColor.BLACK:
				$MeshInstance3D.mesh.surface_set_material(0,BLACK)
				rotation.y = 0.5 * TAU
			_:
				printerr("No color Selected for ", name)
	for c in $StateMachine.get_children():
		if c is State:
			c.master = $"."
	place()


func place()->void:
	global_position = location.touch_point
	location.occupant = $"."

func capture()->void:
	queue_free()

func rise()->void:
	$StateMachine/Rise.enter()

func fall()->void:
	$StateMachine/Fall.enter()

func fly()->void:
	$StateMachine/Fly.enter()

func on_piece_arrived(who:Piece,cords:Vector2i)->void:
	if cords == location.my_cords and who != $".":
		capture()

func on_move_answer(move:Move , action:PacketInfo.ActionType)->void:
	if move.start != location.my_cords:
		return
	
	if move.type == my_type and move.clr == my_color:
		match action:
			PacketInfo.ActionType.DENY:
				fall()
			PacketInfo.ActionType.CONFIRM:
				awaiting_new_location = true
				MasterTools.marco_space.emit(move.end)
				await get_tree().physics_frame
				fly() 
			_:
				printerr(name," recived an unexpected answer about a move")

func on_marco_piece(cords:Vector2i)->void:
	if cords == location.my_cords:
		MasterTools.polo.emit($".", location.my_cords)

func on_polo(who:CharacterBody3D,_cords:Vector2i)->void:
	if awaiting_new_location == true and who is Space:
		location = who
		awaiting_new_location = false
























#Stop Shortening
