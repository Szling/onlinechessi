extends PacketInfo
class_name ColorAssignment

var id : int
var act_type : PacketInfo.ActionType
var clr : MasterTools.MyColor

static func create(new_id:int , action_type:PacketInfo.ActionType , new_clr:MasterTools.MyColor)->ColorAssignment:
	var info : ColorAssignment = ColorAssignment.new()
	info.packet_type = PacketType.COLOR_ASSIGNMENT
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.id = new_id
	info.act_type = action_type
	info.clr = new_clr
	return info

static func create_from_data(data:PackedByteArray)->ColorAssignment:
	var info : ColorAssignment = ColorAssignment.new()
	info.decode(data)
	return info

func encode()->PackedByteArray:
	var data = super.encode()
	data.resize(4)
	data.encode_u8(1,id)
	data.encode_u8(2,act_type)
	data.encode_u8(3,clr)
	return data

func decode(data:PackedByteArray)->void:
	super.decode(data)
	flag = ENetPacketPeer.FLAG_RELIABLE
	id = data.decode_u8(1)
	act_type = data.decode_u8(2) as PacketInfo.ActionType
	clr = data.decode_u8(3) as MasterTools.MyColor

































#Stop shorening
