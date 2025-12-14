extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_button_pressed() -> void:
	Player_globals.level_counter = 1
	if len(Player_globals.cards) > 0:
		var new_cards = []
		for i in range(0,min(5,len(Player_globals.cards))):
			var card_random = Player_globals.cards.pick_random()
			Player_globals.cards.remove_at(Player_globals.cards.find(card_random))
			new_cards.append(card_random)
		for i in range(len(new_cards)):
			Player_globals.add_card(new_cards[i])
	get_tree().change_scene_to_file("res://Scenes/Casino.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
