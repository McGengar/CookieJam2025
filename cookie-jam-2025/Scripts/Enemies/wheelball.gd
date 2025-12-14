extends RigidBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var speed: float = 450.0  # Wolna prędkość
@export var damage: int = 10
@export var lifetime: float = 10.0
var rng = RandomNumberGenerator.new()
func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	

func _physics_process(delta):
	rotation += deg_to_rad(delta)
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_dmg(10)
		print("Trafiono gracza chipem!")
		queue_free()
