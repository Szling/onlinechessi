extends Node3D

const PLAY_SPACE = preload("res://World/play_space.tscn")
const MAIN_MENU = preload("res://UI/main_menu.tscn")
const PLAY_MENU = preload("res://UI/play_menu.tscn")

@onready var hud_holder: CanvasLayer = $HudHolder


func _ready() -> void:
	NetworkHandler.on_server_started.connect(begin)
	NetworkHandler.on_connected_to_server.connect(begin)
	MasterTools.on_to_main.connect(return_to_main)


func begin()->void:
	call_deferred("add_child",PLAY_SPACE.instantiate())
	hud_holder.call_deferred("add_child",PLAY_MENU.instantiate())


func return_to_main()->void:
	if get_tree().get_first_node_in_group("MainMenu") == null:
		hud_holder.call_deferred("add_child",MAIN_MENU.instantiate())
