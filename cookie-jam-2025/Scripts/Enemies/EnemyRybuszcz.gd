extends CharacterBody2D

const SPEED = 100.0
const GRAVITY = 980.0
var hp = 20 +5*Player_globals.level_counter

@export var projectile_scene: PackedScene 

var player = null
var can_shoot = true

@onready var muzzle = $Muzzle
@onready var shoot_timer = $Timer

@onready var rybuszcz_attack: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	add_to_group("enemies")
	shoot_timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player:
		var direction_vector = global_position.direction_to(player.global_position)
		
		if abs(global_position.x - player.global_position.x) > 150.0:
			velocity.x = sign(direction_vector.x) * SPEED
			update_facing_direction(direction_vector.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		shoot_at_player()
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot_at_player():
	if can_shoot and projectile_scene:
		rybuszcz_attack.play()
		can_shoot = false
		shoot_timer.start()
		
		var projectile = projectile_scene.instantiate()
		
		projectile.global_position = muzzle.global_position
		
		var dir = (player.global_position - muzzle.global_position).normalized()
		projectile.direction = dir
		
		projectile.look_at(player.global_position)
		get_parent().add_child(projectile)

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
