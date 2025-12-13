extends CharacterBody2D

@export var max_speed = 350.0
@export var acceleration = 250.0
@export var hp = 8
var damage = 35

# --- NOWE ZMIENNE ---
@export var spin_trigger_distance = 250.0 # Jak blisko musi być, żeby zaczął wirować
@export var spin_speed = 20.0 # Jak szybko się kręci (w radianach, więc 25 to bardzo szybko)

var player = null

func _ready():
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		# 1. Obliczanie ruchu (to zostaje bez zmian)
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		
		# 2. Obliczanie dystansu do gracza
		var distance = global_position.distance_to(player.global_position)

		# 3. Logika obrotu
		if distance < spin_trigger_distance:
			# Jest BLISKO gracza -> KRĘĆ SIĘ!
			rotation += spin_speed * delta
		else:
			# Jest DALEKO -> Patrz na gracza
			if velocity.length() > 0:
				look_at(player.global_position)

	move_and_slide()

func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_dmg(damage)
		#print(body.hp)
