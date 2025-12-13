extends CharacterBody2D

@onready var shoot_timer = $ShootTimer
@onready var sprite = $Sprite2D

@export var bullet_scene: PackedScene
@export var move_speed: float = 100.0
@export var keep_distance: float = 250.0 
@export var min_distance: float = 150.0
@export var projectiles_count: int = 8 
var hp=2;

var player: Node2D = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	shoot_timer.wait_time = 2.0
	shoot_timer.autostart = true
	shoot_timer.start()
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	_handle_movement()
	_handle_visuals(delta)

func _handle_movement():
	if not player: return

	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance > keep_distance:
		velocity = direction * move_speed
	elif distance < min_distance:
		velocity = -direction * move_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * 0.1)

	move_and_slide()

func _handle_visuals(delta):
	if sprite:
		sprite.rotation_degrees += 90 * delta

func _on_shoot_timer_timeout():
	shoot_radial()

func shoot_radial():
	if not bullet_scene: return
	
	var angle_step = 360.0 / projectiles_count
	
	for i in range(projectiles_count):
		var bullet = bullet_scene.instantiate()
		
		bullet.global_position = global_position
		
		var current_angle = i * angle_step
		bullet.rotation_degrees = current_angle
		get_parent().add_child(bullet)
		
func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()
