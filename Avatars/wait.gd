extends State

@export var idle_state : State

func _ready() -> void:
	ClientNetworkGlobals.on_move_answer.connect(on_move_answer)


func on_move_answer(move:Move , answer:PacketInfo.ActionType)->void:
	if is_processing():
		if !move.match_header(master.cur_move):
			return
		match answer:
			PacketInfo.ActionType.DENY:
				master.cur_piece = null
				master.cur_space = null
				master.cur_move = null
				idle_state.enter()
			PacketInfo.ActionType.CONFIRM:
				exit()
			_:
				printerr("Unexpected answer about a move")
