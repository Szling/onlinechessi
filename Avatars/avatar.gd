extends Node3D


var speed : float = 4
var look_speed : float = 0.05
var looking : bool

var min_v : float = 4
var max_v : float = 14
var max_h : float = 14


const BLACK = preload("res://Gameplay/Pieces/Materials/PlaceholderBlack.tres")
const WHITE = preload("res://Gameplay/Pieces/Materials/PlaceholderWhite.tres")

var target : CharacterBody3D
var cur_piece : Piece
var cur_space : Space
var cur_move : Move


func _ready() -> void:
	$WhiteHand/HandMesh.mesh.surface_set_material(0,WHITE)
	$BlackHand/HandMesh.mesh.surface_set_material(0,BLACK)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and looking:
		rotate_look(event.relative)


func rotate_look(rot_vector: Vector2)->void:
	$Camera3D.rotation.x += rot_vector.y * look_speed/TAU
	if $Camera3D.rotation.x < -0.20 * TAU:
		$Camera3D.rotation.x = -0.20 * TAU
	elif $Camera3D.rotation.x > 0.037 * TAU:
		$Camera3D.rotation.x = 0.037 * TAU
	$Camera3D.rotation.y += rot_vector.x * look_speed/TAU


func _physics_process(delta: float) -> void:
	var input_dir = Vector3(
		Input.get_axis("fly_left","fly_right") , 
		Input.get_axis("fly_down","fly_up") ,
		Input.get_axis("fly_fw","fly_bw") , 
		)
	
	var dir: Vector3 = $Camera3D.transform.basis * Vector3(input_dir.x, 0, input_dir.z).normalized()
	dir.y = input_dir.y
	
	if position.y < min_v and dir.y < 0:
		dir.y = 0
	elif position.y > max_v and dir.y > 0:
		dir.y = 0
	
	if position.x > max_h and dir.x >0:
		dir.x = 0
	elif position.x < max_h*-1 and dir.x<0:
		dir.x = 0
	
	if position.z > max_h and dir.z > 0:
		dir.z = 0
	elif position.z < max_h * -1 and dir.z < 0:
		dir.z = 0
	
	
	position += dir * speed * delta
	
	if Input.is_action_pressed("look"):
		looking = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		looking = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



























#Stop Shorening
