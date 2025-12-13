extends Control

const GAME_SCENE_PATH = "res://Scenes/Levels/level_01.tscn"
const TUTORIAL_SCENE_PATH = "res://Scenes/Levels/level_tutorial.tscn"

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/TutorialButton.pressed.connect(_on_tutorial_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_tutorial_pressed():
	get_tree().change_scene_to_file(TUTORIAL_SCENE_PATH)

func _on_quit_pressed():
	get_tree().quit()
