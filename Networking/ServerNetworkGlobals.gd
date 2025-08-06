extends Node

var peer_ids : Array[int]
var current_white : int = -1
var current_black : int = -1

var current_turn : MasterTools.MyColor = MasterTools.MyColor.WHITE
var game_history : Array[Move]
var awaiting_victim : bool = false
var victim_cords : Vector2i = Vector2i(-1,-1)
var victim : Piece = null


func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)
	MasterTools.polo.connect(on_polo)




func on_peer_connected(peer_id:int)->void:
	peer_ids.append(peer_id)
	IDAssignment.create(peer_id).broadcast(NetworkHandler.connection)
	TurnPass.create(current_turn,PacketInfo.ActionType.CONFIRM).broadcast(NetworkHandler.connection)


func on_peer_disconnected(peer_id:int)->void:
	peer_ids.erase(peer_id)
	if peer_id == current_black:
		judge_packet_assignment(ColorAssignment.create(peer_id,PacketInfo.ActionType.ABANDON,MasterTools.MyColor.BLACK),peer_id)
	elif peer_id == current_white:
		judge_packet_assignment(ColorAssignment.create(peer_id,PacketInfo.ActionType.ABANDON,MasterTools.MyColor.WHITE),peer_id)
	##Create IDUnassignment later if needed

func on_server_packet(peer_id:int,data:PackedByteArray)->void:
	var packet_type : int = data.decode_u8(0)
	match packet_type:
		PacketInfo.PacketType.ID_ASSIGNMENT:
			NetworkHandler.on_client_packet.emit(data)
		PacketInfo.PacketType.TOUCH:
			NetworkHandler.on_client_packet.emit(data)
			NetworkHandler.connection.broadcast(0,data,ENetPacketPeer.FLAG_UNSEQUENCED)
		PacketInfo.PacketType.COLOR_ASSIGNMENT:
			judge_packet_assignment(ColorAssignment.create_from_data(data),peer_id)
		PacketInfo.PacketType.TURN_PASS:
			judge_turn_pass(TurnPass.create_from_data(data),peer_id)
		PacketInfo.PacketType.MOVE:
			judge_move(MovePacket.create_from_data(data).extract() , peer_id , data.decode_u8(1) as PacketInfo.ActionType)

func judge_packet_assignment(packet: ColorAssignment , peer_id:int)->void:
	if peer_id != packet.id:
		return
	## *** For requests ***
	
	if packet.act_type == PacketInfo.ActionType.REQUEST:
		if current_black > 0 and packet.clr == MasterTools.MyColor.BLACK:
			if peer_id == 1:
				ClientNetworkGlobals.manage_color_assignment(ColorAssignment.create(peer_id , PacketInfo.ActionType.DENY , packet.clr))
			else:
				ColorAssignment.create(peer_id , PacketInfo.ActionType.DENY , packet.clr).broadcast(NetworkHandler.connection)
		elif current_white > 0 and packet.clr == MasterTools.MyColor.WHITE:
			if peer_id == 1:
				ClientNetworkGlobals.manage_color_assignment(ColorAssignment.create(peer_id , PacketInfo.ActionType.DENY , packet.clr))
			else:
				ColorAssignment.create(peer_id , PacketInfo.ActionType.DENY , packet.clr).broadcast(NetworkHandler.connection)
		else:
			match packet.clr:
				MasterTools.MyColor.BLACK:
					current_black = peer_id
				MasterTools.MyColor.WHITE:
					current_white = peer_id
				
			ClientNetworkGlobals.manage_color_assignment(ColorAssignment.create(peer_id, PacketInfo.ActionType.CONFIRM , packet.clr))
			ColorAssignment.create(peer_id, PacketInfo.ActionType.CONFIRM , packet.clr).broadcast(NetworkHandler.connection)
	
	## *** For abondonment ***
	
	if packet.act_type == PacketInfo.ActionType.ABANDON:
		match packet.clr:
			MasterTools.MyColor.BLACK:
				if peer_id != current_black:
					return
				current_black = -1
			MasterTools.MyColor.WHITE:
				if peer_id != current_white:
					return
				current_white = -1
		
		ClientNetworkGlobals.manage_color_assignment(ColorAssignment.create(254 , PacketInfo.ActionType.CONFIRM , packet.clr))
		ColorAssignment.create(254 , PacketInfo.ActionType.CONFIRM , packet.clr).broadcast(NetworkHandler.connection)


func judge_turn_pass(packet:TurnPass,peer_id:int)->void:
	if packet.clr != current_turn or packet.act_type != PacketInfo.ActionType.REQUEST:
		return
	
	match packet.clr:
		MasterTools.MyColor.BLACK:
			if peer_id == current_black:
				current_turn = MasterTools.MyColor.WHITE
				ClientNetworkGlobals.manage_turn_pass(TurnPass.create(MasterTools.MyColor.WHITE , PacketInfo.ActionType.CONFIRM))
				TurnPass.create(MasterTools.MyColor.WHITE,PacketInfo.ActionType.CONFIRM).broadcast(NetworkHandler.connection)
		MasterTools.MyColor.WHITE:
			if peer_id == current_white:
				current_turn = MasterTools.MyColor.BLACK
				ClientNetworkGlobals.manage_turn_pass(TurnPass.create(MasterTools.MyColor.BLACK , PacketInfo.ActionType.CONFIRM))
				TurnPass.create(MasterTools.MyColor.BLACK , PacketInfo.ActionType.CONFIRM).broadcast(NetworkHandler.connection)


func judge_move(move:Move , peer_id:int , act_type:PacketInfo.ActionType)->void:
	
	if move.clr != current_turn or act_type != PacketInfo.ActionType.REQUEST:
		return
	match current_turn:
		MasterTools.MyColor.BLACK:
			if peer_id != current_black:
				return
		MasterTools.MyColor.WHITE:
			if peer_id != current_white:
				return
	
	if TestMove.ask(move):
		awaiting_victim = true
		victim_cords = move.end
		MasterTools.marco_piece.emit(move.end)
		await get_tree().physics_frame
		awaiting_victim = false
		if victim:
			move.capture = true
			move.victim_clr = victim.my_color
			move.victim_type = victim.my_type
		victim = null
		victim_cords = Vector2i(-1,-1)
		game_history.append(move)
		ClientNetworkGlobals.manage_move(move , PacketInfo.ActionType.CONFIRM)
		MovePacket.create(move,PacketInfo.ActionType.CONFIRM).broadcast(NetworkHandler.connection)
	else:
		ClientNetworkGlobals.manage_move(move , PacketInfo.ActionType.DENY)
		MovePacket.create(move,PacketInfo.ActionType.DENY).broadcast(NetworkHandler.connection)


func on_polo(who:CharacterBody3D , cords:Vector2i)->void:
	if awaiting_victim and who is Piece:
		if who.location.my_cords == victim_cords:
			victim = who



















#Stop Shortening
