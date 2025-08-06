extends PacketInfo
class_name Touch

var clr : MasterTools.MyColor
var visible : bool = false
var position : Vector3 = Vector3(0,0,0)

static func create(new_clr:MasterTools.MyColor ,is_visible:bool, pos: Vector3 = Vector3(0,0,0))->Touch:
	var info : Touch = Touch.new()
	info.packet_type = PacketType.TOUCH
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.clr = new_clr
	info.visible = is_visible
	info.position = pos
	return info

static func create_from_data(data:PackedByteArray)->Touch:
	var info : Touch = Touch.new()
	info.decode(data)
	return info

func encode()->PackedByteArray:
	var data : PackedByteArray = super.encode()
	if visible:
		data.resize(14)
		data.encode_u8(1,clr)
		data.encode_float(2,position.x)
		data.encode_float(6,position.y)
		data.encode_float(10,position.z)
	else:
		data.resize(2)
		data.encode_u8(1,clr)
	return data

func decode(data:PackedByteArray)->void:
	super.decode(data)
	clr = data.decode_u8(1) as MasterTools.MyColor
	if data.size() == 2:
		return
	
	visible = true
	position = Vector3(
		data.decode_float(2),
		data.decode_float(6),
		data.decode_float(10)
	)
