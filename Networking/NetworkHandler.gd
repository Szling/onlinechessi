extends Node

##Server Signals
signal on_server_started()
signal on_peer_connected(peer_id:int)
signal on_peer_disconnected(peer_id:int)
signal on_server_packet(peer_id:int , data:PackedByteArray)

##Server variables
var available_peer_ids: Array = range(2,253) ##Use ID 1 for the server, 254 for no one, and 255 for everyone
var client_peers : Dictionary ##[int,ENetPacketPeer]
var shutting_down : bool

##Client Signals
signal on_disconnected_from_server()
signal on_connected_to_server()
signal on_client_packet(data:PackedByteArray)

##Client Variables
var server: ENetPacketPeer

## General Signals
signal startup_failed(msg:String)

## General Variables
var connection : ENetConnection
var is_server : bool


func _process(delta: float) -> void:
	if connection == null:
		return
	elif shutting_down:
		if client_peers == {}:
			printerr("shudown sucessful")
			connection.destroy()
			connection = null
			shutting_down = false
			is_server = false
			return
		else:
			stop_server()
	handle_events()

func handle_events()->void:
	var packet_event : Array = connection.service()
	var event_type : ENetConnection.EventType = packet_event[0]
	
	while event_type != ENetConnection.EventType.EVENT_NONE:
		var peer : ENetPacketPeer = packet_event[1]
		match event_type:
			ENetConnection.EventType.EVENT_ERROR:
				printerr("Packet Resulted in an unknown error")
				return
			ENetConnection.EventType.EVENT_CONNECT:
				if is_server:
					peer_connected(peer)
				else:
					connected_to_server()
			ENetConnection.EventType.EVENT_DISCONNECT:
				if is_server:
					peer_disconnected(peer)
				else:
					disconnected_from_server()
					return
			ENetConnection.EventType.EVENT_RECEIVE:
				if is_server:
					on_server_packet.emit(peer.get_meta("id"),peer.get_packet())
				else:
					on_client_packet.emit(peer.get_packet())
		
		packet_event = connection.service()
		event_type = packet_event[0]


func start_server(ip_adress:String="127.0.0.1",port:int=42069)->void:
	connection = ENetConnection.new()
	var error :Error = connection.create_host_bound(ip_adress,port)
	if error:
		print("Server starting failed: " + error_string(error))
		startup_failed.emit("Failed to start server : " + error_string(error))
		connection = null
		return
		
	print("Server Started")
	on_server_started.emit()
	is_server = true
	ClientNetworkGlobals.manage_id(IDAssignment.create(1))
	ClientNetworkGlobals.manage_turn_pass(TurnPass.create(ServerNetworkGlobals.current_turn,PacketInfo.ActionType.CONFIRM))

func stop_server()->void:
	for i in client_peers.keys():
		client_peers[i].peer_disconnect()
	shutting_down = true

func peer_connected(peer:ENetPacketPeer)->void:
	var peer_id : int = available_peer_ids.pop_front()
	peer.set_meta("id",peer_id)
	client_peers[peer_id] = peer
	print("Peer connected with assinged id ", peer_id)
	on_peer_connected.emit(peer_id)


func peer_disconnected(peer:ENetPacketPeer)->void:
	var peer_id : int = peer.get_meta("id")
	available_peer_ids.push_front(peer_id)
	client_peers.erase(peer_id)
	print("Successfully disconnected player ", peer_id, " from server")
	on_peer_disconnected.emit(peer_id)

func start_client(ip_adress:String="127.0.0.1",port:int=42069)->void:
	connection = ENetConnection.new()
	var error : Error = connection.create_host(1)
	if error:
		print("Client starting failed: " + error_string(error))
		startup_failed.emit("Failed to connect to server " + error_string(error))
		connection = null
		return
	
	print("Client Started")
	server = connection.connect_to_host(ip_adress,port)



func connected_to_server()->void:
	on_connected_to_server.emit()
	print("Sucessfully Connected to Server")
	

func disconnected_from_server()->void:
	print("Sucessfully disconnected from server")
	on_disconnected_from_server.emit()
	connection = null


























#Stop Shortening
