extends Area2D

@onready var popup_image: Sprite2D = $PopupImage

var is_showing: bool = false

func _ready():
	popup_image.visible = false
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if is_showing:
		return

	show_graphic_for_seconds(5.0)

func show_graphic_for_seconds(duration: float):
	is_showing = true
	
	popup_image.visible = true
	
	await get_tree().create_timer(duration).timeout
	
	popup_image.visible = false
	
	is_showing = false
