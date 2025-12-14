extends Area2D

@export var screens: Array[Texture2D] 
@export var cooldown_time: float = 2.0
@export var luck_bar: ProgressBar 

# Tablica na dźwięki
@export var scroll_sounds: Array[AudioStream]

@onready var sprite = $Sprite2D

# USUNĄŁEM stare zmienne audio_player i timer, bo one powodowały błędy
# i nie są potrzebne w nowej metodzie.

var current_index: int = 0
var is_mouse_over: bool = false
var can_scroll: bool = true 

func _ready():
	randomize()
	
	# Tutaj usunąłem konfigurację Timera, bo teraz tworzymy go dynamicznie
	
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
			
			play_scroll_sound() # Wywołujemy nową funkcję
			
			if luck_bar:
				luck_bar.add_luck()
			
			start_cooldown()

# --- NOWA, CAŁKOWICIE ZMIENIONA FUNKCJA ---
func play_scroll_sound():
	if scroll_sounds.is_empty():
		return 

	var random_sound = scroll_sounds.pick_random()
	
	# 1. Tworzymy nowy odtwarzacz w kodzie (nie potrzebujemy go w Scenie)
	var temp_player = AudioStreamPlayer.new()
	add_child(temp_player) # Dodajemy go do gry
	temp_player.stream = random_sound
	
	# 2. Odpalamy dźwięk
	temp_player.play()
	
	# 3. Ustawiamy "bombę zegarową"
	# Po 5 sekundach wywoła queue_free(), co usunie odtwarzacz i utnie dźwięk
	var timer = get_tree().create_timer(5.0)
	timer.timeout.connect(temp_player.queue_free)
	
	# 4. (Opcjonalnie) Jeśli dźwięk jest krótki, usuń go od razu jak się skończy,
	# żeby nie śmiecić w pamięci.
	temp_player.finished.connect(temp_player.queue_free)

# Funkcja _on_timer_timeout nie jest już potrzebna.

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
