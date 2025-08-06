extends State

@export var pick_state : State


func _ready() -> void:
	super._ready()
	ClientNetworkGlobals.on_client_message.connect(check_client_message)
	enter()


func check_client_message(msg:String , clr:MasterTools.MyColor)->void:
	if msg.contains("'s turn.") and clr==ClientNetworkGlobals.clr:
		enter()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		if ClientNetworkGlobals.current_turn != MasterTools.MyColor.NONE:
			if ClientNetworkGlobals.current_turn == ClientNetworkGlobals.clr:
				if master.target:
					if master.target is Piece and master.target.my_color == ClientNetworkGlobals.clr:
						master.cur_piece = master.target
						master.cur_move = Move.new()
						master.cur_move.clr = master.target.my_color
						master.cur_move.type = master.target.my_type
						master.cur_move.start = master.target.location.my_cords
						master.target.rise()
						pick_state.enter()
