extends Area2D

var target_scene_path = "res://Scenes/main_menu.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		change_level()

func change_level():
	if target_scene_path == "":
		print("Błąd: Nie ustawiono ścieżki do sceny w Inspektorze!")
		return
		
	get_tree().change_scene_to_file(target_scene_path)
