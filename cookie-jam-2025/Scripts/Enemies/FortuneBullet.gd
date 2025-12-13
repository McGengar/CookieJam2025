extends Area2D

@export var speed: float = 150.0
@export var damage: int = 10
@export var lifetime: float = 5.0

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		#print("Trafiono gracza kołem!")
		damage = randf_range(0.1*body.max_hp, 0.5*body.max_hp)
		print(body.hp)
		body.take_dmg(damage)
		queue_free()
	elif body.name != "EnemyFortuneWheel":
		queue_free()
