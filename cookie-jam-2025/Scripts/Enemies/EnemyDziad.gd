extends CharacterBody2D

# --- STATYSTYKI ---
@export var speed = 120.0
@export var jump_force = -450.0 # Siła skoku (ujemna to góra)
@export var gravity = 980.0
@export var attack_range = 60.0 # Jak blisko musi być, żeby ciąć mieczem
@export var damage = 40
var hp = 10;

# Referencje
var player = null
@onready var sword_hitbox = $SwordHitbox
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer

# Zmienna stanu
var is_attacking = false

func _ready():
	add_to_group("enemies")
	# Wyłączamy miecz na start (włączymy go tylko podczas ataku)
	sword_hitbox.monitoring = false
	
	# Znajdź gracza
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	# 1. Grawitacja
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Logika (tylko jeśli gracz istnieje i Dziad nie atakuje w tej chwili)
	if player and not is_attacking:
		var distance = global_position.distance_to(player.global_position)
		var direction_x = sign(player.global_position.x - global_position.x)
		
		# --- RUCH W STRONĘ GRACZA ---
		if distance > attack_range:
			velocity.x = direction_x * speed
			update_facing(direction_x)
		else:
			# Jest blisko -> Zatrzymaj się i ATAKUJ!
			velocity.x = move_toward(velocity.x, 0, speed)
			perform_attack()

		# --- REAKCJA NA SKOK GRACZA ---
		# Jeśli Dziad jest na ziemi I Gracz leci w górę (skacze)
		if is_on_floor() and player.velocity.y < -100: 
			# Opcjonalnie: sprawdź czy gracz jest wyżej (player.global_position.y < global_position.y)
			jump_towards_player()

	elif is_attacking:
		# Podczas ataku stój w miejscu (żeby nie "ślizgał się" machając mieczem)
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

# --- FUNKCJE POMOCNICZE ---

func update_facing(dir_x):
	if dir_x > 0:
		sprite.flip_h = false
		# Miecz musi być z prawej
		sword_hitbox.scale.x = 1 
	elif dir_x < 0:
		sprite.flip_h = true
		# Miecz musi przeskoczyć na lewą stronę
		sword_hitbox.scale.x = -1

func jump_towards_player():
	print("Dziad: Hopsa! Skaczę za tobą!")
	velocity.y = jump_force
	# Dodajemy trochę pędu w stronę gracza przy skoku
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * speed * 1.5 

func perform_attack():
	if attack_timer.is_stopped():
		print("Dziad: Cios mieczem!")
		is_attacking = true
		attack_timer.start()
		
		# 1. Włącz obszar obrażeń (Hitbox)
		sword_hitbox.monitoring = true
		
		# 2. Wizualizacja (zamiast animacji - mrugnięcie)
		var original_color = sprite.modulate
		sprite.modulate = Color.YELLOW # Miecz/Dziad świeci przy ataku
		
		# 3. Czekamy ułamek sekundy (czas trwania ciosu)
		await get_tree().create_timer(0.3).timeout
		
		# 4. Wyłączamy hitbox i resetujemy
		sword_hitbox.monitoring = false
		sprite.modulate = original_color
		is_attacking = false

# --- OBSŁUGA OBRYWANIA (Żebyś mógł go zabić) ---
func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()

# --- OBSŁUGA TRAFIENIA MIECZEM ---
# Podłącz sygnał body_entered z SwordHitbox do tego skryptu!
func _on_sword_hitbox_body_entered(body):
	if body.is_in_group("player"):
		print("Gracz dostał z miecza!")
		body.take_dmg(damage)
		print(body.health)
