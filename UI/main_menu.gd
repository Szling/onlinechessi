extends ColorRect

enum ConnectMode {
	CONNECT = 0,
	HOST = 1,
}

@onready var connection_menu: ColorRect = $"Connection Menu"
@onready var connection_lost: Label = $MarginContainer/HBoxContainer/VBoxContainer2/ConnectionLost

func _ready() -> void:
	NetworkHandler.on_server_started.connect(queue_free)
	NetworkHandler.on_connected_to_server.connect(queue_free)
	connection_lost.visible = ClientNetworkGlobals.previous_connection

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_host_pressed() -> void:
	connection_menu.open(ConnectMode.HOST)



func _on_connect_pressed() -> void:
	connection_menu.open(ConnectMode.CONNECT)
