extends Node

signal on_touch(touch:Touch)
signal on_client_message(msg:String , clr:MasterTools.MyColor)
signal on_move_answer(move:Move , action: PacketInfo.ActionType)


var id : int = -1
var previous_connection : bool

var clr : MasterTools.MyColor = MasterTools.MyColor.NONE

var current_turn : MasterTools.MyColor = MasterTools.MyColor.NONE

func _ready() -> void:
	NetworkHandler.on_client_packet.connect(on_client_packet)
	NetworkHandler.on_disconnected_from_server.connect(on_disconnected_from_server)


func on_client_packet(data:PackedByteArray)->void:
	var packet_type : int =  data.decode_u8(0)
	match packet_type:
		PacketInfo.PacketType.ID_ASSIGNMENT:
			manage_id(IDAssignment.create_from_data(data))
		PacketInfo.PacketType.TOUCH:
			on_touch.emit(Touch.create_from_data(data))
		PacketInfo.PacketType.COLOR_ASSIGNMENT:
			manage_color_assignment(ColorAssignment.create_from_data(data))
		PacketInfo.PacketType.TURN_PASS:
			manage_turn_pass(TurnPass.create_from_data(data))
		PacketInfo.PacketType.MOVE:
			manage_move(MovePacket.create_from_data(data).extract() , data.decode_u8(1) as PacketInfo.ActionType)
			
		


func manage_id(id_assignment:IDAssignment)->void:
	if NetworkHandler.is_server:
		id = 1
	elif id == -1:
		id = id_assignment.id

func manage_turn_pass(packet:TurnPass)->void:
	if packet.act_type == PacketInfo.ActionType.CONFIRM:
		current_turn = packet.clr
		var adder : String = ""
		match packet.clr:
			MasterTools.MyColor.BLACK:
				adder = "Black"
			MasterTools.MyColor.WHITE:
				adder = "White"
		var msg : String = "It is now " + adder + "'s turn."
		on_client_message.emit(msg , packet.clr)


func manage_color_assignment(packet:ColorAssignment)->void:
	var adder : String = "placeholder"
	match packet.clr:
		MasterTools.MyColor.BLACK:
			adder = "Black"
		MasterTools.MyColor.WHITE:
			adder = "White"
	
	if packet.act_type == PacketInfo.ActionType.DENY:
		if packet.id != id:
			return
		var msg : String = "You cannot become " + adder + " right now. There is already a " + adder + " player."
		on_client_message.emit(msg,packet.clr)
	else:
		if packet.act_type == PacketInfo.ActionType.CONFIRM:
			if packet.id == id:
				clr = packet.clr
				var msg : String = "You are now " + adder
				on_client_message.emit(msg,packet.clr)
			else:
				if packet.clr == clr:
					clr = MasterTools.MyColor.NONE
					var msg : String = "You are no longer " + adder
					on_client_message.emit(msg,packet.clr)
				if packet.id == 254:
					var msg : String = adder + " is now available."
					on_client_message.emit(msg,packet.clr)
				else:
					var msg : String = "Player " + str(packet.id) + " is now " + adder + "."
					on_client_message.emit(msg,packet.clr)


func on_disconnected_from_server()->void:
	id = -1
	clr = MasterTools.MyColor.NONE
	previous_connection = true
	MasterTools.on_to_main.emit()


func manage_move(move:Move , act_type:PacketInfo.ActionType)->void:
	on_move_answer.emit(move , act_type)

































#Stop shortening
