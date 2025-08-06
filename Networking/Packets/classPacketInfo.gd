class_name PacketInfo

enum PacketType {
	ID_ASSIGNMENT  = 0,
	COLOR_ASSIGNMENT = 3,
	TOUCH = 5,
	TURN_PASS = 8,
	MOVE = 9,
	MESSAGE = 20,
}


enum ActionType {
	UNDEFINED  = 0,
	REQUEST = 1,
	ABANDON = 2,
	CONFIRM = 10,
	DENY = 11,
}

var packet_type : PacketType
var flag : int



func encode()->PackedByteArray:
	var data : PackedByteArray
	data.resize(1)
	data.encode_u8(0,packet_type)
	return data

func decode(data:PackedByteArray)->void:
	packet_type = data.decode_u8(0) as PacketInfo.PacketType

func send(target:ENetPacketPeer)->void:
	target.send(0,encode(),flag)

func broadcast(connection:ENetConnection)->void:
	connection.broadcast(0,encode(),flag)
