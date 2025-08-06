extends Camera3D

@onready var physics_server : PhysicsDirectSpaceState3D=get_viewport().world_3d.direct_space_state

@export var white_hand : Node3D
@export var black_hand : Node3D

var last_hand : Array = [false,Vector3(0,0,0)]

#func _input(event: InputEvent) -> void:
	#pass

func _ready() -> void:
	ClientNetworkGlobals.on_touch.connect(relay_touch)

func _process(delta: float) -> void:
	find_touch()

func find_touch()->void:
	match ClientNetworkGlobals.clr:
		MasterTools.MyColor.WHITE:
			if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
				white_hand.visible = false
			else:
				var t = find_target([1,4])
				if t:
					$"..".target = t
					white_hand.global_position = t.touch_point
					white_hand.visible = true
				else:
					$"..".target = null
					white_hand.visible = false
			
			if NetworkHandler.connection or NetworkHandler.server:
				if white_hand.visible != last_hand[0] or white_hand.global_position != last_hand[1]:
					last_hand[0] = white_hand.visible
					last_hand[1] = white_hand.global_position
					if NetworkHandler.is_server:
						Touch.create(MasterTools.MyColor.WHITE,white_hand.visible,white_hand.global_position).broadcast(NetworkHandler.connection)
					else:
						Touch.create(MasterTools.MyColor.WHITE,white_hand.visible,white_hand.global_position).send(NetworkHandler.server)
		
		MasterTools.MyColor.BLACK:
			if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
				black_hand.visible = false
			else:
				var t = find_target([1,4])
				if t:
					$"..".target = t
					black_hand.global_position = t.touch_point
					black_hand.visible = true
				else:
					$"..".target = null
					black_hand.visible = false
			
			if NetworkHandler.connection or NetworkHandler.server:
				if black_hand.visible != last_hand[0] or black_hand.global_position != last_hand[1]:
					last_hand[0] = black_hand.visible
					last_hand[1] = black_hand.global_position
					if NetworkHandler.is_server:
						Touch.create(MasterTools.MyColor.BLACK,black_hand.visible,black_hand.global_position).broadcast(NetworkHandler.connection)
					else:
						Touch.create(MasterTools.MyColor.BLACK,black_hand.visible,black_hand.global_position).send(NetworkHandler.server)


func find_target(layers:Array[int]) -> CharacterBody3D:
	var s : Vector3 = global_position
	var m : Vector2 = get_viewport().get_mouse_position()
	var e = project_ray_normal(m)
	e *= 128
	e += s
	var l : int = 0
	for i in layers:
		@warning_ignore("narrowing_conversion")
		l += pow(2,i-1)
	var d : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(s,e,l)
	d.collide_with_areas = false
	d.collide_with_bodies = true
	var r = physics_server.intersect_ray(d)
	if r:
		return r["collider"]
	else:
		return null


func relay_touch(touch:Touch)->void:
	if touch.clr == ClientNetworkGlobals.clr:
		return
	
	match touch.clr:
		MasterTools.MyColor.WHITE:
			if !touch.visible:
				white_hand.visible = false
			else:
				white_hand.global_position = touch.position
				white_hand.visible = true
		MasterTools.MyColor.BLACK:
			if !touch.visible:
				black_hand.visible = false
			else:
				black_hand.global_position = touch.position
				black_hand.visible = true
