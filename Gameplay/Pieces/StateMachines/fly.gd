extends State

@export var fall_state : State

func enter()->void:
	super.enter()
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var dist_left : Vector3 = Vector3 (
		master.location.touch_point.x - master.global_position.x,
		0,
		master.location.touch_point.z - master.global_position.z
		)
	if dist_left.length() > master.round_moves:
		master.velocity = dist_left.normalized() * master.h_speed
		if master.velocity.length() * delta > dist_left.length():
			master.velocity = dist_left / delta
		master.move_and_slide()
	else:
		fall_state.enter()
