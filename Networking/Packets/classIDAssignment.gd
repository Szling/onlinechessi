extends PacketInfo
class_name IDAssignment

var id : int

static func create(new_id:int)->IDAssignment:
	var info : IDAssignment = IDAssignment.new()
	info.packet_type = PacketType.ID_ASSIGNMENT
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.id = new_id
	return info

static func create_from_data(data:PackedByteArray)->IDAssignment:
	var info : IDAssignment = IDAssignment.new()
	info.decode(data)
	return info

func encode()->PackedByteArray:
	var data :PackedByteArray = super.encode()
	data.resize(2)
	data.encode_u8(1,id)
	return data

func decode(data:PackedByteArray)->void:
	super.decode(data)
	flag = ENetPacketPeer.FLAG_RELIABLE
	id = data.decode_u8(1)
























#Stop Shortening
