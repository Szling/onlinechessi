extends PacketInfo
class_name TurnPass

var clr : MasterTools.MyColor
var act_type : PacketInfo.ActionType


static func create(new_clr:MasterTools.MyColor , action_type:PacketInfo.ActionType) -> TurnPass:
	var info : TurnPass = TurnPass.new()
	info.packet_type = PacketInfo.PacketType.TURN_PASS
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.clr = new_clr
	info.act_type = action_type
	return info

static func create_from_data(data:PackedByteArray) -> TurnPass:
	var info : TurnPass = TurnPass.new()
	info.decode(data)
	return info


func encode() -> PackedByteArray:
	var data : PackedByteArray = super.encode()
	data.resize(3)
	data.encode_u8(1,clr)
	data.encode_u8(2,act_type)
	return data


func decode(data:PackedByteArray) -> void:
	super.decode(data)
	flag = ENetPacketPeer.FLAG_RELIABLE
	clr = data.decode_u8(1) as MasterTools.MyColor
	act_type = data.decode_u8(2) as PacketInfo.ActionType
	
