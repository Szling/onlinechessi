extends State

@export var idle_state : State
@export var wait_state : State

var can_transfer : bool = false

func enter()->void:
	super.enter()
	can_transfer = false
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("undo"):
		master.cur_piece.fall()
		master.cur_piece = null
		idle_state.enter()
	
	elif Input.is_action_just_released("select"):
		can_transfer = true
	
	elif Input.is_action_just_pressed("select"):
		if ClientNetworkGlobals.current_turn != MasterTools.MyColor.NONE:
			if ClientNetworkGlobals.current_turn == ClientNetworkGlobals.clr:
				if master.target:
					if master.target is Space:
						master.cur_move.end = master.target.my_cords
						master.cur_space = master.target
					elif master.target is Piece and can_transfer == true:
						master.cur_space = master.target.location
						master.cur_move.end = master.cur_space.my_cords
					else:
						return
					
					if NetworkHandler.is_server:
						ServerNetworkGlobals.judge_move(master.cur_move,1,PacketInfo.ActionType.REQUEST)
					else:
						MovePacket.create(master.cur_move,PacketInfo.ActionType.REQUEST).send(NetworkHandler.server)
					wait_state.enter()
















#Stop Shortening
