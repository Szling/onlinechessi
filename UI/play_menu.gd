extends Control

@onready var body: ScrollContainer = $MarginContainer/HBoxContainer/VBoxContainer/Body
@onready var msg_box: VBoxContainer = $MarginContainer/HBoxContainer/MSGBox


@onready var button_holder: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Body/VBoxContainer

## Individual buttons referenced here because they need to be toggled
@onready var become_white: Button = $MarginContainer/HBoxContainer/VBoxContainer/Body/VBoxContainer/BecomeWhite
@onready var become_black: Button = $MarginContainer/HBoxContainer/VBoxContainer/Body/VBoxContainer/BecomeBlack
@onready var abandon_color: Button = $MarginContainer/HBoxContainer/VBoxContainer/Body/VBoxContainer/AbandonColor
@onready var clear_colors: Button = $MarginContainer/HBoxContainer/VBoxContainer/Body/VBoxContainer/ClearColors


const MSG_LABEL = preload("res://UI/msg_label.tscn")

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug"):
		#display_message("Hello there little bug",MasterTools.MyColor.BLACK)
	#elif event.is_action_pressed("debug_also"):
		#display_message("Not many visit our humble town these days", MasterTools.MyColor.WHITE)

func _ready() -> void:
	MasterTools.on_to_main.connect(queue_free)
	ClientNetworkGlobals.on_client_message.connect(display_message)
	update()


func _on_open_pressed() -> void:
	if body.visible:
		close()
	else:
		open()


func open()->void:
	update()
	body.visible = true

func update()->void:
	if ClientNetworkGlobals.clr == MasterTools.MyColor.NONE:
		become_white.visible = true
		button_holder.get_child(become_white.get_index()+1).visible = true
		become_black.visible = true
		button_holder.get_child(become_black.get_index()+1).visible = true
		
		abandon_color.visible = false
		button_holder.get_child(abandon_color.get_index()+1).visible = false
	else:
		become_white.visible = false
		button_holder.get_child(become_white.get_index()+1).visible = false
		become_black.visible = false
		button_holder.get_child(become_black.get_index()+1).visible = false
		
		abandon_color.visible = true
		button_holder.get_child(abandon_color.get_index()+1).visible = true
	
	if NetworkHandler.is_server:
		clear_colors.visible = true
		button_holder.get_child(clear_colors.get_index()+1).visible = true
	else:
		clear_colors.visible = false
		button_holder.get_child(clear_colors.get_index()+1).visible = false


func close()->void:
	body.visible = false


func display_message(msg:String, clr: MasterTools.MyColor)->void:
	if msg.contains("White") or msg.contains("Black"):
		update()
	var a = MSG_LABEL.instantiate()
	a.msg = msg 
	a.clr = clr
	msg_box.call_deferred("add_child", a)


func _on_become_white_pressed() -> void:
	if NetworkHandler.is_server:
		ServerNetworkGlobals.judge_packet_assignment(ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.REQUEST,MasterTools.MyColor.WHITE),1)
	else:
		ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.REQUEST,MasterTools.MyColor.WHITE).send(NetworkHandler.server)

func _on_become_black_pressed() -> void:
	if NetworkHandler.is_server:
		ServerNetworkGlobals.judge_packet_assignment(ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.REQUEST,MasterTools.MyColor.BLACK),1)
	else:
		ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.REQUEST,MasterTools.MyColor.BLACK).send(NetworkHandler.server)

func _on_abandon_color_pressed() -> void:
	if NetworkHandler.is_server:
		ServerNetworkGlobals.judge_packet_assignment(ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.ABANDON,ClientNetworkGlobals.clr),1)
	else:
		ColorAssignment.create(ClientNetworkGlobals.id,PacketInfo.ActionType.ABANDON,ClientNetworkGlobals.clr).send(NetworkHandler.server)


func _on_clear_colors_pressed() -> void:
	if NetworkHandler.is_server:
		ServerNetworkGlobals.judge_packet_assignment(ColorAssignment.create(ServerNetworkGlobals.current_black,PacketInfo.ActionType.ABANDON,MasterTools.MyColor.BLACK),ServerNetworkGlobals.current_black)
		ServerNetworkGlobals.judge_packet_assignment(ColorAssignment.create(ServerNetworkGlobals.current_white,PacketInfo.ActionType.ABANDON,MasterTools.MyColor.WHITE),ServerNetworkGlobals.current_white)


func _on_to_main_pressed() -> void:
	MasterTools.on_to_main.emit()
	if NetworkHandler.is_server:
		NetworkHandler.stop_server()
	else:
		NetworkHandler.server.peer_disconnect()
