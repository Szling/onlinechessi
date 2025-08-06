extends State

@export var sit_state : State

func enter()->void:
	super.enter()
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var dist_left : Vector3 = master.location.touch_point - master.global_position
	if dist_left.length() > master.round_moves:
		master.velocity = dist_left.normalized() * master.v_speed
		if master.velocity.length() * delta > dist_left.length():
			master.velocity = dist_left / delta
		master.move_and_slide()
	else:
		master.global_position = master.location.touch_point
		sit_state.enter()
