extends Modifier
class_name Card

var card_name : String
var modifiers : Array[Modifier]
var augments : Array[String]


func _init(_name = "", _mods =[], _augments=[]):
	card_name = _name
	modifiers = _mods
	augments = _augments
