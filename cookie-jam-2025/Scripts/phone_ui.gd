extends Area2D

@export var screens: Array[Texture2D] 
@export var cooldown_time: float = 2.0

# --- NOWE: Odniesienie do paska ---
@export var luck_bar: ProgressBar 
# ----------------------------------

@onready var sprite = $Sprite2D

var current_index: int = 0
var is_mouse_over: bool = false
var can_scroll: bool = true 

func _ready():
	if screens.size() > 0:
		sprite.texture = screens[0]
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	# Automatyczne szukanie paska, jeśli zapomnisz przypisać w Inspektorze
	if not luck_bar:
		# Szuka węzła o nazwie LuckBar w CanvasLayer (dostosuj ścieżkę jeśli masz inną strukturę)
		# Najbezpieczniej jednak przypisać to ręcznie w Inspektorze!
		pass

func _input(event):
	if not is_mouse_over or not can_scroll:
		return
	
	if event is InputEventMouseButton and event.pressed:
		var changed = false 
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_index = (current_index + 1) % screens.size()
			changed = true
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_index -= 1
			if current_index < 0:
				current_index = screens.size() - 1
			changed = true
			
		if changed:
			sprite.texture = screens[current_index]
			
			# --- NOWE: Odnawiamy pasek przy scrollowaniu ---
			if luck_bar:
				luck_bar.add_luck()
			# -----------------------------------------------
			
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
