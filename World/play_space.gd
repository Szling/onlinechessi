extends Node3D

func _ready() -> void:
	MasterTools.on_to_main.connect(queue_free)
