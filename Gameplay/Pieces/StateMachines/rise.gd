extends State



func enter()->void:
	super.enter()
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var rise_point : Vector3 = master.location.touch_point + master.rise_offset
	var dist_left : Vector3 = rise_point - master.global_position
	if dist_left.length() > master.round_moves:
		master.velocity = dist_left.normalized() * master.v_speed
		if master.velocity.length() * delta > dist_left.length():
			master.velocity = dist_left / delta
		master.move_and_slide()
	else:
		master.global_position = rise_point
		exit()
