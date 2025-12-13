extends CharacterBody2D

@export var speed = 120.0
@export var jump_force = -450.0
@export var gravity = 980.0
@export var attack_range = 80.0 
@export var damage = 40
var hp = 15;

var player = null
@onready var sword_hitbox = $SwordHitbox
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var handslam: AnimatedSprite2D = $SwordHitbox/handslam
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var is_attacking = false

func _ready():
	add_to_group("enemies")
	sword_hitbox.monitoring = false
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if ray_cast_2d.is_colliding():
		velocity.y += -50
	if not is_on_floor():
		velocity.y += gravity * delta

	if player and not is_attacking:
		animated_sprite_2d.play("default")
		ray_cast_2d.look_at(player.global_position)
		var distance = global_position.distance_to(player.global_position)
		var direction_x = sign(player.global_position.x - global_position.x)
		
		if distance > attack_range:
			velocity.x = direction_x * speed
			update_facing(direction_x)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			perform_attack()

		if is_on_floor() and player.velocity.y < -100: 
			jump_towards_player()

	elif is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func update_facing(dir_x):
	if dir_x > 0:
		animated_sprite_2d.flip_h = false
		sword_hitbox.scale.x = 1 
	elif dir_x < 0:
		animated_sprite_2d.flip_h = true
		sword_hitbox.scale.x = -1

func jump_towards_player():
	print("Baba: Hopsa! Skaczę za tobą!")
	velocity.y = jump_force
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * speed * 1.5 

func perform_attack():
	if attack_timer.is_stopped():
		#print("Dziad: Cios mieczem!")
		is_attacking = true
		attack_timer.start()
		handslam.play("default")
		handslam.scale = Vector2(1,1)
		await get_tree().create_timer(0.3).timeout
		
		sword_hitbox.monitoring = true
		var original_color = animated_sprite_2d.modulate
		var original_color_hand = handslam.modulate
		animated_sprite_2d.modulate = Color.YELLOW
		handslam.modulate = Color.YELLOW
		handslam.play("new_animation_1")
		await get_tree().create_timer(0.3).timeout
		handslam.scale = Vector2(0.5,0.5)
		handslam.play("new_animation")
		animated_sprite_2d.play("default")
		sword_hitbox.monitoring = false
		animated_sprite_2d.modulate = original_color
		handslam.modulate = original_color_hand
		is_attacking = false
func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()
	
func _on_sword_hitbox_body_entered(body):
	if body.is_in_group("player"):
		#print("Gracz dostał z miecza!")
		body.take_dmg(damage)
		print(body.hp)
