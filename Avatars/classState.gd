extends Node
class_name State

@export var master : Node3D

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func enter() -> void:
	for c in get_parent().get_children():
		if c is State and c !=$".":
			c.exit()
	set_process(true)

func exit() -> void:
	set_process(false)
	set_physics_process(false)
