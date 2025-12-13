extends CharacterBody2D

@onready var shoot_timer = $ShootTimer
@onready var sprite = $Sprite2D # Odniesienie do duszka, żeby nim kręcić

# Ustawienia w Inspektorze
@export var bullet_scene: PackedScene # Tu przeciągnij scenę SlowBullet.tscn
@export var move_speed: float = 100.0
@export var keep_distance: float = 250.0 # Dystans, jaki chce utrzymać
@export var min_distance: float = 150.0 # Jak jest bliżej niż to, zaczyna uciekać
@export var projectiles_count: int = 8 # Ile pocisków w kole

var player: Node2D = null

func _ready():
	# Znajdź gracza (upewnij się, że Gracz jest w grupie "Player")
	player = get_tree().get_first_node_in_group("player")
	
	# Ustawienia timera strzelania
	shoot_timer.wait_time = 2.0
	shoot_timer.autostart = true
	shoot_timer.start()
	
	# Podłącz sygnał timera (jeśli nie robisz tego w edytorze)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	_handle_movement()
	_handle_visuals(delta)

func _handle_movement():
	if not player: return

	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	
	# Logika poruszania się (AI)
	if distance > keep_distance:
		# Gracz za daleko -> Goń go
		velocity = direction * move_speed
	elif distance < min_distance:
		# Gracz za blisko -> Uciekaj (wektor przeciwny)
		velocity = -direction * move_speed
	else:
		# Dystans idealny -> Wygaszenie prędkości (można dodać lerp dla płynności)
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)

	move_and_slide()

func _handle_visuals(delta):
	# Ciągły obrót samego duszka (efekt koła fortuny)
	if sprite:
		sprite.rotation_degrees += 90 * delta

func _on_shoot_timer_timeout():
	shoot_radial()

func shoot_radial():
	if not bullet_scene: return
	
	var angle_step = 360.0 / projectiles_count
	
	for i in range(projectiles_count):
		var bullet = bullet_scene.instantiate()
		
		# Ustawiamy pozycję startową na środku przeciwnika
		bullet.global_position = global_position
		
		# Obliczamy kąt dla danego pocisku
		var current_angle = i * angle_step
		bullet.rotation_degrees = current_angle
		
		# Dodajemy pocisk do sceny (nie jako dziecko przeciwnika, bo by się z nim ruszał!)
		get_parent().add_child(bullet)
