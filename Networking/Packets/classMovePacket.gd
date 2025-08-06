extends PacketInfo
class_name MovePacket

var move : Move
var act_type : PacketInfo.ActionType

static func create(this_move:Move , action_type:PacketInfo.ActionType)->MovePacket:
	var info : MovePacket = MovePacket.new()
	info.packet_type = PacketType.MOVE
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.act_type = action_type
	info.move = this_move
	return info


static func create_from_data(data:PackedByteArray)->MovePacket:
	var info : MovePacket = MovePacket.new()
	info.decode(data)
	return info

func extract()->Move:
	return move

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(8)
	data.encode_u8(1,act_type)
	data.encode_u8(2,move.clr)
	data.encode_u8(3,move.type)
	data.encode_u8(4,move.start.x)
	data.encode_u8(5,move.start.y)
	data.encode_u8(6,move.end.x)
	data.encode_u8(7,move.end.y)
	
	if move.capture:
		data.resize(10)
		data.encode_u8(8,move.victim_clr)
		data.encode_u8(9,move.victim_type)
	
	return data

func decode(data:PackedByteArray)->void:
	super.decode(data)
	flag = ENetPacketPeer.FLAG_RELIABLE
	act_type = data.decode_u8(1) as PacketInfo.ActionType
	move = Move.new()
	move.clr = data.decode_u8(2) as MasterTools.MyColor
	move.type = data.decode_u8(3) as MasterTools.Type
	move.start.x = data.decode_u8(4)
	move.start.y = data.decode_u8(5)
	move.end.x = data.decode_u8(6)
	move.end.y = data.decode_u8(7)
	
	if data.size() == 8:
		return
	
	move.capture = true
	move.victim_clr = data.decode_u8(8) as MasterTools.MyColor
	move.victim_type =  data.decode_u8(9) as MasterTools.Type























#Stop Shorening
