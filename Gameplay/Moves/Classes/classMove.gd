extends Resource
class_name Move

var clr : MasterTools.MyColor = MasterTools.MyColor.NONE
var type : MasterTools.Type = MasterTools.Type.UNKOWN

var start : Vector2i
var end : Vector2i

var capture : bool = false
var victim_clr : MasterTools.MyColor = MasterTools.MyColor.NONE
var victim_type : MasterTools.Type = MasterTools.Type.UNKOWN


func match_header(other:Move)->bool:
	if other.clr == clr:
		if other.type == type:
			if other.start == start:
				if other.end == end:
					if other.capture == capture:
						return true
	return false


func match_victim(other:Move)->bool:
	if other.victim_clr == victim_clr:
		if other.victim_type == victim_type:
			return true
	return false

func match_full(other:Move)->bool:
	if match_header(other) and match_victim(other):
		return true
	return false
