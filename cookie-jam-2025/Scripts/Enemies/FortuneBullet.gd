extends Area2D

@export var speed: float = 150.0  # Wolna prędkość
@export var damage: int = 10
@export var lifetime: float = 5.0

func _ready():
	# Usunięcie pocisku po czasie (zabezpieczenie)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	# Ruch w "prawo" względem własnej rotacji
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Tutaj wywołaj funkcję zadawania obrażeń u gracza, np.:
		# body.take_damage(damage)
		print("Trafiono gracza kołem!")
		damage = randf_range(0.1*body.max_hp, 0.5*body.max_hp)
		print(body.health)
		body.take_dmg(damage)
		queue_free()
	elif body.name != "EnemyFortuneWheel": # Żeby nie niszczył się na samym przeciwniku przy starcie
		queue_free() # Zniszcz na ścianach
