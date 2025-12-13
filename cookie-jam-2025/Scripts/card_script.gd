extends Node2D

@export var card_id := 0
@export var tier := 0
@export var selected := false

var positive_modifier : Modifier
var negative_modifier : Modifier
	

func _ready():
	await get_tree().create_timer(0.1).timeout
	var mod_n =len(Player_globals.cards[card_id].modifiers)
	var aug_n =len(Player_globals.cards[card_id].augments)
	print(Player_globals.cards[card_id].modifiers, Player_globals.cards[card_id].augments)
	match  mod_n:
		2:
			positive_modifier= Player_globals.cards[card_id].modifiers[0]
			negative_modifier= Player_globals.cards[card_id].modifiers[1]
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
		1:
			positive_modifier= Player_globals.cards[card_id].modifiers[0]
			var negative_augment 
			if aug_n>0: negative_augment = Player_globals.cards[card_id].augments[0]
			else: negative_augment = ""
			$PContainer/Positive.visible = false
			$NContainer/Negative.visible = false
			$Figure.frame=tier
			var type : String
			var value : String
			var stat : String
			stat = str(positive_modifier.stat)
			if positive_modifier.type == 'a': 
				if positive_modifier.value>0:type = '+'
				else: type="" 
				value = str(positive_modifier.value)
			else: 
				type = "x"
				value = str(1+positive_modifier.value)
	
			$PContainer/Positive.text = type + value + " " + stat
			$NContainer/Negative.text = str(negative_augment)
		0:
			var positive_augment
			var negative_augment
			if aug_n>0: positive_augment = Player_globals.cards[card_id].augments[0]
			else: positive_augment = ""
			if aug_n>1: negative_augment = Player_globals.cards[card_id].augments[1]
			else: negative_augment = ""
			$PContainer/Positive.visible = false
			$NContainer/Negative.visible = false
			$Figure.frame=tier
			$PContainer/Positive.text = str(positive_augment)
			$NContainer/Negative.text = str(negative_augment)
			
@warning_ignore("unused_parameter")
func _on_hitbox_mouse_shape_entered(shape_idx):
	var can_be_selected = true
	for sibling in get_parent().get_children():
		if sibling.selected == true:
			can_be_selected = false
	if can_be_selected:
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
