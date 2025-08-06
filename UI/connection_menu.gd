extends ColorRect

enum ConnectMode {
	CONNECT = 0,
	HOST = 1,
}

var current_mode : ConnectMode = ConnectMode.CONNECT

@onready var do_the_thing: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonContainer/DoTheThing
@onready var line_ip: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer/IPInput/LineEdit
@onready var line_port: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer/PortInput/LineEdit


func open(new_mode: ConnectMode)->void:
	current_mode = new_mode
	update()
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
	visible = true

func update()->void:
	match current_mode:
		ConnectMode.CONNECT:
			do_the_thing.text = "Connect to server"
		ConnectMode.HOST:
			do_the_thing.text = "Host Server"

func close()->void:
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	visible = false


func _on_back_pressed() -> void:
	close()


func _on_do_the_thing_pressed() -> void:
	match current_mode:
		ConnectMode.HOST:
			NetworkHandler.start_server(line_ip.text,int(line_port.text))
		ConnectMode.CONNECT:
			NetworkHandler.start_client(line_ip.text,int(line_port.text))


























#Stop Shortening
