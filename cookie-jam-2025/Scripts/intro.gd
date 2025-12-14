extends Control

@export var background_images: Array[Texture2D]
@export_multiline var texts: Array[String]

@onready var background_rect: TextureRect = $Background
@onready var info_label: Label = $InfoText
@onready var next_button: Button = $NextButton

var current_index: int = 0
var click_count: int = 0
var can_click: bool = true 

func _ready():
	if background_images.is_empty() or texts.is_empty():
		next_button.disabled = true
		return
	update_display()
	
	next_button.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed():
	if not can_click:
		return

	click_count += 1

	if click_count == 4:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_01.tscn")
		next_button.disabled = true 
		return

	can_click = false
	next_button.disabled = true
	
	current_index += 1
	
	if current_index >= background_images.size():
		current_index = 0
		
	update_display()
	
	await get_tree().create_timer(2.0).timeout
	
	if click_count < 4:
		can_click = true
		next_button.disabled = false

func update_display():
	if current_index < background_images.size():
		background_rect.texture = background_images[current_index]
	
	if current_index < texts.size():
		info_label.text = texts[current_index]
