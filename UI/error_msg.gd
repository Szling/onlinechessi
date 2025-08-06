extends ColorRect

@onready var msg_label: Label = $VBoxContainer/Label


func _ready() -> void:
	NetworkHandler.startup_failed.connect(open)

func open(msg:String)->void:
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
	msg_label.text = msg
	visible = true

func close()->void:
	mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	visible = false


func _on_close_pressed() -> void:
	close()
