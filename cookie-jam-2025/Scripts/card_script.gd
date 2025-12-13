extends Node2D

@export var card_id : int = 0
@export var tier = 0
@export var selected = false

var positive_modifier : Modifier
var negative_modifier : Modifier

func _init():
	Player_globals.debug_gen_card()
	positive_modifier= Player_globals.cards[card_id].modifiers[0]
	negative_modifier= Player_globals.cards[card_id].modifiers[1]

func _ready():
	$PContainer/Positive.visible = false
	$NContainer/Negative.visible = false
	$Figure.frame=tier
	var type : String
	var value : String
	var stat : String
	stat = str(positive_modifier.stat)
	if positive_modifier.type == 'a': 
		type = '+' 
		value = str(positive_modifier.value)
	else: 
		type = "x"
		value = str(1+positive_modifier.value)
	
	$PContainer/Positive.text = type + value + " " + stat

	if negative_modifier.type == 'a': 
		type = '-' 
		value = str(abs(negative_modifier.value))
	else: 
		type = "x"
		value = str(1+negative_modifier.value)
	stat = str(negative_modifier.stat)
	$NContainer/Negative.text = type + value + " " + stat

@warning_ignore("unused_parameter")
func _on_hitbox_mouse_shape_entered(shape_idx):
	z_index=1
	selected = true
	$PContainer/Positive.visible = true
	$NContainer/Negative.visible = true
@warning_ignore("unused_parameter")
func _on_hitbox_mouse_shape_exited(shape_idx):
	z_index=0
	selected = false
	$PContainer/Positive.visible = false
	$NContainer/Negative.visible = false
