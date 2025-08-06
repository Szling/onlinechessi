extends MeshInstance3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		look_at($"../Pawn3".global_position)
