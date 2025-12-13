extends Area2D

@export_multiline var text_to_show: String = "Tutaj wpisz treść porady..."
@export var display_time: float = 5.0

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	canvas_layer.hide()
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		start_tutorial_sequence()

func start_tutorial_sequence() -> void:
	label.text = text_to_show
	canvas_layer.show()
	
	get_tree().paused = true
	
	await get_tree().create_timer(display_time).timeout
	
	get_tree().paused = false
	canvas_layer.hide()
	
	queue_free()
