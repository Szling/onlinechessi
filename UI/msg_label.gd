extends Label


var msg : String = "Also a Placeholder"
var clr : MasterTools.MyColor = MasterTools.MyColor.WHITE
var duration_step : float = 0.04
var duration : float = 1
var min_duration : float = 1.0



func _ready()->void:
	text = msg
	match clr:
		MasterTools.MyColor.BLACK:
			add_theme_color_override("font_color",Color(0,0,0,1))
			add_theme_color_override("font_outline_color",Color(1,1,1,1))
	duration = msg.length() * duration_step
	if duration < min_duration:
		duration = min_duration
	$Timer.start(duration)


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fade")


func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
