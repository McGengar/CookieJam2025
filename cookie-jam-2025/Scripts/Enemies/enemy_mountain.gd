extends CharacterBody2D

const SPEED = 100.0
const GRAVITY = 980.0
var hp = 30+10*Player_globals.level_counter
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var bullet_scene: PackedScene
@export var projectiles_count: int = 20
var player = null
var can_shoot = true
var is_shooting = false
var rng = RandomNumberGenerator.new()
@onready var muzzle = $Muzzle
@onready var shoot_timer = $Timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var mountain_attack: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	add_to_group("enemies")
	shoot_timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	if ray_cast_2d.is_colliding() and is_on_floor():
		velocity.y += -50
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if player:
		var direction_vector = global_position.direction_to(player.global_position)
		ray_cast_2d.look_at(player.global_position)
		if abs(global_position.x - player.global_position.x) > 70:
			velocity.x = sign(direction_vector.x) * SPEED
			update_facing_direction(direction_vector.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		shoot_at_player()
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot_at_player():
	shoot_radial()

func _on_timer_timeout():
	can_shoot = true

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body):
	if body == player:
		player = null

func update_facing_direction(dir_x):
	if dir_x > 0:
		$Sprite2D.flip_h = false 
		muzzle.position.x = abs(muzzle.position.x)
	elif dir_x < 0:
		$Sprite2D.flip_h = true
		muzzle.position.x = -abs(muzzle.position.x)

func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()
func shoot_radial():
	if is_shooting==false:
		is_shooting = true
		await get_tree().create_timer(0.5).timeout
		if not bullet_scene: return
		
		var angle_step = 360.0 / projectiles_count
		mountain_attack.play()
		
		for i in range(projectiles_count):
			var bullet = bullet_scene.instantiate()
			
			bullet.global_position = global_position
			var current_angle = i * angle_step
			bullet.rotation_degrees = current_angle
			get_parent().add_child(bullet)
		await get_tree().create_timer(2).timeout
		is_shooting = false
