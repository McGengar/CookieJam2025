extends Area2D

@export var screens: Array[Texture2D] 
@export var cooldown_time: float = 2.0
@export var luck_bar: ProgressBar 

@onready var sprite = $Sprite2D

var current_index: int = 0
var is_mouse_over: bool = false
var can_scroll: bool = true 

func _ready():
	randomize()
	
	if screens.size() > 0:
		current_index = randi() % screens.size()
		sprite.texture = screens[current_index]
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	if not luck_bar:
		pass

func _input(event):
	if screens.size() == 0:
		return

	if not is_mouse_over or not can_scroll:
		return
	
	if event is InputEventMouseButton and event.pressed:
		var changed = false 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			
			var new_index = randi() % screens.size()
			
			if screens.size() > 1:
				while new_index == current_index:
					new_index = randi() % screens.size()
			
			current_index = new_index
			changed = true
			
		if changed:
			sprite.texture = screens[current_index]
			
			if luck_bar:
				luck_bar.add_luck()
			
			start_cooldown()

func start_cooldown():
	can_scroll = false 
	modulate = Color(0.7, 0.7, 0.7) 
	
	await get_tree().create_timer(cooldown_time).timeout
	
	can_scroll = true 
	
	if is_mouse_over:
		modulate = Color(1.2, 1.2, 1.2)
	else:
		modulate = Color.WHITE

func _on_mouse_entered():
	is_mouse_over = true
	if can_scroll:
		modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	is_mouse_over = false
	modulate = Color.WHITE
