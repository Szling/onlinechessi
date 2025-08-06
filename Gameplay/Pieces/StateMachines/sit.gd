extends State

func enter()->void:
	super.enter()
	MasterTools.on_piece_arrived.emit(master , master.location.my_cords)
	master.global_position = master.location.touch_point
	if master.my_color == ClientNetworkGlobals.clr and ClientNetworkGlobals.clr == ClientNetworkGlobals.current_turn:
		if NetworkHandler.is_server:
			ServerNetworkGlobals.judge_turn_pass(TurnPass.create(master.my_color,PacketInfo.ActionType.REQUEST),1)
		else:
			TurnPass.create(master.my_color,PacketInfo.ActionType.REQUEST).send(NetworkHandler.server)
	exit()
